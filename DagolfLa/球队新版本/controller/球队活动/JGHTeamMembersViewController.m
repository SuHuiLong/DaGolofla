//
//  JGHTeamMembersViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTeamMembersViewController.h"
#import "JGMenberTableViewCell.h"
#import "JGHPlayersModel.h"

@interface JGHTeamMembersViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tableView;
}
@end

@implementation JGHTeamMembersViewController

- (instancetype)init{
    if (self == [super init]) {
        self.teamGroupAllDataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"成员列表";
    [self uiConfig];
    
    if (self.isload == 1) {
        [self loadData];
    }
}
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)_activityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data==%@", data);
        if ([data count]>2) {
            NSArray *dataArray = [data objectForKey:@"teamSignUpList"];
            for (NSDictionary *dict in dataArray) {
                JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.teamGroupAllDataArray addObject:model];
            }
        }else if ([data count] == 2){
            
        }
        
        [_tableView reloadData];
    }];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGMenberTableViewCell class] forCellReuseIdentifier:@"JGMenberTableViewCell"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _teamGroupAllDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGMenberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMenberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
    model = _teamGroupAllDataArray[indexPath.row];
    [cell configJGHPlayersModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
    model = [self.teamGroupAllDataArray objectAtIndex:indexPath.row];
    [dict setObject:[NSString stringWithFormat:@"%td", _oldSignUpKey] forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
    [dict setObject:[NSString stringWithFormat:@"%td", model.timeKey] forKey:@"newSignUpKey"]; // 新的球队活动报名人timeKey
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.groupIndex] forKey:@"groupIndex"]; // 组号
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.sortIndex] forKey:@"sortIndex"]; // 排序索引
    if (self.delegate) {
        [self.delegate didSelectMembers:dict];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //更新分组updateTeamActivityGroupIndex
//    [self updateTeamActivityGroupIndex];
}

//- (void)updateTeamActivityGroupIndex{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"" forKey:@"oldSignUpKey"];//老的球队活动报名人timeKey
//    [dict setObject:@"" forKey:@"newSignUpKey"];//新的球队活动报名人timeKey
//    [dict setObject:@"" forKey:@"groupIndex"];//组号
//    [dict setObject:@"" forKey:@"sortIndex"];//排序索引
//    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivityGroupIndex" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
//        NSLog(@"errType == %@", errType);
//    } completionBlock:^(id data) {
//        NSLog(@"data == %@", data);
//    }];
//}


@end
