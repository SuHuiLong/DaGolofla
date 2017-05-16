//
//  JGLBankCardTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLBankModel.h"
@interface JGLBankCardTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView* viewBack;

@property (strong, nonatomic) UIImageView* iconImg;

@property (strong, nonatomic) UILabel* titleName;

@property (strong, nonatomic) UILabel* stateLabel;

@property (strong, nonatomic) UILabel* numLabel;

@property (strong, nonatomic) UIButton* deleteBtn;

-(void)showData:(JGLBankModel *)model;

@end
