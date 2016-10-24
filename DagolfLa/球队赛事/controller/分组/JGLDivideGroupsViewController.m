//
//  JGLDivideGroupsViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLDivideGroupsViewController.h"
#import "JGLGroupClubTitleTableViewCell.h"
#import "JGLGroupPeoTableViewCell.h"
#import "JGLGroupPeopleDetileTableViewCell.h"

#import "JGLGroupRoundModel.h"
#import "JGLGroupCombatModel.h"
#import "JGLGroupSignUpMemberModel.h"
#import "JGLGroupSignUpMenViewController.h"
@interface JGLDivideGroupsViewController ()<UITableViewDelegate,UITableViewDataSource, JGLGroupPeopleDetileTableViewCellDelegate>
{
    UITableView* _tableView;
    BOOL _isSegLeft[10000],_isSegRight[10000], _isClick[10000];//判断segment是否选中
    
    NSMutableArray* _dataArray;//最外层总数据
    NSMutableArray* _dataListArray;//最外层轮次请求数据
    NSMutableArray* _dataModeArray;//中层对抗请求数据
    NSMutableArray* _dataSignUpArray1;//内层成员数据
    NSMutableArray* _dataSignUpArray2;//内层成员数据
    int _page;
}
@end

@implementation JGLDivideGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组";
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _dataListArray = [[NSMutableArray alloc]init];
    _dataModeArray = [[NSMutableArray alloc]init];
    _dataSignUpArray1 = [[NSMutableArray alloc]init];
    _dataSignUpArray2 = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    [self uiConfig];
}
-(void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //    _tableView.bounces = NO;
    //    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[JGLGroupPeopleDetileTableViewCell class] forCellReuseIdentifier:@"JGLGroupPeopleDetileTableViewCell"];
    [_tableView registerClass:[JGLGroupPeoTableViewCell class] forCellReuseIdentifier:@"JGLGroupPeoTableViewCell"];
    _tableView.tag = 100;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@122 forKey:@"matchKey"];
    NSString *strMD = [JGReturnMD5Str getTeamCompeteSignUpListWithMatchKey:122 userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getMatchGroupList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
                indexTag = 0;
            }
            
            if ([data objectForKey:@"list"]) {
                _dataArray = [[data objectForKey:@"list"] mutableCopy];
            }
            NSMutableArray * arrData1 = [[NSMutableArray alloc]init];
            NSMutableArray * arrData2 = [[NSMutableArray alloc]init];
            if (_dataArray.count != 0) {
                for (int i = 0; i < _dataArray.count; i++) {
                    NSMutableArray * arr = [[NSMutableArray alloc]init];
                    for (NSDictionary* dict in [_dataArray[i] objectForKey:@"combatList"]) {
                        JGLGroupCombatModel *model = [[JGLGroupCombatModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [arr addObject:model];
                    }
                    [_dataModeArray addObject:arr];
                    for (int j = 0; j < [_dataModeArray[i] count]; j++) {
                        NSMutableArray * arr1 = [[NSMutableArray alloc]init];
                        for (NSDictionary* dict in [_dataModeArray[i][j] signUpList1]) {
                            JGLGroupCombatModel *model = [[JGLGroupCombatModel alloc] init];
                            [model setValuesForKeysWithDictionary:dict];
                            [arr1 addObject:model];
                        }
                        [arrData1 addObject:arr1];
                    }
                    [_dataSignUpArray1 addObject:arrData1];
                    for (int j = 0; j < [_dataModeArray[i] count]; j++) {
                        NSMutableArray * arr2 = [[NSMutableArray alloc]init];
                        for (NSDictionary* dict in [_dataModeArray[i][j] signUpList2]) {
                            JGLGroupCombatModel *model = [[JGLGroupCombatModel alloc] init];
                            [model setValuesForKeysWithDictionary:dict];
                            [arr2 addObject:model];
                        }
                        [arrData2 addObject:arr2];
                    }
                    [_dataSignUpArray2 addObject:arrData2];
                }
            }
            
            _page++;
            [_tableView reloadData];
        }else {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 100) {
        return _dataArray.count;
    }
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (tableView.tag == 100) {
        UIView* viewHead = [[UIView alloc]init];
        viewHead.frame = CGRectMake(0, 0, screenWidth, 85*ProportionAdapter);
        viewHead.backgroundColor = [UIColor whiteColor];
        UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*ProportionAdapter, screenWidth, 20*ProportionAdapter)];
        labelTitle.font = [UIFont systemFontOfSize:16*ProportionAdapter];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.textColor = [UITool colorWithHexString:@"313131" alpha:1];
        if (_dataArray.count != 0) {
            if ([_dataArray[section] objectForKey:@"round"] != nil && ![Helper isBlankString:[_dataArray[section] objectForKey:@"matchformatName"]]) {
                NSString* str = [NSString stringWithFormat:@"第%@轮",[Helper numTranslation:[NSString stringWithFormat:@"%@",[_dataArray[section] objectForKey:@"round"]]]];
                labelTitle.text = [NSString stringWithFormat:@"%@  %@",str, [_dataArray[section] objectForKey:@"matchformatName"]];
            }
            else{
                labelTitle.text = @"暂无轮次或赛制名称";
            }
        }
        else{
            labelTitle.text = @"暂无轮次或赛制名称";
        }
        
        [viewHead addSubview:labelTitle];
        
        UILabel* labelDetile = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 55*ProportionAdapter, 100*ProportionAdapter, 20*ProportionAdapter)];
        labelDetile.text = @"分组详情";
        labelDetile.textColor = [UITool colorWithHexString:@"313131" alpha:1];
        [viewHead addSubview:labelDetile];
        
        UIButton* btnSetLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSetLeft.frame = CGRectMake(screenWidth-140*ProportionAdapter, 50*ProportionAdapter, 65*ProportionAdapter, 27*ProportionAdapter);
        btnSetLeft.tag = 10000 + section;
        if (_isClick[section] == NO) {
            [btnSetLeft setImage:[UIImage imageNamed:@"segunselectleft"] forState:UIControlStateNormal];
        }
        else{
            if (_isSegLeft[section] == YES) {
                [btnSetLeft setImage:[UIImage imageNamed:@"segselectleft"] forState:UIControlStateNormal];
            }
            else{
                [btnSetLeft setImage:[UIImage imageNamed:@"segdefaultleft"] forState:UIControlStateNormal];
            }
        }
        [viewHead addSubview:btnSetLeft];
        
        UIButton* btnSegRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSegRight.frame = CGRectMake(screenWidth-75*ProportionAdapter, 50*ProportionAdapter, 65*ProportionAdapter, 27*ProportionAdapter);
        if (_isClick[section] == NO) {
            [btnSegRight setImage:[UIImage imageNamed:@"segunselectright"] forState:UIControlStateNormal];
        }
        else{
            if (_isSegRight[section] == YES) {
                [btnSegRight setImage:[UIImage imageNamed:@"segselectright"] forState:UIControlStateNormal];
            }
            else{
                [btnSegRight setImage:[UIImage imageNamed:@"segdefaultright"] forState:UIControlStateNormal];
            }
        }
        btnSegRight.tag = 100000 + section;
        [viewHead addSubview:btnSegRight];
        [btnSegRight addTarget:self action:@selector(chooseSortRightClick:) forControlEvents:UIControlEventAllEvents];
        [btnSetLeft addTarget:self action:@selector(chooseSortLeftClick:) forControlEvents:UIControlEventAllEvents];
        
        
        return viewHead;
}
-(void)chooseSortLeftClick:(UIButton *)btn
{
    //根据button 获取区号    左边tag - 10000
    NSInteger section = btn.tag;
    UIButton* btnr = (UIButton *)[self.view viewWithTag:section - 10000 + 100000];
    [btn setImage:[UIImage imageNamed:@"segselectleft"] forState:UIControlStateNormal];
    [btnr setImage:[UIImage imageNamed:@"segdefaultright"] forState:UIControlStateNormal];
    if (_isSegLeft[section - 10000] == NO) {
        _isSegLeft[section - 10000] = !_isSegLeft[section - 10000];
    }
    if (_isSegRight[section - 10000] == YES) {
        _isSegRight[section - 10000] = !_isSegRight[section - 10000];
    }
    if (_isClick[section - 10000] == NO) {
        _isClick[section - 10000] = YES;
    }
    
    btn.userInteractionEnabled = NO;
    btnr.userInteractionEnabled = NO;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[_dataArray[section - 10000] objectForKey:@"timeKey"] forKey:@"roundKey"];
    [dict setObject:@1 forKey:@"grouptype"];//随机分组
    NSString* strMd = [JGReturnMD5Str getTeamCompeteSignUpListWithuserKey:[DEFAULF_USERID integerValue] roundKey:[[_dataArray[section - 10000] objectForKey:@"timeKey"] integerValue]];
    [dict setObject:strMd forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getAutomaticGroupList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
        btnr.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        btn.userInteractionEnabled = YES;
        btnr.userInteractionEnabled = YES;
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            NSMutableDictionary* dictD = [[NSMutableDictionary alloc]init];
            dictD = [_dataArray[section - 10000] mutableCopy];
            [dictD setObject:[data objectForKey:@"list"] forKey:@"combatList"];
            [dictD setObject:@1 forKey:@"groupType"];
            [_dataArray replaceObjectAtIndex:section-10000 withObject:dictD];
            
            NSMutableArray* arr = [[NSMutableArray alloc]init];
            for (NSDictionary* dict in [data objectForKey:@"list"]) {
                JGLGroupCombatModel *model = [[JGLGroupCombatModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [arr addObject:model];
            }
            [_dataModeArray replaceObjectAtIndex:section - 10000 withObject:arr];
            [_tableView reloadData];
        }
        else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
    
}
-(void)chooseSortRightClick:(UIButton *)btn
{
    NSInteger section = btn.tag;// 右边tag - 100000
    UIButton* btnl = (UIButton *)[self.view viewWithTag:section - 100000 + 10000];
    [btnl setImage:[UIImage imageNamed:@"segdefaultleft"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"segselectright"] forState:UIControlStateNormal];
    _isSegRight[section - 100000] = !_isSegRight[section - 100000];
    if (_isSegLeft[section - 100000] == YES) {
        _isSegLeft[section - 100000] = !_isSegLeft[section - 100000];
    }
    if (_isSegRight[section - 100000] == NO) {
        _isSegRight[section - 100000] = !_isSegRight[section - 100000];
    }
    if (_isClick[section] == NO) {
        _isClick[section] = YES;
    }
    
    btn.userInteractionEnabled = NO;
    btnl.userInteractionEnabled = NO;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
//    [dict setObject:@122 forKey:@"matchKey"];
    [dict setObject:[_dataArray[section - 100000] objectForKey:@"timeKey"] forKey:@"roundKey"];
    [dict setObject:@2 forKey:@"grouptype"];//随机分组
    NSString* strMd = [JGReturnMD5Str getTeamCompeteSignUpListWithuserKey:[DEFAULF_USERID integerValue] roundKey:[[_dataArray[section - 100000] objectForKey:@"timeKey"] integerValue]];
    [dict setObject:strMd forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getAutomaticGroupList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
        btnl.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        btn.userInteractionEnabled = YES;
        btnl.userInteractionEnabled = YES;
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            NSMutableDictionary* dictD = [[NSMutableDictionary alloc]init];
            dictD = [_dataArray[section - 100000] mutableCopy];
            [dictD setObject:[data objectForKey:@"list"] forKey:@"combatList"];
            [dictD setObject:@2 forKey:@"groupType"];
            [_dataArray replaceObjectAtIndex:section-100000 withObject:dictD];
            
            
            
            NSMutableArray* arr = [[NSMutableArray alloc]init];
            for (NSDictionary* dict in [data objectForKey:@"list"]) {
                JGLGroupCombatModel *model = [[JGLGroupCombatModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [arr addObject:model];
            }
            [_dataModeArray replaceObjectAtIndex:section - 100000 withObject:arr];
            [_tableView reloadData];

        }
        else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
    
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView.tag == 100) {
        return 1;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag == 100) {
        return [[_dataArray[indexPath.section] objectForKey:@"sumGroup"] integerValue] * 70*ProportionAdapter + [_dataModeArray[indexPath.section] count] * 104*ProportionAdapter;
//    }
//    else
//        return 104*ProportionAdapter;
}

//显示行
static int indexTag = 0;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexTag < _dataArray.count) {
//        indexTag ++;
//    }
    

    JGLGroupPeopleDetileTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JGLGroupPeopleDetileTableViewCell"];
    cell.delegate = self;

    [cell tableViewReFresh:_dataModeArray[indexPath.section] withArrAll:_dataArray];
    cell.tableView.frame=CGRectMake(0, 0, screenWidth, [[_dataArray[indexPath.section] objectForKey:@"sumGroup"] integerValue] * 70*ProportionAdapter + [_dataModeArray[indexPath.section] count] * 104*ProportionAdapter);
    cell.tableView.tag = 1000 + indexPath.section;
    NSLog(@"----------------%td",cell.tableView.tag);
    [cell.tableView reloadData];
    return cell;
}

//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (tableView.tag == 100) {
        return 85*ProportionAdapter;
//    }
//    else{
//        return 70*ProportionAdapter;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark --push界面的代理方法
- (void)pushController:(NSNumber *)teamKey withUserKey:(NSNumber *)userKey{
    JGLGroupSignUpMenViewController* vc = [[JGLGroupSignUpMenViewController alloc]init];
    vc.teamKey = teamKey;
    vc.userKey = userKey;
    vc.dataArrayAll = [_dataArray mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
