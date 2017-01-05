//
//  JGHActivityScoreManagerViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityScoreManagerViewController.h"
#import "JGHActivityMembersViewController.h"
//#import "JGHSetAlmostPromptViewController.h"
#import "JGDAlmostStlyleSetViewController.h"

#import "JGHMatchTranscriptTableViewCell.h"
#import "JGHPlayersScoreTableViewCell.h"
#import "JGHCenterBtnTableViewCell.h"
#import "JGHPublishedPeopleView.h"
#import "JGLScoreLiveModel.h"
#import "JGTeamAcitivtyModel.h"
#import "JGLScoreLiveViewController.h"
#import "JGDActSelfHistoryScoreViewController.h"
#import "JGLScoreRankViewController.h"

static NSString *const JGHMatchTranscriptTableViewCellIdentifier = @"JGHMatchTranscriptTableViewCell";
static NSString *const JGHPlayersScoreTableViewCellIdentifier = @"JGHPlayersScoreTableViewCell";
static NSString *const JGHCenterBtnTableViewCellIdentifier = @"JGHCenterBtnTableViewCell";

@interface JGHActivityScoreManagerViewController ()<UITableViewDelegate, UITableViewDataSource, JGHMatchTranscriptTableViewCellDelegate, JGHCenterBtnTableViewCellDelegate, JGHPublishedPeopleViewDelegate, JGHPlayersScoreTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableDictionary* _dictChoose;
    NSMutableDictionary *_dict;
    
    JGHPublishedPeopleView *_publisView;
    NSInteger _selectAll;
    
    NSInteger _selectNumber;//选择的人数
    NSNumber *_teamKey;
    NSInteger _lockScore;//是否锁定
}

@property (nonatomic, strong)UITableView *scoreManageTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSInteger almostType;//差点计算类型



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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relodDate) name:@"redloadActivityScoreManagerData" object:nil];
    
    _page = 0;
    _selectAll = 0;
    _selectNumber = 0;
    _almostType = 0;
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
    
    _publisView = [[[NSBundle mainBundle]loadNibNamed:@"JGHPublishedPeopleView" owner:self options:nil]lastObject];
    _publisView.delegate = self;
    _publisView.frame = CGRectMake(0, 0, screenWidth, 44);
    [_publisView setNeedsLayout];
    [_publisView setNeedsDisplay];
    [view addSubview:_publisView];
    [self.view addSubview:view];
}
#pragma mark -- 刷新数据通知
- (void)relodDate{
    [self headRereshing];
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
    if (_activityBaseModel.teamActivityKey != 0) {
        [dict setObject:@(_activityBaseModel.teamActivityKey) forKey:@"teamActivityKey"];
    }else{
        [dict setObject:@([_activityBaseModel.timeKey integerValue]) forKey:@"teamActivityKey"];
    }
    
    NSString* str = [dict objectForKey:@"teamActivityKey"];
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
            //      self.TeamArray = [data objectForKey:@"teamList"];
            _almostType = [[data objectForKey:@"almostType"] integerValue];
            _lockScore = [[data objectForKey:@"lockScore"] integerValue];
            
            for (NSDictionary *dataDic in [data objectForKey:@"list"]) {
                JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                model.select = 0;
                [_dataArray addObject:model];
            }
            //            [self.TeamArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            if ([data objectForKey:@"teamKey"]) {
                _teamKey = [data objectForKey:@"teamKey"];
            }
            _page++;
            [self.scoreManageTableView reloadData];
            
            
//            for (int i=0; i<_dataArray.count; i++) {
//                JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
//                model = _dataArray[i];
//                if ([model.publish integerValue] == 0) {
//                    break;
//                }else{
//                    if (i == _dataArray.count-1) {
//                        [_publisView.imageBtn setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
//                        [_publisView.selectAllBtn setTitle:@"取消" forState:UIControlStateNormal];
//                        _selectAll = 1;
//                    }
//                }
//            }
//            
//            [self countProple];
            _selectAll = 0;
            _publisView.provalue.text = @"0";
            [_publisView.imageBtn setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
            [_publisView.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }else {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        [self.scoreManageTableView reloadData];
        if (isReshing) {
            [self.scoreManageTableView.header endRefreshing];
        }

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
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _dataArray.count;
    }else{
        return 1;
    }
//    return 3 + _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80 *ProportionAdapter;
    }else{
        return 40 *ProportionAdapter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%td", indexPath.section);
    if (indexPath.section == 0) {
        JGHMatchTranscriptTableViewCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHMatchTranscriptTableViewCellIdentifier];
        tranCell.delegate = self;
        tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tranCell configActivityName:_activityBaseModel.ballName andStartTime:_activityBaseModel.beginDate andEndTime:_activityBaseModel.endDate];
        return tranCell;
    }else if (indexPath.section == 2){
        JGHCenterBtnTableViewCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHCenterBtnTableViewCellIdentifier];
        centerBtnCell.delegate = self;
        centerBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return centerBtnCell;
    }else{
//        if (indexPath.row == 1) {
//            JGHPlayersScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHPlayersScoreTableViewCellIdentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.imageScore.hidden = YES;
//            cell.fristLabel.text = @"姓名";
//            cell.fristLabel.textColor = [UIColor lightGrayColor];
//            cell.twoLabel.text = @"总杆";
//            cell.twoLabel.textColor = [UIColor lightGrayColor];
//            cell.threeLabel.text = @"差点";
//            cell.threeLabel.textColor = [UIColor lightGrayColor];
//            cell.fiveLabel.text = @"净杆";
//            cell.fiveLabel.textColor = [UIColor lightGrayColor];
//            return cell;
//        }else{
            JGHPlayersScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHPlayersScoreTableViewCellIdentifier];
            cell.selectBtn.tag = indexPath.row + 100;
            cell.delegate = self;
            [cell showData:_dataArray[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
//        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 40*ProportionAdapter;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        JGHPlayersScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHPlayersScoreTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageScore.hidden = YES;
        cell.fristLabel.text = @"姓名";
        cell.fristLabel.textColor = [UIColor lightGrayColor];
        cell.twoLabel.text = @"总杆";
        cell.twoLabel.textColor = [UIColor lightGrayColor];
        cell.threeLabel.text = @"差点";
        cell.threeLabel.textColor = [UIColor lightGrayColor];
        cell.fiveLabel.text = @"净杆";
        cell.fiveLabel.textColor = [UIColor lightGrayColor];
        return (UIView *)cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%td", indexPath.section);
    NSLog(@"%td", indexPath.row);
    if (indexPath.section == 2) {
        JGDActSelfHistoryScoreViewController *actVC = [[JGDActSelfHistoryScoreViewController alloc] init];
        actVC.scoreModel = self.dataArray[indexPath.section - 2];
        actVC.timeKey = _activityBaseModel.timeKey;
        actVC.teamKey = _teamKey;
        [self.navigationController pushViewController:actVC animated:YES];
    }
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
//    JGHSetAlmostPromptViewController *setAlmostCtrl = [[JGHSetAlmostPromptViewController alloc]initWithNibName:@"JGHSetAlmostPromptViewController" bundle:nil];
//    setAlmostCtrl.teamKey = _activityBaseModel.teamKey;
//    setAlmostCtrl.almostType = _almostType;
//    if (_activityBaseModel.teamActivityKey != 0) {
//        setAlmostCtrl.teamActivityKey = _activityBaseModel.teamActivityKey;
//    }else{
//        setAlmostCtrl.teamActivityKey = [_activityBaseModel.timeKey integerValue];
//    }
//    
//    __weak JGHActivityScoreManagerViewController *weakSlef = self;
//    setAlmostCtrl.refreshBlock = ^(NSInteger almostType){
//        weakSlef.almostType = almostType;
//        [self headRereshing];
    //    };
    JGDAlmostStlyleSetViewController *setAlmostCtrl = [[JGDAlmostStlyleSetViewController alloc] init];
    setAlmostCtrl.teamKey = _activityBaseModel.teamKey;
    setAlmostCtrl.almostType = _almostType;
    if (_activityBaseModel.teamActivityKey != 0) {
        setAlmostCtrl.teamActivityKey = _activityBaseModel.teamActivityKey;
    }else{
        setAlmostCtrl.teamActivityKey = [_activityBaseModel.timeKey integerValue];
    }
    
    setAlmostCtrl.lockScore = _lockScore;
    setAlmostCtrl.refreshBlock = ^(){
//        weakSlef.almostType = almostType;
        [self headRereshing];
    };
    [self.navigationController pushViewController:setAlmostCtrl animated:YES];
}
#pragma mark -- 保存
- (void)saveBtnClick{
    NSLog(@"保存");
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_dataArray.count; i++) {
        JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc]init];
        model = _dataArray[i];
        if ([model.publish integerValue] == 1) {
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
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
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
        if ([model.publish integerValue] == 1) {
            [array addObject:model.scoreKey];
        }
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
                    [self performSelector:@selector(pushCtrl) withObject:self afterDelay:TIMESlEEP];
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
            }];
        }
    }];
}
#pragma mark -- 公布跳转
- (void)pushCtrl{
    JGLScoreRankViewController *rankCtrl = [[JGLScoreRankViewController alloc]init];
    if (_activityBaseModel.teamActivityKey != 0) {
        rankCtrl.activity = [NSNumber numberWithInteger:_activityBaseModel.teamActivityKey];
    }else{
        rankCtrl.activity = [NSNumber numberWithInteger:[_activityBaseModel.timeKey integerValue]];
    }
    
    rankCtrl.teamKey = [NSNumber numberWithInteger:_activityBaseModel.teamKey];
    
    [self.navigationController pushViewController:rankCtrl animated:YES];
}
#pragma mark -- 全选
- (void)selectAll{
    NSLog(@"全选");
    
    if (_selectAll == 0) {
        _selectAll = 1;
        for (int i=0; i<_dataArray.count; i++) {
            JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
            model = _dataArray[i];
            if ([model.publish integerValue] == 0) {
                model.publish = [NSNumber numberWithInteger:1];
//                [_dataArray replaceObjectAtIndex:i withObject:model];
            }
        }
        
        _selectNumber = _dataArray.count;
        [_publisView.imageBtn setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
        [_publisView.selectAllBtn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        _selectAll = 0;
        for (int i=0; i<_dataArray.count; i++) {
            JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
            model = _dataArray[i];
            if ([model.publish integerValue] == 1) {
                model.publish = [NSNumber numberWithInteger:0];
//                [_dataArray replaceObjectAtIndex:i withObject:model];
            }
        }
        
        _selectNumber = 0;
        [_publisView.imageBtn setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
        [_publisView.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    _publisView.provalue.text = [NSString stringWithFormat:@"%td", _selectNumber];
    
    [self.scoreManageTableView reloadData];
}

#pragma mark -- 选择
- (void)selectMembers:(UIButton *)btn{
    _selectNumber = 0;
    NSLog(@"%td", btn.tag);
    JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
    model = _dataArray[btn.tag -100];
    
    NSLog(@"%td", btn.tag - 100);
    
    if ([model.publish integerValue] == 0) {
        model.publish = [NSNumber numberWithInteger:1];
    }else{
        model.publish = [NSNumber numberWithInteger:0];
    }
    
    [self countProple];
    [self.scoreManageTableView reloadData];
}
#pragma mark -- 统计选择人数
- (void)countProple{
    _selectNumber = 0;
    for (int i=0; i<_dataArray.count; i++) {
        JGLScoreLiveModel *model = [[JGLScoreLiveModel alloc] init];
        model = _dataArray[i];
        if ([model.publish integerValue] == 1) {
            _selectNumber += 1;
        }
    }
    
    _publisView.provalue.text = [NSString stringWithFormat:@"%td", _selectNumber];
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
