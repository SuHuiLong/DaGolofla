//
//  JGHPoorBarHoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHPoorBarHoleCellDelegate <NSObject>

- (void)jGHPoorBarHoleCellDelegate:(UIButton *)btn;

@end

@interface JGHPoorBarHoleCell : UITableViewCell

@property (nonatomic, weak)id <JGHPoorBarHoleCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *nameBtn;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBtnLeft;//10
- (IBAction)nameBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *nameBtnImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBtnImageViewLeft;//13

@property (weak, nonatomic) IBOutlet UILabel *oneK;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneKW;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneKRight;//6

@property (weak, nonatomic) IBOutlet UILabel *eagleLable;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eagleLableRight;//15

@property (weak, nonatomic) IBOutlet UILabel *twoK;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoKW;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoKRight;//6

@property (weak, nonatomic) IBOutlet UILabel *birdleLable;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *birdleLableRight;//15

@property (weak, nonatomic) IBOutlet UILabel *three;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeW;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeRight;//6

@property (weak, nonatomic) IBOutlet UILabel *parLable;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parLableRight;//15

@property (weak, nonatomic) IBOutlet UILabel *fourK;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourKW;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourKRight;//6

@property (weak, nonatomic) IBOutlet UILabel *BogeyLable;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BogeyLableRight;//10

- (void)configJGHPoorBarHoleCell:(NSString *)areaString andImageDirection:(NSInteger)direction;

@end
