//
//  DPFilledPathView.h
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DPLinearMeterView : UIView <UIAppearance>

@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) CGFloat progress;

- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape;
- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape gravity:(BOOL)gravity;

- (void)setShape:(CGPathRef)shape;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)minus:(CGFloat)delta animated:(BOOL)animated;
- (void)add:(CGFloat)delta animated:(BOOL)animated;

// Gravity Motion
@property (nonatomic, readonly, getter = isGravityActive) BOOL gravityActive;
- (void)startGravity;
- (void)stopGravity;

@end
