//
//  FridgeTableViewController.m
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "FridgeTableViewController.h"
#import "UIButton+FridgeBlock.h"
#import "UIAlertView+FridgeBlock.h"
#import "Fridge+Cat.h"
#import "Ingredient+Cat.h"
#import "UIViewController+Context.h"
#import "AddProductViewController.h"
#import "FridgeTableViewCell.h"
#import "DataDownloader.h"
#import "RecipesTVC.h"
#import "RecipeWithImage.h"


@class UITableView;


@interface FridgeTableViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *toaddItems;
@property (strong, nonatomic) Fridge *fridge;
@property (strong, nonatomic) Recipe *recipe;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonForTaras;
@property (strong, nonatomic) RecipeWithImage *detailRecipeController;

@end

@implementation FridgeTableViewController
#pragma mark - Custom accessors


#pragma mark - View life cycle

- (void)viewDidLoad {
     [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toaddItems = [[NSMutableArray alloc] init];
    
    //right barButtonItem
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(editAction:)];
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct:)];
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editBarButtonItem, flexibleSpaceButton, addBarButtonItem, nil];
    

    //products are allready fridge
    self.fridge = [Fridge addFridgeWithName:@"MyFridge" inManagedObjectContext:self.currentContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    request.predicate = [NSPredicate predicateWithFormat:@"fromFridge = %@", self.fridge];
    
    NSError *error;
    self.toaddItems = [[NSMutableArray alloc] initWithArray:[self.currentContext executeFetchRequest:request error:&error]];
    
      [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fridge2.jpg"]];

    self.tableView.backgroundView.alpha = 0.2f;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationController.toolbarHidden = NO;
    
    
    if (UIUserInterfaceIdiomPad) {
       
        self.detailRecipeController = [self.splitViewController.viewControllers objectAtIndex:1];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.toaddItems) self.title = @"My Fridge";
    else self.title = @"My Fridge (empty)";
    self.navigationController.toolbarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - UITableView data source and delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.toaddItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifier = @"FridgeCell";
    
    FridgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    
    // Update cell content from data source.
    
    Ingredient *ingr = [self.toaddItems objectAtIndex:indexPath.row];
    
    cell.nameOfProduct.text = ingr.label;
    cell.quantityOfProduct.text = [ingr.quantity stringValue];
    cell.units.text = ingr.unitOfMeasure;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *toaddItem = self.toaddItems[indexPath.row];
    
    // Remove to-do item.
    [Ingredient deleteIngredient:[self.toaddItems objectAtIndex:indexPath.row]
                      fromFridge:self.fridge
          inManagedObjectContext:self.currentContext];
    
    [self.toaddItems removeObject:toaddItem];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - IBActions


//edit button
- (void)editAction:(id)sender
{
    [self performSegueWithIdentifier:@"EditProduct" sender:self];
    NSLog(@"edit button clicked");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *query = [DataDownloader getQueryStringFromArray:self.toaddItems];
    RecipesTVC *newController = segue.destinationViewController;
    //newController.query = query;
}

- (IBAction)buttonForTaras:(id)sender {
    
}


- (IBAction)addProduct:(id)sender {
    // Display an alert view with a text input.
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:@"Add a new product:"
                                                             message:nil delegate:nil
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:@"Add", nil];
    
    inputAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    __weak FridgeTableViewController *weakSelf = self;
    
    // Add a completion block (using our category to UIAlertView).
    [inputAlertView setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        // If user pressed 'Add'...
        if (buttonIndex == 1) {
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *string = [textField.text capitalizedString];
            NSMutableDictionary *ingredientDict = [[NSMutableDictionary alloc] init];
            [ingredientDict setObject:string forKey:INGREDIENT_LABEL_KEY];
            [weakSelf.toaddItems addObject:[Ingredient addIngredientForRecipe:self.recipe
                                                                     withInfo:ingredientDict
                                                                     toFridge:self.fridge
                                                       inManagedObiectContext:self.currentContext]];
            
            NSUInteger row = [weakSelf.toaddItems count] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    [inputAlertView show];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor lightGrayColor];
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.toaddItems exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor clearColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

- (IBAction)ingredientAddedToFridge:(UIStoryboardSegue *)segue
{
    AddProductViewController *addProductViewController = segue.sourceViewController;
    if (addProductViewController.nameTextField.text) {
        NSDictionary *ingredient = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    addProductViewController.nameTextField.text, INGREDIENT_LABEL_KEY,
                                    [NSNumber numberWithDouble:[addProductViewController.quantityTextField.text doubleValue]], INGREDIENT_QUANTITY_KEY,
                                    addProductViewController.unitsTextField.text, INGREDIENT_MEASURE_KEY,
                                    nil];
        [self.toaddItems addObject:[Ingredient addIngredientForRecipe:nil
                                                             withInfo:ingredient
                                                             toFridge:self.fridge
                                               inManagedObiectContext:self.currentContext]];
        
        
        
        
        [self.tableView reloadData];
    }else{
        UIAlertView *emptyLabel = [[UIAlertView alloc] initWithTitle:@"Empty label"
                                                             message:@"Please enter ingredient label at least"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyLabel show];
    }
}


#pragma mark - Helper methods


/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


@end
