//
//  DataDownloader.h
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataDownloader : NSObject

+ (void)downloadRecipesForQuery:(NSString *)query
          withCompletionHandler:(void(^)(NSArray *recipes))handler;

+ (void)setRecipeImageWithURL:(NSString *)imageLink usingImageView:(UIImageView *)imageView
        withCompletionHandler:(void(^)())handler;

+ (void)networkIsReachable;

+ (NSString *)getQueryStringFromArray:(NSMutableArray *)array;
@end
