//
//  JGHApplyListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyListCellDelegate <NSObject>

- (void)didSelectDeleteBtn:(UIButton *)btn;

- (void)didChooseBtn:(UIButton *)btn;

@end

@interface JGHApplyListCell : UITableViewCell
//勾选按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

- (IBAction)chooseBtn:(UIButton *)sender;
//名字
@property (weak, nonatomic) IBOutlet UILabel *name;
//价格
@property (weak, nonatomic) IBOutlet UILabel *price;
//删除
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtn:(UIButton *)sender;

@property (weak, nonatomic)id <JGHApplyListCellDelegate> delegate;

- (void)configDict:(NSDictionary *)dict;

@end
