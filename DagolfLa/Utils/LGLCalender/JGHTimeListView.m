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
{
    BOOL _hasUserCard;
}

@property (nonatomic, retain)UITableView *timeListTableView;

@property (nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation JGHTimeListView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _hasUserCard = NO;
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
    if (_dataArray.count > 0) {
        [timeViewListCell configJGHTimeViewListCell:_dataArray[indexPath.row] andHasUserCard:_hasUserCard];
    }
    
    
    if (indexPath.row == _dataArray.count -1) {
        timeViewListCell.line.hidden = YES;
    }else{
        timeViewListCell.line.hidden = NO;
    }
    
    return timeViewListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    if ([dict objectForKey:@"money"]) {
        NSString *money = [NSString stringWithFormat:@"%@", [dict objectForKey:@"money"]];
        NSString *paymentMoney;
        if ([dict objectForKey:@"paymentMoney"]) {
            paymentMoney = [NSString stringWithFormat:@"%@", [dict objectForKey:@"paymentMoney"]];
        }else{
            paymentMoney = @"";
        }
        
        NSString *deductionMoney;
        if ([dict objectForKey:@"deductionMoney"]) {
            deductionMoney = [NSString stringWithFormat:@"%@", [dict objectForKey:@"deductionMoney"]];
        }else{
            deductionMoney = @"";
        }
        
        NSString *leagueMoney;//球场联盟价格
        if ([dict objectForKey:@"leagueMoney"]) {
            leagueMoney = [NSString stringWithFormat:@"%@", [dict objectForKey:@"leagueMoney"]];
        }else{
            leagueMoney = @"";
        }
        
        _blockSelectTimeAndPrice([NSString stringWithFormat:@"%@", [dict objectForKey:@"halfHour"]], money, paymentMoney, deductionMoney, leagueMoney);
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
    [[JsonHttp jsonHttp]httpRequest:@"bookball/getBallHalfHourPrice" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [LQProgressHud hide];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _dataArray = [data objectForKey:@"priceList"];
            _hasUserCard = ([[data objectForKey:@"hasUserCard"] integerValue] == 1)?YES:NO;
            
            [self.timeListTableView reloadData];
        }
        else
        {
            _hasUserCard = NO;
            
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
