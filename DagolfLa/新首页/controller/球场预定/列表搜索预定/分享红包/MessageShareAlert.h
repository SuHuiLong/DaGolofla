//
//  MessageShareAlert.h
//  DagolfLa
//
//  Created by SHL on 2017/6/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectIndex)(NSInteger index);
@interface MessageShareAlert : UIView

@property (nonatomic,copy) selectIndex selectIndex;

@end
