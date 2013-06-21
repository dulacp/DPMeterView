//
//  DPViewController.m
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import "ViewController.h"

#import "DPMeterView.h"
#import "UIBezierPath+BasicShapes.h"

#import <QuartzCore/QuartzCore.h>


@interface ViewController ()

@property (nonatomic, strong) NSTimer* animationTimer;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UIApperance
    [[DPMeterView appearance] setTrackTintColor:[UIColor lightGrayColor]];
    [[DPMeterView appearance] setProgressTintColor:[UIColor darkGrayColor]];
    
    // shape 1 -- Heart
    [self.shape1View setShape:[UIBezierPath heartShape:self.shape1View.frame].CGPath];
    self.shape1View.progressTintColor = [UIColor colorWithRed:189/255.f green:32/255.f blue:49/255.f alpha:1.f];
    
    // shape 2 -- User
    [self.shape2View setShape:[UIBezierPath userShape:self.shape2View.frame].CGPath];
    self.shape2View.progressTintColor = [UIColor colorWithRed:0/255.f green:163/255.f blue:65/255.f alpha:1.f];
    
    // shape 3 -- Martini
    [self.shape3View setShape:[UIBezierPath martiniShape:self.shape3View.frame].CGPath];
    self.shape3View.progressTintColor = [UIColor colorWithRed:76/255.f green:116/255.f blue:206/255.f alpha:1.f];
    
    // shape 4 -- 3 Stars
    [self.shape4View setMeterType:DPMeterTypeLinearHorizontal];
    [self.shape4View setShape:[UIBezierPath stars:3 shapeInFrame:self.shape4View.frame].CGPath];
    self.shape4View.progressTintColor = [UIColor colorWithRed:255/255.f green:199/255.f blue:87/255.f alpha:1.f];
    
    // shape 5 -- Progress
    [self.shape5View setMeterType:DPMeterTypeLinearHorizontal];
    self.shape5View.progressTintColor = [UIColor colorWithRed:216/255.f green:147/255.f blue:48/255.f alpha:1.f];
    self.shape5View.trackTintColor = [UIColor colorWithRed:231/255.f green:190/255.f blue:132/255.f alpha:1.f];
    [self.shape5View setShape:[UIBezierPath bezierPathWithRoundedRect:self.shape5View.bounds cornerRadius:0.f].CGPath];
    [self.shape5View.layer setBorderWidth:1.f];
    [self.shape5View.layer setBorderColor:[UIColor colorWithRed:195/255.f green:129/255.f blue:35/255.f alpha:1.f].CGColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateProgressWithDelta:0.6 animated:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (NSArray *)shapeViews
{
    NSMutableArray *shapeViews = [NSMutableArray array];
    
    if (self.shape1View && [self.shape1View isKindOfClass:[DPMeterView class]])
        [shapeViews addObject:self.shape1View];
    
    if (self.shape2View && [self.shape2View isKindOfClass:[DPMeterView class]])
        [shapeViews addObject:self.shape2View];
    
    if (self.shape3View && [self.shape3View isKindOfClass:[DPMeterView class]])
        [shapeViews addObject:self.shape3View];
    
    if (self.shape4View && [self.shape4View isKindOfClass:[DPMeterView class]])
        [shapeViews addObject:self.shape4View];
    
    if (self.shape5View && [self.shape5View isKindOfClass:[DPMeterView class]])
        [shapeViews addObject:self.shape5View];
    
    return [NSArray arrayWithArray:shapeViews];
}

- (void)updateProgressWithDelta:(CGFloat)delta animated:(BOOL)animated
{
    NSArray *shapeViews = [self shapeViews];
    for (DPMeterView *shapeView in shapeViews) {
        if (delta < 0) {
            [shapeView minus:fabs(delta) animated:animated];
        } else {
            [shapeView add:fabs(delta) animated:animated];
        }
    }
    
    self.title = [NSString stringWithFormat:@"%.2f%%",
                                [(DPMeterView *)[shapeViews lastObject] progress]*100];
}

- (IBAction)minus:(id)sender
{
    [self updateProgressWithDelta:-0.1 animated:YES];
}

- (IBAction)add:(id)sender
{
    [self updateProgressWithDelta:+0.1 animated:YES];
}

- (IBAction)orientationHasChanged:(id)sender
{
    CGFloat value = self.orientationSlider.value;
    CGFloat angle = (M_PI/180) * value;
    self.orientationLabel.text = [NSString stringWithFormat:@"orientation (%.0f°)", value];
    
    for (DPMeterView *v in [self shapeViews]) {
        [v setGradientOrientationAngle:angle];
    }
}

- (IBAction)toggleGravity:(id)sender
{
    for (DPMeterView *shapeView in [self shapeViews]) {
        if ([self.gravitySwitch isOn] && ![shapeView isGravityActive]) {
            [shapeView startGravity];
        } else if (![self.gravitySwitch isOn] && [shapeView isGravityActive]) {
            [shapeView stopGravity];
        }
    }
}

@end
