//
//  JGTeamPhotoViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGTeamPhotoViewController : ViewController

//相册中的参数：球队的key
@property (strong, nonatomic) NSNumber* teamKey;

//相册中的权限设置
@property (strong, nonatomic) NSString* power;
@end
