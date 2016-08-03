//
//  JGHSimpleScorePepoleBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHSimpleScorePepoleBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewWith;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewLeft;//10


@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeft;//15

@property (weak, nonatomic) IBOutlet UILabel *almost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostLeft;//10


@end
