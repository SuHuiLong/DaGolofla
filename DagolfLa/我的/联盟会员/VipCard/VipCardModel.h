//
//  VipCardModel.h
//  DagolfLa
//
//  Created by SHL on 2017/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface VipCardModel : BaseModel
//图片url
@property(nonatomic,copy)NSString *imagePicUrl;
//卡片状态 1:可用 0:不可用
@property(nonatomic,assign)NSInteger cardState;
//卡片状态描述
@property(nonatomic,copy)NSString *cardStr;
//卡片id
@property(nonatomic,copy)NSString *cardId;
/**
 卡编号
 */
@property(nonatomic,copy)NSString *cardNumber;

@end
