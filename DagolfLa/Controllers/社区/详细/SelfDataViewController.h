//
//  SelfDataViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/3.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

@interface SelfDataViewController : ViewController

//其他人的id
@property (copy, nonatomic) NSNumber* strMoodId;

@property (strong, nonatomic) NSNumber* messType;

@property (assign, nonatomic) NSInteger sexType;




@end
