//
//  MyselfImpotTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/9/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeselfModel.h"

@interface MyselfImpotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelChoose;
//@property (weak, nonatomic) IBOutlet UIImageView *imgvGou;



@property (assign, nonatomic) NSInteger sections;
@property (assign, nonatomic) NSInteger row;
//-(void)showData:(MeselfModel *)model;

@end
