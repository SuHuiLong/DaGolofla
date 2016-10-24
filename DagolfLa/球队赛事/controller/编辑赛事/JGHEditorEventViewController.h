//
//  JGHEditorEventViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGHPublishEventModel;

@interface JGHEditorEventViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, strong)JGHPublishEventModel *model;

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

- (void)configJGHPublishEventModelReloadTable:(JGHPublishEventModel *)model andCostlistArray:(NSMutableArray *)costListArray;
//

@end
