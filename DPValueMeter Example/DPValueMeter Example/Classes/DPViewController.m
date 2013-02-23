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
+ (DPLinearMeterView*)heartShapedView:(CGRect)frame;
@end

@implementation DPLinearMeterView (Example)

+ (DPLinearMeterView*)heartShapedView:(CGRect)frame
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
    
    return [[DPLinearMeterView alloc] initWithFrame:frame shape:bezierPath.CGPath gravity:YES];
}

@end


@interface DPViewController ()

@property (nonatomic, strong) NSTimer* animationTimer;

@end

@implementation DPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat w = 120.f;
    self.filledView = [DPLinearMeterView heartShapedView:CGRectMake(self.view.frame.size.width/2 - w/2,
                                                                   self.view.frame.size.height/2 - w/2 - 20.f,
                                                                   w,
                                                                   w)];
    
    // beautiful red over gray
    self.filledView.trackTintColor = [UIColor lightGrayColor];
    self.filledView.progressTintColor = [UIColor colorWithRed:189/255.f green:32/255.f blue:49/255.f alpha:1.f];
    [self.filledView setProgress:0.f animated:NO];
    [self.view addSubview:self.filledView];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)animate:(id)sender
{
    if (self.filledView.progress >= 1.0) {
        [self.animationTimer invalidate];
        [self.filledView stopGravity];
        return;
    }
    
    [self.filledView setProgress:(self.filledView.progress+0.15) animated:YES];
}

@end
