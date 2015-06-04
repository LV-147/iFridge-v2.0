//
//  Fridge+Cat.h
//  iFridge
//
//  Created by Vladius on 5/18/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "Fridge.h"

@interface Fridge (Cat)

+ (Ingredient *)addIngredientWithInfo:(NSDictionary *)ingredientDict
                             toFridge:(Fridge *)fridge
               inManagedObjectContext:(NSManagedObjectContext *)context;
@end
