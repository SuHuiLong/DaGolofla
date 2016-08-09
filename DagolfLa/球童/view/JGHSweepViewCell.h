//
//  JGHSweepViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHSweepViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerLableTop;//10

@property (weak, nonatomic) IBOutlet UILabel *dividerLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerLableDown;//10

@property (weak, nonatomic) IBOutlet UILabel *cabbieScore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cabbieScoreDown;//25

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mtQrcodeDown;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cabbieImageDown;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myQrCodeLableDown;//25
@property (weak, nonatomic) IBOutlet UILabel *myQrCodeLable;

@property (weak, nonatomic) IBOutlet UIButton *cabbieBtn;
- (IBAction)cabbieBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *myQrBtn;
- (IBAction)myQrBtn:(UIButton *)sender;


@end
