//
//  JGDAwardSetTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 2017/4/25.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGHAwardModel.h"

@interface JGDAwardSetTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *awardNameLB;

@property (nonatomic, strong) UIButton *trashButton;

@property (nonatomic, strong) UITextField *prizeTF;

@property (nonatomic, strong) UITextField *prizeCountTF;

@property (nonatomic, strong) JGHAwardModel *model;

@end
