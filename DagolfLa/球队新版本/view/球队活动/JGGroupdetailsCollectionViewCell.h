//
//  JGGroupdetailsCollectionViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGGroupdetailsCollectionViewCellDelegate <NSObject>

- (void)didSelectHeaderImage:(UIButton *)btn;

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


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sction1Left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section1Right;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section2Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section2Right;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section3Left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section3Right;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section4Left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *section4Right;


@property (weak, nonatomic) IBOutlet UILabel *lable1;

@property (weak, nonatomic) IBOutlet UILabel *lable2;

@property (weak, nonatomic) IBOutlet UILabel *lable3;

@property (weak, nonatomic) IBOutlet UILabel *lable4;


@end
