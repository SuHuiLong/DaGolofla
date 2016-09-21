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
#import "JGTeamMemberManager.h"

@interface JGHTeamMembersViewController ()<UITableViewDelegate, UITableViewDataSource, JGMenberPhoneCellDelegate>
{
    UITableView* _tableView;
    NSMutableArray *_listArray;
    NSMutableArray *_keyArray;
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
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"成员列表";
    
    [self uiConfig];
    
//    if (self.isload == 1) {
//        [self loadData];
//    }else{
        _listArray = [[NSMutableArray alloc]initWithArray:[JGTeamMemberManager activityArchiveNumbers:_teamGroupAllDataArray]];
        
        _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
        
        for (int i = (int)_listArray.count-1; i>=0; i--) {
            if ([_listArray[i] count] == 0) {
                [_listArray removeObjectAtIndex:i];
            }
        }
//    }
}
//- (void)loadData{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:[NSString stringWithFormat:@"%ld", (long)_activityKey] forKey:@"activityKey"];
//    [dict setObject:@0 forKey:@"teamKey"];
//    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
//    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:_activityKey userKey:[DEFAULF_USERID integerValue]];
//    [dict setObject:strMD forKey:@"md5"];
//    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
//        NSLog(@"%@", errType);
//    } completionBlock:^(id data) {
//        NSLog(@"data==%@", data);
//        if ([data count]>2) {
//            NSArray *dataArray = [data objectForKey:@"teamSignUpList"];
//            for (NSDictionary *dict in dataArray) {
//                JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.teamGroupAllDataArray addObject:model];
//            }
//            
//            _listArray = [[NSMutableArray alloc]initWithArray:[JGTeamMemberManager activityArchiveNumbers:_teamGroupAllDataArray]];
//            
//            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
//            
//            for (int i = (int)_listArray.count-1; i>=0; i--) {
//                if ([_listArray[i] count] == 0) {
//                    [_listArray removeObjectAtIndex:i];
//                }
//            }
//        }
//        
//        [_tableView reloadData];
//    }];
//}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGMenberTableViewCell class] forCellReuseIdentifier:@"JGMenberTableViewCell"];
}

//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray[section] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_listArray[section] count] == 0) {
        return nil;
    }else{
        return _keyArray[section];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGMenberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMenberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
//    model = _teamGroupAllDataArray[indexPath.row];
    model = _listArray[indexPath.section][indexPath.row];
    [cell configJGHPlayersModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
    model = _listArray[indexPath.section][indexPath.row];
    [dict setObject:[NSString stringWithFormat:@"%td", _oldSignUpKey] forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
    [dict setObject:[NSString stringWithFormat:@"%td", model.timeKey] forKey:@"newSignUpKey"]; // 新的球队活动报名人timeKey
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.groupIndex] forKey:@"groupIndex"]; // 组号
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.sortIndex] forKey:@"sortIndex"]; // 排序索引
    if (self.delegate) {
        [self.delegate didSelectMembers:dict];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
    NSInteger number = [_listArray count];
    return [_keyArray subarrayWithRange:NSMakeRange(0, number)];
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if (![_listArray[index] count]) {
        
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        return index;
    }
}
#pragma mark -- 打电话代理
- (void)makePhoneClick:(NSString *)phone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
