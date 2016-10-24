//
//  JGHGameSetBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHGameSetBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rulesName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulesNameLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulesNameW;


@property (weak, nonatomic) IBOutlet UILabel *rulesContext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulesContextLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulesContextRight;

- (void)configJGHGameSetBaseCell:(NSDictionary *)dict;

@end
