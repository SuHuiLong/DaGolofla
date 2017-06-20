//
//  RedpacketAlertView.h
//  DagolfLa
//
//  Created by SHL on 2017/6/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedpacketAlertView : UIView

//弹出界面
@property (nonatomic,strong) UIImageView *circleView;
// 创建订场红包弹窗界面
-(instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text;
@end
