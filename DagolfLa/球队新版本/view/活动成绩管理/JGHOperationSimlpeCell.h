//
//  JGHOperationSimlpeCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHOperationSimlpeCellDelegate <NSObject>

- (void)addRodBtn;

- (void)redRodBtn;

@end

@interface JGHOperationSimlpeCell : UITableViewCell

@property (nonatomic, weak)id <JGHOperationSimlpeCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTop;//5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgRight;

@property (weak, nonatomic) IBOutlet UILabel *onlyScoreTotal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlyScoreTotalTop;//65

@property (weak, nonatomic) IBOutlet UILabel *rodLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodLabelLeft;

@property (weak, nonatomic) IBOutlet UILabel *rodVlaue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodVlaueTop;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnRight;//35
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
- (IBAction)redBtnClick:(UIButton *)sender;


- (void)configPoles:(NSInteger)poles;

@end
