//
//  JGHRegistersViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHRegistersViewController : ViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeft;//8
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewRight;//8
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;//50

@property (weak, nonatomic) IBOutlet UIButton *mobileBtn;//17
- (IBAction)mobileBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobileBtnW;//50
@property (weak, nonatomic) IBOutlet UILabel *mobileLine;

@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UILabel *codeOneLine;
@property (weak, nonatomic) IBOutlet UILabel *codeTwoLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeTwoLineH;//25
@property (weak, nonatomic) IBOutlet UILabel *passwordLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoViewTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeViewTop;//10
@property (weak, nonatomic) IBOutlet UIButton *codebtn;
- (IBAction)codebtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
- (IBAction)getCodeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *passwordBtn;
- (IBAction)passwordBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextRight;//15
@property (weak, nonatomic) IBOutlet UIButton *entryBtn;
- (IBAction)entryBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryBtnW;//22
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryBtnRight;//15

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnLeft;//8
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnW;//15

@property (weak, nonatomic) IBOutlet UILabel *registeredLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registeredLableLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registeredLableW;

@property (weak, nonatomic) IBOutlet UIButton *termsBtn;//13
- (IBAction)termsBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
- (IBAction)completeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeBtnTop;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeBtnLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeBtnRight;


@end
