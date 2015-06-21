//
//  DPFilledPathView.m
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import "DPMeterView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#define EPSILON     1e-6


@interface DPMeterView ()

@property (nonatomic, readonly) CAGradientLayer* gradientLayer;
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) CADisplayLink* motionDisplayLink;
@property (nonatomic) float motionLastYaw;
@property (nonatomic) BOOL isAnimating;

- (void)commonInit;
- (NSArray *)gradientPoints:(CGFloat)angle;
- (NSArray *)gradientLocations:(CGFloat)progress;
- (void)initialGradientOrientation;
- (void)motionRefresh:(id)sender;

@end


@implementation DPMeterView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer
{
    return (CAGradientLayer*)self.layer;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame shape:nil];
}

- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape
{
    return [self initWithFrame:frame shape:shape gravity:NO];
}

- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape gravity:(BOOL)gravity
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    // use the shape as a mask
    [self setShape:shape];
    
    // gravity motion
    if (gravity) {
        [self startGravity];            
    }

    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.trackTintColor = [UIColor greenColor];
    self.progressTintColor = [UIColor blueColor];
    
    self.meterType = DPMeterTypeLinearVertical;
    self.gradientLayer.locations = @[@0.f, @0.f];
    self.progress = 0.f;
}

- (void)initialGradientOrientation
{
    switch (_meterType) {
        case DPMeterTypeLinearVertical:
            [self setGradientOrientationAngle:M_PI_2];
            break;
            
        case DPMeterTypeLinearHorizontal:
            [self setGradientOrientationAngle:0];
            break;
            
        default:
            // enforce explicit declaration
            NSAssert(_meterType == DPMeterTypeLinearNone,
                     @"!   You need to set the meterType property to something else than DPMeterTypeLinearNone");
            break;
    };
}

- (void)didMoveToWindow
{
    self.gradientLayer.contentsScale = [UIScreen mainScreen].scale;
}


#pragma mark - Setters & Getters

- (void)setShape:(CGPathRef)shape
{
    if (shape == nil) {
        self.gradientLayer.mask = nil;
    }
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = shape;
    self.gradientLayer.mask = maskLayer;
}

- (CGRect)shapeBounds
{
    return CGPathGetPathBoundingBox([(CAShapeLayer *)self.gradientLayer.mask path]);
}

- (void)setMeterType:(DPMeterType)meterType
{
    if (_meterType == meterType)
        return;
    
    _meterType = meterType;
    
    // config gradient according to the meter type
    [self initialGradientOrientation];
}

- (void)updateGradientColors
{
    self.gradientLayer.colors = [[NSArray alloc] initWithObjects:
                                 (id)self.progressTintColor.CGColor,
                                 (id)self.trackTintColor.CGColor, nil];
    [self.gradientLayer setNeedsDisplay];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    if (trackTintColor != _trackTintColor) {
        _trackTintColor = trackTintColor;
        [self updateGradientColors];
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if (progressTintColor != _progressTintColor) {
        _progressTintColor = progressTintColor;
        [self updateGradientColors];
    }
}


#pragma mark - Progress

- (CGFloat)rescaledProgress:(CGFloat)progress
{
    // make sure again that it's a percentage
    CGFloat pinnedProgress = MIN(MAX(progress, 0.f), 1.f);
    
    // get the bounding box of the mask shape
    CGRect shapeBounds = [self shapeBounds];
    
    if (CGRectIsEmpty(shapeBounds)) {
        return pinnedProgress;
    }
    
    // rescale the progress against the distance between the start and end points
    CGPoint start = self.gradientLayer.startPoint, end = self.gradientLayer.endPoint;
    
    // map the gradient points to the shape bounds
    CGPoint shapeStart = CGPointMake(start.x * shapeBounds.size.width, start.y * shapeBounds.size.height);
    CGPoint shapeEnd = CGPointMake(end.x * shapeBounds.size.width, end.y * shapeBounds.size.height);
    
    // compute shape distance
    CGFloat shapeDistance = sqrt((shapeStart.x - shapeEnd.x)*(shapeStart.x - shapeEnd.x) +
                                 (shapeStart.y - shapeEnd.y)*(shapeStart.y - shapeEnd.y));
    // scale progress against the distance
    CGFloat scaledProgress = pinnedProgress * shapeDistance;
    
    // compute the shape padding
    // NB: the coordinates of Apple are (0,0) at the top left
    CGFloat viewDistance, shapePadding;
    CGFloat gradientAngle = [self gradientOrientationAngle];  // remember the angle interval [0,2*PI]
    if (gradientAngle > 7*M_PI_4 || gradientAngle <= M_PI_4) {
        viewDistance = CGRectGetWidth(self.bounds);
        shapePadding = CGRectGetMinX(shapeBounds);
    } else if (gradientAngle > M_PI_4 && gradientAngle <= 3*M_PI_4) {
        viewDistance = CGRectGetHeight(self.bounds);
        shapePadding = viewDistance - CGRectGetMaxY(shapeBounds);
    } else if (gradientAngle > 3*M_PI_4 && gradientAngle <= 5*M_PI_4) {
        viewDistance = CGRectGetWidth(self.bounds);
        shapePadding = viewDistance - CGRectGetMaxX(shapeBounds);
    } else {
        viewDistance = CGRectGetHeight(self.bounds);
        shapePadding = CGRectGetMinY(shapeBounds);
    }
    
    // translate the progress by the shape padding
    scaledProgress += shapePadding;
    
    // convert into a percentage
    scaledProgress /= viewDistance;
    
    return scaledProgress;
}

- (NSArray *)gradientLocations:(CGFloat)progress
{
    CGFloat rescaledProgress = [self rescaledProgress:progress];
    return @[[NSNumber numberWithFloat:rescaledProgress], [NSNumber numberWithFloat:rescaledProgress]];
}

- (CGFloat)gradientOrientationAngle
{
    // map-inverse the points because Apple is using (0,0) at the top-left origin
    CGPoint s = CGPointMake(self.gradientLayer.startPoint.x, 1.f - self.gradientLayer.startPoint.y),
            e = CGPointMake(self.gradientLayer.endPoint.x, 1.f - self.gradientLayer.endPoint.y);
    
    CGFloat dx = s.x - e.x,
            dy = s.y - e.y;
    
    if (dx == 0) {
        return M_PI_2;
    }
    
    CGFloat alpha = atanf(dy/dx);
    if (alpha < 0) {
        alpha += M_PI;
    }

    return alpha;
}

+ (NSArray *)intersectionPointsOfLineOrientedBy:(CGFloat)angle withBox:(CGRect)box
{
    // Vertical line special cases
    if (fabs(angle - M_PI_2) < EPSILON) {
        // vertical "up"
        return @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(box), CGRectGetMinY(box))],
                 [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(box), CGRectGetMaxY(box))]];
    } else if (fabs(angle - 3*M_PI_2) < EPSILON) {
        // vertical "down"
        return @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(box), CGRectGetMaxY(box))],
                 [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(box), CGRectGetMinY(box))]];
    }
    
    // Horizontal special cases
    if (fabs(angle) < EPSILON) {
        // horizontal "right"
        return @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(box), CGRectGetMidY(box))],
                 [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(box), CGRectGetMidY(box))]];
    } else if (fabs(fabs(angle) - 2*M_PI_2) < EPSILON) {
        // horizontal "left"
        return @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(box), CGRectGetMidY(box))],
                 [NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(box), CGRectGetMidY(box))]];
    }
    
    // Compute the end point as a point on the unit circle
    CGFloat x = cosf(angle),
    y = sinf(angle);
    CGPoint start = CGPointMake(0.f, 0.f);  // center of the unit circle
    CGPoint end = CGPointMake(x, y);        // on the unit circle
    
    // Bounding box intersections (in 2D)
    // http://people.csail.mit.edu/amy/papers/box-jgt.pdf
    //
    // NB: it's like expanding the line to the bounding square that wrap the unit circle
    //
    CGRect centeredBox = CGRectMake(-CGRectGetWidth(box)/2,
                                    -CGRectGetHeight(box)/2,
                                    CGRectGetWidth(box),
                                    CGRectGetHeight(box));
    CGFloat dx = end.x - start.x,
            dy = end.y - start.y,
            m = dy/dx,
            txmin, txmax, tymin, tymax;
    
    if (dx >= 0) {
        tymin = (CGRectGetMinX(centeredBox) - start.x) / (1/m);
        tymax = (CGRectGetMaxX(centeredBox) - start.x) / (1/m);
    } else {
        tymin = (CGRectGetMaxX(centeredBox) - start.x) / (1/m);
        tymax = (CGRectGetMinX(centeredBox) - start.x) / (1/m);
    }
    
    if (dy >= 0) {
        txmin = (CGRectGetMinY(centeredBox) - start.y) / m;
        txmax = (CGRectGetMaxY(centeredBox) - start.y) / m;
    } else {
        txmin = (CGRectGetMaxY(centeredBox) - start.y) / m;
        txmax = (CGRectGetMinY(centeredBox) - start.y) / m;
    }
    
    txmin = MIN(MAX(-CGRectGetWidth(box)/2, txmin), CGRectGetWidth(box)/2);
    tymin = MIN(MAX(-CGRectGetHeight(box)/2, tymin), CGRectGetHeight(box)/2);
    txmax = MIN(MAX(-CGRectGetWidth(box)/2, txmax), CGRectGetWidth(box)/2);
    tymax = MIN(MAX(-CGRectGetHeight(box)/2, tymax), CGRectGetHeight(box)/2);
    
    // translate the values because we use a centered box and maybe the original box has an offset
    txmin += CGRectGetWidth(box)/2 + box.origin.x;
    tymin += CGRectGetHeight(box)/2 + box.origin.y;
    txmax += CGRectGetWidth(box)/2 + box.origin.x;
    tymax += CGRectGetHeight(box)/2 + box.origin.y;
    
    CGPoint minPoint = CGPointMake(txmin, tymin),
            maxPoint = CGPointMake(txmax, tymax),
            startPoint = minPoint,
            endPoint = maxPoint;
    
    // Set the correct start and end point according to the unit circle quadran
    if (angle < M_PI) {
        // the start point has to be lower that the end point on the y-axis
        if (minPoint.y < maxPoint.y) {
            startPoint = minPoint;
            endPoint = maxPoint;
        } else {
            startPoint = maxPoint;
            endPoint = minPoint;
        }
    } else {
        // the start point has to be higher that the end point on the y-axis
        if (minPoint.y > maxPoint.y) {
            startPoint = minPoint;
            endPoint = maxPoint;
        } else {
            startPoint = maxPoint;
            endPoint = minPoint;
        }
    }
    
    return @[[NSValue valueWithCGPoint:startPoint],
             [NSValue valueWithCGPoint:endPoint]];

}

- (NSArray *)gradientPoints:(CGFloat)angle
{
    // ensure [0,2*PI] interval
    angle = fmodf(angle, 2*M_PI);
    
    // bounding box intersection
    CGRect box = CGRectMake(0.f, 0.f, 1.f, 1.f);
    NSArray *intersectionPoints = [DPMeterView intersectionPointsOfLineOrientedBy:angle withBox:box];
    
    // map the intersection points to agree with the (0,0) at top left and (1,1) bottom right Apple scale
    // to achieve that we make a symetry around the axis defined by y=0.5
    CGPoint startPoint = [intersectionPoints[0] CGPointValue],
            endPoint = [intersectionPoints[1] CGPointValue];
    startPoint = CGPointMake(startPoint.x, 1.f - startPoint.y);
    endPoint = CGPointMake(endPoint.x, 1.f - endPoint.y);
    
    return @[[NSValue valueWithCGPoint:startPoint],
             [NSValue valueWithCGPoint:endPoint]];
}

- (void)setGradientOrientationAngle:(CGFloat)angle
{
    NSArray *points = [self gradientPoints:angle];
    self.gradientLayer.startPoint = [points[0] CGPointValue];
    self.gradientLayer.endPoint = [points[1] CGPointValue];
    [self.gradientLayer setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO duration:0];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self setProgress:progress animated:animated duration:0.5];
}

- (void)setProgress:(CGFloat)progress duration:(NSTimeInterval)duration
{
    [self setProgress:progress animated:YES duration:duration];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    CGFloat pinnedProgress = MIN(MAX(progress, 0.f), 1.f);
    NSArray* newLocations = [self gradientLocations:pinnedProgress];

    if (animated) {
        _isAnimating = YES;
        [UIView animateWithDuration:duration animations:^{
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = duration;
            animation.delegate = self;
            animation.fromValue = self.gradientLayer.locations;
            animation.toValue = newLocations;
            [self.gradientLayer addAnimation:animation forKey:@"animateLocations"];
        } completion:^(BOOL finished) {
            _isAnimating = NO;
        }];
    } else {
        _isAnimating = NO;
        [self.gradientLayer setNeedsDisplay];
    }

    self.gradientLayer.locations = newLocations;
    _progress = pinnedProgress;
}

- (void)minus:(CGFloat)delta
{
    [self minus:delta animated:NO];
}

- (void)minus:(CGFloat)delta animated:(BOOL)animated
{
    [self setProgress:(self.progress - delta) animated:animated];
}

- (void)add:(CGFloat)delta
{
    [self add:delta animated:NO];
}

- (void)add:(CGFloat)delta animated:(BOOL)animated
{
    [self setProgress:(self.progress + delta) animated:animated];
}


#pragma mark - Gravity Motion

- (CGFloat)currentYaw
{
    return 0.5f - self.gradientLayer.startPoint.x;
}

- (void)motionRefresh:(id)sender
{
    
    // compute the device yaw from the attitude quaternion
    // http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    CMQuaternion quat = self.motionManager.deviceMotion.attitude.quaternion;
    double yaw = asin(2*(quat.x*quat.z - quat.w*quat.y));
    
    // TODO improve the yaw interval (stuck to [-PI/2, PI/2] due to arcsin definition
    
    yaw *= -1;      // reverse the angle so that it reflect a *liquid-like* behavior
    yaw += M_PI_2;  // because for the motion manager 0 is the calibration value (but for us 0 is the horizontal axis)
    
    if (self.motionLastYaw == 0) {
        self.motionLastYaw = yaw;
    }
    
    // kalman filtering
    static float q = 0.1;   // process noise
    static float r = 0.1;   // sensor noise
    static float p = 0.1;   // estimated error
    static float k = 0.5;   // kalman filter gain
    
    float x = self.motionLastYaw;
    p = p + q;
    k = p / (p + r);
    x = x + k*(yaw - x);
    p = (1 - k)*p;
    self.motionLastYaw = x;
    
    // update starting & ending point of the gradient
    [self setGradientOrientationAngle:x];
}

- (BOOL)isGravityActive
{
    return self.motionDisplayLink != nil;
}

- (void)startGravity
{
    if ( ! [self isGravityActive]) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.02; // 50 Hz
        
        self.motionLastYaw = 0;
        self.motionDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(motionRefresh:)];
        [self.motionDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    if ([self.motionManager isDeviceMotionAvailable]) {
        // to avoid using more CPU than necessary we use ``CMAttitudeReferenceFrameXArbitraryZVertical``
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    }
}

- (void)stopGravity
{
    if ([self isGravityActive]) {
        [self.motionDisplayLink invalidate];
        self.motionDisplayLink = nil;
        self.motionLastYaw = 0;
        
        // reset the gradient orientation
        [self initialGradientOrientation];
        
        self.motionManager = nil;   // release the motion manager memory
    }
    if ([self.motionManager isDeviceMotionActive])
        [self.motionManager stopDeviceMotionUpdates];
}

@end
