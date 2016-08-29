//
//  JGLViewCityChoose.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLViewCityChoose.h"
#import "UITool.h"
#define CityChooseViewWidth self.layer.frame.size.width
#define CityChooseViewHeight self.layer.frame.size.height

@implementation JGLViewCityChoose
{
    UIView* _viewBack;
    NSInteger _lastBtn;
    NSArray* _arrTitle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)initwithStr:(NSString *)str
{
    _arrTitle = @[@"全国",@"上海",@"江苏",@"浙江",@"北京",@"广东",@"天津",@"云南",@"海南"];
    
    [self createBackView];
    
    [self uiConfig];
}

-(void)createBackView
{
    _viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CityChooseViewWidth, CityChooseViewHeight)];
    [self addSubview:_viewBack];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CityChooseViewWidth, CityChooseViewHeight)];
    imgv.image = [UIImage imageNamed:@"citychoose"];
    [_viewBack addSubview:imgv];
}

-(void)uiConfig{
    
    for (int i = 0; i < 9; i++) {
        UIButton* btnText = [UIButton buttonWithType:UIButtonTypeCustom];
        btnText.frame = CGRectMake(10*ScreenWidth/375 + 120*(i%3)*ScreenWidth/375,20*ScreenWidth/375 + 40*ScreenWidth/375*(i/3), 90*ScreenWidth/375, 30*ScreenWidth/375);
        btnText.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_viewBack addSubview:btnText];
        [btnText setTitleColor:[UITool colorWithHexString:@"#a0a0a0" alpha:1] forState:UIControlStateNormal];
        btnText.layer.cornerRadius = 6*ScreenWidth/375;
        btnText.layer.masksToBounds = YES;
        [btnText.layer setBorderWidth:1.0]; //边框宽度
        btnText.layer.borderColor = [[UITool colorWithHexString:@"#a0a0a0" alpha:1] CGColor];
        [btnText setTitle:_arrTitle[i] forState:UIControlStateNormal];
        btnText.tag = 100 + i;
        [btnText addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
        if ([_strProVince containsString:@"上海"]  == YES) {
            if (i == 1) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 101;
            }
        }
        else if ([_strProVince containsString:@"江苏"]  == YES)
        {
            if (i == 2) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 102;
            }
        }
        else if ([_strProVince containsString:@"浙江"]  == YES)
        {
            if (i == 3) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 103;
            }
        }
        else if ([_strProVince containsString:@"北京"]  == YES)
        {
            if (i == 4) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 104;
            }
        }
        else if ([_strProVince containsString:@"广东"]  == YES)
        {
            if (i == 5) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 105;
            }
        }
        else if ([_strProVince containsString:@"天津"]  == YES)
        {
            if (i == 6) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 106;
            }
        }
        else if ([_strProVince containsString:@"云南"]  == YES)
        {
            if (i == 7) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 107;
            }
        }
        else if ([_strProVince containsString:@"海南"]  == YES)
        {
            if (i == 8) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 108;
            }
        }
        else{
            if (i == 0) {
                btnText.backgroundColor = [UIColor orangeColor];
                [btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _lastBtn = 100;
            }
        }
    }
}

-(void)chooseCity:(UIButton *)btn
{
    if (_lastBtn!=0) {
        UIButton *button = (UIButton *)[self viewWithTag:_lastBtn];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UITool colorWithHexString:@"#a0a0a0" alpha:1] forState:UIControlStateNormal];
    }
    UIButton *button = (UIButton *)[self viewWithTag:btn.tag];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lastBtn = btn.tag;
    _blockStrPro(_arrTitle[btn.tag - 100]);
}


@end
