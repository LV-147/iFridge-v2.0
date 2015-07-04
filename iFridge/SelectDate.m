//
//  SelectDate.m
//  iFridge
//
//  Created by Pavlo Bardar on 7/2/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "SelectDate.h"

@interface SelectDate ()

@end

@implementation SelectDate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)datePicked:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.selectDate.text = formattedDate;
    [self.delegate pickDateWithSelectedDate:sender.date];
    
}
- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
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
