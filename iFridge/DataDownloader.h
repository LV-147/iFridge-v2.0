//
//  DataDownloader.h
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>

@interface DataDownloader : NSObject

@property (strong, nonatomic) NSArray *recipes;

- (void)downloadRecipesForQuery:(NSString *)query
                           than:(void(^)())handler;

- (void)setImageWithURL:(NSString *)imageLink
         usingImageView:(UIImageView *) imageView;

@end
