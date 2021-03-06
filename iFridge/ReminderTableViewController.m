//
//  ReminderTableViewController.m
//  iFridge
//
//  Created by Pavlo Bardar on 5/25/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "ReminderTableViewController.h"
#import "UIAlertView+ReminderBlock.h"
#import "UIButton+ReminderBlock.h"
#import "Fridge+Cat.h"
#import "UIViewController+Context.h"
#import "SelectDate.h"



@import EventKit;

@interface ReminderTableViewController () <DatePickerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSArray *todoItems;
@property (copy, nonatomic) NSArray *reminders;
@property (strong, nonatomic) EKCalendar *calendar;
@property (nonatomic, strong) NSString *savedEvent;
@property (weak, nonatomic) IBOutlet UIButton *sendToCalendar;
@property (strong, nonatomic) NSDate* pickedDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReminderTableViewController

#pragma mark - Custom accessors

// 1
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (NSArray *)todoItems {
    if (!_todoItems) {
        _todoItems = [@[@"You need to do smth!"] mutableCopy];
        
        self.todoItems = [NSArray arrayWithArray:self.ingredientsForReminder];
    }
    return _todoItems;
}




-(void)pickDateWithSelectedDate:(NSDate *)selectedDate {
    self.pickedDate = selectedDate;
}



#pragma mark - View life cycle



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.navigationController.toolbarHidden = NO;
    self.title = @"To Buy!";
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundView.alpha = 0.2f;
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    
    [self.sendToCalendar setTitle:@"Send to Calendar" forState:UIControlStateNormal];
    _sendToCalendar.tintColor = [UIColor purpleColor];
    [_sendToCalendar setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        self.navigationController.toolbarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO];
   

    }
    
-(void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }




#pragma mark - UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.todoItems count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    
    // Update cell content from data source.
    NSString *object = self.todoItems[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = object;
    cell.textLabel.textColor = [UIColor blackColor];
    

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *todoItem = self.todoItems[indexPath.row];
    
    NSMutableArray *todoItems = [[NSMutableArray alloc] initWithArray:self.todoItems];
    
    self.todoItems = todoItems;
    
    // Remove to-do item.
    [todoItems removeObject:todoItem];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - IBActions
//- (IBAction)cancel:(UIBarButtonItem *)sender {
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
//}


- (IBAction)sendToCalendar:(id)sender {
    
    EKEventStore *eventStore = [EKEventStore new];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        NSString *eventForCalendarTitle = [NSString stringWithFormat:@"To buy for %@", _nameOfEventForCalendar];
        event.title = eventForCalendarTitle;
        event.notes = [self.todoItems componentsJoinedByString:@"\n"];

        if (!self.pickedDate) {
            event.startDate = [NSDate date];
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60]; //set 1 hour meeting
        } else {
            event.startDate = self.pickedDate;
            event.endDate = event.startDate;
        }

        event.calendar = [eventStore defaultCalendarForNewEvents];
        NSError *err = nil;
        
        for (NSString *savedEvent in self.todoItems) {
            [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        }        
        event.calendar = [eventStore defaultCalendarForNewEvents];
        self.savedEvent = event.eventIdentifier;  //save the event id if you want to access this later
    }];
    
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent* eventToRemove = [eventStore eventWithIdentifier:self.savedEvent];
        if (eventToRemove) {
            NSError* error = nil;
            [eventStore removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
        }
    }];
    
    if(self.todoItems)
    {
        [sender setEnabled:YES];
        
        [self.sendToCalendar setTitle:@"Sent" forState:UIControlStateNormal];
        _sendToCalendar.tintColor = [UIColor purpleColor];
        [_sendToCalendar setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    }
    else
    {
        [sender setEnabled:NO];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)addButtonPressed:(id)sender {
    
    // Display an alert view with a text input.
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:@"Add a new to-do item:" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Add", nil];
    
    inputAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    // Add a completion block (using our category to UIAlertView).
    [inputAlertView setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        // If user pressed 'Add'...
        if (buttonIndex == 1) {
            
            NSString *string = [alertView textFieldAtIndex:0].text;
            NSMutableArray *todoItems = [[NSMutableArray alloc] initWithArray:self.todoItems];
            [todoItems addObject:string];
            self.todoItems = todoItems;
            [self.tableView reloadData];
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
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor clearColor];
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
                NSMutableArray *todoItems = [[NSMutableArray alloc] initWithArray:self.todoItems];
                
                [todoItems exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                self.todoItems = todoItems;
                
                
                
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

#pragma mark - Reminders





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


#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dateSegue"]){
    }
    SelectDate *newController = segue.destinationViewController;
    newController.delegate = self;
}




@end
