//
//  UIAlertView+FridgeBlock.h
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FridgeAlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (FridgeBlock)

- (void)setCompletionBlock:(FridgeAlertViewCompletionBlock)completionBlock;
- (FridgeAlertViewCompletionBlock)completionBlock;


@end
