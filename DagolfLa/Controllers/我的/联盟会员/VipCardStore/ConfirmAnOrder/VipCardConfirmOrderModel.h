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
 用户id
 */
@property(nonatomic,copy)NSString *userKey;
/**
 用户名
 */
@property(nonatomic,copy)NSString *userName;
/**
 头像
 */
@property(nonatomic,copy)NSString *picHeadURL;
/**
 证件号
 */
@property(nonatomic,copy)NSString *certNumber;
/**
 性别 0：女 1：男
 */
@property(nonatomic,assign)NSInteger sex;
/**
 证件图片
 */
@property(nonatomic,copy)NSString *picCertURLs;
/**
 用户手机号
 */
@property(nonatomic,copy)NSString *mobile;



/**
 销售人员手机号
 */
@property(nonatomic, copy)NSString *sellPhoneStr;
/**
 勾选是否选中
 */
@property(nonatomic, assign)BOOL isSelect;
@end
