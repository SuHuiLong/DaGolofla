//
//  JGDDPhotoAlbumViewController.h
//  DagolfLa
//
//  Created by 東 on 16/12/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDDPhotoAlbumViewController : ViewController

@property (nonatomic, copy) NSString *strTitle;//相册标题
//相册的key
@property (strong, nonatomic) NSNumber* albumKey;//相册key------首页改动后只要相册key，别的暂时都不用
@property (strong, nonatomic) NSString* power;//球队管理权限

@property (strong, nonatomic) NSNumber* userKey;//发布人的userKey

@property (strong, nonatomic) NSNumber* teamTimeKey;//球队key

//球队名
@property (nonatomic, copy) NSString *teamName;

@property (strong, nonatomic) NSNumber* state;

@property (strong, nonnull) NSDictionary* dictMember;

//是否是获取球队所有的照片
@property (nonatomic, assign) BOOL isGetAll;

@end
