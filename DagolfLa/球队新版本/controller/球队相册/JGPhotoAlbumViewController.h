//
//  JGPhotoAlbumViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGPhotoAlbumViewController : ViewController


@property (strong, nonatomic) NSString* strTitle;
@property (strong, nonatomic) NSNumber* strTimeKey;

//相册的key
@property (strong, nonatomic) NSNumber* albumKey;
@property (strong, nonatomic) NSString* power;//球队管理权限

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSNumber* teamTimeKey;

@property (strong, nonatomic) NSNumber* state;

@property (strong, nonnull) NSDictionary* dictMember;

@property (copy, nonatomic) void (^blockRefresh)();

@end
