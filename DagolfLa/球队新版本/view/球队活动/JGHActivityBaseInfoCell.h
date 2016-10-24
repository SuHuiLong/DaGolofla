//
//  JGHActivityBaseInfoCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHActivityBaseInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titles;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;//40

@property (weak, nonatomic) IBOutlet UILabel *value;

- (void)configBaseInfo:(NSString *)string andIndexRow:(NSInteger)index;

- (void)configMatchBaseInfo:(NSString *)string andBaseValue:(NSString *)baseValue andRow:(NSInteger)row;

@end
