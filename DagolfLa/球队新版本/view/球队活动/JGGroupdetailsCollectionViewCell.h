//
//  JGGroupdetailsCollectionViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHPlayersModel;
@class JGGroupdetailsCollectionViewCell;

@protocol JGGroupdetailsCollectionViewCellDelegate <NSObject>

- (void)didSelectHeaderImage:(UIButton *)btn JGGroupCell:(JGGroupdetailsCollectionViewCell *)cell;

@end

@interface JGGroupdetailsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *sction1;

@property (weak, nonatomic) IBOutlet UIButton *sction2;

@property (weak, nonatomic) IBOutlet UIButton *section3;

@property (weak, nonatomic) IBOutlet UIButton *section4;

@property (weak, nonatomic) IBOutlet UIImageView *sctionImage;

@property (weak, nonatomic) IBOutlet UILabel *groupName;

@property (weak, nonatomic) id <JGGroupdetailsCollectionViewCellDelegate> delegate;



@property (strong, nonatomic) UILabel *lable1;

@property (strong, nonatomic) UILabel *lable2;

@property (strong, nonatomic) UILabel *lable3;

@property (strong, nonatomic) UILabel *lable4;

@property (strong, nonatomic) UIImageView *money1;
@property (strong, nonatomic) UIImageView *money2;
@property (strong, nonatomic) UIImageView *money3;
@property (strong, nonatomic) UIImageView *money4;

//- (void)configJGHPlayersModel:(JGHPlayersModel *)model andSortIndex:(NSInteger)sortIndex;

- (void)configCellWithModelArray:(NSMutableArray *)modelArray;

@end
