//
//  JGLCaddieSelfScoreViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLCaddieSelfScoreViewController : ViewController
///普通积分，逻辑处理和活动记分类似，跳转页面也基本相同
///传值得方式也相同，最后提交数据又不一样的地方


@property (strong, nonatomic) NSString* userNamePlayer;//打球人姓名

@property (strong, nonatomic) NSNumber* userKeyPlayer;//打球人userkey

@property (strong, nonatomic) NSString* userMobilePlayer;//打球人手机号

@property (assign, nonatomic)NSInteger sex;//性别

@end
