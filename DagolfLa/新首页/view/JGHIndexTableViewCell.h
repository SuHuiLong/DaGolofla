//
//  JGHIndexTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHIndexTableViewCellDelegate <NSObject>

@optional
- (void)wonderfulSelectClick:(UIButton *)btn;

- (void)recomStadiumSelectClick:(UIButton *)btn;

- (void)suppliesMallSelectClick:(UIButton *)btn;

- (void)hotTeamSelectClick:(UIButton *)btn;

- (void)selectSpectatorSportsUrlString:(NSInteger)selectID;

- (void)didSelectGolgPackageUrlString:(NSInteger)selectID;

@end

@interface JGHIndexTableViewCell : UITableViewCell

@property (weak, nonatomic)id <JGHIndexTableViewCellDelegate> delegate;
//高旅套餐
- (void)configJGHGolfPackageView:(NSArray *)spectatorArray;
//精彩赛事
- (void)configJGHSpectatorSportsView:(NSArray *)spectatorArray;
//精彩推荐
- (void)configJGHWonderfulTableViewCell:(NSArray *)wonderfulArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;
//订场推荐
- (void)configJGHShowRecomStadiumTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;
//用品商城
- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;
//热门球队
- (void)configJGDHotTeamCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;

@end
