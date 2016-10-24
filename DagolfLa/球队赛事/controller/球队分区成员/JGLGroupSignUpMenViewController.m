//
//  JGLTeamSignUpMemViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGroupSignUpMenViewController.h"
#import "JGLTeamCounterMemberTableViewCell.h"
#import "JGLCompeteMemberModel.h"
@interface JGLGroupSignUpMenViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableDictionary* _dataModeDict;
    int _page;
}
@end

@implementation JGLGroupSignUpMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名成员";
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _dataModeDict = [[NSMutableDictionary alloc]init];
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
    [dict setObject:_teamKey forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamCompeteSignUpListWithMatchKey:122 teamKey:[_teamKey integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getCanMatchTeamSignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
                [_dataModeDict removeAllObjects];
            }
            [_dataModeDict setObject:[data objectForKey:@"teamName"] forKey:@"teamName"];
            //数据解析
            for (NSDictionary* dict in [data objectForKey:@"list"]) {
                JGLCompeteMemberModel *model = [[JGLCompeteMemberModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
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

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}


#pragma mark -- tableview代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    backView.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [headerView addSubview:backView];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 10*ProportionAdapter, 250*ProportionAdapter, 40*ProportionAdapter)];
    labelTitle.textColor = [UITool colorWithHexString:@"eb6100" alpha:1];
    labelTitle.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    if (![Helper isBlankString:[_dataModeDict objectForKey:@"teamName"]]) {
        labelTitle.text = [_dataModeDict objectForKey:@"teamName"];
    }
    [headerView addSubview:labelTitle];
    
    UILabel* labelNum = [[UILabel alloc]initWithFrame:CGRectMake(270*ProportionAdapter, 10*ProportionAdapter, 100*ProportionAdapter, 40*ProportionAdapter)];
    labelNum.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    labelNum.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    labelNum.text = [NSString stringWithFormat:@"（%td）人",_dataArray.count];
    [headerView addSubview:labelNum];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 30*ProportionAdapter, 25*ProportionAdapter, 16*ProportionAdapter, 14*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@")-1"];
    [headerView addSubview:imgv];
    return headerView;
}


//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62 * screenWidth / 375;
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLTeamCounterMemberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamCounterMemberTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
    cell.iconImage.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showData:_dataArray[indexPath.row] withUserKey:_userKey] ;
    return cell;
}



//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44*ScreenWidth/375;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _bl
    //已添加过得，可移除
    if ([[_dataArray[indexPath.row] userKey] integerValue] == [_userKey integerValue]) {
        
    }
    else{
        
    }
    
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
