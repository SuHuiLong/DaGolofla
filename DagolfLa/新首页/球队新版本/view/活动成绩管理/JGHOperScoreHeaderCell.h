//
//  JGHOperScoreHeaderCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHOperScoreHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *oneAreaLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneAreaLableLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneAreaLableRight;//35

@property (weak, nonatomic) IBOutlet UILabel *twoAreaLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoAreaLableRight;


- (void)configJGHOperScoreHeaderCell:(NSString *)region1 andregion2:(NSString *)region2;

@end
