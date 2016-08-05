//
//  JGLAddressAddTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGLAddressAddTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* imgvState;

@property (strong, nonatomic) UILabel*     labelName;

@property (strong, nonatomic) UILabel*     labelMobile;

@property (assign, nonatomic) BOOL isGest;//判断是否是嘉宾，嘉宾不需要标记

@end
