//
//  SelectDateViewController.h
//  iFridge
//
//  Created by Pavlo Bardar on 6/29/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *selectDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)pickerAction:(id)sender;

@end
