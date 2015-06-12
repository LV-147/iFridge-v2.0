//
//  AddIngredientsViewController.m
//  iFridge
//
//  Created by Vladius on 6/12/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "AddIngredientsViewController.h"
#import "Ingredient+Cat.h"
#import "AddRecipeViewController.h"

@interface AddIngredientsViewController () <UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ingredientLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityOfIngredient;
@property (weak, nonatomic) IBOutlet UITextField *unitOfMeasureOfIngredient;

@property (strong, nonatomic) Ingredient *ingredient;
@end

@implementation AddIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

- (IBAction)ingredientAdded:(UIStoryboardSegue *)segue
{
    if (self.ingredientLabel.text) {
        self.ingredient.label = self.ingredientLabel.text;
        self.ingredient.quantity = [NSNumber numberWithDouble:[self.quantityOfIngredient.text doubleValue]];
        
        AddRecipeViewController *addRecipeController = (AddRecipeViewController *)segue.sourceViewController;
        [addRecipeController.ingredients addObject:self.ingredient];
        [addRecipeController.recipeIngredients reloadData];
    }else{
        UIAlertView *emptyLabel = [[UIAlertView alloc] initWithTitle:@"Empty label"
                                                             message:@"Please enter ingredient label at least"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyLabel show];
    }
}
@end
