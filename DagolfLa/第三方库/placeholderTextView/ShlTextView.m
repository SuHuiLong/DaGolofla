//
//  ShlTextView.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ShlTextView.h"

@implementation ShlTextView


- (instancetype)initWithFrame:(CGRect)frame placeLabel:(UILabel *)placeLabel
{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            _placeStr = placeLabel.text;
            _placeLabel = placeLabel;
            [self createView];
        }
    }
    return self;
}

//创建
-(void)createView{
    self.textContainerInset = UIEdgeInsetsMake(0, kHvertical(5), 0, 0);

    _placeLabel.userInteractionEnabled = NO;//lable必须设置为不可用
    [_placeLabel sizeToFit];
    [self addSubview:_placeLabel];
    
}

-(void)textViewDidChange:(NSString *)str{
    if (str.length == 0) {
        _placeLabel.text = _placeStr;
    }else{
        _placeLabel.text = @"";
    }
    [_placeLabel sizeToFit];
}


@end
