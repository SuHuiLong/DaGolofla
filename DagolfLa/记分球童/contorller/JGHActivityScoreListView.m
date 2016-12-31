//
//  JGHActivityScoreListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//
//  ------活动列表-----

#import "JGHActivityScoreListView.h"
#import "JGLChooseScoreModel.h"
#import "JGHActicityScoreDictCell.h"

@interface JGHActivityScoreListView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *dataArray;

@property (nonatomic, strong)UITableView *activityListTableView;

@property (nonatomic, retain)UIView *whiteBG;

@property (nonatomic, retain)UIButton *deleteBtn;

@end

@implementation JGHActivityScoreListView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0];
        
        _dataArray = [NSMutableArray array];
        
        self.whiteBG = [[UIView alloc]initWithFrame:CGRectMake(12 *ProportionAdapter, screenHeight -64, screenWidth - 24 *ProportionAdapter, 300 *ProportionAdapter)];
        self.whiteBG.backgroundColor = [UIColor whiteColor];
        self.whiteBG.layer.masksToBounds = YES;
        self.whiteBG.layer.cornerRadius = 8*ProportionAdapter;
        [self addSubview:self.whiteBG];
        
        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth -32*ProportionAdapter)/2, screenHeight -64 +400 *ProportionAdapter +20 *ProportionAdapter, 32*ProportionAdapter, 32*ProportionAdapter)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"close_activityList"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        
        self.activityListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35 *ProportionAdapter, self.whiteBG.frame.size.width, self.whiteBG.frame.size.height -65 *ProportionAdapter) style:UITableViewStylePlain];
        self.activityListTableView.delegate = self;
        self.activityListTableView.dataSource = self;
        self.activityListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.activityListTableView registerClass:[JGHActicityScoreDictCell class] forCellReuseIdentifier:@"JGHActicityScoreDictCell"];
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.activityListTableView.frame.size.width, 55 *ProportionAdapter)];
        UILabel *headerLable = [[UILabel alloc]initWithFrame:CGRectMake(12*ProportionAdapter, 0, self.activityListTableView.frame.size.width -24*ProportionAdapter, 42 *ProportionAdapter)];
        headerLable.textColor = [UIColor colorWithHexString:B31_Color];
        headerLable.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        headerLable.text = @"您近三天有如下高球活动正在进行，点选即可记分。";
        headerLable.numberOfLines = 2;
        [headerView addSubview:headerLable];
        
        self.activityListTableView.tableHeaderView = headerView;
        [self.whiteBG addSubview:self.activityListTableView];
        
//        [self loadActivityListData];
    }
    return self;
}
#pragma mark -- 删除试图
- (void)deleteBtn:(UIButton *)deleteBtn{
    [self removeFromSuperview];
}
- (void)loadActivityListData:(NSString *)userKey{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:userKey forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", userKey]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getUserLatelyActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            //清除数组数据
            [_dataArray removeAllObjects];
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                for (NSDictionary *dataDic in [data objectForKey:@"activityList"]) {
                    JGLChooseScoreModel *model = [[JGLChooseScoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDic];
                    [_dataArray addObject:model];
                }
                
                float activityListH = 0.0;
                if (_dataArray.count == 1) {
                    activityListH = 210 *ProportionAdapter;
                }else {
                    activityListH = 300 *ProportionAdapter;
                }
                
                //动画
                [UIView animateWithDuration:0.5f animations:^{
                    
                    self.whiteBG.frame = CGRectMake(self.whiteBG.frame.origin.x, self.whiteBG.frame.origin.y, screenWidth - 24 *ProportionAdapter, activityListH);
                    
                    self.deleteBtn.frame = CGRectMake(self.deleteBtn.frame.origin.x, self.deleteBtn.frame.origin.y, 32*ProportionAdapter, 32*ProportionAdapter);
                }];
                
                [self.activityListTableView reloadData];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
                }
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHActicityScoreDictCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGHActicityScoreDictCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configJGLChooseScoreModel:_dataArray[indexPath.section]];
    
    NSLog(@"indexPath.row ==%td", indexPath.row);
    NSLog(@"indexPath.row1 == %td", _dataArray.count -1);
    if (indexPath.section == _dataArray.count -1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 *ProportionAdapter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _blockChangeActivityStartScore(_dataArray[indexPath.section]);
    [self removeFromSuperview];
}

- (void)loadAnimate{
    //判断UI
    float activityListH = 0.0;
    if (_dataArray.count == 1) {
        activityListH = 210 *ProportionAdapter;
    }else {
        activityListH = 300 *ProportionAdapter;
    }
    
    //动画
    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        self.whiteBG.frame = CGRectMake(12 *ProportionAdapter, 100 *ProportionAdapter, screenWidth - 24 *ProportionAdapter, activityListH);
        
        self.deleteBtn.frame = CGRectMake((screenWidth -32*ProportionAdapter)/2, activityListH + 100 *ProportionAdapter +20 *ProportionAdapter, 32*ProportionAdapter, 32*ProportionAdapter);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
