//
//  JGHWithdrawCatoryCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHWithdrawCatoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titles;

@property (weak, nonatomic) IBOutlet UIImageView *blankImageView;

@property (weak, nonatomic) IBOutlet UILabel *values;

- (void)configModelTitles:(NSString *)titles andBlankImage:(NSString *)blankImage andBlankName:(NSString *)blankName;

@end
