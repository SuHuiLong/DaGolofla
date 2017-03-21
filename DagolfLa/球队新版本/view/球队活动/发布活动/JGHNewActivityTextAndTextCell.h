//
//  JGHNewActivityTextAndTextCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHNewActivityTextAndTextCell : UITableViewCell

@property (nonatomic, strong)UITextField *nameText;

@property (nonatomic, strong)UILabel *hvrLine;

@property (nonatomic, strong)UITextField *mobileText;

- (void)configJGHNewActivityTextAndTextCellName:(NSString *)name andMobile:(NSString *)mobile;

@end
