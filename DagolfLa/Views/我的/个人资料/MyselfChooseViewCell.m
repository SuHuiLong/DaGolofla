//
//  MyselfChooseViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyselfChooseViewCell.h"
#import "PostDataRequest.h"
#import "Helper.h"
#import "ViewController.h"

#define kUpDateData_URL @"user/updateUserInfo.do"
@implementation MyselfChooseViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _isMen = NO;
    _isWomen = NO;
    _btnMen.imageEdgeInsets = UIEdgeInsetsMake(5*ScreenWidth/375, 35*ScreenWidth/375, 5*ScreenWidth/375, 5*ScreenWidth/375);
    _btnMen.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _btnMen.titleEdgeInsets = UIEdgeInsetsMake(0, -40*ScreenWidth/375, 0, 0);

    _btnWomen.imageEdgeInsets = UIEdgeInsetsMake(5*ScreenWidth/375, 35*ScreenWidth/375, 5*ScreenWidth/375, 5*ScreenWidth/375);
    _btnWomen.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _btnWomen.titleEdgeInsets = UIEdgeInsetsMake(0, -40*ScreenWidth/375, 0, 0);
    
    
    [_btnMen addTarget:self action:@selector(menClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnWomen addTarget:self action:@selector(womenClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)menClick{
    _isMen = YES;
    _isWomen = NO;
    [_btnMen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
    [_btnWomen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    [self post:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"sex":@1}];
    NSNumber* number = @1;
    _blockSexNumber(number);
}
-(void)womenClick{
    
    _isMen = NO;
    _isWomen = YES;
    [_btnMen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    [_btnWomen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
    [self post:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"sex":@0}];//
    NSNumber* number = @0;
    self.blockSexNumber(number);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showData:(MeselfModel *)model
{
    if (model.sex == 0) {
        _isMen = NO;
        _isWomen = YES;
        [_btnMen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
        [_btnWomen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        
    }
    else
    {
        _isMen = YES;
        _isWomen = NO;
        [_btnMen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        [_btnWomen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    }
}

-(void)post:(NSDictionary *)dict
{
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
    }];
    
}

@end
