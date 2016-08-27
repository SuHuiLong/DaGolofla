//
//  JGDGuestChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDGuestChannelViewController.h"
#import "JGDGuestPayViewController.h"

@interface JGDGuestChannelViewController ()

@property (nonatomic, strong) UITextField *enterTF;

@end

@implementation JGDGuestChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"嘉宾报名";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UILabel *enterLB = [[UILabel alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 25 * ProportionAdapter, 120 * ProportionAdapter, 30 * ProportionAdapter)];
    enterLB.text = @"输入嘉宾参赛码";
    enterLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    enterLB.textColor = [UIColor colorWithHexString:@"#313131"];
    [self.view addSubview:enterLB];
    
    self.enterTF = [[UITextField alloc] initWithFrame:CGRectMake(135 * ProportionAdapter, 25 * ProportionAdapter, screenWidth - 150 * ProportionAdapter, 30 * ProportionAdapter)];
    self.enterTF.borderStyle = UITextBorderStyleRoundedRect;
    self.enterTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.enterTF];
    
    UILabel *textLB = [[UILabel alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 70 * ProportionAdapter, screenWidth - 30 * ProportionAdapter, 60 * ProportionAdapter)];
    textLB.text = @"说明：系统为每个球队活动生成唯一“嘉宾参赛码”，嘉宾在此处中输入该码，可直达嘉宾报名页，完成活动报名与付款。";
    textLB.numberOfLines = 0;
    textLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
    textLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    [self.view addSubview:textLB];
    
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * screenWidth / 320, 130 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 44 * ProportionAdapter)];
    previewBtn.clipsToBounds = YES;
    previewBtn.layer.cornerRadius = 6.f;
    [previewBtn setTitle:@"确定" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(payAct) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:previewBtn];
    // Do any additional setup after loading the view.
}

- (void)payAct{
    
    [self.view endEditing:YES];
    if ([self.enterTF.text length] == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入嘉宾参赛码" FromView:self.view];
        return;
    }
    JGDGuestPayViewController *guestPayVC = [[JGDGuestPayViewController alloc] init];
    guestPayVC.activityKey = self.enterTF.text;
    [self.navigationController pushViewController:guestPayVC animated:YES];
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
