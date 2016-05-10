//
//  MyselfChooseViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/9/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeselfModel.h"

@interface MyselfChooseViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnWomen;

@property (weak, nonatomic) IBOutlet UIButton *btnMen;


@property (assign, nonatomic) BOOL isMen, isWomen;

@property (strong, nonatomic) NSNumber * sexNumber;


@property (copy, nonatomic) void(^blockSexNumber)(NSNumber*);


-(void)showData:(MeselfModel *)model;
-(void)post:(NSDictionary *)dict;

@end
