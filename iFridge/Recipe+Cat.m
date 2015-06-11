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
        recipe.fat = [recipeDict valueForKeyPath:@"recipe.totalNutrients.FAT.quantity"];
        recipe.sugars = [recipeDict valueForKeyPath:@"recipe.totalNutrients.SUGAR.quantity"];
        recipe.cookingLevel = [recipeDict valueForKeyPath:@"recipe.level"];
        
        NSMutableSet *ingredients = [[NSMutableSet alloc]init];
        NSArray *recipeIngredients = [recipeDict valueForKeyPath:@"recipe.ingrediens"];
        for(NSDictionary* ingredient in recipeIngredients){
            [ingredients addObject:[Ingredient addIngredientForRecipe:recipe withInfo:ingredient inManagedObiectContext:context]];
        }
        recipe.ingredients = [NSSet setWithSet:ingredients];
        [context save:NULL];
    }
    
    return recipe;
}

+ (NSDictionary *)deleteRecipe:(Recipe *)recipe fromManagedObjectContext:(NSManagedObjectContext *)context{
    
    NSMutableDictionary *recipeDict = [[NSMutableDictionary alloc] init];
    [recipeDict setObject:recipe.label forKey:@"label"];
    [recipeDict setObject:recipe.imageUrl forKey:@"image"];
    [recipeDict setObject:recipe.cookingTime forKey:@"cookingTime"];
    [recipeDict setObject:recipe.weight forKey:@"totalWeight"];
    [recipeDict setObject:recipe.cookingLevel forKey:@"level"];
    
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    for (Ingredient *ingredient in recipe.ingredients) {
        NSMutableDictionary *ingredientDict = [[NSMutableDictionary alloc] init];
        [ingredientDict setObject:ingredient.label forKey:@"label"];
        [ingredientDict setObject:ingredient.quantity forKey:@"quantity"];
        [ingredients addObject:ingredientDict];
        ingredientDict = nil;
    }
    [recipeDict setObject:ingredients forKey:@"ingrediens"];
    NSDictionary *deletedRecipe = [NSDictionary dictionaryWithObjects:@[recipeDict] forKeys:@[@"recipe"]];

    [context deleteObject:recipe];
    [context save:NULL];
    
    return deletedRecipe;
}
@end
