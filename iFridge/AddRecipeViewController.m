//
//  AddRecipeViewController.m
//  iFridge
//
//  Created by Vladius on 6/12/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "AddIngredientsViewController.h"
#import "Ingredient+Cat.h"
#import "Recipe+Cat.h"
#import "UIViewController+Context.h"

@interface AddRecipeViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ingredients = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions
- (IBAction)cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)takePicture {
}

#pragma mark text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ingredients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Ingredient cell" forIndexPath:indexPath];
    
    NSDictionary *ingredient = [self.ingredients objectAtIndex:indexPath.row];
    cell.textLabel.text = [ingredient valueForKey:@"label"];
    cell.detailTextLabel.text = [ingredient valueForKey:@"quantity"];
    return cell;
}

#pragma mark - Navigation

- (IBAction)ingredientAdded:(UIStoryboardSegue *)segue
{
    AddIngredientsViewController *addIngredientsController = segue.sourceViewController;
    if (addIngredientsController.ingredientLabel.text) {
        NSDictionary *ingredient = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    addIngredientsController.ingredientLabel.text, @"label",
                                    addIngredientsController.quantityOfIngredient.text, @"quantity",
                                    addIngredientsController.units.text, @"units",
                                    nil];
        [self.ingredients addObject:ingredient];
        
        [self.tableView reloadData];
    }else{
        UIAlertView *emptyLabel = [[UIAlertView alloc] initWithTitle:@"Empty label"
                                                             message:@"Please enter ingredient label at least"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyLabel show];
    }
}

@end
