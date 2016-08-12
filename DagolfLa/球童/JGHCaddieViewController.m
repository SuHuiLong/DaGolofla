//
//  JGHCaddieViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCaddieViewController.h"
#import "JGDPlayPersonViewController.h"

@interface JGHCaddieViewController ()

@end

@implementation JGHCaddieViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.backTop.constant = 27 *ProportionAdapter;
    self.backLeft.constant = 20 *ProportionAdapter;
    self.playBtnLeft.constant = 40 *ProportionAdapter;
    self.beetewn.constant = 75 *ProportionAdapter;
    self.cabbieBtnRight.constant = 40 *ProportionAdapter;
    
    self.titleLable.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    
    self.playBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
    self.caddieBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
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

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)playBtn:(UIButton *)sender {
    JGDPlayPersonViewController * playVC = [[JGDPlayPersonViewController alloc] init];
    [self.navigationController pushViewController:playVC animated:YES];
}
- (IBAction)caddieBtn:(UIButton *)sender {
}
@end
