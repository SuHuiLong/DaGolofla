//
//  JGDAddFromContactTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDAddFromContactTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *mobileLB;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) NSInteger state;  // 0 邀请  1 添加  2 已添加  3 等待验证
@end
