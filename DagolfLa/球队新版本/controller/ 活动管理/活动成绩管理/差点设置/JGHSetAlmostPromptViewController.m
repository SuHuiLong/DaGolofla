//
//  JGHSetAlmostPromptViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSetAlmostPromptViewController.h"

@interface JGHSetAlmostPromptViewController ()

{
    NSInteger _selectId;// 0 1
}

@end

@implementation JGHSetAlmostPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"差点设置";
    
    self.twoLableTop.constant = 15 *ProportionAdapter;
    self.twoLableDown.constant = 15 *ProportionAdapter;
    self.twoLableLeft.constant = 10 *ProportionAdapter;
    self.twoLableRight.constant = 10 *ProportionAdapter;
    
    self.titleTop.constant = 15 *ProportionAdapter;
    self.titleDwon.constant = 15 *ProportionAdapter;
    self.titleLeft.constant = 10 *ProportionAdapter;
    self.rImageRight.constant = 10 *ProportionAdapter;
    self.propmtLabelTop.constant = 10 *ProportionAdapter;
    self.propmtLabelLeftAndRight.constant = 10 *ProportionAdapter;

    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 8.0 *ProportionAdapter;
    
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 8.0 *ProportionAdapter;

    self.oneTitle.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.onedetails.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    
    self.twoTitle.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.twoDetails.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    
    self.propmtLabel.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.propmtLabel.textColor = [UIColor colorWithHexString:Click_Color];
    
    _selectId = 0;
    self.imageNoSelect.image = [UIImage imageNamed:@"xiao_danx"];//xiao_dan
    self.imageNoSelectTwo.image = [UIImage imageNamed:@"xiao_dan"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark -- 确定
- (void)saveBtnClick{
    NSLog(@"确定");
    
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

- (IBAction)oneBtnClick:(UIButton *)sender {
    _selectId = 0;
    self.imageNoSelect.image = [UIImage imageNamed:@"xiao_danx"];//xiao_dan
    self.imageNoSelectTwo.image = [UIImage imageNamed:@"xiao_dan"];
}
- (IBAction)twoBtnClick:(UIButton *)sender {
    _selectId = 1;
    self.imageNoSelectTwo.image = [UIImage imageNamed:@"xiao_danx"];
    self.imageNoSelect.image = [UIImage imageNamed:@"xiao_dan"];
}
@end
