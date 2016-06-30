//
//  JGHWithdrawCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHWithdrawCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titles;


@property (weak, nonatomic) IBOutlet UILabel *values;

- (void)configJGHWithdrawModelTime:(NSString *)time;

- (void)configJGHWithdrawModelSerialNumber:(NSString *)serialNumber;

- (void)configJGHWithdrawModelBlankName:(NSString *)blankName;

- (void)configSetPassword;

- (void)configWithdrawBalance:(float)balance;

@end
