//
//  JGCostSetViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGCostSetViewControllerDelegate <NSObject>

//- (void)inputMembersCost:(NSString *)membersCost guestCost:(NSString *)guestCost andRegisteredPrice:(NSString *)registeredPrice andBearerPrice:(NSString *)bearerPrice;

- (void)costList:(NSMutableArray *)costArray;

@end

@interface JGCostSetViewController : ViewController


@property (weak, nonatomic) IBOutlet UITableView *costTableView;

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

@property (nonatomic, assign)NSInteger activityKey;


@property (weak, nonatomic)id <JGCostSetViewControllerDelegate> delegate;



@end
