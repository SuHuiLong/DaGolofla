//
//  JGHButtonCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHButtonCellDelegate <NSObject>

- (void)selectCommitBtnClick:(UIButton *)btn;

@end

@interface JGHButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

- (IBAction)btnClick:(UIButton *)sender;

@property (weak, nonatomic)id <JGHButtonCellDelegate> delegate;

@end
