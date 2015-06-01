//
//  Recipe+Cat.h
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Recipe.h"

@interface Recipe (Cat)

+ (void)createRecipeWithInfo:(NSDictionary *)recipeDict
          inManagedObiectContext:(NSManagedObjectContext *)context;

+ (void)deleteRecipe:(Recipe *)recipe fromManagedObjectContext:(NSManagedObjectContext *)context;

@end
