//
//  JGHShowFavouritesCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHShowFavouritesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityHeaderImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityHeaderImageViewW;//70
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityHeaderImageViewLeft;//10

@property (weak, nonatomic) IBOutlet UILabel *name;//17
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//20
@property (weak, nonatomic) IBOutlet UILabel *activityNumber;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityNumberLeft;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressImageLeft;//20

@property (weak, nonatomic) IBOutlet UILabel *address;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeft;//10

@property (weak, nonatomic) IBOutlet UILabel *details;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsLeft;//20


- (void)configJGHShowFavouritesCell:(NSDictionary *)dict;

@end
