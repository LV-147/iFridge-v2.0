//
//  UIButton+ReminderBlock.m
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "UIButton+ReminderBlock.h"
#import <objc/runtime.h>

@implementation UIButton (ReminderBlock)

#pragma mark - Custom accessors

- (void)addActionblock:(ReminderButtonActionBlock)actionBlock forControlEvents:(UIControlEvents)events {
    
    // Store it.
    objc_setAssociatedObject(self, @selector(actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // Add self as target and -performActionBlock as action.
    [self addTarget:self action:@selector(performActionBlock:) forControlEvents:events];
}

- (ReminderButtonActionBlock)actionBlock {
    return objc_getAssociatedObject(self, @selector(actionBlock));
}

#pragma mark - IBActions

- (IBAction)performActionBlock:(id)sender {
    
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}




@end
