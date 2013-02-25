//
//  DPViewController.h
//  DPValueMeterView
//
//  Created by Pierre Dulac on 27/01/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DPMeterView;

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) IBOutlet DPMeterView *shape1View;
@property (strong, nonatomic) IBOutlet DPMeterView *shape2View;
@property (strong, nonatomic) IBOutlet DPMeterView *shape3View;
@property (strong, nonatomic) IBOutlet DPMeterView *shape4View;
@property (strong, nonatomic) IBOutlet DPMeterView *shape5View;

@property (strong, nonatomic) IBOutlet UILabel *orientationLabel;
@property (strong, nonatomic) IBOutlet UISlider *orientationSlider;
@property (strong, nonatomic) IBOutlet UISwitch *gravitySwitch;

- (IBAction)minus:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)orientationHasChanged:(id)sender;
- (IBAction)toggleGravity:(id)sender;

@end
