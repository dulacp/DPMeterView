//
//  DPViewController.h
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DPLinearMeterView;

@interface DPViewController : UIViewController

@property (nonatomic, strong) DPLinearMeterView* filledView;
- (IBAction)animate:(id)sender;

@end
