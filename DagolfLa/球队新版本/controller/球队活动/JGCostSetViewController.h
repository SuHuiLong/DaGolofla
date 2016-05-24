//
//  JGCostSetViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGCostSetViewControllerDelegate <NSObject>

- (void)inputMembersCost:(NSString *)membersCost guestCost:(NSString *)guestCost;

@end

@interface JGCostSetViewController : ViewController

//球队队员费用
@property (weak, nonatomic) IBOutlet UITextField *membersCost;

//嘉宾费用
@property (weak, nonatomic) IBOutlet UITextField *guestCost;

@property (weak, nonatomic)id <JGCostSetViewControllerDelegate> delegate;

@end
