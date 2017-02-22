//
//  JGHScoresMainViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//


#import <UIKit/UIKit.h>

//@protocol JGHScoresMainViewControllerdelegate <NSObject>
//
//- (void)leftOrRightswitchScore:(NSInteger)switchMode;
//
//@end

@interface JGHScoresMainViewController : UIViewController

//@property (weak, nonatomic)id <JGHScoresMainViewControllerdelegate> delegate;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy)void (^returnScoresDataArray)(NSMutableArray *dataArray);

@property (nonatomic, copy)void (^selectHoleBtnClick)();


- (void)switchScoreModeNote;//

@property (nonatomic, assign)NSInteger switchMode;// 0- 总；1- 差

@property (nonatomic, strong)NSString *scorekey;

- (void)reloadTableView:(NSInteger)switchMode;

@property (nonatomic, strong)NSMutableArray *currentAreaArray;


@end
