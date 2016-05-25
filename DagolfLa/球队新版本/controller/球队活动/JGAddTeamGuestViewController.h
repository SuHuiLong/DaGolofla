//
//  JGAddTeamGuestViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGAddTeamGuestViewControllerDelegate <NSObject>

- (void)addGuestListArray:(NSArray *)guestListArray;

@end

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
//手机号
@property (weak, nonatomic) IBOutlet UITextField *photoNumber;
//是否为球队队员
@property (weak, nonatomic) IBOutlet UIButton *isPlayersBtn;
- (IBAction)isPlayersBtn:(UIButton *)sender;

//添加嘉宾
@property (nonatomic, strong)NSMutableArray *applyArray;

@property (nonatomic, copy)NSString *teamKey;//球队key
@property (nonatomic, copy)NSString *activityKey;//活动ID

@property (weak, nonatomic)id <JGAddTeamGuestViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *guestArray;//成员数组集合

@end
