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

@property (strong, nonatomic) IBOutlet DPLinearMeterView *shape1View;
@property (strong, nonatomic) IBOutlet DPLinearMeterView *shape2View;
@property (strong, nonatomic) IBOutlet DPLinearMeterView *shape3View;
@property (strong, nonatomic) IBOutlet DPLinearMeterView *shape4View;

@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UISwitch *gravitySwitch;

- (IBAction)minus:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)toggleGravity:(id)sender;

@end
