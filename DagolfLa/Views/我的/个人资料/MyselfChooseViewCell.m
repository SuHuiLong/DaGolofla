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
    [self post:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"sex":@0}];
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
//        _imgMen.image = [UIImage imageNamed:@"xuan_w"];
//        _imgWomen.image = [UIImage imageNamed:@"xuan_z"];
        [_btnMen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
        [_btnWomen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        
    }
    else
    {
        _isMen = YES;
        _isWomen = NO;
//        _imgMen.image = [UIImage imageNamed:@"xuan_z"];
//        _imgWomen.image = [UIImage imageNamed:@"xuan_w"];
        [_btnMen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        [_btnWomen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    }
}

-(void)post:(NSDictionary *)dict
{
    [[PostDataRequest sharedInstance] postDataRequest:kUpDateData_URL parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
//        [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
//        }];
    } failed:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        
    }];
    
    
}

@end
