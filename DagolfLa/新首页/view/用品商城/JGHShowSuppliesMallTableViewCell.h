//
//  JGHShowSuppliesMallTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHShowSuppliesMallTableViewCellDelegate <NSObject>

- (void)suppliesMallSelectClick:(UIButton *)btn;

@end

@interface JGHShowSuppliesMallTableViewCell : UITableViewCell

@property (weak, nonatomic)id <JGHShowSuppliesMallTableViewCellDelegate> delegate;

- (void)configJGHShowSuppliesMallTableViewCell:(NSArray *)array;

@end
