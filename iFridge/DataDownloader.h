//
//  DataDownloader.h
//  iFridge
//
//  Created by Vladius on 5/27/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownloader : NSObject
@property (strong, nonatomic) NSArray *recipes;

- (void)downloadRecipesForQuery:(NSString *)query
<<<<<<< HEAD
                           than:(void(^)(NSArray *recipes))handler;
=======
                           than:(void(^)())handler;
>>>>>>> Taras_Hates_GitHub_branch
@end
