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
<<<<<<< HEAD
                           than:(void(^)(NSArray *recipes))handler;
=======
                           than:(void(^)())handler;
<<<<<<< HEAD

- (void)setImageWithURL:(NSString *)imageLink
         usingImageView:(UIImageView *) imageView;

=======
>>>>>>> Taras_Hates_GitHub_branch
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
@end
