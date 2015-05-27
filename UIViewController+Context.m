//
//  UIViewController+Context.m
//  iFridge
//
//  Created by Vladius on 5/19/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "UIViewController+Context.h"
#import "AppDelegate.h"

@implementation UIViewController (Context)

- (NSManagedObjectContext *)currentContext {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

@end
