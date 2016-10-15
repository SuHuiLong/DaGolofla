//
//  JGLTeamSignUpMemViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLSignUpMemberCeViewController.h"
#import "JGLTeamCounterMemberTableViewCell.h"
#import "JGLCompeteMemberModel.h"
@interface JGLSignUpMemberCeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataModeArray;
    int _page;
}
@end

@implementation JGLSignUpMemberCeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名成员";
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _dataModeArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //    _tableView.bounces = NO;
    //    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[JGLTeamCounterMemberTableViewCell class] forCellReuseIdentifier:@"JGLTeamCounterMemberTableViewCell"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@122 forKey:@"matchKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getTeamCompeteSignUpListWithMatchKey:122 userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getMatchSignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
                [_dataModeArray removeAllObjects];
            }
            //数据解析
            _dataArray = [[data objectForKey:@"list"] mutableCopy];
            if (_dataArray.count != 0) {
                for (int i = 0; i < _dataArray.count; i++) {
                    NSMutableArray * arr = [[NSMutableArray alloc]init];
                    for (NSDictionary* dict in [_dataArray[i] objectForKey:@"signUpList"]) {
                        JGLCompeteMemberModel *model = [[JGLCompeteMemberModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [arr addObject:model];
                        
                    }
                    [_dataModeArray addObject:arr];
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
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

#pragma mark -- tableview代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataModeArray.count;
}


//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65*ScreenWidth/375)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, ScreenWidth, 65*ScreenWidth/375);
    [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    backView.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [headerView addSubview:backView];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 10*ProportionAdapter, 250*ProportionAdapter, 30*ProportionAdapter)];
    labelTitle.textColor = [UITool colorWithHexString:@"eb6100" alpha:1];
    labelTitle.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    if (section < _dataArray.count) {
        if (![Helper isBlankString:[_dataArray[section] objectForKey:@"teamName"]]) {
            labelTitle.text = [_dataArray[section] objectForKey:@"teamName"];
        }
    }
    
    [headerView addSubview:labelTitle];
    
    UILabel* labelNum = [[UILabel alloc]initWithFrame:CGRectMake(270*ProportionAdapter, 10*ProportionAdapter, 100*ProportionAdapter, 30*ProportionAdapter)];
    labelNum.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    labelNum.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    if (section < _dataArray.count){
        labelNum.text = [NSString stringWithFormat:@"（%@）人",[_dataArray[section] objectForKey:@"sumCount"]];
    }
    
    [headerView addSubview:labelNum];
    
    UILabel* labelPeople = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 40*ProportionAdapter, 140*ProportionAdapter, 25*ProportionAdapter)];
    labelPeople.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    labelPeople.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    labelPeople.text = @"报名人：张晓晓";
    if (section < _dataArray.count) {
        if (![Helper isBlankString:[_dataArray[section] objectForKey:@"userName"]]) {
            labelPeople.text = [_dataArray[section] objectForKey:@"userName"];
        }
    }
    
    [headerView addSubview:labelPeople];
    
    UIImageView* imgvPhone = [[UIImageView alloc]initWithFrame:CGRectMake(150*ProportionAdapter, 46.5*ProportionAdapter, 12*ProportionAdapter, 12*ProportionAdapter)];
    imgvPhone.image = [UIImage imageNamed:@"call-in"];
    [headerView addSubview:imgvPhone];
    
    UIButton* btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    if (![Helper isBlankString:[_dataArray[section] objectForKey:@"userMobile"]]) {
        [btnPhone setTitle:[_dataArray[section] objectForKey:@"userMobile"] forState:UIControlStateNormal];
    }
    btnPhone.titleLabel.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    [btnPhone setTitleColor:[UITool colorWithHexString:@"32b14d" alpha:1] forState:UIControlStateNormal];
    btnPhone.frame = CGRectMake(160*ProportionAdapter, 40*ProportionAdapter, 100*ProportionAdapter, 25*ProportionAdapter);
    [btnPhone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btnPhone];
    btnPhone.tag = section;
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 30*ProportionAdapter, 28*ProportionAdapter, 16*ProportionAdapter, 13*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@")-1"];
    [headerView addSubview:imgv];
    return headerView;
}
#pragma mark -- 打电话
-(void)callPhone
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
}

#pragma mark -  表开合
- (void)headerButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //根据button 获取区号
    NSInteger section = button.tag;
    _isClickBool[section] = !_isClickBool[section];
    //刷新表  表的相关代理方法会重新执行
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果当前区为打开状态
    if (_isClickBool[section])
    {
        return 0;
    }
    else//如果不等于当前打开的区号 就是合闭状态 用返回0行来模拟出闭合状态
        return [_dataModeArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65 * screenWidth / 375;
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLTeamCounterMemberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamCounterMemberTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
    cell.iconImage.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showData:_dataModeArray[indexPath.section][indexPath.row]];
    return cell;
}



//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65*ScreenWidth/375;
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
