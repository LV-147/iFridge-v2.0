//
//  FridgeTableViewCell.h
//  iFridge
//
//  Created by Pavlo Bardar on 6/21/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FridgeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameOfProduct;
@property (strong, nonatomic) IBOutlet UILabel *quantityOfProduct;
@property (strong, nonatomic) IBOutlet UILabel *units;

@end
