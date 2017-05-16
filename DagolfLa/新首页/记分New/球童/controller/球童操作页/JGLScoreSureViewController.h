//
//  JGLScoreSureViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLScoreSureViewController : ViewController

@property (strong, nonatomic) NSString* userNamePlayer;

@property (strong, nonatomic) NSNumber* userKeyPlayer;

@property (strong, nonatomic) NSString* userMobilePlayer;

@property (assign, nonatomic) NSInteger errorState;//判断界面显示的样式，1，其他，2，球童扫球童，3打球人

@end
