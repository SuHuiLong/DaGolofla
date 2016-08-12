//
//  JGHLableAndLableCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHLableAndLableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//20

@property (weak, nonatomic) IBOutlet UILabel *valueLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLableLeft;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableW;


- (void)configBallName:(NSString *)ballName;


@end
