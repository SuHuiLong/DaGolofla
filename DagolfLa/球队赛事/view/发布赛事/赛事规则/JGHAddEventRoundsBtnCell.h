//
//  JGHAddEventRoundsBtnCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAddEventRoundsBtnCellDelegate <NSObject>

- (void)didSelectAddEventRoundsBtn:(UIButton *)btn;

@end


@interface JGHAddEventRoundsBtnCell : UITableViewCell

@property (weak, nonatomic)id <JGHAddEventRoundsBtnCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *ruleaddBtn;

- (IBAction)ruleaddBtn:(UIButton *)sender;



@end
