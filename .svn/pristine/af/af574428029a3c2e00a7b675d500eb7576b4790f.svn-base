//
//  ComDetailViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/7/24.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"


#import "CommunityModel.h"
#import "UserAssistModel.h"
@interface ComDetailViewController : ViewController

@property (copy, nonatomic) NSNumber* mId;

@property (strong, nonatomic) CommunityModel* model;

@property (strong, nonatomic) NSMutableArray* dataArray;

@property (strong, nonatomic) NSMutableArray* firstDataArray;
@property (assign, nonatomic) NSInteger firstIndexPath;
@property (strong, nonatomic) NSMutableArray * mutableArr;

@property (strong, nonatomic) NSMutableArray *picsArr;
@property (strong, nonatomic) UITextView *commentTextView;//输入框

@property (assign, nonatomic) NSInteger moveHight;
//键盘视图
@property (strong, nonnull) UIView* commentView;


@property (copy, nonatomic) void(^blockGuanzhu)();
@property (copy, nonatomic) void(^blockDianzan)();
@property (copy, nonatomic) void(^blockPinglun)();

typedef void(^BlockGuanzhuRereshingk)();
@property(nonatomic,copy)BlockGuanzhuRereshingk blockGuanzhuRereshing;





- (void)showKey:(NSNotification*)info;
@end
