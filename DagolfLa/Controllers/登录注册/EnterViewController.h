//
//  EnterViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface EnterViewController : ViewController

@property (assign,nonatomic) NSInteger popViewNumber;


typedef void(^BlockRereshingk)();
@property(nonatomic,copy)BlockRereshingk jiazai;



@end





