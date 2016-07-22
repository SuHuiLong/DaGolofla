
//
//  JGLTeeChooseView.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeeChooseView.h"
#import "UITool.h"
@implementation JGLTeeChooseView
{
    NSMutableArray* _arrData;
}

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)array;
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrData = [[NSMutableArray alloc]init];
        _arrData = array;
        for (int i = 0; i < array.count; i ++) {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 40*screenWidth/375*i, 100*screenWidth/375, 40*screenWidth/375);
            btn.backgroundColor = [UIColor whiteColor];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            
            
            UIView* viewColor = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, 30*screenWidth/375, 20*screenWidth/375)];
            viewColor.backgroundColor = [UIColor redColor];
            [btn addSubview:viewColor];
            if ([array[i] isEqualToString:@"红T"] == YES) {
                viewColor.backgroundColor = [UITool colorWithHexString:@"e21f23" alpha:1];
            }
            else if ([array[i] isEqualToString:@"蓝T"] == YES)
            {
                viewColor.backgroundColor = [UITool colorWithHexString:@"2474ac" alpha:1];
            }
            else if ([array[i] isEqualToString:@"黑T"] == YES)
            {
                viewColor.backgroundColor = [UITool colorWithHexString:@"000000" alpha:1];
            }
            else if ([array[i] isEqualToString:@"黄T"] == YES || [array[i] isEqualToString:@"金T"] == YES)
            {
                viewColor.backgroundColor = [UITool colorWithHexString:@"bedd00" alpha:1];
            }
            else
            {
                viewColor.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
            }
            
            UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(50*screenWidth/375, 0, 50*screenWidth/375, 40*screenWidth/375)];
            labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
            [btn addSubview:labelTitle];
            labelTitle.text = array[i];
            labelTitle.textAlignment = NSTextAlignmentCenter;
            
        }
    }
    return self;
}


-(void)chooseClick:(UIButton *)btn
{
    NSLog(@"%td   %@",btn.tag -100,_arrData[btn.tag - 100]);
    _blockTeeName(_arrData[btn.tag - 100]);
}


//-(id)initWithNumber:(NSMutableArray *)array
//{
//    for (int i = 0; i < array.count; i ++) {
//        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 40*screenWidth/375*i, 120*screenWidth/375, 40*screenWidth/375);
//        [self addSubview:btn];
//        
//        UIView* viewColor = [[UIView alloc]initWithFrame:CGRectMake(0, 10*screenWidth/375+ 10*screenWidth/375*i, 30*screenWidth/375, 20*screenWidth/375)];
//        viewColor.backgroundColor = [UIColor redColor];
//        [btn addSubview:viewColor];
//        
//        UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40*screenWidth/375, 40*screenWidth/375*i, 60*screenWidth/375, 40*screenWidth/375)];
//        labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
//        [btn addSubview:labelTitle];
//        labelTitle.text = @"红T";
//    }
//    return self;
//}

//- (void)show
//{
//    UIViewController *topVC = [self appRootViewController];
//    //self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, 200, 550);
//    [topVC.view addSubview:self];
//}
//
//- (UIViewController *)appRootViewController
//{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    return topVC;
//}

@end
