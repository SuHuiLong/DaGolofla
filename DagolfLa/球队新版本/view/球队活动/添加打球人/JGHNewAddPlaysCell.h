//
//  JGHNewAddPlaysCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewAddPlaysCellDelegate <NSObject>

- (void)selectAddPlays:(UIButton *)btn;//添加队员

- (void)selectAddBallPlays:(UIButton *)btn;//添加球友

//- (void)selectAddContactPlays:(UIButton *)btn;//添加联系人

@end

@interface JGHNewAddPlaysCell : UITableViewCell

@property (weak, nonatomic)id <JGHNewAddPlaysCellDelegate> delegate;

@property (nonatomic, retain)UIButton *oneBtn;

@property (nonatomic, retain)UIImageView *teamPalyerImageView;

@property (nonatomic, retain)UILabel *teamPalyer;

@property (nonatomic, retain)UIButton *twoBtn;

@property (nonatomic, retain)UIImageView *palyerImageView;

@property (nonatomic, retain)UILabel *palyer;

@end
