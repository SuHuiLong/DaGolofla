//
//  JGHAddPlaysCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAddPlaysCellDelegate <NSObject>

- (void)selectAddPlays:(UIButton *)btn;//添加队员

- (void)selectAddBallPlays:(UIButton *)btn;//添加球友

- (void)selectAddContactPlays:(UIButton *)btn;//添加联系人

@end

@interface JGHAddPlaysCell : UITableViewCell

@property (nonatomic, weak)id <JGHAddPlaysCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageViewTop;//16
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageViewLeft;//42
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageViewRight;//42--

@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoImageViewLeft;//42
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoImageViewTop;//16
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoImageViewRight;//--42


@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeImageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeImageViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeImageViewLeftRight;//40

@property (weak, nonatomic) IBOutlet UILabel *oneLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLableTop;//16

@property (weak, nonatomic) IBOutlet UILabel *twoLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLableLeft;

@property (weak, nonatomic) IBOutlet UILabel *threeLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLableLeft;

- (IBAction)oneBtn:(UIButton *)sender;

- (IBAction)twoBtn:(UIButton *)sender;

- (IBAction)threeBtn:(UIButton *)sender;

@end
