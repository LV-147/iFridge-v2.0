//
//  DataDownloader.h
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
<<<<<<< HEAD
#import <UIKit/UIKit.h>

@interface DataDownloader : NSObject

+ (void)downloadRecipesForQuery:(NSString *)query
          withCompletionHandler:(void(^)(NSArray *recipes))handler;

+ (void)setRecipeImageWithURL:(NSString *)imageLink usingImageView:(UIImageView *)imageView
        withCompletionHandler:(void(^)())handler;
=======
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>

@interface DataDownloader : NSObject

@property (strong, nonatomic) NSArray *recipes;

- (void)downloadRecipesForQuery:(NSString *)query
                           than:(void(^)())handler;

- (void)setImageWithURL:(NSString *)imageLink
         usingImageView:(UIImageView *) imageView;

>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
@end
