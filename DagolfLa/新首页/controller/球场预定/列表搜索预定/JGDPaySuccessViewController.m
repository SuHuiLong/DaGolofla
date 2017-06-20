//
//  JGDPaySuccessViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPaySuccessViewController.h"
#import "JGDOrderDetailViewController.h"
#import "JGDCourtDetailViewController.h"
#import "JGDOrderListViewController.h"
#import "RedpacketAlertView.h"
#import "MessageShareAlert.h"
#import <MessageUI/MessageUI.h>
@interface JGDPaySuccessViewController ()<MFMessageComposeViewControllerDelegate>
//红包弹出视图
@property (nonatomic,copy) RedpacketAlertView *redPacketAlertView;
//红包数据
@property (nonatomic,copy) NSDictionary *redpacketData;
//分享选项
@property (nonatomic,copy) MessageShareAlert *shareAlert;
//是否分享成功
@property (nonatomic,assign) BOOL shareSucess;


@end

@implementation JGDPaySuccessViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_payORlaterPay == 2) {
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
        
    }else{
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
        leftBar.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = leftBar;
        

    }
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"consult"] style:(UIBarButtonItemStyleDone) target:self action:@selector(phoneAct)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    

}

- (void)phoneAct{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)backBtn{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        // 取消订单
        if (_payORlaterPay == 3 && [vc isKindOfClass:[JGDOrderListViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }else if (_payORlaterPay == 2) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else if (_payORlaterPay == 1 && [vc isKindOfClass:[JGDOrderListViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if ([vc isKindOfClass:[JGDOrderDetailViewController class]] || [vc isKindOfClass:[JGDCourtDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderStateChange" object:nil];
    [self createView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除分享界面
    [self removeShreView];
}

#pragma mark - CreateView
-(void)createView{
    if (_payORlaterPay == 1) {
        self.title = @"支付成功";
        //获取订场红包
        [self initRedpacket];
    }else if (_payORlaterPay == 2 || _payORlaterPay == 4) {
        self.title = @"提交成功";
    }else if (_payORlaterPay == 3 || _payORlaterPay == 5) {
        self.title = @"取消订单";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIView *ueView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 100 * ProportionAdapter)];
    ueView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ueView];
    
    UILabel *orderStateLB = [self lablerect:CGRectMake(0, 10, screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:@"订单状态" textAlignment:(NSTextAlignmentCenter)];
    [ueView addSubview:orderStateLB];
    
    
    UIView *shitaView = [[UIView alloc] initWithFrame:CGRectMake(0, 120 * ProportionAdapter, screenWidth, 160 * ProportionAdapter)];
    shitaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shitaView];
    
    if (_payORlaterPay == 1 || _payORlaterPay == 4) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 50 * ProportionAdapter)];
        [btn setTitle:_payORlaterPay == 1 ? @"支付成功" : @"提交成功" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"icn_present_success"] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
        [shitaView addSubview:btn];
        
        UILabel *payTipLB = [self lablerect:CGRectMake(0, 95 * ProportionAdapter , screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:@"30分钟内会短信通知您球位确认结果" textAlignment:(NSTextAlignmentCenter)];
        [shitaView addSubview:payTipLB];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 80 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [ueView addSubview:lineView];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"订单受理", @"球位确认", @"订单完成" ,nil];
        for (int i = 0; i < 3; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter + i * 145 * ProportionAdapter, 53 * ProportionAdapter, 14 * ProportionAdapter, 14 * ProportionAdapter)];
            if (i != 0) {
                imageView.image = [UIImage imageNamed:@"unpresent_dot"];
            }else{
                imageView.image = [UIImage imageNamed:@"present_dot"];
            }
            imageView.contentMode = UIViewContentModeCenter;
            [ueView addSubview:imageView];
            UILabel *tileLB = [self lablerect:CGRectMake(10 * ProportionAdapter + 145 * ProportionAdapter * i, 70 * ProportionAdapter, 80 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:titleArray[i] textAlignment:(NSTextAlignmentLeft)];
            [ueView addSubview:tileLB];
        }
        
        
    }else if (_payORlaterPay == 2) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 50 * ProportionAdapter)];
        [btn setTitle:@"提交成功" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"icn_present_success"] forState:(UIControlStateNormal)];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
        [shitaView addSubview:btn];
        
        UILabel *commitTipLB = [self lablerect:CGRectMake(0, 95 * ProportionAdapter , screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:@"请于30分钟内完成支付，逾期订单自动失效。" textAlignment:(NSTextAlignmentCenter)];
        [shitaView addSubview:commitTipLB];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 70 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [ueView addSubview:lineView];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"订单受理", @"支付成功", @"球位确认", @"订单完成" ,nil];
        for (int i = 0; i < 4; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter + i * 98 * ProportionAdapter, 53 * ProportionAdapter, 14 * ProportionAdapter, 14 * ProportionAdapter)];
            if (i != 0) {
                imageView.image = [UIImage imageNamed:@"unpresent_dot"];
            }else{
                imageView.image = [UIImage imageNamed:@"present_dot"];
            }
            imageView.contentMode = UIViewContentModeCenter;
            UILabel *tileLB = [self lablerect:CGRectMake(10 * ProportionAdapter + 98 * ProportionAdapter * i, 70 * ProportionAdapter, 80 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:titleArray[i] textAlignment:(NSTextAlignmentLeft)];
            [ueView addSubview:tileLB];
            [ueView addSubview:imageView];
        }
        
    }else if (_payORlaterPay ==  3 || _payORlaterPay == 5) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 50 * ProportionAdapter)];
        [btn setTitle:@"提交成功" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"icn_present_success"] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
        [shitaView addSubview:btn];
        
        UILabel *payTipLB = [self lablerect:CGRectMake(0, 95 * ProportionAdapter , screenWidth, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:@"客服人员会尽快与球场联系\n并第一时间告知您取消要求的受理情况。" textAlignment:(NSTextAlignmentCenter)];
        payTipLB.numberOfLines = 0;
        [shitaView addSubview:payTipLB];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 80 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [ueView addSubview:lineView];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"提交取消", @"球场审核", _payORlaterPay == 5 ? @"取消成功" : @"    退款" ,nil];
        for (int i = 0; i < 3; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter + i * 145 * ProportionAdapter, 53 * ProportionAdapter, 14 * ProportionAdapter, 14 * ProportionAdapter)];
            if (i != 0) {
                imageView.image = [UIImage imageNamed:@"unpresent_dot"];
            }else{
                imageView.image = [UIImage imageNamed:@"present_dot"];
            }
            imageView.contentMode = UIViewContentModeCenter;
            [ueView addSubview:imageView];
            UILabel *tileLB = [self lablerect:CGRectMake(10 * ProportionAdapter + 145 * ProportionAdapter * i, 70 * ProportionAdapter, 80 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:titleArray[i] textAlignment:(NSTextAlignmentLeft)];
            [ueView addSubview:tileLB];
        }

    }
    
    
    UILabel *commitTipLB = [self lablerect:CGRectMake(0, 50 * ProportionAdapter , screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(14 * ProportionAdapter) text:@"客服受理中，请稍后" textAlignment:(NSTextAlignmentCenter)];
    [shitaView addSubview:commitTipLB];

    if (_payORlaterPay != 3) {
        UILabel *tipLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 290 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 60 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(14 * ProportionAdapter) text:@"温馨提示\n非工作时间（18:00至9:00）提交订单，确认球位时间会延长，可能需工作时间返回确认信息。" textAlignment:(NSTextAlignmentLeft)];
        tipLB.numberOfLines = 0;
        [self.view addSubview:tipLB];
    }
    
    NSArray *array = [NSArray arrayWithObjects:@"查看订单详情", @"返回首页", nil];
    for (int i = 0; i < 2; i ++) {
        UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + i * 185 * ProportionAdapter, screenHeight - 190 * ProportionAdapter, 150 * ProportionAdapter, 30 * ProportionAdapter)];
        [detailBtn setTitle: array[i] forState:(UIControlStateNormal)];
        detailBtn.titleLabel.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        [detailBtn setTitleColor:[UIColor colorWithHexString:@"#32b14b"] forState:(UIControlStateNormal)];
        detailBtn.layer.borderWidth = 0.5 * ProportionAdapter;
        detailBtn.layer.borderColor = [[UIColor colorWithHexString:@"#32b14b"] CGColor];
        detailBtn.layer.cornerRadius = 6;
        detailBtn.clipsToBounds = YES;
        detailBtn.tag = 80 + i;
        [detailBtn addTarget:self action:@selector(checkORpop:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:detailBtn];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)checkORpop:(UIButton *)btn {
    if (btn.tag == 80) {
        JGDOrderDetailViewController *orderVC = [[JGDOrderDetailViewController alloc] init];
        orderVC.orderKey = self.orderKey;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else if (btn.tag == 81) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
}

#pragma mark - 订场红包
//获取是否有红包
-(void)initRedpacket{

    NSDictionary *dict = @{
                           @"orderKey":_orderKey,
                           };
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"orderPay/doQueryOrderPayResult" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSuccess) {
            NSInteger payMoney = [[data objectForKey:@"payMoney"] integerValue];
            if (payMoney>0) {
                NSString *title = [data objectForKey:@"strPrompt"];
                self.redpacketData = [data objectForKey:@"redPacket"];
                if (self.redpacketData.allKeys.count>0) {
                    [self alertRedpaketviewWithText:title];
                }
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self initRedpacket];
                });
            }
        }
        
    }];
}
//弹出红包
-(void)alertRedpaketviewWithText:(NSString *)text{
    
    _redPacketAlertView = [[RedpacketAlertView alloc] initWithFrame:self.view.bounds Text:text];
    _redPacketAlertView.hidden = false;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToShare)];
    [_redPacketAlertView.circleView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_redPacketAlertView];
}
//点击分享
-(void)clickToShare{
    
    MessageShareAlert *alert = [[MessageShareAlert alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    alert.selectIndex = ^(NSInteger index) {
        if (index == 0) {
            [self shareCancelClick];
        }else{
            _shareSucess = false;
            [self shareInfo:index];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    _shareAlert = alert;
}


-(void)shareInfo:(NSInteger)index{
    
    //分享链接
    NSString *shareUrl = [_redpacketData objectForKey:@"shareURL"];
    //标题
    NSString *name = [_redpacketData objectForKey:@"title"];
    //微信分享内容
    NSString *desc = [_redpacketData objectForKey:@"desc"];
    //图标
    UIImage *icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_redpacketData objectForKey:@"iconURL"]]]];
    
    [UMSocialData defaultData].extConfig.title=name;
    if(index==1){
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:desc image:icon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [MobClick event:@"redpacket_weixin_share"];

                [self shareSucessBlock];
            }
        }];
    }else if (index==2){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:desc image:icon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [MobClick event:@"redpacket_pengyouquan_share"];

                [self shareSucessBlock];
            }
        }];
        
    }else if (index==3){
        NSString *smsBody = [_redpacketData objectForKey:@"smsBody"];
        if( [MFMessageComposeViewController canSendText] ){
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
            controller.messageComposeDelegate = self;
            controller.body = smsBody;
            [self justHiden];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}


//短信发送结果
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self justShow];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *resultStr = [NSString string];
    if (result == MessageComposeResultCancelled) {
        resultStr = @"取消发送";
    }else if (result == MessageComposeResultSent){
        resultStr = @"发送成功";
        [MobClick event:@"redpacket_message_share"];
        [self shareSucessBlock];
    }else{
        resultStr = @"发送失败";
    }
    [[ShowHUD showHUD] showToastWithText:resultStr FromView:self.view];
}

//隐藏视图
//所有只是隐藏
-(void)justHiden{
    _redPacketAlertView.hidden = true;
    _shareAlert.hidden = true;
}
//取消隐藏
-(void)justShow{
    _redPacketAlertView.hidden = false;
    _shareAlert.hidden = false;
}
//分享成功
-(void)shareSucessBlock{
    _shareSucess = true;
}

//分享取消按钮点击
-(void)shareCancelClick{
    if (_shareSucess) {
        [self removeShreView];
    }
}
//移除分享界面
-(void)removeShreView{
    if (!_redPacketAlertView.hidden) {
        _redPacketAlertView.hidden = true;
        [_redPacketAlertView removeAllSubviews];
        [_redPacketAlertView removeFromSuperview];
    }
    if (!_shareAlert.hidden) {
        _shareAlert.hidden = true;
        [_shareAlert removeAllSubviews];
        [_shareAlert removeFromSuperview];
        
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
