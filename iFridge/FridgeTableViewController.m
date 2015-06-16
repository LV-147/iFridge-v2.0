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

@class UITableView;


@interface FridgeTableViewController ()

@property (strong, nonatomic) NSMutableArray *toaddItems;
@property (strong, nonatomic) Fridge *fridge;
@property (strong, nonatomic) Recipe *recipe;



@end

@implementation FridgeTableViewController
#pragma mark - Custom accessors

- (NSMutableArray *)toaddItems {
//    if (!_toaddItems) {
//        _toaddItems = [@[@"You may add some products"] mutableCopy];
//    }
    return _toaddItems;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
     [super viewDidLoad];
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(editAction:)];
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct:)];
    
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editBarButtonItem, flexibleSpaceButton, addBarButtonItem, nil];
    
    


    //products is allready fridge
    self.fridge = [Fridge addFridgeWithName:@"MyFridge" inManagedObjectContext:self.currentContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    request.predicate = [NSPredicate predicateWithFormat:@"fromFridge = %@", self.fridge];
    
    NSError *error;
    self.toaddItems = [[NSMutableArray alloc] initWithArray:[self.currentContext executeFetchRequest:request error:&error]];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fridge2.jpg"]];

    self.tableView.backgroundView.alpha = 0.2f;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.toaddItems) self.title = @"My Fridge";
    else self.title = @"My Fridge (empty)";
}

#pragma mark - UITableView data source and delegate methods



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toaddItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    
    // Update cell content from data source.
    Ingredient *object = self.toaddItems[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = object.label;
    

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
- (IBAction)editAction:(id)sender
{
    NSLog(@"edit button clicked");
}


- (IBAction)addProduct:(id)sender {
    // Display an alert view with a text input.
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:@"Add a new product:" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Add", nil];
    
    inputAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    __weak FridgeTableViewController *weakSelf = self;
    
    // Add a completion block (using our category to UIAlertView).
    [inputAlertView setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        // If user pressed 'Add'...
        if (buttonIndex == 1) {
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *string = [textField.text capitalizedString];
            NSMutableDictionary *ingredientDict = [[NSMutableDictionary alloc] init];
            [ingredientDict setObject:string forKey:@"label"];
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
