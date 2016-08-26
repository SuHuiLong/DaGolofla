//
//  JGHApplyNewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyNewCellDelegate <NSObject>

- (void)selectEditorBtn:(UIButton *)btn;

- (void)selectApplyDeleteBtn:(UIButton *)btn;

@end

@interface JGHApplyNewCell : UITableViewCell

@property (nonatomic, weak)id <JGHApplyNewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//37

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBtnLeft;//55

@property (weak, nonatomic) IBOutlet UIButton *editorBtn;
- (IBAction)editorBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *preferpriceImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preferpriceImageViewRight;


@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
- (IBAction)deleBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleBtnRight;

@property (nonatomic, strong) UILabel *couponsLabel;//优惠价格

//报名页面
- (void)configDict:(NSDictionary *)dict;


@end
