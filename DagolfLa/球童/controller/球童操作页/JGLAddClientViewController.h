//
//  JGLAddClientViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLAddClientViewController : ViewController

@property (assign, nonatomic) NSInteger isCaddie;//是否是球童，1，是球童，2，是打球人
@property (copy, nonatomic) void(^blockData)(NSString *);


@property (copy, nonatomic) void(^blockQcodeActivityScore)(NSString *, NSString *, NSInteger);

@property (copy, nonatomic) void(^blockQcodeScore)(NSString *, NSString *, NSInteger);

@end
