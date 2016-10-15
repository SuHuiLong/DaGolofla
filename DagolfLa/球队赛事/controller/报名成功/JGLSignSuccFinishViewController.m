//
//  JGLSignSuccFinishViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLSignSuccFinishViewController.h"

@interface JGLSignSuccFinishViewController ()

@end

@implementation JGLSignSuccFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球队报名";
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    
    
    [self createImgv];
    
    [self createTitle];
    [self createBtn];
}
-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    [btn setTitle:@"朕知道~" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*screenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)finishClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTitle
{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 260*ProportionAdapter, screenWidth - 20*ProportionAdapter, 40*ProportionAdapter)];
    NSString* str = @"该赛事正在火热报名中，您已在报名球队内部建队际赛报名页，赶快去查看吧！";
    label.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    label.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(str.length -  4, 2)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 * ProportionAdapter] range:NSMakeRange(str.length -  4, 2)];
    label.attributedText = attributedString;
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [label addGestureRecognizer:labelTapGestureRecognizer];
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    NSLog(@"被点击了");
}


-(void)createImgv
{
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(134*ProportionAdapter, 98*ProportionAdapter, 107*ProportionAdapter, 114*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"emjlaugh"];
    [self.view addSubview:imgv];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 222*ProportionAdapter, screenWidth, 30*ProportionAdapter)];
    label.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您已完成球队报名！";
    label.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    [self.view addSubview:label];
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
