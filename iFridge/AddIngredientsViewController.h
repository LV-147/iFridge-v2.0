//
//  AddIngredientsViewController.h
//  iFridge
//
//  Created by Vladius on 6/12/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddIngredientsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ingredientLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityOfIngredient;
@property (weak, nonatomic) IBOutlet UITextField *units;
@end
