//
//  JGLBankTypeView.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLBankTypeView.h"
@implementation JGLBankTypeView
{
    NSInteger _indexChoose;
    UIButton* _btnChoose;
    NSInteger _lastBtn ,_isLast;
    
    UIImageView* _imgvChoose;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self uiConfig];
    }
    return self;
}


-(void)uiConfig
{
    NSArray* arrIcon = @[@"zhonghang_color",@"nonghang_color",@"jianhang_color",@"gonghang_color",@"jiaohang_color",@"youzheng_color",@"zhaohang_color",@"zhongxin_color",@"minsheng_color",@"xingye_color",@""];
    NSArray* arrTitle = @[@"中国银行",@"农业银行",@"建设银行",@"工商银行",@"交通银行",@"邮政储蓄",@"招商银行",@"中信银行",@"民生银行",@"兴业银行",@"其他银行"];
    
    for (int i = 0; i < 11; i++) {
       
        _btnChoose = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnChoose.frame = CGRectMake(screenWidth/2*(i%2), 44*ScreenWidth/375*(i/2), screenWidth/2, 44*ScreenWidth/375);
        _btnChoose.layer.masksToBounds = YES;
        _btnChoose.layer.cornerRadius = 3*ScreenWidth/375;
        _btnChoose.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [self addSubview:_btnChoose];
        [_btnChoose addTarget:self action:@selector(bankChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnChoose.tag = 300 + i;
        
        
        _imgvChoose = [[UIImageView alloc]initWithFrame:CGRectMake(4*screenWidth/375, 14*screenWidth/375, 16*screenWidth/376, 16*screenWidth/375)];
        _imgvChoose.image = [UIImage imageNamed:@"wxz"];
        [_btnChoose addSubview:_imgvChoose];
        _imgvChoose.tag = 500 + i;
        
        UIImageView* imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30*screenWidth/376, 10*screenWidth/375, 24*screenWidth/376, 24*screenWidth/375)];
        imgvIcon.image = [UIImage imageNamed:arrIcon[i]];
        [_btnChoose addSubview:imgvIcon];
    
        
        
        UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(64*screenWidth/375, 0, screenWidth/2-70*screenWidth/375, 44*screenWidth/375)];
        labelName.font = [UIFont systemFontOfSize:14*screenWidth/375];
        labelName.text = arrTitle[i];
        [_btnChoose addSubview:labelName];
    
    }
 
    UIButton* cancle=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancle.frame=CGRectMake(0, 44*ScreenWidth/375*(10/2) + 44*screenWidth/375, ScreenWidth/2, 44*screenWidth/375);
    cancle.backgroundColor=[UIColor orangeColor];
    [cancle addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    
    
    UIButton* sure=[UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sure.frame=CGRectMake(screenWidth/2, 44*ScreenWidth/375*(10/2) + 44*screenWidth/375, ScreenWidth/2, 44*screenWidth/375);
    sure.backgroundColor=[UIColor orangeColor];
    [sure addTarget:self action:@selector(sureAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sure];
    
}

-(void)bankChooseClick:(UIButton *)btn
{
    
    if (_lastBtn!=0) {
        UIImageView *imgv = (UIImageView *)[self viewWithTag:_lastBtn];
        imgv.image = [UIImage imageNamed:@"wxz"];
    }
    UIImageView *imgv = (UIImageView *)[self viewWithTag:btn.tag + 200];
    imgv.image = [UIImage imageNamed:@"yxz"];
    
    _lastBtn = btn.tag + 200;
    _indexChoose = btn.tag - 300;
}

#pragma mark --取消按钮界面消失
- (void)dismissAlert
{
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}

#pragma mark --确定按钮
-(void)sureAlert
{
    NSArray* arrTitle = @[@"中国银行",@"农业银行",@"建设银行",@"工商银行",@"交通银行",@"邮政储蓄",@"招商银行",@"中信银行",@"民生银行",@"兴业银行",@"其他银行"];
    NSString* str = arrTitle[_indexChoose];
    if (_indexChoose == 10) {
        _indexChoose = 0;
    }
    else{
        _indexChoose = _indexChoose + 1;
    }
    _callBackTitle(_indexChoose,str);
    [self dismissAlert];
}



@end
