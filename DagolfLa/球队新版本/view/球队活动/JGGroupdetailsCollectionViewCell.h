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

//长按手势
- (void)handleLongPressWithBtnTag:(NSInteger)tag JGGroupCell:(JGGroupdetailsCollectionViewCell *)cell;

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

- (void)configGroupName:(NSString *)groupname;

- (void)configCellWithModelArray:(NSMutableArray *)modelArray;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostTop1;//25

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewTop1;//-25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewLeft1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewW1;//60

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostTop2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewTop2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewLeft2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewW2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostTop3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostLeft3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostRight3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewTop3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewLeft3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewW3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostTop4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostLeft4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostRight4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewTop4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewLeft4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewW4;


@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (weak, nonatomic) IBOutlet UILabel *leftTopValue;
@property (weak, nonatomic) IBOutlet UILabel *leftTopAlmost;

@property (weak, nonatomic) IBOutlet UIView *RightTopView;
@property (weak, nonatomic) IBOutlet UILabel *rightTopValue;
@property (weak, nonatomic) IBOutlet UILabel *rightTopAlmost;

@property (weak, nonatomic) IBOutlet UIView *leftDownView;
@property (weak, nonatomic) IBOutlet UILabel *leftDownValue;
@property (weak, nonatomic) IBOutlet UILabel *leftDownAlmost;

@property (weak, nonatomic) IBOutlet UIView *rightDownView;
@property (weak, nonatomic) IBOutlet UILabel *rightDownVlaue;
@property (weak, nonatomic) IBOutlet UILabel *rightDownAlmost;


@end
