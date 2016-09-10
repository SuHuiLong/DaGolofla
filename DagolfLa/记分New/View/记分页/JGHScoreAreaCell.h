//
//  JGHScoreAreaCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHScoreAreaCellDelegate <NSObject>

- (void)oneAreaNameBtn:(UIButton *)btn;

@end

@interface JGHScoreAreaCell : UITableViewCell

@property (weak, nonatomic)id <JGHScoreAreaCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *areaNameBtn;
- (IBAction)areaNameBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaNameBtnLeft;//10

@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaImageViewLeft;//13

@property (weak, nonatomic) IBOutlet UILabel *blueLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLableRight;//5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLableW;

@property (weak, nonatomic) IBOutlet UILabel *redParLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redParLabelRight;//18

@property (weak, nonatomic) IBOutlet UILabel *redPar;//10

@property (weak, nonatomic) IBOutlet UILabel *ligParLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ligParLableW;

@property (weak, nonatomic) IBOutlet UILabel *addLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addLableW;//13

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addLableRight;//5

@property (weak, nonatomic) IBOutlet UILabel *addParLable;
@property (weak, nonatomic) IBOutlet UILabel *addaddParLable;

- (void)configArea:(NSString *)areaString andImageDirection:(NSInteger)direction;

@end
