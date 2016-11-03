//
//  JGHForgotPasswordViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHForgotPasswordViewController.h"

@interface JGHForgotPasswordViewController ()

@end

@implementation JGHForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"忘记密码";
    
    self.oneViewLeft.constant = 8 *ProportionAdapter;
    self.oneViewTop.constant = 10 *ProportionAdapter;
    self.oneViewRight.constant = 8 *ProportionAdapter;
    
    self.mobileBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.mobileBtnW.constant = 50 *ProportionAdapter;
    
    self.mobileLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.mobileText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.codeTwoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
   
    self.passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.passwordText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.passwordTextRight.constant = 15 *ProportionAdapter;

    self.entryBtnW.constant = 22 *ProportionAdapter;
    self.entryBtnRight.constant = 15 *ProportionAdapter;

    self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    self.resetBtnLeft.constant = 8 *ProportionAdapter;
    self.resetBtnTop.constant = 50 *ProportionAdapter;
    self.resetBtnRight.constant = 8 *ProportionAdapter;
    
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
- (IBAction)passwordBtn:(UIButton *)sender {
}
- (IBAction)entryBtn:(UIButton *)sender {
}
- (IBAction)resetBtn:(UIButton *)sender {
}
@end
