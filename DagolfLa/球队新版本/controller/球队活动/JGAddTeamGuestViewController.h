//
//  JGAddTeamGuestViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGAddTeamGuestViewController : ViewController
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameText;
//差点
@property (weak, nonatomic) IBOutlet UITextField *poorPointText;
//女
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
//男
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
//已经添加
@property (weak, nonatomic) IBOutlet UILabel *alrealyAddGuestLabel;
@property (assign, nonatomic) BOOL isMen, isWomen;
@end
