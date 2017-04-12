//
//  VipCardConfirmOrderModel.h
//  DagolfLa
//
//  Created by SHL on 2017/4/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipCardConfirmOrderModel : NSObject


/**
 销售人员手机号
 */
@property(nonatomic, copy)NSString *sellPhoneStr;
/**
 勾选是否选中
 */
@property(nonatomic, assign)BOOL isSelect;
@end
