//
//  DPViewController.m
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import "DPViewController.h"

#import "DPLinearMeterView.h"


@interface DPLinearMeterView (Example)

+ (UIBezierPath *)heartShape:(CGRect)frame;

@end

@implementation DPLinearMeterView (Example)

+ (UIBezierPath *)heartShape:(CGRect)frame
{
    CGFloat a = MIN(frame.size.width, frame.size.height);
    CGRect f = CGRectMake(frame.size.width/2 - a/2, frame.size.height/2 - a/2, a, a);
    
    // Create an heart like shape
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(f) + 0.49986 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.24129 * CGRectGetHeight(f))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(f) + 0.00841 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.36081 * CGRectGetHeight(f)) controlPoint1: CGPointMake(CGRectGetMinX(f) + 0.37259 * CGRectGetWidth(f), CGRectGetMinY(f) + -0.06208 * CGRectGetHeight(f)) controlPoint2: CGPointMake(CGRectGetMinX(f) + 0.01079 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.00870 * CGRectGetHeight(f))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(f) + 0.29627 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.70379 * CGRectGetHeight(f)) controlPoint1: CGPointMake(CGRectGetMinX(f) + 0.00709 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.55420 * CGRectGetHeight(f)) controlPoint2: CGPointMake(CGRectGetMinX(f) + 0.18069 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.62648 * CGRectGetHeight(f))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(f) + 0.50061 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.92498 * CGRectGetHeight(f)) controlPoint1: CGPointMake(CGRectGetMinX(f) + 0.40835 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.77876 * CGRectGetHeight(f)) controlPoint2: CGPointMake(CGRectGetMinX(f) + 0.48812 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.88133 * CGRectGetHeight(f))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(f) + 0.70195 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.70407 * CGRectGetHeight(f)) controlPoint1: CGPointMake(CGRectGetMinX(f) + 0.50990 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.88158 * CGRectGetHeight(f)) controlPoint2: CGPointMake(CGRectGetMinX(f) + 0.59821 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.77912 * CGRectGetHeight(f))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(f) + 0.99177 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.35870 * CGRectGetHeight(f)) controlPoint1: CGPointMake(CGRectGetMinX(f) + 0.81539 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.62200 * CGRectGetHeight(f)) controlPoint2: CGPointMake(CGRectGetMinX(f) + 0.99308 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.55208 * CGRectGetHeight(f))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(f) + 0.49986 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.24129 * CGRectGetHeight(f)) controlPoint1: CGPointMake(CGRectGetMinX(f) + 0.98938 * CGRectGetWidth(f), CGRectGetMinY(f) + 0.00573 * CGRectGetHeight(f)) controlPoint2: CGPointMake(CGRectGetMinX(f) + 0.61811 * CGRectGetWidth(f), CGRectGetMinY(f) + -0.06095 * CGRectGetHeight(f))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

@end


@interface DPViewController ()

@property (nonatomic, strong) NSTimer* animationTimer;

@end

@implementation DPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UIApperance
    [[DPLinearMeterView appearance] setTrackTintColor:[UIColor darkGrayColor]];
    [[DPLinearMeterView appearance] setProgressTintColor:[UIColor lightGrayColor]];
    
    // shape 1 -- Heart
    [self.shape1View setShape:[DPLinearMeterView heartShape:self.shape1View.frame].CGPath];
    self.shape1View.trackTintColor = [UIColor lightGrayColor];
    self.shape1View.progressTintColor = [UIColor colorWithRed:189/255.f green:32/255.f blue:49/255.f alpha:1.f];
    [self.shape1View setProgress:0.f animated:NO];
    
    // shape 2 -- TODO other shapes
    // shape 3 -- ...
    // shape 4 -- ...
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (NSArray *)shapeViews
{
    NSMutableArray *shapeViews = [NSMutableArray array];
    
    if (self.shape1View && [self.shape1View isKindOfClass:[DPLinearMeterView class]])
        [shapeViews addObject:self.shape1View];
    
    if (self.shape2View && [self.shape2View isKindOfClass:[DPLinearMeterView class]])
        [shapeViews addObject:self.shape2View];
    
    if (self.shape3View && [self.shape3View isKindOfClass:[DPLinearMeterView class]])
        [shapeViews addObject:self.shape3View];
    
    if (self.shape4View && [self.shape4View isKindOfClass:[DPLinearMeterView class]])
        [shapeViews addObject:self.shape4View];
    
    return [NSArray arrayWithArray:shapeViews];
}

- (void)updateProgressWithDelta:(CGFloat)delta animated:(BOOL)animated
{
    NSArray *shapeViews = [self shapeViews];
    for (DPLinearMeterView *shapeView in shapeViews) {
        if (delta < 0) {
            [shapeView minus:fabs(delta) animated:animated];
        } else {
            [shapeView add:fabs(delta) animated:animated];
        }
    }
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f %%",
                               [(DPLinearMeterView *)[shapeViews lastObject] progress]*100];
}

- (IBAction)minus:(id)sender
{
    [self updateProgressWithDelta:-0.1 animated:YES];
}

- (IBAction)add:(id)sender
{
    [self updateProgressWithDelta:+0.1 animated:YES];
}

- (IBAction)toggleGravity:(id)sender
{
    for (DPLinearMeterView *shapeView in [self shapeViews]) {
        NSLog(@"sw: %@ | %@", self.gravitySwitch.on ? @"YES" : @"NO", [shapeView isGravityActive] ? @"YES" : @"NO");
        if ([self.gravitySwitch isOn] && ![shapeView isGravityActive]) {
            NSLog(@"wws: %@", self.gravitySwitch.on ? @"YES" : @"NO");
            [shapeView startGravity];
        } else if (![self.gravitySwitch isOn] && [shapeView isGravityActive]) {
            NSLog(@"sww: %@", self.gravitySwitch.on ? @"YES" : @"NO");
            [shapeView stopGravity];
        }
    }
}

@end
