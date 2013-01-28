//
//  DPViewController.h
//  PathFill
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DPFilledPathView;

@interface DPViewController : UIViewController

@property (nonatomic, strong) DPFilledPathView* filledView;
- (IBAction)animate:(id)sender;

@end
