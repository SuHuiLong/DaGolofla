//
//  JGDPlayerQRCodeViewController.h
//  DagolfLa
//
//  Created by 東 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDPlayerQRCodeViewController : ViewController

@property (nonatomic, copy) void (^clipBlock)(NSString *, NSInteger );

//活动记分
@property (nonatomic, copy) void (^blockCaddieAcitivtyScore)(NSString *, NSString * , NSInteger);

//普通记分
@property (nonatomic, copy) void (^blockStartCaddieScore)(NSString *, NSString * , NSInteger);


@end
