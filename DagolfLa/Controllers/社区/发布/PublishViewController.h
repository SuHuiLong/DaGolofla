//
//  PublishViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import <ALBBQuPaiPlugin/ALBBQuPaiPluginPluginServiceProtocol.h>
#import <ALBBQuPaiPlugin/QPEffectMusic.h>

/**
 *  发布消息
 */
@interface PublishViewController : ViewController

typedef void(^BlockRereshingk)();
@property(nonatomic,copy)BlockRereshingk blockRereshing;



@end
