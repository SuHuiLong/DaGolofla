//
//  JGHApplyCatoryPriceViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyCatoryPriceViewCellDelegate <NSObject>

- (void)selectJGHApplyCatoryPriceViewCell:(UIButton *)btn;

@end

@interface JGHApplyCatoryPriceViewCell : UITableViewCell

@property (nonatomic, weak)id <JGHApplyCatoryPriceViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *catoryLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catoryLableLeft;//40

@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promLableRight;//20

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnRight;//30
@property (weak, nonatomic) IBOutlet UILabel *promLable;

- (void)configJGHApplyCatoryPriceViewCell:(NSMutableDictionary *)dict;


@end
