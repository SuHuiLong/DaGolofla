//
//  JGHCaddieViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHCaddieViewController : ViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;//27
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backLeft;//20


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnLeft;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beetewn;//75

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cabbieBtnRight;//40


@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)playBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *caddieBtn;
- (IBAction)caddieBtn:(UIButton *)sender;


@end
