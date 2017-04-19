//
//  VipCardHeaderCollectionReusableView.h
//  DagolfLa
//
//  Created by SHL on 2017/3/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VipCardHeaderCollectionReusableView : UICollectionReusableView

//提示图片
@property(nonatomic, strong)UIImageView *alertImageView;
//提示文字
@property(nonatomic, strong)UILabel *descLabel;
//文本上立即添加按钮
@property(nonatomic, strong)UIButton *addBtn;
//立即添加按钮
@property(nonatomic, strong)UIButton *addNowBtn;
//不可用卡片分割线
@property(nonatomic, strong)UIView *line;
//不可用卡片的提示
@property(nonatomic, strong)UILabel *nocanDescLabel;
/**
 跳转联盟卡商城按钮
 */
@property(nonatomic, strong)UIButton *goodsListButton;
@end
