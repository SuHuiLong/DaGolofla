//
//  JGLPlayerNameTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLAddActiivePlayModel;

@interface JGLPlayerNameTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel*     labelTitle;

@property (strong, nonatomic) UILabel*     labelName;

@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel*     labelTee;

-(void)showTee:(NSString *)str;

- (void)configJGLAddActiivePlayModel:(JGLAddActiivePlayModel *)model;


@end
