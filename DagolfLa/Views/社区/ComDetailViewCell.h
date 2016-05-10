//
//  ComDetailViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/9/26.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComDeatailModel.h"
#import "AppraiseModel.h"
#import "ComDeatailModel.h"


@interface ComDetailViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//@property (weak, nonatomic) IBOutlet UILabel *labelName;
//@property (weak, nonatomic) IBOutlet UILabel *labelTime;
//@property (weak, nonatomic) IBOutlet UILabel *labelDetail;

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *labelName;
@property (nonatomic,strong) UILabel *labelTime;
@property (nonatomic,strong) UILabel *labelDetail;
//@property (nonatomic,strong) UILabel *labelFlood;

@property (nonatomic,assign) NSInteger lou;


@property (nonatomic,strong) ComDeatailModel *deatailModel;

-(void)showData:(ComDeatailModel *)model;
-(void)showAppData:(AppraiseModel *)model;
//-(void)showNumber:(NSInteger )index;

@end
