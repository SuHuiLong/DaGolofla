//
//  MakePhotoTextTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakePhotoTextViewModel.h"
@interface MakePhotoTextTableViewCell : UITableViewCell
//删除按钮
@property(nonatomic, copy)UIButton *deleateBtn;
//文本输入框
@property(nonatomic, copy)UILabel *textViewLabel;
//默认图
@property(nonatomic, copy)UIImageView *iconImageView;
//可拖动提示文字
@property(nonatomic, copy)UILabel *descLabel;
//配置数据
-(void)configModel:(MakePhotoTextViewModel *)model;
@end
