//
//  JGHBindingAccountViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHBindingAccountViewController : ViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoViewTop;//10

@property (weak, nonatomic) IBOutlet UIButton *mobileBtn;
- (IBAction)mobileBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *mobileLable;
@property (weak, nonatomic) IBOutlet UITextField *mobiletext;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *codeLine;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UILabel *codeTwoLine;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
- (IBAction)getCodeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *bindingAccount;
- (IBAction)bindingAccount:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindingAccountBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindingAccountBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindingAccountBtnRight;



@end
