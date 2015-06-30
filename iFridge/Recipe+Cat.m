//
//  Recipe+Cat.m
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Recipe+Cat.h"
#import "Ingredient+Cat.h"

@implementation Recipe (Cat)

+ (Recipe *)createRecipeWithInfo:(NSDictionary *)recipeDict
          inManagedObiectContext:(NSManagedObjectContext *)context{
    
    Recipe *recipe = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = [NSPredicate predicateWithFormat:@"label = %@", [recipeDict valueForKeyPath:@"recipe.label"]];
    
    NSError *error;
    NSArray *mathes = [context executeFetchRequest:request error:&error];
    
    if (!mathes || error || mathes.count > 1) {
        NSLog(@"matches %@ /n error %@", mathes, error);
        
    }else if (mathes.count){
        recipe = mathes.firstObject;
        
    }else{
        recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
        recipe.label = [recipeDict valueForKeyPath:@"recipe.label"];
        recipe.imageUrl = [recipeDict valueForKeyPath:@"recipe.image"];
        recipe.cookingTime = [recipeDict valueForKeyPath:@"recipe.cookingTime"];
        recipe.weight = [recipeDict valueForKeyPath:@"recipe.totalWeight"];
        recipe.calories = [recipeDict valueForKeyPath:@"recipe.calories"];
        NSMutableSet *ingredients = [[NSMutableSet alloc]init];
        NSArray *recipeIngredients = [recipeDict valueForKeyPath:@"recipe.ingredients"];
        for(NSDictionary* ingredient in recipeIngredients){
            [ingredients addObject:[Ingredient addIngredientForRecipe:recipe
                                                             withInfo:ingredient
                                                             toFridge:nil
                                               inManagedObiectContext:context]];
        }
        recipe.ingredients = [NSSet setWithSet:ingredients];
        [context save:NULL];
    }
    
    return recipe;
}

+ (void)deleteRecipe:(Recipe *)recipe fromManagedObjectContext:(NSManagedObjectContext *)context{

    [context deleteObject:recipe];
    [context save:NULL];
}
@end
