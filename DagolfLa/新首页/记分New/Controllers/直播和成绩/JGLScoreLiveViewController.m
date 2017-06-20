//
//  JGLScoreLiveViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreLiveViewController.h"
#import "JGLChoosesScoreTableViewCell.h"
#import "JGLScoreLiveHeadTableViewCell.h"
#import "JGLScoreLiveDetailTableViewCell.h"
#import "JGLScoreLiveModel.h"
#import "UITool.h"

#import "JGDHIstoryScoreDetailViewController.h"

@interface JGLScoreLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
}

@property (strong, nonatomic) JGTeamAcitivtyModel* model;

@end

@implementation JGLScoreLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动成绩";
    _dataArray = [[NSMutableArray alloc]init];
    self.model = [[JGTeamAcitivtyModel alloc]init];
    _page = 0;
    [self uiConfig];
}

-(void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setExtraCellLineHidden];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLChoosesScoreTableViewCell class] forCellReuseIdentifier:@"JGLChoosesScoreTableViewCell"];
    [_tableView registerClass:[JGLScoreLiveHeadTableViewCell class] forCellReuseIdentifier:@"JGLScoreLiveHeadTableViewCell"];
    [_tableView registerClass:[JGLScoreLiveDetailTableViewCell class] forCellReuseIdentifier:@"JGLScoreLiveDetailTableViewCell"];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [self getTeamActivity];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:_activity forKey:@"teamActivityKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamActivityKey=%@dagolfla.com", DEFAULF_USERID,_activity]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getScoreDirectSeeding" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }
        //        else {
        //            [_tableView.mj_footer endRefreshing];
        //        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            //            self.TeamArray = [data objectForKey:@"teamList"];
            for (NSDictionary *dataDic in [data objectForKey:@"list"]) {
                JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
            //            [self.TeamArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            _page++;
            [_tableView reloadData];
        }else {
             [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }
        //        else {
        //            [_tableView.mj_footer endRefreshing];
        //        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

#pragma mark -- 获取活动详情
- (void)getTeamActivity{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_activity forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            
            [self.model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
            [_tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : _dataArray.count + 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //活动名称
        JGLChoosesScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChoosesScoreTableViewCell" forIndexPath:indexPath];
        [cell showLiveData:_model];
        return cell;

    }
    else{
        //title
        if (indexPath.row == 0) {
            JGLScoreLiveHeadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLScoreLiveHeadTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UITool colorWithHexString:@"ecf7ef" alpha:1];
            return cell;
        }
        else{
            //同一个cell，加载数据
            JGLScoreLiveDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLScoreLiveDetailTableViewCell" forIndexPath:indexPath];
                [cell showData:_dataArray[indexPath.row - 1]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10* screenWidth / 375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0 ? 93 * screenWidth / 375 : 44* screenWidth / 375;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return kHvertical(0.01);
    }
    return kHvertical(100);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerview = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, screenWidth, kHvertical(100))];
    if (section==0) {
        footerview.height=0;
        return footerview;
    }
    UILabel *oneLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    oneLable.text = @"照片太多，手机上传太慢？！";
    oneLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    oneLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    oneLable.textAlignment = NSTextAlignmentCenter;
    [footerview addSubview:oneLable];
    
    UILabel *twoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    twoLable.text = @"我们提供了PC端导入工具，海量照片，一键导入！";
    twoLable.textAlignment = NSTextAlignmentCenter;
    twoLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    twoLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    [footerview addSubview:twoLable];
    
    UILabel *threeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    threeLable.text = @"PC端登录地址：http://keeper.dagolfla.com";
    threeLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:threeLable.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:B31_Color] range:NSMakeRange(8, threeLable.text.length-8)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    threeLable.attributedText = attributedString;
    
    threeLable.textAlignment = NSTextAlignmentCenter;
    threeLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    [footerview addSubview:threeLable];
    
    return footerview;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%td", indexPath.row);
    NSLog(@"section == %td", indexPath.section);
    if (indexPath.section == 1 && indexPath.row > 0) {
        JGDHIstoryScoreDetailViewController *hisVC = [[JGDHIstoryScoreDetailViewController alloc] init];
        hisVC.srcKey = _activity;
        JGLScoreLiveModel *model = _dataArray[indexPath.row -1];
        hisVC.scoreKey = model.timeKey;
        hisVC.fromLive = 5;
        [self.navigationController pushViewController:hisVC animated:YES];
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
