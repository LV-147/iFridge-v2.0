//
//  DataDownloader.m
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "DataDownloader.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImageManager.h>

@interface DataDownloader()

@end

NSString *app_id = @"098aa935";//@"4e8543af";
NSString *app_key = @"e6f6e485b0222cf1b48439a164562270";//@"e1309c8e747bdd4d7363587a4435f5ee";

@implementation DataDownloader

<<<<<<< HEAD
+ (void)downloadRecipesForQuery:(NSString *)query
          withCompletionHandler:(void(^)(NSArray *recipes))handler
=======
- (void)setImageWithURL:(NSString *)imageLink usingImageView: (UIImageView *) imageView {
   
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageLink]
                                                         options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                           
                                                           [imageView setBackgroundColor:[UIColor colorWithPatternImage:image]];
                                                       }];

}


- (void)downloadRecipesForQuery:(NSString *)query
                           than:(void(^)())handler
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
{
    if (!query)
    {
        handler(nil);
        return;
    }
    query = [query stringByReplacingOccurrencesOfString: @" " withString:@"+"];
    NSString *myRequest = [[NSString alloc] initWithFormat:@"https://api.edamam.com/search?q=%@&app_id=%@&app_key=%@&from=0&to=100", query, app_id, app_key];

//    NSLog(@"myLink: %@", myRequest);


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    [manager GET:myRequest
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *recipes = [[NSArray alloc] initWithArray:((NSDictionary *) responseObject)[@"hits"]];
//             NSLog(@"JSON: %@", self.recipes);
             handler(recipes);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Downloading failed with error: %@", error);
             handler(nil);
         }];
}

+ (void)setRecipeImageWithURL:(NSString *)imageLink usingImageView:(UIImageView *)imageView
        withCompletionHandler:(void(^)())handler
{
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageLink]
                                                         options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                           [imageView setImage:image];
                                                           if (handler) handler();
                                                       }];
}
@end
