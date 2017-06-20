//
//  SelectRedPacketViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/6/8.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"
#import "RedPacketModel.h"
typedef void (^selectModelBlock)(RedPacketModel *model);
@interface SelectRedPacketViewController : BaseViewController
//数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
//当前选中的红包
@property (nonatomic,strong) RedPacketModel *selectModel;

@property(nonatomic,copy)selectModelBlock selectModelBlock;

@end
