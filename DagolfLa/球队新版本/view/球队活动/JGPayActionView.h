//
//  JGPayActionView.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGPayActionViewDelegate <NSObject>

- (void)didSelectZhifuBaoPay;

- (void)didSelectWeChatPay;

@end

@interface JGPayActionView : UIView


@end
