//
//  JGHWithdrawDetailsCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHWithdrawDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyforTime;

@property (weak, nonatomic) IBOutlet UILabel *dealwithTime;

@property (weak, nonatomic) IBOutlet UILabel *seccessful;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;

@property (weak, nonatomic) IBOutlet UILabel *withdrawful;

@property (weak, nonatomic) IBOutlet UILabel *balnkful;

@property (weak, nonatomic) IBOutlet UILabel *tradSuf;


- (void)configApplyforTime:(NSString *)applyforTime andDealwithTime:(NSString *)dealwithTime andSeccessful:(NSString *)seccessful;

@end
