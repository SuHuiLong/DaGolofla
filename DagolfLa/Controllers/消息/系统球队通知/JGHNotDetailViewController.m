//
//  JGHNotDetailViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNotDetailViewController.h"
#import "JGHInformModel.h"

@interface JGHNotDetailViewController ()

@end

@implementation JGHNotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"通知详情";
    
    CGSize titleSize = [_model.content boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;
    
    CGSize nameSize = [_model.title boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*ProportionAdapter]} context:nil].size;
    
    UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 *ProportionAdapter, screenWidth, nameSize.height +titleSize.height +(35+20+72+40)*ProportionAdapter)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
                                                              
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 35 *ProportionAdapter, screenWidth - 20*ProportionAdapter, nameSize.height)];
    name.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    name.text = _model.title;
    name.numberOfLines = 0;
    [oneView addSubview:name];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    contentLabel.text = _model.content;
    contentLabel.numberOfLines = 0;//多行显示，计算高度
    contentLabel.textColor = [UIColor lightGrayColor];
    
    contentLabel.frame = CGRectMake(10 *ProportionAdapter, nameSize.height +50*ProportionAdapter, screenWidth -20 *ProportionAdapter, titleSize.height);
    
    [oneView addSubview:contentLabel];
   
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, oneView.frame.size.height -40*ProportionAdapter, screenWidth-20*ProportionAdapter, 20 *ProportionAdapter)];
    time.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    time.textAlignment = NSTextAlignmentRight;
    time.text = _model.createTime;
    [oneView addSubview:time];
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
