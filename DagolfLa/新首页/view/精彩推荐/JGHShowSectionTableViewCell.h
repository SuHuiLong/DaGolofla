//
//  JGHShowSectionTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHShowSectionTableViewCellDelegate <NSObject>

- (void)didSelectMoreBtn:(UIButton *)moreBtn;

@end

@interface JGHShowSectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bgLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLableLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLableH;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//10

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
- (IBAction)moreBtn:(UIButton *)sender;

- (IBAction)moreClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreClickW;


@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (weak, nonatomic)id <JGHShowSectionTableViewCellDelegate> delegate;

- (void)congfigJGHShowSectionTableViewCell:(NSString *)name andHiden:(NSInteger)hiden;

@end
