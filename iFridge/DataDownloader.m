//
//  DataDownloader.m
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "DataDownloader.h"
#import <AFNetworking/AFNetworking.h>

@interface DataDownloader()
@property (strong, nonatomic) NSDictionary *requestResults;

@end

@implementation DataDownloader

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
{
    NSString *myRequest = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://api.edamam.com/search?q=",query,@"&app_id=4e8543af&app_key=e1309c8e747bdd4d7363587a4435f5ee&from=0&to=100"];
//    NSLog(@"myLink: %@", myRequest);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:myRequest
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *allRecipes = (NSDictionary *) responseObject;
             self.recipes = allRecipes[@"hits"];
//             NSLog(@"JSON: %@", self.recipes);
             handler();
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}
@end
