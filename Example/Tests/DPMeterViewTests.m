 //
//  DPValueMeterViewTests.m
//  DPValueMeterViewTests
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import "DPMeterView.h"
#import <QuartzCore/QuartzCore.h>

#import "Kiwi.h"

#define EPSILON     1e-5


SPEC_BEGIN(Test)

describe(@"DPLinearMeterView", ^{
    __block DPMeterView *meterView = nil;
    
    beforeEach(^{
        meterView = [[DPMeterView alloc] init];
    });
    
    afterAll(^{
        meterView = nil;
    });
    
    it(@"should have a progress at 0 by default", ^{
        [[theValue(meterView.progress) should] equal:0 withDelta:EPSILON];
    });
    
    it(@"should set progress to correct value", ^{
        [meterView setProgress:0.65];
        [[theValue(meterView.progress) should] equal:0.65 withDelta:EPSILON];
    });
    
    it(@"should increase current value", ^{
        [meterView setProgress:0.65];
        [meterView add:0.12];
        [[theValue(meterView.progress) should] equal:0.77 withDelta:EPSILON];
    });
    
    it(@"should decrease current value", ^{
        [meterView setProgress:0.65];
        [meterView minus:0.12];
        [[theValue(meterView.progress) should] equal:0.53 withDelta:EPSILON];
    });
    
    it(@"should descrese until a minimum of 0", ^{
        [meterView setProgress:0.15];
        [meterView minus:0.3];
        [[theValue(meterView.progress) should] equal:0 withDelta:EPSILON];
    });
    
    it(@"should increse until a maximum of 1", ^{
        [meterView setProgress:0.85];
        [meterView add:0.2];
        [[theValue(meterView.progress) should] equal:1 withDelta:EPSILON];
    });
    
    it(@"should have gravity disable by default", ^{
        [[theValue([meterView isGravityActive]) should] beNo];
    });
    
    it(@"should return YES to isGravityActive selector", ^{
        [meterView startGravity];
        [[theValue([meterView isGravityActive]) should] beYes];
    });
    
    it(@"should stop gravity when requested", ^{
        [meterView startGravity];
        [meterView stopGravity];
        [[theValue([meterView isGravityActive]) should] beNo];
    });
    
    it(@"should have the startPoint at the top by default", ^{
        [meterView setProgress:0.5];
        CGPoint point = [(CAGradientLayer *)[meterView layer] startPoint];
        [[theValue(point.y) should] equal:1 withDelta:EPSILON];
    });
    
    it(@"should have the endPoint at the bottom by default", ^{
        [meterView setProgress:0.5];
        CGPoint point = [(CAGradientLayer *)[meterView layer] endPoint];
        [[theValue(point.y) should] equal:0 withDelta:EPSILON];
    });
    
    context(@"has gravity activated", ^{
        
        beforeEach(^{
            [meterView startGravity];
        });
        
        it(@"should reset gradient orientation when disabling gravity", ^{
            [meterView stopGravity];
            [[theValue([meterView gradientOrientationAngle]) should] equal:M_PI_2 withDelta:EPSILON];
        });
        
    });
    
    context(@"has a yaw", ^{
        
        beforeEach(^{
        });
        
        afterEach(^{
        });
        
        it(@"should return the current gradient orientation", ^{
            [meterView setGradientOrientationAngle:M_PI/6];
            [[theValue([meterView gradientOrientationAngle]) should] equal:M_PI/6 withDelta:EPSILON];
        });
        
        it(@"should have the start point and the end point stay in the [0,1] interval", ^{
            [meterView setGradientOrientationAngle:-1.01*M_PI_2];
            CGPoint s = [(CAGradientLayer *)[meterView layer] startPoint];
            CGPoint e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.x) should] equal:0.5 withDelta:(0.5+EPSILON)];
            [[theValue(s.y) should] equal:0.5 withDelta:(0.5+EPSILON)];
            [[theValue(e.x) should] equal:0.5 withDelta:(0.5+EPSILON)];
            [[theValue(e.y) should] equal:0.5 withDelta:(0.5+EPSILON)];
        });
        
        it(@"should have a vertical 'up' gradient", ^{
            [meterView setGradientOrientationAngle:M_PI_2];
            CGPoint s = [(CAGradientLayer *)[meterView layer] startPoint];
            CGPoint e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.x) should] equal:0.5 withDelta:(0.5+EPSILON)];
            [[theValue(s.y) should] equal:1.0 withDelta:(0.5+EPSILON)];
            [[theValue(e.x) should] equal:0.5 withDelta:(0.5+EPSILON)];
            [[theValue(e.y) should] equal:0.0 withDelta:(0.5+EPSILON)];
        });
        
        it(@"should have a vertical 'down' gradient", ^{
            [meterView setGradientOrientationAngle:3*M_PI_2];
            CGPoint s = [(CAGradientLayer *)[meterView layer] startPoint];
            CGPoint e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.x) should] equal:0.5 withDelta:EPSILON];
            [[theValue(s.y) should] equal:0.0 withDelta:EPSILON];
            [[theValue(e.x) should] equal:0.5 withDelta:EPSILON];
            [[theValue(e.y) should] equal:1.0 withDelta:EPSILON];
        });
        
        it(@"should have correct intersection points for a square wrapping the unit circle", ^{
            CGRect box = CGRectMake(-1.f, -1.f, 2.f, 2.f);
            NSArray *points = nil;
            CGPoint s, e;
            
            // quadran 1  PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:-1 withDelta:EPSILON];
            [[theValue(s.y) should] equal:-1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:1 withDelta:EPSILON];
            [[theValue(e.y) should] equal:1 withDelta:EPSILON];
            
            // quadran 2  3*PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:3*M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:1 withDelta:EPSILON];
            [[theValue(s.y) should] equal:-1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:-1 withDelta:EPSILON];
            [[theValue(e.y) should] equal:1 withDelta:EPSILON];
            
            // quadran 2  5*PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:5*M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:1 withDelta:EPSILON];
            [[theValue(s.y) should] equal:1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:-1 withDelta:EPSILON];
            [[theValue(e.y) should] equal:-1 withDelta:EPSILON];
            
            // quadran 2  7*PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:7*M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:-1 withDelta:EPSILON];
            [[theValue(s.y) should] equal:1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:1 withDelta:EPSILON];
            [[theValue(e.y) should] equal:-1 withDelta:EPSILON];
        });
        
        it(@"should have correct intersection points for a unit square [0,1]", ^{
            CGRect box = CGRectMake(0.f, 0.f, 1.f, 1.f);
            NSArray *points = nil;
            CGPoint s, e;
            
            // quadran 1  PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:0 withDelta:EPSILON];
            [[theValue(s.y) should] equal:0 withDelta:EPSILON];
            [[theValue(e.x) should] equal:1 withDelta:EPSILON];
            [[theValue(e.y) should] equal:1 withDelta:EPSILON];
            
            // quadran 2  3*PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:3*M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:1 withDelta:EPSILON];
            [[theValue(s.y) should] equal:0 withDelta:EPSILON];
            [[theValue(e.x) should] equal:0 withDelta:EPSILON];
            [[theValue(e.y) should] equal:1 withDelta:EPSILON];
            
            // quadran 2  5*PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:5*M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:1 withDelta:EPSILON];
            [[theValue(s.y) should] equal:1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:0 withDelta:EPSILON];
            [[theValue(e.y) should] equal:0 withDelta:EPSILON];
            
            // quadran 2  7*PI/4
            points = [DPMeterView intersectionPointsOfLineOrientedBy:7*M_PI_4 withBox:box];
            s = [points[0] CGPointValue], e = [points[1] CGPointValue];
            [[theValue(s.x) should] equal:0 withDelta:EPSILON];
            [[theValue(s.y) should] equal:1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:1 withDelta:EPSILON];
            [[theValue(e.y) should] equal:0 withDelta:EPSILON];
        });
        
        it(@"should have the start and the end points in the correct order", ^{
            CGPoint s, e;
            
            // NB: remember that the origin of coordinates for gradient points is
            //      (0,0) at top-left
            
            // quadran 1  PI/4
            [meterView setGradientOrientationAngle:M_PI_4];
            s = [(CAGradientLayer *)[meterView layer] startPoint];
            e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.y) should] beGreaterThan:theValue(e.y)];
            
            // quadran 2  3*PI/4
            [meterView setGradientOrientationAngle:3*M_PI_4];
            s = [(CAGradientLayer *)[meterView layer] startPoint];
            e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.y) should] beGreaterThan:theValue(e.y)];
            
            // quadran 3  5*PI/4
            [meterView setGradientOrientationAngle:5*M_PI_4];
            s = [(CAGradientLayer *)[meterView layer] startPoint];
            e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.y) should] beLessThan:theValue(e.y)];
            
            // quadran 4  7*PI/4
            [meterView setGradientOrientationAngle:7*M_PI_4];
            s = [(CAGradientLayer *)[meterView layer] startPoint];
            e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.y) should] beLessThan:theValue(e.y)];
        });

    });
    
    context(@"has a shape smaller than the view frame", ^{
        
        beforeEach(^{
            /**
             *  ----------------------------
             * |            ^               |
             * |           3px              |
             * |       --------------       |
             * |< 4px |              | 2px >|
             * |      |              |      |
             * |      |              |      |
             * |       --------------       |
             * |            ^               |
             * |           1px              |
             *  ----------------------------
             *
             * the outer box 
             *  size:   (width=20, height=20)
             *
             * the inner box (represents the rectangular shape)
             *  offset: (x=4, y=3)
             *  size:   (width=14, height=16)
             */
            CGRect box = CGRectMake(0, 0, 20.f, 20.f);
            CGRect innerBox = CGRectMake(4.f, 3.f, box.size.width - 6.f, box.size.height - 4.f);
            [meterView setFrame:box];
            [meterView setShape:[UIBezierPath bezierPathWithRect:innerBox].CGPath];
        });
        
        it(@"should have a rescaledProgress > 0", ^{
            CGFloat rescaledProgress = [meterView rescaledProgress:0.f];
            [[theValue(rescaledProgress) should] equal:0.05 withDelta:EPSILON];
        });
        
        it(@"should have a rescaledProgress correct", ^{
            CGFloat rescaledProgress = [meterView rescaledProgress:.5f];
            /**
             * 50% in the inner box is easy calculated
             * 0.5 * the inner box height
             *  => 8
             * then we shift the result up with 1 (the bottom padding)
             *  => 9
             * finally we translate that height in a percentage of the outer box height
             *  => 9.0 / 20
             */
            [[theValue(rescaledProgress) should] equal:0.45 withDelta:EPSILON];
        });
        
        it(@"should have a rescaledProgress correct for an horizontal meter type", ^{
            [meterView setMeterType:DPMeterTypeLinearHorizontal];
            CGFloat rescaledProgress = [meterView rescaledProgress:.5f];
            /**
             * 50% in the inner box is easy calculated
             * 0.5 * the inner box width
             *  => 7
             * then we shift the result up with 4 (the left padding)
             *  => 11
             * finally we translate that height in a percentage of the outer box height
             *  => 11.0 / 20
             */
            [[theValue(rescaledProgress) should] equal:0.55 withDelta:EPSILON];
        });

        
        it(@"should be completely filled for a progress of 1", ^{
            CGFloat rescaledProgress = [meterView rescaledProgress:1.f];
            // compute the equivalent height
            CGFloat h = rescaledProgress * meterView.bounds.size.height;
            // it should be more or equal to the (bottom padding + shape height)
            [[theValue(h) should] beGreaterThanOrEqualTo:theValue(1 + 16)];
        });
    
    });
    
    context(@"has a vertical meter type", ^{
        
        beforeEach(^{
            [meterView setMeterType:DPMeterTypeLinearHorizontal];
        });
        
        it(@"should has a vertical gradient", ^{
            [meterView setProgress:0.5f];
            [[theValue([meterView gradientOrientationAngle]) should] equal:0 withDelta:EPSILON];
        });
        
        it(@"should have the left-to-right gradient by default", ^{
            [meterView setProgress:0.5];
            CGPoint s = [(CAGradientLayer *)[meterView layer] startPoint], e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.x) should] equal:0 withDelta:EPSILON];
            [[theValue(e.x) should] equal:1 withDelta:EPSILON];
        });
        
        it(@"should have the right-to-left gradient", ^{
            [meterView setGradientOrientationAngle:M_PI];
            [meterView setProgress:0.5];
            CGPoint s = [(CAGradientLayer *)[meterView layer] startPoint], e = [(CAGradientLayer *)[meterView layer] endPoint];
            [[theValue(s.x) should] equal:1 withDelta:EPSILON];
            [[theValue(e.x) should] equal:0 withDelta:EPSILON];
        });
        
    });
    
    context(@"has an horizontal meter type", ^{
       
        beforeEach(^{
            [meterView setMeterType:DPMeterTypeLinearHorizontal];
        });
        
        it(@"should has an horizontal gradient", ^{
            [meterView setProgress:0.5f];
            [[theValue([meterView gradientOrientationAngle]) should] equal:0 withDelta:EPSILON];
        });
        
    });
});

SPEC_END