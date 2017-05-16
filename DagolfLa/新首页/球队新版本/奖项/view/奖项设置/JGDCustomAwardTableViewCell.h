//
//  JGDCustomAwardTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 2017/4/26.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDCustomAwardTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLB;

@property (nonatomic, strong) UITextField *inputTF;

@property (nonatomic, strong) UILabel *lineLB;

@property (nonatomic, assign) CGFloat rowHeight;

@end
