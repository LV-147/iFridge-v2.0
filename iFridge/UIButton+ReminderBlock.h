//
//  UIButton+ReminderBlock.h
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReminderButtonActionBlock)(UIButton *sender);

@interface UIButton (ReminderBlock)

- (void)addActionblock:(ReminderButtonActionBlock)actionBlock forControlEvents:(UIControlEvents)events;

- (ReminderButtonActionBlock)actionBlock;

@end
