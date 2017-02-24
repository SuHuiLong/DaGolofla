//
//  JGDInputView.m
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDInputView.h"


@implementation JGDInputView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];

        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 * ProportionAdapter, screenWidth, (100 + self.height) * ProportionAdapter)];
        self.backView.backgroundColor = [UIColor whiteColor];
        
        self.putTextView = [[UITextView alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 30 * ProportionAdapter, screenWidth - 30 * ProportionAdapter, self.height * ProportionAdapter)];
        self.putTextView.layer.borderWidth = 0.5 * ProportionAdapter;
        self.putTextView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        self.putTextView.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.putTextView.delegate = self;
        [self.backView addSubview:self.putTextView];
    
        
        self.placeHolderLB = [Helper lableRect:CGRectMake(15 * ProportionAdapter, 10 * ProportionAdapter, 200, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#c8c8c8"] labelFont:15 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.putTextView addSubview:self.placeHolderLB];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(260 * ProportionAdapter, (60 + self.height) * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [self.cancelBtn addTarget:self action:@selector(cancelAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        [self.backView addSubview:self.cancelBtn];
        
        self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(320 * ProportionAdapter, (60 + self.height) * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [self.confirmBtn addTarget:self action:@selector(confirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        [self.backView addSubview:self.confirmBtn];
        
        
        [self addSubview:self.backView];
    }
    
    return self;
}


- (void)setHeight:(CGFloat)height{
    
    [self.backView setFrame:CGRectMake(0, 200 * ProportionAdapter - (height - 50 * ProportionAdapter), screenWidth, (100 + height) * ProportionAdapter)];
    
    [self.putTextView setFrame:CGRectMake(15 * ProportionAdapter, 30 * ProportionAdapter, screenWidth - 30 * ProportionAdapter, height * ProportionAdapter)];
    
    [self.cancelBtn setFrame:CGRectMake(260 * ProportionAdapter, (60 + height) * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];
    
    [self.confirmBtn setFrame:CGRectMake(320 * ProportionAdapter, (60 + height) * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];

}

- (void)setPlaceHolderString:(NSString *)placeHolderString{
    self.placeHolderLB.text = placeHolderString;
}

#pragma mark -- UITextViewDelegate代理
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHolderLB.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.putTextView.text isEqualToString:@""]) {
        self.placeHolderLB.hidden = NO;
    }else{
        self.placeHolderLB.hidden = YES;
    }
}

- (void)cancelAct{
    [self removeFromSuperview];
}

- (void)confirmAct{
    self.blockStr(self.putTextView.text);
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
