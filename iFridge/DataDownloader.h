//
//  DataDownloader.h
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownloader : NSObject

+ (void)downloadRecipesForQuery:(NSString *)query
                           than:(void(^)(NSArray *recipes))handler;

+ (void)setRecipeImageWithURL:(NSString *)imageLink usingImageView:(UIImageView *)imageView;
@end
