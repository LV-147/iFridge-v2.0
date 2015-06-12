//
//  Fridge+Cat.h
//  iFridge
//
//  Created by Vladius on 5/18/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "Fridge.h"

@interface Fridge (Cat)

+ (Fridge *)addFridgeWithName:(NSString *)fridgeName
       inManagedObjectContext:(NSManagedObjectContext *)context;
@end
