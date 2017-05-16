//
//  JGHAddCostButtonCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAddCostButtonCellDelegate <NSObject>

- (void)addCostList:(UIButton *)btn;

@end

@interface JGHAddCostButtonCell : UITableViewCell

@property (weak, nonatomic)id <JGHAddCostButtonCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addCostBtn;

- (IBAction)addCostBtn:(UIButton *)sender;

@end
