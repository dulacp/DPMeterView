//
//  DPFilledPathView.h
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPMeterType) {
    DPMeterTypeLinearNone,
    DPMeterTypeLinearVertical,              // default
    DPMeterTypeLinearHorizontal,
    
    // TODO
    // DPMeterTypeCircular,
    // ...,
};


@interface DPMeterView : UIView <UIAppearance>

@property (nonatomic) DPMeterType meterType;
@property (strong, nonatomic) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat progress;
@property (nonatomic, readonly) BOOL isAnimating;

- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape;
- (id)initWithFrame:(CGRect)frame shape:(CGPathRef)shape gravity:(BOOL)gravity;

- (void)setShape:(CGPathRef)shape;

- (CGFloat)rescaledProgress:(CGFloat)progress;
- (void)setProgress:(CGFloat)progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setProgress:(CGFloat)progress duration:(NSTimeInterval)duration;
- (void)minus:(CGFloat)delta;
- (void)minus:(CGFloat)delta animated:(BOOL)animated;
- (void)add:(CGFloat)delta;
- (void)add:(CGFloat)delta animated:(BOOL)animated;

// the gradientOrientation is defined as a positive angle
//  0 is an horizontal gradient from left to right
//  and the default orientation is PI/2 which corresponds to a vertical gradient
- (CGFloat)gradientOrientationAngle;
- (void)setGradientOrientationAngle:(CGFloat)angle;
+ (NSArray *)intersectionPointsOfLineOrientedBy:(CGFloat)angle withBox:(CGRect)box;

// Gravity Motion
- (BOOL)isGravityActive;
- (void)startGravity;
- (void)stopGravity;

@end
