//
//  VipCardConfirmOrderViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"
#import "VipCardGoodDetailViewModel.h"
@interface VipCardConfirmOrderViewController : BaseViewController
/**
 当前卡的model
 */
@property(nonatomic, strong)VipCardGoodDetailViewModel *dataModel;
@end
