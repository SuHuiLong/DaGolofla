//
//  UITabBar+badge.m
//  RCloudMessage
//
//  Created by Jue on 16/7/1.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 5.0
#import "UIColor+RCColor.h"
#import "RCDTabBarBtn.h"

@implementation UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888+index;
    badgeView.layer.cornerRadius = self.frame.size.width/2;//圆形
    badgeView.backgroundColor = [UIColor colorWithHexString:@"f43530" alpha:1.0];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.5) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

- (void)showBadgeOnItemIndex:(int)index badgeValue:(int)badgeValue{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.5) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width) + 3 * ProportionAdapter;
    CGFloat y = ceilf(0.1 * tabFrame.size.height) - 4 * ProportionAdapter;
    if (badgeValue < 10) {
        [self initUnreadCountButton:CGRectMake(x, y, 18*ProportionAdapter, 18*ProportionAdapter) tag:888+index badgeValue:badgeValue];
    }
    if (badgeValue >= 10 && badgeValue < 100 ) {
        [self initUnreadCountButton:CGRectMake(x, y, 22*ProportionAdapter, 18*ProportionAdapter) tag:888+index badgeValue:badgeValue];
    }
    if (badgeValue >= 100) {
        RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(x, y, 30*ProportionAdapter, 18*ProportionAdapter)];
        [btn setImage:[UIImage imageNamed:@"icn_mesg_99+"] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = 888+index;
    }
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [((RCDTabBarBtn *)subView).shapeLayer removeFromSuperlayer];
            [subView removeFromSuperview];
        }
    }
}

-(void)initUnreadCountButton:(CGRect)frame tag:(NSUInteger)tag badgeValue:(int)badgeValue
{
    RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:frame];
    [self addSubview:btn];
    btn.tag = tag;
    btn.layer.cornerRadius = frame.size.width/2;//圆形
    btn.enabled = NO;
    btn.unreadCount = [NSString stringWithFormat:@"%d",badgeValue];
}

@end
