//
//  JGDResultViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDResultViewController.h"
#import "JGDPlayPersonViewController.h"

@interface JGDResultViewController ()

@property (nonatomic, strong) UIImageView *iconImageV;

@end

@implementation JGDResultViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
    leftBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (void)backBtn{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGDPlayPersonViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setData{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 100 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
    self.iconImageV.image = [UIImage imageNamed:@"happy"];
    [self.view addSubview:self.iconImageV];
    
    
    UILabel *titleLB  = [[UILabel alloc] initWithFrame:CGRectMake(0, 230 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
    NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"指定球童 %@ 成功！", self.qcodeUserName]];
    [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(5, lbStr.length - 8)];
    titleLB.attributedText = lbStr;
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [self.view addSubview:titleLB];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 270 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
    label.text = [NSString stringWithFormat:@"球童%@正在为您做记分前准备，稍后即实时同步记分情况。", self.qcodeUserName]
    ;
    label.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    label.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

- (void)failData{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 100 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
    self.iconImageV.image = [UIImage imageNamed:@"cry"];
    [self.view addSubview:self.iconImageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 230 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 70 * ProportionAdapter)];
    label.text = [NSString stringWithFormat:@"您添加的球童 %@ 未完成认证，无法为您提供记分服务，请吩咐启示成球童认证，认证过程大约两分钟。", self.qcodeUserName]
    ;
    label.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    label.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    //
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"球童记分";
    if (self.state == 10) {
        [self failData];
    }else{
        [self setData];
    }
    
    // Do any additional setup after loading the view.
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
