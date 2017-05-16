//
//  JGPlayPayBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGPlayPayBaseCellDelegate <NSObject>

- (void)deletePalyBaseBtn:(UIButton *)btn;

@end

@interface JGPlayPayBaseCell : UITableViewCell

@property (weak, nonatomic)id <JGPlayPayBaseCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//40

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *priceUnit;

@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponsImageViewLeft;//20

@property (weak, nonatomic) IBOutlet UIButton *deletePalyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deletePalyBtnRight;//10
- (IBAction)deletePalyBtn:(UIButton *)sender;

@property (nonatomic, strong) UILabel *couponsLabel;//优惠价格


- (void)configJGPlayPayBaseCell:(NSMutableDictionary *)dict;

@end
