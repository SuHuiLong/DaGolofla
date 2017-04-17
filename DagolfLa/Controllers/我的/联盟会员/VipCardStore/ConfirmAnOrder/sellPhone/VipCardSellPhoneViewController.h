//
//  VipCardSellPhoneViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/4/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ addPhoneBlock)(NSString *phoneStr);
@interface VipCardSellPhoneViewController : BaseViewController

//默认填充文字
@property(nonatomic, copy)NSString *DefaultText;

/**
 保存手机号block
 */
@property(nonatomic, strong)addPhoneBlock addPhoneBlock;
//设置block
-(void)setAddPhoneBlock:(addPhoneBlock)addPhoneBlock;

@end
