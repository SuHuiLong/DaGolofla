//
//  JGCreateTeamView.m
//  DagolfLa
//
//  Created by 東 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGCreateTeamView.h"

@interface JGCreateTeamView ()<UITextViewDelegate>

@property (nonatomic, strong)UILabel *placeHold;
//@property (nonatomic, strong)UIButton *previewBtn; // 预览

@end

@implementation JGCreateTeamView


- (instancetype)initWithFrame:(CGRect)frame{
  
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * screenWidth / 320, screenWidth, 80 * screenWidth / 320)];
        topView.backgroundColor = [UIColor orangeColor];
        [self addSubview:topView];
        
        self.addIconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.addIconBtn setFrame:CGRectMake(10 * screenWidth / 320, 10 * screenWidth / 320, 60 * screenWidth / 320, 60 * screenWidth / 320)];
        [self.addIconBtn setImage:[UIImage imageNamed:@"vedioStopBtn"] forState:(UIControlStateNormal)];
        self.addIconBtn.backgroundColor = [UIColor purpleColor];
        [topView addSubview:self.addIconBtn];
        
        self.teamNmaeTV = [[UITextView alloc] initWithFrame:CGRectMake(80 * screenWidth / 320, 10 * screenWidth / 320, screenWidth - 90 * screenWidth / 320, 60 * screenWidth / 320)];
        self.teamNmaeTV.font = [UIFont systemFontOfSize:16];
        [topView addSubview:self.teamNmaeTV];
        self.teamNmaeTV.delegate = self;
        
        self.placeHold = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * screenWidth / 320, screenWidth - 70 * screenWidth / 320, 30 * screenWidth / 320)];
        self.placeHold.text = @"请输入球队名称";
        self.placeHold.textColor = [UIColor lightGrayColor];
        [self.teamNmaeTV addSubview:self.placeHold];
        
        
        
        UIView *buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 100 * screenWidth / 320, screenWidth, 70 * screenWidth / 320)];
        buttonBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttonBackView];
        
        UIView *btnLineView = [[UIView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 34 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 2 * screenWidth / 320)];
        btnLineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [buttonBackView addSubview:btnLineView];
        
        NSArray *buttonArray = [NSArray arrayWithObjects:@"成立日期", @"所在地区", nil];
        for (int i = 0; i < 2; i ++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(0, i * 40 * screenWidth / 320, screenWidth, 30 * screenWidth / 320);
            button.tag = 200 + i;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:buttonArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [buttonBackView addSubview:button];
        }
    
        self.teamIntroduBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.teamIntroduBtn.backgroundColor = [UIColor whiteColor];
        [self.teamIntroduBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        self.teamIntroduBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
        self.teamIntroduBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.teamIntroduBtn setTitle:@"球队介绍" forState:(UIControlStateNormal)];
        [self.teamIntroduBtn setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
        [self.teamIntroduBtn setFrame:CGRectMake(0, 180 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
        [self addSubview:self.teamIntroduBtn];
    
        UIButton *examineBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        examineBtn.backgroundColor = [UIColor whiteColor];
        [examineBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        examineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [examineBtn setTitle:@"  加入时管理员审批" forState:(UIControlStateNormal)];
        [examineBtn setFrame:CGRectMake(0, 220 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
        [self addSubview:examineBtn];
        
        self.examineSWt = [[UISwitch alloc] initWithFrame:CGRectMake(260 * screenWidth / 320, 0, 50 * screenWidth / 320, 30 * screenWidth / 320)];
        self.examineSWt.transform = CGAffineTransformMakeScale(0.75 * screenWidth / 320, 0.75 * screenWidth / 320);
        [self.examineSWt setFrame:CGRectMake(260 * screenWidth / 320, 3 * screenWidth / 320, 50 * screenWidth / 320, 30 * screenWidth / 320)];
        [examineBtn addSubview:self.examineSWt];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 260 * screenWidth / 320, screenWidth, 20 * screenWidth / 320)];
        label.text = @"申请人资料";
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        [self lableAndTextField:280 * screenWidth / 320 title:@"  真实姓名" placeHolder:@"请输入姓名"];
        [self lableAndTextField:320 * screenWidth / 320 title:@"  联系方式" placeHolder:@"请输入手机号"];
        
        UILabel *apply = [[UILabel alloc] initWithFrame:CGRectMake(0, 355 * screenWidth / 320, screenWidth, 20 * screenWidth / 320)];
        apply.text = @" 注：为了球队能够顺利创建，请务必输入真实信息";
        apply.font = [UIFont systemFontOfSize:12];
        apply.textColor = [UIColor lightGrayColor];
        [self addSubview:apply];
        
        self.previewBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.previewBtn.backgroundColor = [UIColor lightGrayColor];
        [self.previewBtn setTitle:@"预览" forState:(UIControlStateNormal)];
        [self.previewBtn setFrame:CGRectMake(10 * screenWidth / 320, 395 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320)];
        [self addSubview:self.previewBtn];
        
    }
    return self;
}

- (void)lableAndTextField: (CGFloat)y title: (NSString *)title placeHolder: (NSString *)holder{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 100 * screenWidth / 320, 30 * screenWidth / 320)];
    label.text = title;
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100 * screenWidth / 320, y, screenWidth - 100 * screenWidth / 320, 30 * screenWidth / 320)];
    textField.placeholder = holder;
    textField.backgroundColor = [UIColor whiteColor];
    [self addSubview:textField];
}


- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] != 0) {
        self.placeHold.hidden = YES;
    }else{
        self.placeHold.hidden = NO;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
