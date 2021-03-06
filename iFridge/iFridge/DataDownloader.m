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

NSString *app_id = @"4e8543af";
NSString *app_key = @"e1309c8e747bdd4d7363587a4435f5ee";

@implementation DataDownloader

+ (void)downloadRecipesForQuery:(NSString *)query
          withCompletionHandler:(void(^)(NSArray *recipes))handler
{
    query = [query stringByReplacingOccurrencesOfString: @" " withString:@"+"];
    if (!query) return;
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
         }];
}

+ (void)setRecipeImageWithURL:(NSString *)imageLink usingImageView:(UIImageView *)imageView {
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageLink]
                                                         options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                           
                                                           [imageView setBackgroundColor:[UIColor colorWithPatternImage:image]];
                                                       }];
}
@end
