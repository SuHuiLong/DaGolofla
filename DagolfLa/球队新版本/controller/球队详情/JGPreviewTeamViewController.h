//
//  JGPreviewTeamViewController.h
//  DagolfLa
//
//  Created by 東 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamDetail.h"

@interface JGPreviewTeamViewController : ViewController

//@property (nonatomic, strong) JGTeamDetail *detailModel;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, strong) NSMutableDictionary *detailDic;
@property (nonatomic, strong)UIButton *headPortraitBtn;//头像

@end
