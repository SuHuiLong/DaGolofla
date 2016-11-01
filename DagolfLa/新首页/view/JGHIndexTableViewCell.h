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

@end

@interface JGHIndexTableViewCell : UITableViewCell

@property (weak, nonatomic)id <JGHIndexTableViewCellDelegate> delegate;

//精彩推荐
- (void)configJGHWonderfulTableViewCell:(NSArray *)wonderfulArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;
//订场推荐
- (void)configJGHShowRecomStadiumTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;
//用品商城
- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;

@end
