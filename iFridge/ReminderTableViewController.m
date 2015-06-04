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
<<<<<<< HEAD
#import "Fridge+Cat.h"
#import "UIViewController+Context.h"

=======
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6

@import EventKit;

@interface ReminderTableViewController ()

@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSMutableArray *todoItems;
@property (copy, nonatomic) NSArray *reminders;
@property (strong, nonatomic) EKCalendar *calendar;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
<<<<<<< HEAD
@property (nonatomic, strong) NSString *savedEvent;
=======
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6

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


<<<<<<< HEAD


- (NSArray *)todoItems {
=======
- (NSMutableArray *)todoItems {
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6
    if (!_todoItems) {
        _todoItems = [@[@"You need to do smth!"] mutableCopy];
        
        //        self.todoItems = ingredientLines;
    }
    return _todoItems;
}

#pragma mark - View life cycle



- (void)viewDidLoad {
<<<<<<< HEAD
    [super viewDidLoad];
    
    EKEventStore *eventStore = [EKEventStore new];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        NSString *eventForCalendarTitle = [NSString stringWithFormat:@"To buy for %@", _nameOfEventForCalendar];
        event.title = eventForCalendarTitle;
        event.notes = [self.ingredientsForReminder componentsJoinedByString:@"\n"];
        event.startDate = [NSDate date]; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [eventStore defaultCalendarForNewEvents];
        NSError *err = nil;
        
        for (NSString *savedEvent in self.ingredientsForReminder) {
            [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        }
        
        self.savedEvent = event.eventIdentifier;  //save the event id if you want to access this later
    }];
    
    
//    EKEventStore* eventStore = [EKEventStore new];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent* eventToRemove = [eventStore eventWithIdentifier:self.savedEvent];
        if (eventToRemove) {
            NSError* error = nil;
            [eventStore removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
        }
    }];
    
=======
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6
    self.title = @"To Buy!";
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
<<<<<<< HEAD
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image22.jpg"]];
    
    self.tableView.backgroundView.alpha = 0.2f;
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
=======
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"supermarket"]];
    self.tableView.backgroundView.alpha = 0.5f;
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6
    
    [super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.todoItems count];
<<<<<<< HEAD
    
=======
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    
    // Update cell content from data source.
    NSString *object = self.todoItems[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = object;
<<<<<<< HEAD
    cell.textLabel.textColor = [UIColor blackColor];
//    [self addReminderForToDoItem:object];
=======
    
    [self addReminderForToDoItem:object];
    
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6
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
    
    // Remove to-do item.
    [self.todoItems removeObject:todoItem];
    
    
    
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - IBActions

- (IBAction)addButtonPressed:(id)sender {
    
    // Display an alert view with a text input.
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:@"Add a new to-do item:" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Add", nil];
    
    inputAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    __weak ReminderTableViewController *weakSelf = self;
    
    // Add a completion block (using our category to UIAlertView).
    [inputAlertView setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        // If user pressed 'Add'...
        if (buttonIndex == 1) {
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *string = [textField.text capitalizedString];
            [weakSelf.todoItems addObject:string];
            
            NSUInteger row = [weakSelf.todoItems count] - 1;
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
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
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
<<<<<<< HEAD
                NSMutableArray *todoItems = [[NSMutableArray alloc] initWithArray:self.todoItems];
                
                [todoItems exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                self.todoItems = todoItems;
                
                
=======
                [self.todoItems exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6
                
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






- (NSDateComponents *)dateComponentsForDefaultDueDate {
    NSDateComponents *oneDayComponents = [[NSDateComponents alloc] init];
    oneDayComponents.day = 1;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *tomorrow = [gregorianCalendar dateByAddingComponents:oneDayComponents toDate:[NSDate date] options:0];
    
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *tomorrowAt4PM = [gregorianCalendar components:unitFlags fromDate:tomorrow];
    tomorrowAt4PM.hour = 16;
    tomorrowAt4PM.minute = 0;
    tomorrowAt4PM.second = 0;
    
    return tomorrowAt4PM;
}

- (BOOL)itemHasReminder:(NSString *)item {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", item];
    NSArray *filtered = [self.reminders filteredArrayUsingPredicate:predicate];
    return (self.isAccessToEventStoreGranted && [filtered count]);
}





@end
