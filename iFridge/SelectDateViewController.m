//
//  SelectDateViewController.m
//  iFridge
//
//  Created by Pavlo Bardar on 6/29/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "SelectDateViewController.h"

@interface SelectDateViewController ()

@end

@implementation SelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@synthesize delegate = _delegate;

- (IBAction)datePicked:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.selectDate.text = formattedDate;
    [self.delegate pickDateWithSelectedDate:sender.date];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"dateSegue"]){
//        
//    }
//    ReminderTableViewController *newController = segue.destinationViewController;
//    newController.selectedDate = self.selectDate.text;
//}



@end
