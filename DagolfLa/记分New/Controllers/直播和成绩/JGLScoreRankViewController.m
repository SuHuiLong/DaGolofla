//
//  JGLScoreRankViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreRankViewController.h"
#import "JGLScoreRankTableViewCell.h"

#import "JGLScoreRankModel.h"
#import "UITool.h"

#import "JGDActSelfHistoryScoreViewController.h"


@interface JGLScoreRankViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView* _viewHeader;
    UISegmentedControl* _seg;
    UILabel* _labelTitle;
    UILabel* _labelTime;
    
    NSMutableArray* _dataArray;
    NSInteger _page;
    UILabel* _labelNoData;
    NSString* _strTitleShare;
}
@end

@implementation JGLScoreRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    [self createHeader];
    [self uiConfig];
}

-(void)createHeader
{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 75*screenWidth/375)];
    _viewHeader.userInteractionEnabled = YES;
    
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 15*screenWidth/375, 200*screenWidth/375, 25*screenWidth/375)];
    _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [_viewHeader addSubview:_labelTitle];
    _labelTitle.text = @"暂无球场名称";
    
    UIImageView* timeImgv = [[UIImageView alloc]initWithFrame:CGRectMake(12*screenWidth/375, 47*screenWidth/375, 16*screenWidth/375, 16*screenWidth/375)];
    timeImgv.image = [UIImage imageNamed:@"time"];
    [_viewHeader addSubview:timeImgv];
    
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(40*screenWidth/375, 45*screenWidth/375, 150*screenWidth/375, 20*screenWidth/375)];
    _labelTime.text = @"暂无时间";
    _labelTime.font = [UIFont systemFontOfSize:12*screenWidth/375];
    [_viewHeader addSubview:_labelTime];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"总杆排名",@"净杆排名",nil];
    _seg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _seg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _seg.frame = CGRectMake(screenWidth-130*ScreenWidth/375, 35*ScreenWidth/375, 120*ScreenWidth/375, 35*ScreenWidth/375);
    _seg.selectedSegmentIndex = 0;//设置默认选择项索引
    _seg.backgroundColor = [UIColor whiteColor];
    _seg.tintColor = [UITool colorWithHexString:@"#32b14d" alpha:1];
    [_viewHeader addSubview:_seg];
    UIFont *font = [UIFont boldSystemFontOfSize:13.0f*ScreenWidth/375];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [_seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [_seg addTarget:self action:@selector(segTypeClick:) forControlEvents:UIControlEventValueChanged];
    
    //分享按钮
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fenxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(addShare)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
}
#pragma mark -分享
- (void)addShare{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        
        [self.view addSubview:alert];
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index];
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [alert show];
        }];
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}
#pragma mark - 分享
-(void)shareInfo:(NSInteger)index{
    //http://imgcache.dagolfla.com/share/score/scoreRanking.html?teamKey=222&userKey=1&srcKey=1&srcType=1&share=1                  球队计分分享
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
//    if ([_model.timeKey integerValue] == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_activity integerValue] andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreRanking.html?teamKey=%@&userKey=%@&srcKey=%@&srcType=1&share=1", _teamKey, DEFAULF_USERID, _activity];
//    }
//    else
//    {
//        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue]andIsSetWidth:YES andIsBackGround:YES]];
//        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?key=%@", _model.timeKey];
//    }
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@报名", _strTitleShare];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"活动记分分享%@", _activity] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"活动记分分享%@", _activity] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"打高尔夫啦",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}

-(void)segTypeClick:(UISegmentedControl *)sender
{
    if ([_tableView.header isRefreshing] == YES) {
        [_tableView.header endRefreshing];
    }
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _viewHeader;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLScoreRankTableViewCell class] forCellReuseIdentifier:@"JGLScoreRankTableViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_activity forKey:@"srcKey"];
    [dict setObject:@1 forKey:@"srcType"];
    NSLog(@"%@",[NSNumber numberWithInteger:_seg.selectedSegmentIndex]);
    if (_seg.selectedSegmentIndex == 0) {
        [dict setObject:@1 forKey:@"rankingType"];

    }else if (_seg.selectedSegmentIndex == 1) {
        [dict setObject:@0 forKey:@"rankingType"];

    }
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%@&userKey=%@&srcKey=%@&srcType=1dagolfla.com",_teamKey,DEFAULF_USERID,_activity]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getReleasePolenumberRanking" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
        //        else {
        //            [_tableView.footer endRefreshing];
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
            for (NSDictionary *dataDic in [data objectForKey:@"scoreList"]) {
                JGLScoreRankModel *model = [[JGLScoreRankModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
            
            if (![Helper isBlankString:[data objectForKey:@"ballName"]]) {
                _labelTitle.text = [data objectForKey:@"ballName"];
            }
            else{
                _labelTitle.text = @"暂无球场名称";
            }
            if (![Helper isBlankString:[data objectForKey:@"date"]] && ![Helper isBlankString:[data objectForKey:@"endDate"]]) {
                NSArray *array1 = [[data objectForKey:@"date"] componentsSeparatedByString:@" "];
                NSArray *array2 = [[data objectForKey:@"endDate"] componentsSeparatedByString:@" "];
                _labelTime.text = [NSString stringWithFormat:@"%@~%@",array1[0],array2[0]];
            }
            else{
                _labelTime.text = @"暂无时间";
            }
            if (![Helper isBlankString:[data objectForKey:@"title"]]) {
                self.title = [data objectForKey:@"title"];
                _strTitleShare = [data objectForKey:@"title"];
            }
            _labelNoData.hidden = YES;
            _page++;
            [_tableView reloadData];
        }else {
            if ([_tableView.subviews containsObject:_labelNoData] == NO) {
                _labelNoData = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, screenWidth, 30)];
                _labelNoData.font = [UIFont systemFontOfSize:30];
                _labelNoData.text = @"暂无成绩";
                _labelNoData.textColor = [UIColor lightGrayColor];
                _labelNoData.textAlignment = NSTextAlignmentCenter;
                [_tableView addSubview:_labelNoData];
                _labelNoData.tag = 777;
            }
            else{
                _labelNoData.hidden = NO;
            }
            
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        JGLScoreRankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLScoreRankTableViewCell" forIndexPath:indexPath];
        cell.labelRank.text   = @"排名";
        cell.labelRank.textColor = [UIColor lightGrayColor];
        cell.labelName.text   = @"姓名";
        cell.labelName.textColor = [UIColor lightGrayColor];
        cell.labelAll.text    = @"总杆";
        cell.labelAll.textColor = [UIColor lightGrayColor];
        cell.labelAlmost.text = @"差点";
        cell.labelAlmost.textColor = [UIColor lightGrayColor];
        cell.labelTee.text    = @"净杆";
        cell.labelTee.textColor = [UIColor lightGrayColor];
        return cell;
    }
    else{
        JGLScoreRankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLScoreRankTableViewCell" forIndexPath:indexPath];
        cell.labelRank.textColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        cell.labelRank.text = [NSString stringWithFormat:@"%td",indexPath.row];
        [cell showData:_dataArray[indexPath.row-1]];
        return cell;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 2)];
    view.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44* screenWidth / 375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   /*
    [dic setObject:self.scoreModel.scoreKey forKey:@"scoreKey"];
    [dic setObject:self.scoreModel.userKey forKey:@"userKey"];
    [dic setObject:_activity forKey:@"srcKey"];
    */
    if (indexPath.row > 0) {
        JGLScoreRankModel *model = _dataArray[indexPath.row - 1];
        JGDActSelfHistoryScoreViewController *actVC = [[JGDActSelfHistoryScoreViewController alloc] init];
        actVC.userKey = model.userKey;
        actVC.scoreKey = model.scoreKey;
        actVC.srcKey = _activity;
        actVC.fromManeger = 6;
        [self.navigationController pushViewController:actVC animated:YES];
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
