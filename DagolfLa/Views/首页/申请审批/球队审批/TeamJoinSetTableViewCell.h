//
//  TeamJoinSetTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 16/1/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#import "TeamJoinModel.h"
#import "CustomIOSAlertView.h"
@interface TeamJoinSetTableViewCell : UITableViewCell<CustomIOSAlertViewDelegate>

@property (strong, nonatomic) UIImageView* iconImage;

@property (strong, nonatomic) UIImageView *sexImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *ageLabel;
@property (strong, nonatomic) UILabel *chadianLabel;
@property (strong, nonatomic) UIButton *agreeBtn;
@property (strong, nonatomic) UIButton *disMissBtn;


@property (strong, nonatomic) UIButton *btnDetail;

@property (strong, nonatomic) NSString* strDetails;

@property (strong, nonatomic) NSString* strCom;


@property (strong, nonatomic) NSNumber* userAcceptId ,* teamApplyId;

@property (copy, nonatomic) NSMutableDictionary* dict;
@property (copy, nonatomic) NSMutableDictionary* dictTeam;

-(void)showTeamJoin:(TeamJoinModel *)model;
@end
