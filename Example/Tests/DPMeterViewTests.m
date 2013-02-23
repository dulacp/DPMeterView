//
//  DPValueMeterViewTests.m
//  DPValueMeterViewTests
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import "DPLinearMeterView.h"
#import <QuartzCore/QuartzCore.h>

#import "Kiwi.h"

#define EPSILON     1e-5


SPEC_BEGIN(Test)

describe(@"DPLinearMeterView", ^{
    __block DPLinearMeterView *meterView = nil;
    
    beforeEach(^{
        meterView = [[DPLinearMeterView alloc] init];
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
    
    context(@"has a yaw", ^{
        __block CGFloat fakeYaw = 0.1f;
        
        beforeEach(^{
            [meterView startGravity];
            ((CAGradientLayer *)meterView.layer).startPoint = CGPointMake(0.5f-fakeYaw, 1.f);
            ((CAGradientLayer *)meterView.layer).endPoint = CGPointMake(0.5f, 0.f);
        });
        
        afterEach(^{
        });
        
        it(@"should return the current yaw", ^{
            [[theValue([meterView currentYaw]) should] equal:fakeYaw withDelta:EPSILON];
        });
        
        it(@"should reset gradient orientation when disabling gravity", ^{
            [meterView stopGravity];
            [[theValue([meterView currentYaw]) should] equal:0 withDelta:EPSILON];
        });

    });
    
});

SPEC_END