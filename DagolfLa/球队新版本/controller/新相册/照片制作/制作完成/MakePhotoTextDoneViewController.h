//
//  MakePhotoTextDoneViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/3/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"

@interface MakePhotoTextDoneViewController : BaseViewController
//url
@property(nonatomic, copy)NSString *urlStr;
//icon
@property(nonatomic, copy)NSNumber *timeKey;
//title
@property(nonatomic, copy)NSString *headerStr;
//作者
@property(nonatomic, copy)NSString *writerStr;

@end
