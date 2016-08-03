//
//  JGCostSetViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGCostSetViewControllerDelegate <NSObject>

- (void)inputMembersCost:(NSString *)membersCost guestCost:(NSString *)guestCost andRegisteredPrice:(NSString *)registeredPrice andBearerPrice:(NSString *)bearerPrice;

@end

@interface JGCostSetViewController : ViewController

//球队队员费用
@property (weak, nonatomic) IBOutlet UITextField *membersCost;

//嘉宾费用
@property (weak, nonatomic) IBOutlet UITextField *guestCost;

//记名费
@property (weak, nonatomic) IBOutlet UITextField *registeredPrice;

//不记名费
@property (weak, nonatomic) IBOutlet UITextField *bearerPrice;


@property (weak, nonatomic)id <JGCostSetViewControllerDelegate> delegate;

//会员价
@property (strong, nonatomic) NSNumber* memberPrice;
//嘉宾价
@property (strong, nonatomic) NSNumber* guestPrice;
//球队会员记名价
@property (strong, nonatomic) NSNumber* billNamePrice;
//球队会员不记名价
@property (strong, nonatomic) NSNumber* billPrice;


@end
