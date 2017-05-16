//
//  JGLActivityMemberTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/3.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyattenModel.h"
@interface JGLActivityMemberNumTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView* imgvIcon;

@property (strong, nonatomic) UILabel*     labelTitle;

@property (strong, nonatomic) UIImageView* imgvSex;

@property (strong, nonatomic)MyattenModel *myModel;



@end
