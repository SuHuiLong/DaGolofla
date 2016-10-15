//
//  JGLGroupPeoTableViewCell.h
//  DagolfLa
//
//  Created by Madridlee on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGLGroupPeoTableViewCell : UITableViewCell
//左边成员的背景框
@property (strong, nonatomic) UIView* backView1;
//左边第一个分组成员
@property (strong, nonatomic) UIButton* btnHeader1;
@property (strong, nonatomic) UILabel* labelName1;
@property (strong, nonatomic) UILabel* labelAlmast1;
@property (strong, nonatomic) UILabel* labelChadian1;
//左边第二个分组成员
@property (strong, nonatomic) UIButton* btnHeader2;
@property (strong, nonatomic) UILabel* labelName2;
@property (strong, nonatomic) UILabel* labelAlmast2;
@property (strong, nonatomic) UILabel* labelChadian2;
//中间箭头
@property (strong, nonatomic) UILabel* labelNum;
@property (strong, nonatomic) UIImageView* imgvJt;
//右边成员的背景框
@property (strong, nonatomic) UIView* backView2;
//右边的第一个成员
@property (strong, nonatomic) UIButton* btnHeader3;
@property (strong, nonatomic) UILabel* labelName3;
@property (strong, nonatomic) UILabel* labelAlmast3;
@property (strong, nonatomic) UILabel* labelChadian3;
//右边的第二个成员
@property (strong, nonatomic) UIButton* btnHeader4;
@property (strong, nonatomic) UILabel* labelName4;
@property (strong, nonatomic) UILabel* labelAlmast4;
@property (strong, nonatomic) UILabel* labelChadian4;


-(void)initUiConfig;

@end
