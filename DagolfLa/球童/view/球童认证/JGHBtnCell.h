//
//  JGHBtnCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHBtnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
- (IBAction)titleBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnRight;

@end
