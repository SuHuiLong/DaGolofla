//
//  JGHActivityScoreManagerViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityScoreManagerViewController.h"
#import "JGHActivityMembersViewController.h"
#import "JGHSetAlmostPromptViewController.h"
#import "JGHMatchTranscriptTableViewCell.h"
#import "JGHPlayersScoreTableViewCell.h"
#import "JGHCenterBtnTableViewCell.h"
#import "JGHPublishedPeopleView.h"
#import "JGLScoreLiveModel.h"
#import "JGTeamAcitivtyModel.h"

#import "JGDActSelfHistoryScoreViewController.h"

static NSString *const JGHMatchTranscriptTableViewCellIdentifier = @"JGHMatchTranscriptTableViewCell";
static NSString *const JGHPlayersScoreTableViewCellIdentifier = @"JGHPlayersScoreTableViewCell";
static NSString *const JGHCenterBtnTableViewCellIdentifier = @"JGHCenterBtnTableViewCell";

@interface JGHActivityScoreManagerViewController ()<UITableViewDelegate, UITableViewDataSource, JGHMatchTranscriptTableViewCellDelegate, JGHCenterBtnTableViewCellDelegate, JGHPublishedPeopleViewDelegate>
{
    NSInteger _page;
    NSMutableDictionary* _dictChoose;
    NSMutableDictionary *_dict;
}

@property (nonatomic, strong)UITableView *scoreManageTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHActivityScoreManagerViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        _dictChoose    = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = _activityBaseModel.name;
    _dict = [NSMutableDictionary dictionary];
    
    [_dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [_dict setObject:@(_activityBaseModel.teamKey) forKey:@"teamKey"];
    if (_activityBaseModel.teamActivityKey != 0) {
        [_dict setObject:@(_activityBaseModel.teamActivityKey) forKey:@"activityKey"];
    }else{
        [_dict setObject:_activityBaseModel.timeKey forKey:@"activityKey"];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createTable];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight -44 -64, screenWidth, 44)];
    
    JGHPublishedPeopleView *publisView = [[[NSBundle mainBundle]loadNibNamed:@"JGHPublishedPeopleView" owner:self options:nil]lastObject];
    publisView.delegate = self;
    publisView.frame = CGRectMake(0, 0, screenWidth, 44);
    [publisView setNeedsLayout];
    [publisView setNeedsDisplay];
    [view addSubview:publisView];
    [self.view addSubview:view];
}

- (void)createTable{
    self.scoreManageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64 -44) style:UITableViewStylePlain];
    
    UINib *matchTranscriptNib = [UINib nibWithNibName:@"JGHMatchTranscriptTableViewCell" bundle: [NSBundle mainBundle]];
    [self.scoreManageTableView registerNib:matchTranscriptNib forCellReuseIdentifier:JGHMatchTranscriptTableViewCellIdentifier];
    
    UINib *playersScoreNib = [UINib nibWithNibName:@"JGHPlayersScoreTableViewCell" bundle: [NSBundle mainBundle]];
    [self.scoreManageTableView registerNib:playersScoreNib forCellReuseIdentifier:JGHPlayersScoreTableViewCellIdentifier];
    
    UINib *centerBtnNib = [UINib nibWithNibName:@"JGHCenterBtnTableViewCell" bundle: [NSBundle mainBundle]];
    [self.scoreManageTableView registerNib:centerBtnNib forCellReuseIdentifier:JGHCenterBtnTableViewCellIdentifier];
    
    self.scoreManageTableView.delegate = self;
    self.scoreManageTableView.dataSource = self;
    
    self.scoreManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreManageTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.scoreManageTableView];
    
    self.scoreManageTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [self.scoreManageTableView.header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:@625801 forKey:@"teamActivityKey"];
    NSString* str = @"625801";
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamActivityKey=%@dagolfla.com", DEFAULF_USERID,str]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getTeamActivityScoreMgrList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [self.scoreManageTableView.header endRefreshing];
        }
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
                model.select = 0;
                [_dataArray addObject:model];
            }
            //            [self.TeamArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            _page++;
            [self.scoreManageTableView reloadData];
        }else {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        [self.scoreManageTableView reloadData];
        if (isReshing) {
            [self.scoreManageTableView.header endRefreshing];
        }
        //        else {
        //            [_tableView.footer endRefreshing];
        //        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}


#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2 + _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80 *ProportionAdapter;
    }else{
        return 40 *ProportionAdapter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHMatchTranscriptTableViewCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHMatchTranscriptTableViewCellIdentifier];
        tranCell.delegate = self;
        tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tranCell configActivityName:_activityBaseModel.ballName andStartTime:_activityBaseModel.beginDate andEndTime:_activityBaseModel.endDate];
        return tranCell;
    }else if (indexPath.section == _dataArray.count + 1){
        JGHCenterBtnTableViewCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHCenterBtnTableViewCellIdentifier];
        centerBtnCell.delegate = self;
        centerBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return centerBtnCell;
    }else{
        if (indexPath.section == 1) {
            JGHPlayersScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHPlayersScoreTableViewCellIdentifier];
            cell.imageScore.hidden = YES;
            cell.fristLabel.text = @"姓名";
            cell.fristLabel.textColor = [UIColor lightGrayColor];
            cell.twoLabel.text = @"总杆";
            cell.twoLabel.textColor = [UIColor lightGrayColor];
            cell.threeLabel.text = @"差点";
            cell.threeLabel.textColor = [UIColor lightGrayColor];
            cell.fiveLabel.text = @"净杆";
            cell.fiveLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            JGHPlayersScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHPlayersScoreTableViewCellIdentifier];
            [cell showData:_dataArray[indexPath.section-1]];
//            cell.imageScore.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSString* str = [_dictChoose objectForKey:[NSString stringWithFormat:@"%td",indexPath.section-1]];
//            if ([Helper isBlankString:str]) {
//                cell.imageScore.image = [UIImage imageNamed:@"gou_w"];
//            }
//            else{
//                cell.imageScore.image = [UIImage imageNamed:@"gou_x"];
//            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 2*ProportionAdapter;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 2*ProportionAdapter)];
        view.backgroundColor = [UIColor colorWithHexString:@"#3AB152"];
        return view;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGDActSelfHistoryScoreViewController *actVC = [[JGDActSelfHistoryScoreViewController alloc] init];
    actVC.scoreModel = self.dataArray[indexPath.row];
    actVC.timeKey = _activityBaseModel.timeKey;
    [self.navigationController pushViewController:actVC animated:YES];
    
//    NSString* str = [_dictChoose objectForKey:[NSString stringWithFormat:@"%td",indexPath.section-1]];
//    if ([Helper isBlankString:str]) {
////        JGLScoreLiveModel* model = [self.dataArray[indexPath.section -1]];
////        [_dictChoose setObject:model.userKey forKey:[NSString stringWithFormat:@"%td",indexPath.section-1]];
//    }
//    else{
//        [_dictChoose removeObjectForKey:[NSString stringWithFormat:@"%td",indexPath.section-1]];
//    }
//    [self.scoreManageTableView reloadData];
}

#pragma mark -- 添加记录
- (void)addScoreRecord{
    JGHActivityMembersViewController *friendCtrl = [[JGHActivityMembersViewController alloc]init];
    friendCtrl.teamKey = _activityBaseModel.teamKey;
    if (_activityBaseModel.teamActivityKey != 0) {
        friendCtrl.activityKey = _activityBaseModel.teamActivityKey;
    }else{
        friendCtrl.activityKey = [_activityBaseModel.timeKey integerValue];
    }
    
    friendCtrl.activityModel = _activityBaseModel;
    [self.navigationController pushViewController:friendCtrl animated:YES];
}
#pragma mark -- 设置差点
- (void)selectSetAlmostBtn{
    NSLog(@"设置差点");
    JGHSetAlmostPromptViewController *setAlmostCtrl = [[JGHSetAlmostPromptViewController alloc]initWithNibName:@"JGHSetAlmostPromptViewController" bundle:nil];
    [self.navigationController pushViewController:setAlmostCtrl animated:YES];
}
#pragma mark -- 保存
- (void)saveBtnClick{
    NSLog(@"保存");
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_dataArray.count; i++) {
        JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc]init];
        model = _dataArray[i];
        if (model.select == 1) {
            [array addObject:model.scoreKey];
        }
    }
    
    [_dict setObject:array forKey:@"scoreKeyList"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/saveTeamActivityScore" JsonKey:nil withData:_dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"保存成功！" FromView:self.view];
        }else{
            if ([data objectForKey:@"packID"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packID"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 公布
- (void)publisBtn{
    NSLog(@"公布");
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_dataArray.count; i++) {
        JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc]init];
        model = _dataArray[i];
        [array addObject:model.scoreKey];
    }
    
    [_dict setObject:array forKey:@"scoreKeyList"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/saveTeamActivityScore" JsonKey:nil withData:_dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            
            NSMutableDictionary *materDict = [NSMutableDictionary dictionary];
            [materDict setObject:DEFAULF_USERID forKey:@"userKey"];
            [materDict setObject:[_dict objectForKey:@"teamKey"] forKey:@"teamKey"];
            [materDict setObject:[_dict objectForKey:@"activityKey"] forKey:@"activityKey"];
            [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/publishTeamActivityScore" JsonKey:nil withData:_dict failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {
                NSLog(@"%@", data);
                if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                    [[ShowHUD showHUD]showToastWithText:@"公布成功！" FromView:self.view];
                }
            }];
        }
    }];
    
}
#pragma mark -- 全选
- (void)selectAll{
    NSLog(@"全选");
    for (int i=0; i<_dataArray.count; i++) {
        JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
        model = _dataArray[i];
        if (model.select == 0) {
            model.select = 1;
            [_dataArray replaceObjectAtIndex:i withObject:model];
        }
    }
    
    [self.scoreManageTableView reloadData];
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
