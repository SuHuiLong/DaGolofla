//
//  JGHBindingAccountViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBindingAccountViewController.h"

@interface JGHBindingAccountViewController ()

@end

@implementation JGHBindingAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"忘记密码";
    
    self.oneViewLeft.constant = 8 *ProportionAdapter;
    self.oneViewTop.constant = 10 *ProportionAdapter;
    self.oneViewRight.constant = 8 *ProportionAdapter;
    self.twoViewTop.constant = 10 *ProportionAdapter;
    
    self.mobileBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.mobileLable.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.mobiletext.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.codeTwoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.bindingAccount.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    self.bindingAccountBtnLeft.constant = 8 *ProportionAdapter;
    self.bindingAccountBtnTop.constant = 35 *ProportionAdapter;
    self.bindingAccountBtnRight.constant = 8 *ProportionAdapter;
    
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

- (IBAction)mobileBtn:(UIButton *)sender {
}
- (IBAction)codeBtn:(UIButton *)sender {
}
- (IBAction)getCodeBtn:(UIButton *)sender {
}
- (IBAction)bindingAccount:(UIButton *)sender {
}
@end
