//
//  JGDSubMitPayPasswordViewController.h
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDSubMitPayPasswordViewController : ViewController

@property (nonatomic, copy) NSString *code;

// 判断是否是从支付页面跳过来的
@property (nonatomic, assign) BOOL isPayVC;

@end
