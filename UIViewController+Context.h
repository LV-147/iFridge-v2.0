//
//  UIViewController+Context.h
//  iFridge
//
//  Created by Vladius on 5/19/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Context)

- (NSManagedObjectContext *)currentContext;

@end
