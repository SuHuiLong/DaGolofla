//
//  SelfViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/7/24.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"
#import "OtherDataModel.h"



@interface SelfViewController : ViewController


@property(nonatomic,strong) OtherDataModel *userModel;

@property (strong, nonatomic) NSNumber* fromEnroll;

typedef void(^BlockRereshingkMe)(NSArray *);
@property(nonatomic,copy)BlockRereshingkMe blockRereshingMe;




@end
