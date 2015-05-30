//
//  UIAlertView+ReminderBlock.h
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReminderAlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (ReminderBlock)

- (void)setCompletionBlock:(ReminderAlertViewCompletionBlock)completionBlock;
- (ReminderAlertViewCompletionBlock)completionBlock;


@end
