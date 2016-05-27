//
//  JGHHeaderLabelCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHHeaderLabelCell : UITableViewCell

//title
@property (weak, nonatomic) IBOutlet UILabel *titles;
//contcat
@property (weak, nonatomic) IBOutlet UILabel *contact;
@property (weak, nonatomic) IBOutlet UILabel *noteLbael;
//补贴金额
@property (weak, nonatomic) IBOutlet UILabel *subsidies;

@property (weak, nonatomic) IBOutlet UILabel *yuan;

- (void)congiftitles:(NSString *)titles;

- (void)congifContact:(NSString *)contact andNote:(NSString *)note;


- (void)congifCount:(NSInteger)count andSum:(NSInteger)sum;

@end
