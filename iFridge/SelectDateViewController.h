//
//  SelectDateViewController.h
//  iFridge
//
//  Created by Pavlo Bardar on 6/29/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderTableViewController.h"

@protocol DatePickerDelegate <NSObject>

-(void)pickDateWithSelectedDate:(NSDate *)selectedDate;

@end

@interface SelectDateViewController : UIViewController

@property (weak, nonatomic) id <DatePickerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *selectDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;




@end
