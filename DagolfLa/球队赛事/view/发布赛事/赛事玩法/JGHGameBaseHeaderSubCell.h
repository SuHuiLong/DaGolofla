//
//  JGHGameBaseHeaderSubCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHGameBaseHeaderSubCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//40

@property (weak, nonatomic) IBOutlet UIImageView *slectImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slectImageViewRight;//25

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slectImageViewW;//10
@property (weak, nonatomic) IBOutlet UITextField *toptextfeil;
@property (weak, nonatomic) IBOutlet UILabel *namelable2;



- (void)configJGHGameBaseHeaderSubCell:(NSString *)rulesName andSelect:(NSInteger)select andTopvalue:(NSString *)topvalue;

@end
