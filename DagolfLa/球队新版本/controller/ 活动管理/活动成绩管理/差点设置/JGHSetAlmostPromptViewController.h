//
//  JGHSetAlmostPromptViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHSetAlmostPromptViewController : ViewController

@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIImageView *imageNoSelect;

@property (weak, nonatomic) IBOutlet UIImageView *imageNoSelectTwo;

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
- (IBAction)oneBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
- (IBAction)twoBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *oneTitle;

@property (weak, nonatomic) IBOutlet UILabel *onedetails;

@property (weak, nonatomic) IBOutlet UILabel *twoTitle;

@property (weak, nonatomic) IBOutlet UILabel *twoDetails;

@property (weak, nonatomic) IBOutlet UILabel *propmtLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLableTop;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLableDown;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLableLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLableRight;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleDwon;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rImageRight;//10


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmtLabelTop;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmtLabelLeftAndRight;//10

@end
