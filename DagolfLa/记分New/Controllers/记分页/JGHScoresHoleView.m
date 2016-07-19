//
//  JGHScoresHoleView.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresHoleView.h"
#import "JGHScoresHoleCell.h"

static NSString *const JGHScoresHoleCellIdentifier = @"JGHScoresHoleCell";

@interface JGHScoresHoleView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;
}

@property (nonatomic, strong)UITableView *scoreTableView;

@end

@implementation JGHScoresHoleView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        _titleArray = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18"]];
        self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 200) style:UITableViewStylePlain];
        self.scoreTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
        self.scoreTableView.delegate = self;
        self.scoreTableView.dataSource = self;
        UINib *scoresPageCellNib = [UINib nibWithNibName:@"JGHScoresHoleCell" bundle: [NSBundle mainBundle]];
        [self.scoreTableView registerNib:scoresPageCellNib forCellReuseIdentifier:JGHScoresHoleCellIdentifier];
        
        self.scoreTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.scoreTableView];
        
//        [self getScoreList];
    }
    return self;
}

#pragma mark -- getScoreList 获取活动计分列表
- (void)getScoreList:(NSString *)scorKey{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:scorKey forKey:@"scoreKey"];
    [dict setObject:[JGReturnMD5Str getScoreListUserKey:[DEFAULF_USERID integerValue] andScoreKey:[scorKey integerValue]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getScoreList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:(UIView *)self];
            }
        }
    }];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30*ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHScoresHoleCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHScoresHoleCellIdentifier];
    scoresPageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [scoresPageCell configAllViewBgColor:@"#FFFFFF"];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [scoresPageCell configArray:_titleArray[indexPath.row ]];
        }
    }else{
        if (indexPath.row == 0) {
            [scoresPageCell configArray:_titleArray[indexPath.section]];
        }
    }
    
    return scoresPageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 37*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*ProportionAdapter, 4*ProportionAdapter, screenWidth -5*ProportionAdapter, view.frame.size.height - 8*ProportionAdapter)];
    titleLabel.text = [NSString stringWithFormat:@"第%@九洞", (section == 0)? @"一":@"二"];
//    titleLabel.backgroundColor = [UIColor redColor];
    [view addSubview:titleLabel];
    return view;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
