//
//  JGLScoreSureViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreSureViewController.h"
#import "JGLCaddieChooseStyleViewController.h"
#import "JGLCaddieSelfScoreViewController.h"
#import "JGLCaddieScoreViewController.h"
@interface JGLScoreSureViewController ()

@end

@implementation JGLScoreSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setData];
    
    [self createScore];
    
}

-(void)setData
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 160 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
    if (_errorState == 2) {
        imageV.image = [UIImage imageNamed:@"cry"];
    }
    else{
        imageV.image = [UIImage imageNamed:@"icn_laugh"];
    }
    
    [self.view addSubview:imageV];
    
    if (_errorState == 2) {
        
    }
    else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, screenWidth, 30 * ProportionAdapter)];
        NSString* str = [NSString stringWithFormat:@"添加客户 %@ 成功",_userNamePlayer];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(5, _userNamePlayer.length)];
        label.attributedText = attrString;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        [self.view addSubview:label];
    }
    
    
    UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 340 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter)];
    if (_errorState == 2) {
        detailLB.text = @"臣妾做不到啊！人家仅支持球童为客户记分，不支持球童相互记分的啦！";
        detailLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
        detailLB.frame = CGRectMake(20 * ProportionAdapter, 330 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter);
    }else{
        detailLB.text = @"点击开始记分，进入客户记分模式，完成记分后，成绩自动存入客户历史记分卡";
        detailLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
    }
    
    
    detailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    detailLB.numberOfLines = 0;
    [self.view addSubview:detailLB];
}

-(void)createScore
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    if (_errorState == 2) {
        [btn setTitle:@"朕知道了~" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backCaddieClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [btn setTitle:@"开始记分" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight-64*ProportionAdapter-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    
}

-(void)finishClick{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getTodayScore" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"acBoolean"] integerValue] == 1) {
            JGLCaddieChooseStyleViewController* choVc = [[JGLCaddieChooseStyleViewController alloc]init];
            choVc.userKeyPlayer = _userKeyPlayer;
            choVc.userNamePlayer = _userNamePlayer;
            [self.navigationController pushViewController:choVc animated:YES];
        }
        else{
            JGLCaddieSelfScoreViewController* selfVc = [[JGLCaddieSelfScoreViewController alloc]init];
            selfVc.userNamePlayer = _userNamePlayer;
            selfVc.userKeyPlayer = _userKeyPlayer;
            [self.navigationController pushViewController:selfVc animated:YES];
        }
    }];
    
    
    
    
    
}
#pragma mark --球童相互扫描返回按钮
-(void)backCaddieClick
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGLCaddieScoreViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
