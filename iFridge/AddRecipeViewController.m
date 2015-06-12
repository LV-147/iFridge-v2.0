//
//  AddRecipeViewController.m
//  iFridge
//
//  Created by Vladius on 6/12/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "Ingredient+Cat.h"
#import "Recipe+Cat.h"
#import "UIViewController+Context.h"

@interface AddRecipeViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *recipeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@end

@implementation AddRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipeIngredients.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions
- (IBAction)cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done {
}

- (IBAction)addIngredient {
    
}

- (IBAction)takePicture {
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
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:3];
    
    Ingredient *ingredient = [self.ingredients objectAtIndex:indexPath.row];
    cell.textLabel.text = ingredient.label;
    
    NSString *quantity = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:ingredient.quantity]];
    cell.detailTextLabel.text = quantity;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
