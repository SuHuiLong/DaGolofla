//
//  JGTeamPhotoViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGTeamPhotoViewController : ViewController
//球场title
@property (nonatomic, copy)NSString *titleStr;

//相册中的参数：球队的key
@property (strong, nonatomic) NSNumber* teamKey;

//相册中的权限设置
@property (strong, nonatomic) NSString* powerPho;

//teamember,判断是不是球队成员
@property (strong, nonatomic) NSMutableDictionary* dictMember;






//球队大厅中传参 如果inter== 1 则不显示管理按钮
@property (assign, nonatomic) NSInteger manageInter;
@end
