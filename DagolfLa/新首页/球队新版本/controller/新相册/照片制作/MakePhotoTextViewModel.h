//
//  MakePhotoTextViewModel.h
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface MakePhotoTextViewModel : BaseModel
//图片key
@property (nonatomic, copy) NSNumber *timeKey;
//文字
@property (nonatomic, copy) NSString *textStr;

@end
