//
//  JGHCabbieWalletViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieWalletViewController.h"
#import "JGLCaddieScoreViewController.h"
#import "JGHCabbieRewardViewController.h"

@interface JGHCabbieWalletViewController ()
{
//    UIView *_walletView;
    UIImageView *_huadongImageView;
    UIImageView *_hongbaoImageView;
    UIButton *_gapBtn;
    UIImageView *_hongbaojinbiImageView;
    UIView *_barView;
    UILabel *_jineLable;
}

@property (nonatomic, weak)NSTimer *timer;//计时器

@end

@implementation JGHCabbieWalletViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    _barView.backgroundColor = [UIColor colorWithHexString:@"#3AAF55"];
    UIButton *barBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 44, 44)];
    [barBtn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(BackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:barBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 -40*ProportionAdapter, 20, 80*ProportionAdapter, 44)];
    titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"完成记分";
    titleLabel.textColor = [UIColor whiteColor];
    [_barView addSubview:titleLabel];
    
    UIButton *cabbArwedbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cabbArwedbtn.frame = CGRectMake(screenWidth - 54*ProportionAdapter, 20, 44*ProportionAdapter, 44);
    [cabbArwedbtn addTarget:self action:@selector(pushMyReward) forControlEvents:UIControlEventTouchUpInside];
    [cabbArwedbtn setImage:[UIImage imageNamed:@"cabbArwed"] forState:UIControlStateNormal];

    [_barView addSubview:cabbArwedbtn];
    
    [self.view addSubview:_barView];
    
    [self.view insertSubview:_barView atIndex:0];
    
    if ([_wealMony floatValue] <= 0) {
        UIImageView *emjImageView = [[UIImageView alloc]initWithFrame:CGRectMake(134*ProportionAdapter, 87 *ProportionAdapter,  screenWidth-268*ProportionAdapter, 114 *ProportionAdapter)];
        emjImageView.image = [UIImage imageNamed:@"emjlaugh"];
        [self.view addSubview:emjImageView];
        
        UILabel *cabLable = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 235 *ProportionAdapter, screenWidth - 20*ProportionAdapter, 20*ProportionAdapter)];
        cabLable.font = [UIFont systemFontOfSize:20*ProportionAdapter];
        cabLable.text = [NSString stringWithFormat:@"你已完成替客户 %@ 的记分工作", self.customerName];
        cabLable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:cabLable];
        
        UILabel *promLbale = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 278*ProportionAdapter, screenWidth-20*ProportionAdapter, 35*ProportionAdapter)];
        promLbale.numberOfLines = 0;
        promLbale.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        promLbale.text = @"客户可在“打高尔夫啦App”－－记分——历史记分卡中，查看成绩。";
        [self.view addSubview:promLbale];
        
    }else{
        //------
        UILabel *cabLable = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, (40 +64) *ProportionAdapter, screenWidth - 20*ProportionAdapter, 20*ProportionAdapter)];
        cabLable.font = [UIFont systemFontOfSize:20*ProportionAdapter];
        cabLable.text = [NSString stringWithFormat:@"你已完成替客户 %@ 的记分工作", self.customerName];
        cabLable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:cabLable];
        
        UILabel *promLbale = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, (40 +20 +10 +64)*ProportionAdapter, screenWidth-20*ProportionAdapter, 35*ProportionAdapter)];
        promLbale.numberOfLines = 0;
        promLbale.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        promLbale.text = @"客户可在“打高尔夫啦App”－－记分——历史记分卡中，查看成绩。";
        [self.view addSubview:promLbale];
        
        //红包默认图片
        _hongbaoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60*ProportionAdapter, (40 +20 +10 +35 + 40 + 20 +64)*ProportionAdapter,  screenWidth-120*ProportionAdapter, 280 *ProportionAdapter)];
        _hongbaoImageView.userInteractionEnabled = YES;
        _hongbaoImageView.image = [UIImage imageNamed:@"hongbao"];
        [self.view addSubview:_hongbaoImageView];
        
        //滑动文字
        UIImageView *wordsLimageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 190 *ProportionAdapter, _hongbaoImageView.frame.size.width - 20*ProportionAdapter, 30*ProportionAdapter)];
        wordsLimageView.image = [UIImage imageNamed:@"hongbaowords"];
        [_hongbaoImageView addSubview:wordsLimageView];
        //滑动箭头
        _huadongImageView = [[UIImageView alloc]initWithFrame:CGRectMake(170 *ProportionAdapter, 80*ProportionAdapter, 40 *ProportionAdapter, 80 *ProportionAdapter)];
        _huadongImageView.image = [UIImage imageNamed:@"hongbaoopen_arrow"];
        [_hongbaoImageView addSubview:_huadongImageView];
        
        //接受滑动手势的BTN
        _gapBtn = [[UIButton alloc]initWithFrame:CGRectMake(80 *ProportionAdapter, 50*ProportionAdapter, 100*ProportionAdapter, 110*ProportionAdapter)];
        [_hongbaoImageView addSubview:_gapBtn];
        UISwipeGestureRecognizer *btnGapUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gapBtnUpGapClick)];
        [btnGapUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [_gapBtn addGestureRecognizer:btnGapUp];
        
        //创建计时器
        self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                   selector:@selector(arrowAnimation) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}
- (void)BackBtnClick:(UIButton *)btn{
    self.navigationController.navigationBarHidden = NO;
//    [self popScoreCtrl];
    
    if ([NSThread isMainThread]) {
        NSLog(@"Yay!");
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JGLCaddieScoreViewController class]]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@{@"cabbie": @"1"}];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        NSLog(@"Humph, switching to main");
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[JGLCaddieScoreViewController class]]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@{@"cabbie": @"1"}];
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        });
    }
     
}
//#pragma mark -- pop记分页面
//- (void)popScoreCtrl{
//    UIViewController *target;
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[JGLCaddieScoreViewController class]]) {
//            target=vc;
//        }
//    }
//    
//    if (target) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@[]];
//        
//        [self.navigationController popToViewController:target animated:YES];
//    }
//}
#pragma mark -- 我的奖励
- (void)pushMyReward{
    JGHCabbieRewardViewController *rewardCtrl = [[JGHCabbieRewardViewController alloc]init];
    
    [self.navigationController pushViewController:rewardCtrl animated:YES];
}
#pragma mark -- 红包跳转
//- (void)hongbaoImageViewAnimation{
//    [UIView animateWithDuration:1.0 animations:^{
//        //修改按钮的frame
//        _huadongImageView.frame = CGRectMake(170 *ProportionAdapter, 65*ProportionAdapter, 40 *ProportionAdapter, 80 *ProportionAdapter);
//    }];
//}
#pragma maek -- 上滑手势
- (void)gapBtnUpGapClick{
    _gapBtn.enabled = NO;
    [_huadongImageView removeFromSuperview];
    [self.timer invalidate];
    NSLog(@"上滑红包");
    NSMutableArray  *arrayM=[NSMutableArray array];
    for (int i=1; i<21; i++) {
        [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"hongbao%d",i]]];
    }
    //设置动画数组
    [_hongbaoImageView setAnimationImages:arrayM];
    //设置动画播放次数
    [_hongbaoImageView setAnimationRepeatCount:1];
    //设置动画播放时间
    [_hongbaoImageView setAnimationDuration:2.0];
    //开始动画
    [_hongbaoImageView startAnimating];
    
    [self performSelector:@selector(coinRecyclingAnimation) withObject:self afterDelay:2.0];
}
#pragma mark -- 滑动箭头动画
- (void)arrowAnimation{
    [UIView animateWithDuration:1.0 animations:^{
        //修改按钮的frame
        _huadongImageView.frame = CGRectMake(170 *ProportionAdapter, 65*ProportionAdapter, 40 *ProportionAdapter, 80 *ProportionAdapter);
    }];
    _huadongImageView.frame = CGRectMake(170 *ProportionAdapter, 80*ProportionAdapter, 40 *ProportionAdapter, 80 *ProportionAdapter);
}
#pragma mark -- 钱币回收动画
- (void)coinRecyclingAnimation{
    [_hongbaoImageView stopAnimating];
    [_hongbaoImageView setImage:nil];
    _hongbaoImageView.frame = CGRectMake(60*ProportionAdapter, (40 +20 +10 +35 + 20 +64)*ProportionAdapter,  screenWidth-120*ProportionAdapter, 320 *ProportionAdapter);
    [_hongbaoImageView setImage:[UIImage imageNamed:@"hongbaoopen"]];
    
    _hongbaojinbiImageView = [[UIImageView alloc]initWithFrame:CGRectMake((60 +20) *ProportionAdapter, (40 +20 +10 +35 + 40 + 20 +64 +10)*ProportionAdapter, _hongbaoImageView.frame.size.width - 40 *ProportionAdapter, 40*ProportionAdapter)];
    _hongbaojinbiImageView.image = [UIImage imageNamed:@"hongbaojinbi"];
    [self.view addSubview:_hongbaojinbiImageView];
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改按钮的frame
        _hongbaojinbiImageView.frame = CGRectMake(screenWidth - 40*ProportionAdapter, 34, 24*ProportionAdapter, 24);
    }];
 
    //移除
    [self performSelector:@selector(deleteAnimation) withObject:self afterDelay:1.5];
}
- (void)deleteAnimation{
    [_hongbaojinbiImageView removeFromSuperview];
    _jineLable = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 24*ProportionAdapter, 46, 14*ProportionAdapter, 14)];
    _jineLable.text = [NSString stringWithFormat:@"+%@", _wealMony];
    _jineLable.textColor = [UIColor yellowColor];
    _jineLable.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    [_barView addSubview:_jineLable];
    
    [UIView animateWithDuration:1.0 animations:^{
        //修改按钮的frame
        _jineLable.font = [UIFont systemFontOfSize:30 *ProportionAdapter];
        _jineLable.frame = CGRectMake(screenWidth - 74*ProportionAdapter, 10, 64*ProportionAdapter, 54);
    }];
    
    //移除
    [self performSelector:@selector(deleteLableAnimation) withObject:self afterDelay:1.0];
}
- (void)deleteLableAnimation{
    [_jineLable removeFromSuperview];
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
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
