//
//  JGDPaySuccessViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPaySuccessViewController.h"
#import "JGDOrderDetailViewController.h"

@interface JGDPaySuccessViewController ()

@end

@implementation JGDPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_payORlaterPay == 1) {
        self.title = @"支付成功";
    }else if (_payORlaterPay == 2){
        self.title = @"提交成功";
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
    
    if (_payORlaterPay == 1) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 50 * ProportionAdapter)];
        [btn setTitle:@"支付成功" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"icn_present_success"] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
        [shitaView addSubview:btn];
        
        UILabel *payTipLB = [self lablerect:CGRectMake(0, 95 * ProportionAdapter , screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:@"30分钟内会短信通知您球位确认结束" textAlignment:(NSTextAlignmentCenter)];
        [shitaView addSubview:payTipLB];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 80 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [ueView addSubview:lineView];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"订单受理", @"球位确定", @"订单完成" ,nil];
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
        
        UILabel *commitTipLB = [self lablerect:CGRectMake(0, 95 * ProportionAdapter , screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:@"请于30分钟内完成支付，逾期订单自动失效" textAlignment:(NSTextAlignmentCenter)];
        [shitaView addSubview:commitTipLB];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(35 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 70 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [ueView addSubview:lineView];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"订单受理", @"支付成功", @"球位确定", @"订单完成" ,nil];
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
        
    }
    
    
    UILabel *commitTipLB = [self lablerect:CGRectMake(0, 50 * ProportionAdapter , screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(14 * ProportionAdapter) text:@"客服受理中，请稍后" textAlignment:(NSTextAlignmentCenter)];
    [shitaView addSubview:commitTipLB];

    
    UILabel *tipLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 290 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 60 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(14 * ProportionAdapter) text:@"温馨提示\n非工作时间（18：00至9:00）提交订单，确认球位时间会延长，可能需工作时间返回确认信息。" textAlignment:(NSTextAlignmentLeft)];
    tipLB.numberOfLines = 0;
    [self.view addSubview:tipLB];
    
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
