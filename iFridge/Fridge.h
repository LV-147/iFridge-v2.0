//
//  Fridge.h
//  iFridge
//
//  Created by Vladius on 5/18/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient;

@interface Fridge : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *ingredient;
@end

@interface Fridge (CoreDataGeneratedAccessors)

- (void)addIngredientObject:(Ingredient *)value;
- (void)removeIngredientObject:(Ingredient *)value;
- (void)addIngredient:(NSSet *)values;
- (void)removeIngredient:(NSSet *)values;

@end
