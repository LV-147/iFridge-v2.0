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
#import "Ingredient.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface DataDownloader ()

@end

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

NSString *app_id = @"098aa935"; //@"4e8543af";
NSString *app_key =
    @"e6f6e485b0222cf1b48439a164562270"; //@"e1309c8e747bdd4d7363587a4435f5ee";

@implementation DataDownloader

+ (void)downloadRecipesForQuery:(NSString *)query
          withCompletionHandler:(void (^)(NSArray *recipes))handler {
  if (!query) {
    handler(nil);
    return;
  }
  query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  NSString *myRequest = [[NSString alloc]
      initWithFormat:@"https://api.edamam.com/"
                     @"search?q=%@&app_id=%@&app_key=%@&from=0&to=100",
                     query, app_id, app_key];

  //    NSLog(@"myLink: %@", myRequest);

  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  [manager.operationQueue cancelAllOperations];
  [manager GET:myRequest
      parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *recipes = [[NSArray alloc]
            initWithArray:((NSDictionary *)responseObject)[@"hits"]];
        //             NSLog(@"JSON: %@", self.recipes);
        handler(recipes);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Downloading failed with error: %@", error);
        handler(nil);
      }];
}

+ (void)setRecipeImageWithURL:(NSString *)imageLink
               usingImageView:(UIImageView *)imageView
        withCompletionHandler:(void (^)())handler {
  NSLog(@"%@", [imageLink substringWithRange:NSMakeRange(0, 3)]);
  if ([[imageLink substringWithRange:NSMakeRange(0, 3)] isEqual:@"htt"]) {
    [[SDWebImageDownloader sharedDownloader]
        downloadImageWithURL:[NSURL URLWithString:imageLink]
                     options:SDWebImageDownloaderLowPriority
                    progress:nil
                   completed:^(UIImage *image, NSData *data, NSError *error,
                               BOOL finished) {
                     if (image)
                       [imageView setImage:image];
                     else
                       [imageView setImage:[UIImage imageNamed:@"noimage"]];
                     if (handler) {
                       handler();
                     }
                   }];
  } else {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:imageLink]
        resultBlock:^(ALAsset *asset) {
          UIImage *copyOfOriginalImage = [UIImage
              imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]
                         scale:0.5
                   orientation:UIImageOrientationUp];
          [imageView setImage:copyOfOriginalImage];
          if (handler)
            handler();
        }
        failureBlock:^(NSError *error) {
          [imageView setImage:[UIImage imageNamed:@"noimage"]];
        }];
  }
}

+ (void)networkIsReachable {
  NSURL *baseURL = [NSURL URLWithString:@"https://www.edamam.com/"];
  AFHTTPRequestOperationManager *manager =
      [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];

  NSOperationQueue *operationQueue = manager.operationQueue;
  [manager.reachabilityManager
      setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
          [operationQueue setSuspended:NO];
          break;
        case AFNetworkReachabilityStatusNotReachable:
        default:
          [operationQueue setSuspended:YES];
          UIAlertView *message = [[UIAlertView alloc]
                  initWithTitle:@"Warning"
                        message:@"You are not connected to the network"
                       delegate:nil
              cancelButtonTitle:@"Ok"
              otherButtonTitles:nil];
          [message show];
          break;
        }
      }];

  [manager.reachabilityManager startMonitoring];
}

+ (NSString *)getQueryStringFromArray:(NSMutableArray *)array {
  NSString *queryString = @"";
  for (Ingredient *ing in array) {
    queryString = [queryString stringByAppendingString:ing.label];
    if (!(ing == [array lastObject])) {
      queryString = [queryString stringByAppendingString:@", "];
    }
  }

  return queryString;
}

@end
