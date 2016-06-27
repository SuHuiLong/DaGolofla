//
//  JGCostSetViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGCostSetViewController.h"

@interface JGCostSetViewController ()

@end

@implementation JGCostSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"费用设置";
    
    [self createAdminBtn];
}

#pragma mark -- 创建保存按钮
- (void)createAdminBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RightNavItemFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)saveBtnClick:(UIButton *)btn{
    if (self.membersCost.text.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入会员费用！" FromView:self.view];
        return;
    }
    
    if (self.guestCost.text.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入嘉宾费用！" FromView:self.view];
        return;
    }
    
    if (self.delegate) {
        NSLog(@"%@", self.membersCost.text);
        NSLog(@"%@", self.guestCost.text);
        NSLog(@"%@", self.registeredPrice.text);
        NSLog(@"%@", self.bearerPrice.text);
        [self.delegate inputMembersCost:self.membersCost.text guestCost:self.guestCost.text andRegisteredPrice:self.registeredPrice.text andBearerPrice:self.bearerPrice.text];
        [self.navigationController popViewControllerAnimated:YES];
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
