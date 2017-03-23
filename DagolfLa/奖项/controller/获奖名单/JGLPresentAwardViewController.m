//
//  JGLPresentAwardViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPresentAwardViewController.h"
#import "JGLPresentAwardTableViewCell.h"
#import "JGHAwardModel.h"
#import "JGDActivityListViewController.h"
#import "JGLWinnersShareViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGDActvityPriziSetTableViewCell.h"
#import "JGHSetAwardViewController.h"

@interface JGLPresentAwardViewController ()<UITableViewDelegate,UITableViewDataSource, JGDActivityListViewControllerDelegate>
{
    NSMutableArray* _dataArray;
    UITableView* _tableView;
    UIView* _viewBack;
    NSMutableArray *_prizeListArray;
    NSString* _strTeamName;
    UIView *_psuhView;
    UIButton *_psuhBtn;
    
    NSInteger _isManager;
}

@property (nonatomic, strong)UIView *bgView;

@end

@implementation JGLPresentAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.title = @"颁奖";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(saveAwardNameClick:)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _dataArray = [NSMutableArray array];
    _prizeListArray = [NSMutableArray array];
    
    [self createHeader];
    
    [self uiConfig];
    
    
    dispatch_queue_t queue = dispatch_queue_create("activityQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self getActivityManager];
    });
//    [self loadData];
}
#pragma mark -- 创建工具栏
- (void)createPublishAwardNameListBtn{
    _psuhView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 65*ProportionAdapter - 64, screenWidth, 65*ProportionAdapter)];
    _psuhView.backgroundColor = [UIColor whiteColor];
    _psuhBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 65*ProportionAdapter - 20*ProportionAdapter)];
    [_psuhBtn setTitle:@"发布" forState:UIControlStateNormal];
    _psuhBtn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    _psuhBtn.layer.masksToBounds = YES;
    _psuhBtn.layer.cornerRadius = 8.0 *ProportionAdapter;
    _psuhBtn.userInteractionEnabled = NO;
    [_psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
    [_psuhBtn addTarget:self action:@selector(publishAwardNameListClick:) forControlEvents:UIControlEventTouchUpInside];
    [_psuhView addSubview:_psuhBtn];
    [self.view addSubview:_psuhView];
}
#pragma mark -- 公布获奖名单
- (void)publishAwardNameListClick:(UIButton *)btn{
    btn.enabled = NO;
    
    [Helper alertViewWithTitle:@"确定发布获奖名单？" withBlockCancle:^{
        //
    } withBlockSure:^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(_activityKey) forKey:@"activityKey"];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [dict setObject:_prizeListArray forKey:@"prizeList"];
        [[JsonHttp jsonHttp]httpRequest:@"team/doPublishNameList" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
            btn.enabled = YES;
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [[ShowHUD showHUD]showToastWithText:@"发布成功！" FromView:self.view];
                [self performSelector:@selector(pushCtrl) withObject:self afterDelay:TIMESlEEP];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
    
    btn.enabled = YES;
}

#pragma mark -- 跳转
- (void)pushCtrl{
    [self loadData];
}
#pragma mark -- 获取活动权限
- (void)getActivityManager{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(_activityKey) forKey:@"activityKey"];
    
    [dict setValue:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"error");
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            if ([data objectForKey:@"teamMember"]) {
                dict = [data objectForKey:@"teamMember"];
                if ([dict objectForKey:@"power"]) {
                    NSString *power = [dict objectForKey:@"power"];
                    if (power) {
                        if ([power containsString:@"1001"]) {
                            _isManager = 1;
                        }else{
                            _isManager = 0;
                        }
                    }else{
                        _isManager = 0;
                    }
                }
            }else{
                _isManager = 0;//非管理员
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isManager == 1) {
                    [self createPublishAwardNameListBtn];
                }
                
                [_tableView.header beginRefreshing];
            });
            
        }else{
            
        }
    }];
}
#pragma mark -- 下载数据
- (void)loadData{
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];    
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    NSString *urlString = nil;
    if (_isManager == 1) {
        urlString = @"getTeamActivityPrizeAllList";
    }else{
        urlString = @"getAwardedInfo";
        _tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:[NSString stringWithFormat:@"team/%@", urlString] JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [_dataArray removeAllObjects];
        [_prizeListArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _strTeamName = [data objectForKey:@"teamName"];
            NSArray *array = [NSMutableArray array];
            array = [data objectForKey:@"list"];
            if (array.count == 0) {
                _psuhView.hidden = YES;
            }else{
                _psuhView.hidden = NO;
            }
            
            for (NSDictionary *dict in array) {
                JGHAwardModel *model = [[JGHAwardModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
                
                //提交的参数
                NSMutableDictionary *prizeDict = [NSMutableDictionary dictionary];
                if (_isManager == 1) {
                    [prizeDict setObject:model.teamKey forKey:@"teamKey"];
                }
                
                [prizeDict setObject:model.timeKey forKey:@"timeKey"];
                [prizeDict setObject:@(_activityKey) forKey:@"teamActivityKey"];
                [prizeDict setObject:model.name forKey:@"name"];
                if ([Helper isBlankString:model.prizeName]) {
                    [prizeDict setObject:@"" forKey:@"prizeName"];
                }else{
                    [prizeDict setObject:model.prizeName forKey:@"prizeName"];
                }
                
                [prizeDict setObject:model.prizeSize forKey:@"prizeSize"];
                if (![Helper isBlankString:model.signupKeyInfo]) {
                    [prizeDict setObject:model.signupKeyInfo forKey:@"signupKeyInfo"];
                }
                
                if (![Helper isBlankString:model.userInfo]) {
                    [prizeDict setObject:model.userInfo forKey:@"userInfo"];

                }
                
                [_prizeListArray addObject:prizeDict];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self pollingAwareNameList];//轮询奖项是否设置获奖人
        
        if (_dataArray.count == 0) {
            [self createNoData];
        }else{
            for(UIView *view in [self.bgView subviews])
            {
                [view removeFromSuperview];
            }
            
            [_bgView removeFromSuperview];
        }
        
        [_tableView.header endRefreshing];
        
        [_tableView reloadData];
        
    }];
}
#pragma mark -- 轮询活动奖项是否设置获奖人，如果全部设置，显示发布按钮
- (void)pollingAwareNameList{
    NSInteger countAware = 0;
    for (NSDictionary *dict in _prizeListArray) {
        if ([[dict objectForKey:@"signupKeyInfo"] length] >0) {
            countAware += 1;
        }
    }
    
    if (countAware >0) {
        [_psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
        _psuhBtn.userInteractionEnabled = YES;
    }else{
        [_psuhBtn setBackgroundColor:[UIColor lightGrayColor]];
        _psuhBtn.userInteractionEnabled = NO;
    }
}
#pragma mark --未发布
- (void)createNoData{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2 - 45*ProportionAdapter, screenHeight/2 - 110*ProportionAdapter, 80*ProportionAdapter, 100*ProportionAdapter)];
    UIImageView *weifabuImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, self.bgView.frame.size.width-20*ProportionAdapter, self.bgView.frame.size.height - 40*ProportionAdapter)];
    weifabuImageview.image = [UIImage imageNamed:@"weifabutishi"];
    [self.bgView addSubview:weifabuImageview];
    
    UILabel *weifaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, weifabuImageview.frame.size.height + 15*ProportionAdapter, self.bgView.frame.size.width, 20*ProportionAdapter)];
    weifaLabel.text = @"暂未发布奖项";
    weifaLabel.textAlignment = NSTextAlignmentCenter;
    weifaLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    weifaLabel.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:weifaLabel];
    [_tableView addSubview:self.bgView];
}
-(void)createHeader
{
    _viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 84*screenWidth/375)];
    _viewBack.backgroundColor = [UIColor whiteColor];
    
    UIImageView* iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, 64*screenWidth/375, 64*screenWidth/375)];
    iconImgv.image = [UIImage imageNamed:DefaultHeaderImage];
    iconImgv.layer.masksToBounds = YES;
    iconImgv.layer.cornerRadius = 8*screenWidth/375;
    [_viewBack addSubview:iconImgv];
    //头像
    if (_model.teamActivityKey == 0) {
        [iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    }else{
        [iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    }
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(94*screenWidth/375, 10*screenWidth/375, 200*screenWidth/375, 25*screenWidth/375)];
    titleLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
    if (![Helper isBlankString:_model.name]) {
        titleLabel.text = _model.name;
    }
    else{
        titleLabel.text = @"暂无活动名称";
    }
    [_viewBack addSubview:titleLabel];
    
    UIImageView* timeImgv = [[UIImageView alloc]initWithFrame:CGRectMake(93*screenWidth/375, 38*screenWidth/375, 13*screenWidth/375, 14*screenWidth/375)];
    timeImgv.image = [UIImage imageNamed:@"time"];
    [_viewBack addSubview:timeImgv];
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(115*screenWidth/375, 35*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
    timeLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    //活动时间componentsSeparatedByString
    NSString *timeString = [[_model.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    if (monthTimeString) {
        timeLabel.text = [NSString stringWithFormat:@"%@月%@日", monthTimeString, dataTimeString];
    }
    
    timeLabel.textColor = [UIColor lightGrayColor];
    [_viewBack addSubview:timeLabel];
    
    UIImageView* distanceImgv = [[UIImageView alloc]initWithFrame:CGRectMake(95*screenWidth/375, 58*screenWidth/375, 9*screenWidth/375, 14*screenWidth/375)];
    distanceImgv.image = [UIImage imageNamed:@"juli"];
    [_viewBack addSubview:distanceImgv];
    
    UILabel* distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(115*screenWidth/375, 55*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
    distanceLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    if (![Helper isBlankString:_model.ballName]) {
        distanceLabel.text = _model.ballName;
    }
    else{
        distanceLabel.text = @"暂无活动地址";
    }

    [_viewBack addSubview:distanceLabel];
}
#pragma mark --创建TB
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 65*ProportionAdapter -64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _viewBack;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [_tableView registerClass:[JGLPresentAwardTableViewCell class] forCellReuseIdentifier:@"JGLPresentAwardTableViewCell"];
    
//    [_tableView registerClass:[JGDActvityPriziSetTableViewCell class] forCellReuseIdentifier:@"setCell"];
    
    _tableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
    _tableView.backgroundColor = [UIColor colorWithHexString:BG_color];
}
#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 1.0;
    }
    return 10*screenWidth/320;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*screenWidth/320)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    JGHAwardModel *model = [[JGHAwardModel alloc]init];
    if (indexPath.section == 0) {
        return 44*ProportionAdapter;
    }else{
        model = _dataArray[indexPath.section-1];
        height = [Helper textHeightFromTextString:model.name width:screenWidth - 54*screenWidth/320 fontSize:15*screenWidth/320];
        return 85*screenWidth/320 + height;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count +1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *JGDActvityPriziSetTableViewCellID = @"JGDActvityPriziSetTableViewCell";
        JGDActvityPriziSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGDActvityPriziSetTableViewCellID];
        if (cell == nil) {
             cell = [[JGDActvityPriziSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JGDActvityPriziSetTableViewCellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLB.text = [NSString stringWithFormat:@"活动奖项（%td）", _dataArray.count];
        
        if (_isManager == 1) {
            [cell.contentView addSubview:cell.presentationBtn];
            
            [cell.presentationBtn addTarget:self action:@selector(prizeSet) forControlEvents:(UIControlEventTouchUpInside)];
        }else{
            cell.presentationBtn.hidden = YES;
        }
        return cell;
    }else{
        static NSString *JGLPresentAwardTableViewCellID = @"JGLPresentAwardTableViewCell";
        JGLPresentAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGLPresentAwardTableViewCellID];
        if (cell == nil) {
            cell = [[JGLPresentAwardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JGLPresentAwardTableViewCellID];
        }
        
        if (_isManager == 1) {
            cell.chooseBtn.tag = indexPath.section + 100 -1;
            [cell.chooseBtn addTarget:self action:@selector(chooseAwarderClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.chooseBtn.hidden = YES;
        }
        
        [cell configJGHAwardModel:_dataArray[indexPath.section -1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isManager == 1) {
        if (indexPath.section > 0) {
            JGDActivityListViewController *listerErctrl = [[JGDActivityListViewController alloc]init];
            listerErctrl.activityKey = _activityKey;
            listerErctrl.checkdict = _prizeListArray[indexPath.section-1];
            listerErctrl.delegate = self;
            listerErctrl.awardId = indexPath.section-1;
            [self.navigationController pushViewController:listerErctrl animated:YES];
        }
    }
}
#pragma mark -- 奖项设置
- (void)prizeSet{
    JGHSetAwardViewController *setAwardVC = [[JGHSetAwardViewController alloc] init];
    setAwardVC.activityKey = self.activityKey;
    setAwardVC.teamKey = self.teamKey;
    setAwardVC.model = self.model;
    setAwardVC.refreshBlock = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [_tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:setAwardVC animated:YES];
}
#pragma mark -- 选择获奖者
- (void)chooseAwarderClick:(UIButton *)btn{
    if (_isManager == 1) {
        JGDActivityListViewController *listerErctrl = [[JGDActivityListViewController alloc]init];
        listerErctrl.activityKey = _activityKey;
        listerErctrl.checkdict = _prizeListArray[btn.tag - 100];
        listerErctrl.delegate = self;
        listerErctrl.awardId = btn.tag - 100;
        [self.navigationController pushViewController:listerErctrl animated:YES];
    }
}
#pragma mark -- 选择颁奖人后返回的代理
- (void)saveBtnDict:(NSMutableDictionary *)dict andAwardId:(NSInteger)awardId{
    NSLog(@"awardId ＝＝ %td", awardId);
    [_prizeListArray replaceObjectAtIndex:awardId withObject:dict];
    
    JGHAwardModel *model = [[JGHAwardModel alloc]init];
    model = _dataArray[awardId];
    model.signupKeyInfo = [dict objectForKey:@"signupKeyInfo"];
    model.userInfo = [dict objectForKey:@"userInfo"];
    
    [_dataArray replaceObjectAtIndex:awardId withObject:model];
    
    [_tableView reloadData];
    
    [self pollingAwareNameList];
}
#pragma mark -- 分享
- (void)saveAwardNameClick:(UIBarButtonItem *)item{
    item.enabled = NO;
    //        self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexRow];
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
    
    item.enabled = YES;
}
#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
//    http://imgcache.dagolfla.com/share/team/awardedPrize.html?teamKey=587857&activityKey=587860&userKey=529&from=groupmessage&isappinstalled=1
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
    if ([_model.timeKey integerValue] == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES]];
        
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/awardedPrize.html?activityKey=%ld&userKey=%@",(long)self.activityKey,DEFAULF_USERID];
    }
    else
    {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue]andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/awardedPrize.html?activityKey=%ld&userKey=%@",(long)self.activityKey,DEFAULF_USERID];
    }
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@%@的获奖名单", _strTeamName,_model.name];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@的获奖名单", _strTeamName,_model.name]  image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@%@的获奖名单", _strTeamName,_model.name] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
        data.shareText = [NSString stringWithFormat:@"%@%@的获奖名单", _strTeamName,_model.name];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
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
