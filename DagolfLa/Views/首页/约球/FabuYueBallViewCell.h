//
//  FabuYueBallViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/9/17.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabuYueBallViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *xuanBtn;

@property (assign, nonatomic) BOOL choose;
@property (assign, nonatomic) int strlegth;
@property(nonatomic,copy)void(^block)(UIViewController *vc);

@property (strong, nonatomic) NSMutableArray* dataArray, *telArray;






@end
