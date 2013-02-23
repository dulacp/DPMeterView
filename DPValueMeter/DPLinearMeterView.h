//
//  DPFilledPathView.h
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DPLinearMeterView : UIView

@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) CGFloat progress;

- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape;
- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape motionAnimated:(BOOL)motionAnimated;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

// Motion Animations
@property (nonatomic, readonly, getter = isMotionAnimating) BOOL motionAnimating;
- (void)startMotionAnimation;
- (void)stopMotionAnimation;

@end
