//
//  JGHTwoScoreAreaCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHTwoScoreAreaCellDelegate <NSObject>

- (void)twoAreaNameBtn:(UIButton *)btn;

@end

@interface JGHTwoScoreAreaCell : UITableViewCell

@property (nonatomic, weak)id <JGHTwoScoreAreaCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *areaNameBtn;
- (IBAction)areaNameBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaNameBtnLeft;//10

@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaImageViewLeft;//13

@end
