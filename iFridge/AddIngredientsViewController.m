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



@end

@implementation AddIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done {
    if ([self.ingredientLabel.text isEqualToString:@""] ||
        [self.ingredientLabel.text isEqualToString:@"Label"]) {
        UIAlertView *emptyLabel = [[UIAlertView alloc] initWithTitle:@"Empty label"
                                                             message:@"Please enter ingredient label at least"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyLabel show];
    }else{
        [self performSegueWithIdentifier:@"ingredientAddedSegue" sender:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    return YES;
}

@end
