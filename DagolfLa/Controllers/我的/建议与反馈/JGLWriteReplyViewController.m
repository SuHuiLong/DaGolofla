//
//  JGLWriteReplyViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLWriteReplyViewController.h"
#import "UITool.h"
#import "JGLFeedbackViewController.h"
@interface JGLWriteReplyViewController ()

@end

@implementation JGLWriteReplyViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}
-(void)backButtonClcik
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGLFeedbackViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回信";
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [self createBack];

}

-(void)createBack
{
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 40*ProportionAdapter, screenWidth-40*ProportionAdapter, 485*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"feedBack"];
    [self.view addSubview:imgv];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 45*ProportionAdapter, 200*ProportionAdapter, 30*ProportionAdapter)];
    label.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    NSString* str = [NSString stringWithFormat:@"嗨，%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor],   NSFontAttributeName :[UIFont systemFontOfSize:17*ProportionAdapter]} range:NSMakeRange(0, attributeString.length)];
    label.attributedText = attributeString;
    [imgv addSubview:label];
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
