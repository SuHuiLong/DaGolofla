//
//  MakePhotoTextSelectHeaderViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ selectHeaderImageBlock)(NSNumber *picTimeKey);
@interface MakePhotoTextSelectHeaderViewController : BaseViewController

//数据源
@property(nonatomic, strong)NSMutableArray *dataArray;
//球队值
@property(nonatomic, copy)NSNumber *teamTimeKey;

//选择返回block
@property(nonatomic, copy)selectHeaderImageBlock selectBlock;

-(void)setSelectHeaderImageBlock:(selectHeaderImageBlock)selectBlock;
@end
