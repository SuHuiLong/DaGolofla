//
//  MakePhotoTextSelectFromAllViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextSelectHeaderViewController.h"
typedef void (^ selectPhotoBlock)(NSMutableArray *mArray);
@interface MakePhotoTextSelectFromAllViewController : BaseViewController

//数据源
@property(nonatomic, strong)NSMutableArray *dataArray;
//球队值
@property(nonatomic, copy)NSNumber *teamTimeKey;
//是否可多选
@property(nonatomic, assign)BOOL canMultipleChoice;

//图片跳转Block
@property (copy, nonatomic) selectPhotoBlock selectPhotoBlock;
//设置block
-(void)SetSelectPhotoBlock:(selectPhotoBlock)selectPhotoBlock;

@end
