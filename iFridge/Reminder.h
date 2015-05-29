//
//  Reminder.h
//  iFridge
//
//  Created by Vladius on 5/29/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient;

@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSSet *ingredientsToBuy;
@end

@interface Reminder (CoreDataGeneratedAccessors)

- (void)addIngredientsToBuyObject:(Ingredient *)value;
- (void)removeIngredientsToBuyObject:(Ingredient *)value;
- (void)addIngredientsToBuy:(NSSet *)values;
- (void)removeIngredientsToBuy:(NSSet *)values;

@end
