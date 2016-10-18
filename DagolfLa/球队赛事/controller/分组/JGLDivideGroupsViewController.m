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

#import "JGLGroupRoundModel.h"
#import "JGLGroupCombatModel.h"
#import "JGLGroupSignUpMemberModel.h"
@interface JGLDivideGroupsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    UILabel* _labelTitle, *_labelDetile;//分区头
    UIButton* _btnSetLeft,* _btnSegRight;//分区头
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
    [_tableView registerClass:[JGLGroupClubTitleTableViewCell class] forCellReuseIdentifier:@"JGLGroupClubTitleTableViewCell"];
    [_tableView registerClass:[JGLGroupPeoTableViewCell class] forCellReuseIdentifier:@"JGLGroupPeoTableViewCell"];
    
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
        }else {
           [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        [_tableView reloadData];
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
    return _dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 85*ProportionAdapter)];
    viewHead.backgroundColor = [UIColor whiteColor];
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*ProportionAdapter, screenWidth, 20*ProportionAdapter)];
    _labelTitle.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    if ([_dataArray[section] objectForKey:@"round"] != nil && ![Helper isBlankString:[_dataArray[section] objectForKey:@"matchformatName"]]) {
        NSString* str = [NSString stringWithFormat:@"第%@轮",[Helper numTranslation:[NSString stringWithFormat:@"%@",[_dataArray[section] objectForKey:@"round"]]]];
        _labelTitle.text = [NSString stringWithFormat:@"%@  %@",str, [_dataArray[section] objectForKey:@"matchformatName"]];
    }
    else{
        _labelTitle.text = @"暂无轮次或赛制名称";
    }
    [viewHead addSubview:_labelTitle];
    
    _labelDetile = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 55*ProportionAdapter, 100*ProportionAdapter, 20*ProportionAdapter)];
    _labelDetile.text = @"分组详情";
    _labelDetile.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    [viewHead addSubview:_labelDetile];
    
    _btnSetLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSetLeft.frame = CGRectMake(screenWidth-140*ProportionAdapter, 50*ProportionAdapter, 65*ProportionAdapter, 27*ProportionAdapter);
    if (_isClick[section] == NO) {
        [_btnSetLeft setImage:[UIImage imageNamed:@"segunselectleft"] forState:UIControlStateNormal];
    }
    else{
        if (_isSegLeft[section] == YES) {
            [_btnSetLeft setImage:[UIImage imageNamed:@"segselectleft"] forState:UIControlStateNormal];
        }
        else{
            [_btnSetLeft setImage:[UIImage imageNamed:@"segdefaultleft"] forState:UIControlStateNormal];
        }
    }
    
    [viewHead addSubview:_btnSetLeft];
    [_btnSetLeft addTarget:self action:@selector(chooseSortLeftClick:) forControlEvents:UIControlEventAllEvents];
    _btnSetLeft.tag = 10000 + section;
    
    _btnSegRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSegRight.frame = CGRectMake(screenWidth-75*ProportionAdapter, 50*ProportionAdapter, 65*ProportionAdapter, 27*ProportionAdapter);
    if (_isClick[section] == NO) {
        [_btnSegRight setImage:[UIImage imageNamed:@"segunselectright"] forState:UIControlStateNormal];
    }
    else{
        if (_isSegLeft[section] == YES) {
            [_btnSegRight setImage:[UIImage imageNamed:@"segselectright"] forState:UIControlStateNormal];
        }
        else{
            [_btnSegRight setImage:[UIImage imageNamed:@"segdefaultright"] forState:UIControlStateNormal];
        }
    }
    
    
    [viewHead addSubview:_btnSegRight];
    [_btnSegRight addTarget:self action:@selector(chooseSortRightClick:) forControlEvents:UIControlEventAllEvents];
    _btnSegRight.tag = 100000 + section;
    return viewHead;
}
-(void)chooseSortLeftClick:(UIButton *)btn
{
    //根据button 获取区号
    NSInteger section = btn.tag;
    UIButton* btnr = (UIButton *)[self.view viewWithTag:section - 10000 + 100000];
    NSLog(@"%td    %td",section,btnr.tag);
//    if (_isSegLeft[section - 10000] == NO) {
        [btn setImage:[UIImage imageNamed:@"segselectleft"] forState:UIControlStateNormal];
        [btnr setImage:[UIImage imageNamed:@"segdefaultright"] forState:UIControlStateNormal];
        _isSegLeft[section - 10000] = !_isSegLeft[section - 10000];
        _isSegRight[section - 10000] = !_isSegRight[section - 10000];
        if (_isClick[section - 10000] == NO) {
            _isClick[section - 10000] = YES;
        }
//    }
}
-(void)chooseSortRightClick:(UIButton *)btn
{
    NSInteger section = btn.tag;
    UIButton* btnl = (UIButton *)[self.view viewWithTag:section - 100000 + 10000];
    NSLog(@"%td    %td",section,btnl.tag);
//    if (_isSegRight[section - 100000] == NO) {
        [btnl setImage:[UIImage imageNamed:@"segdefaultleft"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"segselectright"] forState:UIControlStateNormal];
        _isSegLeft[section - 100000] = !_isSegLeft[section - 100000];
        _isSegRight[section - 100000] = !_isSegRight[section - 100000];
        if (_isClick[section] == NO) {
            _isClick[section] = YES;
        }
//    }
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70*ProportionAdapter;
    }
    else
        return 104*ProportionAdapter;
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JGLGroupClubTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLGroupClubTitleTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        JGLGroupPeoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLGroupPeoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell initUiConfig];
        
        return cell;
    }
}

//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 85*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
