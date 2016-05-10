//
//  TeamApplyViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YueDetailModel.h"
#import "TeamJoinModel.h"

@interface TeamApplyViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *chadianLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *disMissBtn;

@property (assign, nonatomic) NSInteger indexState;

@property (copy, nonatomic) NSMutableDictionary* dict;

@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSNumber* ballId;
-(void)showYueDetail:(YueDetailModel *)model;


@property (copy, nonatomic) void(^callBackData)();
@end
