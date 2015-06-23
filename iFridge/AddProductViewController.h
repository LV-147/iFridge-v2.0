//
//  AddProductViewController.h
//  iFridge
//
//  Created by Pavlo Bardar on 6/17/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddProductViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfProduct;
@property (nonatomic, strong) UIImage *image;




@end
