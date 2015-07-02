//
//  ReminderTableViewController.h
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *ingredientsForReminder;
@property (strong, nonatomic) NSString *nameOfEventForCalendar;
@property (strong, nonatomic) NSString *selectedDate;

@end
