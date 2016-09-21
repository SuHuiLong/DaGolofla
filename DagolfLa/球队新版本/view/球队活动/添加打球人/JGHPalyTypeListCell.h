//
//  JGHPalyTypeListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHPalyTypeListCellDelegate <NSObject>

- (void)selectPalysTypeListBtnClick:(UIButton *)btn;

@end

@interface JGHPalyTypeListCell : UITableViewCell

@property (nonatomic, weak)id <JGHPalyTypeListCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLeft;//40

- (IBAction)selectBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnRight;//20
@property (weak, nonatomic) IBOutlet UILabel *unitLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitLableRight;//20
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

- (void)configJGHPalyTypeListCell:(NSMutableDictionary *)dict;


@end
