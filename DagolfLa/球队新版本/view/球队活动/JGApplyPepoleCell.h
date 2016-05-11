//
//  JGApplyPepoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGApplyPepoleCell : UITableViewCell
//添加活动嘉宾
- (IBAction)addApplyBtnClick:(UIButton *)sender;
//报名人姓名列表视图
@property (weak, nonatomic) IBOutlet UIView *applyListView;
@end
