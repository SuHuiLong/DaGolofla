//
//  JGHRegistersViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRegistersViewController.h"

@interface JGHRegistersViewController ()

@end

@implementation JGHRegistersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewLeft.constant = 8 *ProportionAdapter;
    self.viewTop.constant = 10 *ProportionAdapter;
    self.viewRight.constant = 8 *ProportionAdapter;
    self.viewH.constant = 50 *ProportionAdapter;
    
    self.mobileBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.mobileBtnW.constant = 50 *ProportionAdapter;
    
    self.mobileLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.mobileText.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeOneLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeTwoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeTwoLineH.constant = 25 *ProportionAdapter;
    self.passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.twoViewTop.constant = 10 *ProportionAdapter;
    self.threeViewTop.constant = 10 *ProportionAdapter;
    self.codebtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.passwordBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.passwordText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.passwordTextRight.constant = 15 *ProportionAdapter;
    
    self.entryBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
   
    self.entryBtnW.constant = 22 *ProportionAdapter;
    self.entryBtnRight.constant = 15 *ProportionAdapter;
    
    self.selectBtnLeft.constant = 8 *ProportionAdapter;
    self.selectBtnW.constant = 15 *ProportionAdapter;

    self.registeredLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.registeredLableLeft.constant = 10 *ProportionAdapter;
    
    self.termsBtn.titleLabel.font = [UIFont systemFontOfSize:13 *ProportionAdapter];

    self.completeBtn.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    self.completeBtnTop.constant = 35 *ProportionAdapter;
    self.completeBtnLeft.constant = 10 *ProportionAdapter;
    self.completeBtnRight.constant = 10 *ProportionAdapter;
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
- (IBAction)codebtn:(UIButton *)sender {
    
}
- (IBAction)getCodeBtn:(UIButton *)sender {
    
}
- (IBAction)passwordBtn:(UIButton *)sender {
    
}
- (IBAction)entryBtn:(UIButton *)sender {
    
}
- (IBAction)selectBtn:(UIButton *)sender {
    
}
- (IBAction)termsBtn:(UIButton *)sender {
    
}
- (IBAction)completeBtn:(UIButton *)sender {
    
}
@end
