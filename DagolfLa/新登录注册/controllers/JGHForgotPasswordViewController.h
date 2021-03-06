//
//  JGHForgotPasswordViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

//@protocol JGHForgotPasswordViewControllerDelegate <NSObject>
//
//@optional
//
//- (void)fillLoginViewAccount:(NSString *)account andPassword:(NSString *)password andCodeing:(NSString *)codeing;
//
//@end

@interface JGHForgotPasswordViewController : ViewController

//typedef void(^BlackCtrl)();
//@property(nonatomic,copy)BlackCtrl blackCtrl;

//@property (weak, nonatomic)id <JGHForgotPasswordViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewLeft;//8
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewRight;

@property (weak, nonatomic) IBOutlet UIButton *mobileBtn;
- (IBAction)mobileBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobileBtnW;//50
@property (weak, nonatomic) IBOutlet UILabel *mobileLine;

@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobileTextLeft;

@property (weak, nonatomic) IBOutlet UILabel *codeLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeTextLeft;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UILabel *codeTwoLine;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
- (IBAction)getCodeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeBtnW;

@property (weak, nonatomic) IBOutlet UILabel *passwordLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextLeft;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextRight;
@property (weak, nonatomic) IBOutlet UIButton *entryBtn;
- (IBAction)entryBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryBtnRight;//15

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
- (IBAction)resetBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetBtnTop;//50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetBtnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetBtnH;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIView *threeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneviewH;





@end
