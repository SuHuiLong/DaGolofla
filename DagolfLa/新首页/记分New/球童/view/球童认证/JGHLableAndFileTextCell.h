//
//  JGHLableAndFileTextCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHLableAndFileTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//20

@property (weak, nonatomic) IBOutlet UITextField *fielText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fielTextLeft;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableW;


- (void)configCabbieName;

- (void)configCabbieNumber;

- (void)configCabbieLenghtService;


- (void)configCabbieTitleString:(NSString *)string andVlaueString:(NSString *)valueString;

@end
