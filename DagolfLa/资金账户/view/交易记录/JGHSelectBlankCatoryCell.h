//
//  JGHSelectBlankCatoryCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLBankModel;

@interface JGHSelectBlankCatoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *blankImageView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

- (void)configJGLBankModel:(JGLBankModel *)model andSelectBlank:(NSInteger)selectBlank andCurrentSelect:(NSInteger)currentSelect;

- (void)configAddBlankCatory;

@end
