//
//  JGHTimeListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTimeListView.h"
#import "JGHTimeViewListCell.h"

static NSString *const JGHTimeViewListCellIdentifier = @"JGHTimeViewListCell";

@interface JGHTimeListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)UITableView *timeListTableView;

@property (nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation JGHTimeListView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40 *ProportionAdapter)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#eff5f0"];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.5, screenWidth, 39*ProportionAdapter)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"请选择Teetime";
        lable.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        lable.backgroundColor = [UIColor colorWithHexString:@"#eff5f0"];
        [headerView addSubview:lable];
        
        UILabel *oneline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
        oneline.backgroundColor = [UIColor colorWithHexString:BG_color];
        [headerView addSubview:oneline];
        
        UILabel *twoline = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5 *ProportionAdapter, screenWidth, 0.5)];
        twoline.backgroundColor = [UIColor colorWithHexString:BG_color];
        [headerView addSubview:twoline];
        [self addSubview:headerView];
        
        self.timeListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 *ProportionAdapter, screenWidth, frame.size.height -40*ProportionAdapter) style:UITableViewStylePlain];
        self.timeListTableView.delegate = self;
        self.timeListTableView.dataSource = self;
        self.timeListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.timeListTableView registerClass:[JGHTimeViewListCell class] forCellReuseIdentifier:JGHTimeViewListCellIdentifier];
        
        [self addSubview:self.timeListTableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHTimeViewListCell *timeViewListCell = [tableView dequeueReusableCellWithIdentifier:JGHTimeViewListCellIdentifier];
    [timeViewListCell configJGHTimeViewListCell:_dataArray[indexPath.row]];
    timeViewListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == _dataArray.count -1) {
        timeViewListCell.line.hidden = YES;
    }else{
        timeViewListCell.line.hidden = NO;
    }
    
    return timeViewListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    if ([dict objectForKey:@"money"]) {
        _blockSelectTimeAndPrice([NSString stringWithFormat:@"%@", [dict objectForKey:@"halfHour"]], [NSString stringWithFormat:@"%@", [dict objectForKey:@"money"]]);
    }else{
        [LQProgressHud showMessage:@"暂无价格，无法预定！"];
    }
}

- (void)loadTimeListWithBallKey:(NSNumber *)ballKey andDateString:(NSString *)dateString{
    [LQProgressHud showLoading:@"加载中..."];
    self.dataArray = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:ballKey forKey:@"ballKey"];
    [dict setObject:dateString forKey:@"date"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%@dagolfla.com", ballKey]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getBallHalfHourPrice" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [LQProgressHud hide];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _dataArray = [data objectForKey:@"priceList"];
            
            [self.timeListTableView reloadData];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
        }
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
