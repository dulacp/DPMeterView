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
    CGFloat angl = M_PI/5;
    
    // Create an heart like shape
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a/2, a)];
    [path addLineToPoint:CGPointMake(3./4*a + a/4*cosf(angl), a/4 + a/4*sinf(angl))];
    [path addArcWithCenter:CGPointMake(3./4*a, a/4) radius:a/4 startAngle:angl endAngle:M_PI clockwise:NO];
    [path addArcWithCenter:CGPointMake(a/4, a/4) radius:a/4 startAngle:0 endAngle:-(M_PI+angl) clockwise:NO];
    [path addLineToPoint:CGPointMake(a/2, a)];
    
    return [[DPLinearMeterView alloc] initWithFrame:frame shape:path.CGPath motionAnimated:YES];
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
        [self.filledView stopMotionAnimation];
        return;
    }
    
    [self.filledView setProgress:(self.filledView.progress+0.15) animated:YES];
}

@end
