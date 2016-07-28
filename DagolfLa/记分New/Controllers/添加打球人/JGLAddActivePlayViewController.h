//
//  JGLAddActivePlayViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLChooseScoreModel.h"
@interface JGLAddActivePlayViewController : ViewController

/**
 *      NSMutableDictionary* _dictFinish;//完成的成员字典
 NSMutableArray* _dataPeoArr;//第二个列表数据
 NSMutableArray* _dataKey;//存选择的成员的key，用来第二个列表的删除操作
 */
@property (strong, nonatomic) JGLChooseScoreModel* model;

@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (strong, nonatomic) NSMutableArray* dataKey;

@property (strong, nonatomic) NSMutableArray* dataUserKey;

@property (strong, nonatomic) NSMutableArray* arrMobile;


@property (copy, nonatomic) void (^blockSurePlayer)(NSMutableDictionary *  , NSMutableArray*,NSMutableArray* ,NSMutableArray*);

@end
