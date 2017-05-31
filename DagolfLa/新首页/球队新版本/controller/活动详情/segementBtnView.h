//
//  segementBtnView.h
//  DagolfLa
//
//  Created by SHL on 2017/5/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface segementBtnView : UIView
//左按钮
@property (nonatomic,strong) UIButton *leftBtn;
//右按钮
@property (nonatomic,strong) UIButton *rightBtn;

//单个按钮
@property (nonatomic,strong) UIButton *indexBtn;


-(instancetype)initWithFrame:(CGRect)frame leftTile:(NSString *)left rightTile:(NSString *)right;
-(instancetype)initWithFrame:(CGRect)frame Tile:(NSString *)title;
@end
