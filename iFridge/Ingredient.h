//
//  Ingredient.h
//  iFridge
//
//  Created by Vladius on 5/18/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fridge, Recipe;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSDate * storagePer;
@property (nonatomic, retain) Fridge *fromFridge;
@property (nonatomic, retain) Recipe *forRecipe;

@end
