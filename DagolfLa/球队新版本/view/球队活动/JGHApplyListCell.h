//
//  JGHApplyListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

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
//subsidies
@property (weak, nonatomic) IBOutlet UIImageView *subsidiesImageView;
@property (weak, nonatomic) IBOutlet UILabel *monay;

//删除
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;

@property (nonatomic, strong)UILabel *couponsLabel;

@property (weak, nonatomic)id <JGHApplyListCellDelegate> delegate;

- (void)configDict:(NSDictionary *)dict;

//退款相关
- (void)configCancelApplyDict:(NSMutableDictionary *)dict;

//在报名
- (void)configCancelModel:(JGTeamAcitivtyModel *)model;

@end
