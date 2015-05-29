//
//  Recipe.h
//  iFridge
//
//  Created by Vladius on 5/19/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber * cookingTime;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * fat;
@property (nonatomic, retain) NSNumber * sugars;
@property (nonatomic, retain) NSString * cookingLevel;
@property (nonatomic, retain) NSSet *ingredients;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
