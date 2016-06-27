//
//  JGLPayListTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLPaySignModel.h"
#import "JGTeamAcitivtyModel.h"

@interface JGLPayListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (strong, nonatomic) JGTeamAcitivtyModel *modelData;

-(void)showData:(JGTeamAcitivtyModel *)model;
-(void)showData1:(JGTeamAcitivtyModel *)model;
@property (copy, nonatomic) void (^chooseNoNum)();
@property (copy, nonatomic) void (^chooseYesNum)();

@end
