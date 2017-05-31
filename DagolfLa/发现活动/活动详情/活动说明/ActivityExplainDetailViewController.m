//
//  ActivityExplainDetailViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/19.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ActivityExplainDetailViewController.h"

@interface ActivityExplainDetailViewController ()

@end

@implementation ActivityExplainDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 245, 245);
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigation];
    [self createMainView];
}
//创建上导航
-(void)createNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航背景
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
//创建主视图
-(void)createMainView{
    //icon
    UIImageView *iconImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(11), kHvertical(22), kHvertical(22)) Image:[UIImage imageNamed:@"icn_event_details"]];
    [self.view addSubview:iconImageView];
    //描述
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(40), 0, screenWidth-kWvertical(50), kHvertical(45)) textColor:RGB(0,0,0) fontSize:kHorizontal(15) Title:@"活动说明"];
    [self.view addSubview:descLabel];
    //头部白色背景
    UIView *headerWhiteView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(54))];
    [headerWhiteView addSubview:iconImageView];
    [headerWhiteView addSubview:descLabel];
    [self.view addSubview:headerWhiteView];
    //描述
    CGFloat contentLabelheight = 0;
    UILabel *contentLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(39),  kHvertical(5), screenWidth - kWvertical(52), contentLabelheight) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:_contentStr];
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    contentLabelheight = contentLabel.height+kHvertical(15);
    //描述白色背景
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHvertical(54), screenWidth, kHvertical(25) + contentLabelheight)];
    backView.backgroundColor = WhiteColor;
    backView.contentSize = CGSizeMake(screenWidth,  contentLabelheight);
    if (kHvertical(54)+contentLabelheight>screenHeight-64) {
        backView.height = screenHeight-64-kHvertical(54);
    }
    
    [self.view addSubview:backView];
    [backView addSubview:contentLabel];
}


/**
 动态获取label的高
 
 @param str 内容
 @param width label的宽
 @return label的高
 */
-(CGFloat)getSpaceLabelHeight:(NSString *)str withWidh:(CGFloat)width
{
    
    NSMutableParagraphStyle *paragphStyle=[[NSMutableParagraphStyle alloc]init];
    
    paragphStyle.lineSpacing=0;//设置行距为0
    paragphStyle.firstLineHeadIndent=0.0;
    paragphStyle.hyphenationFactor=0.0;
    paragphStyle.paragraphSpacingBefore=0.0;
    
    NSDictionary *dic=@{
                        NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(15)], NSParagraphStyleAttributeName:paragphStyle, NSKernAttributeName:@1.0f
                        };
    CGSize size=[str boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
    
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
