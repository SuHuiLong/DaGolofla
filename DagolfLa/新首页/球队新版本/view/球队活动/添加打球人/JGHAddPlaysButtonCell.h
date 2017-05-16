//
//  JGHAddPlaysButtonCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAddPlaysButtonCellDelegate <NSObject>

- (void)addPlaysButtonCellClick:(UIButton *)btn;

@end

@interface JGHAddPlaysButtonCell : UITableViewCell

@property (nonatomic, weak)id <JGHAddPlaysButtonCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addPlaysBtn;

- (IBAction)addPlaysBtn:(UIButton *)sender;


@end
