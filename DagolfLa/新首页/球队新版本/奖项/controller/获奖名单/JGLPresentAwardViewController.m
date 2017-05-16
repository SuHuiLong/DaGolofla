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
//#import "JGHSetAwardViewController.h"
#import "JGDAwardSetViewController.h"

@interface JGLPresentAwardViewController ()<UITableViewDelegate,UITableViewDataSource, JGDActivityListViewControllerDelegate>
{
    NSMutableArray* _dataArray;
    UITableView* _tableView;
    UIView* _viewBack;
    NSMutableArray *_prizeListArray;
    NSString* _strTeamName;
    //UIView *_psuhView;
    //UIButton *_psuhBtn;
    
    NSInteger _isManager;
    
    
}

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, strong)UIView *psuhView;

@property (nonatomic, strong)UIButton *psuhBtn;

@end

@implementation JGLPresentAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.title = @"颁奖";
    
    if (!_model) {
        _model = [[JGTeamAcitivtyModel alloc]init];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(saveAwardNameClick:)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _dataArray = [NSMutableArray array];
    _prizeListArray = [NSMutableArray array];
    
    [self uiConfig];
    
    dispatch_queue_t queue = dispatch_queue_create("activityQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self getActivityManager];
    });
//    [self loadData];
}

- (UIView *)psuhView{
    if (_psuhView == nil) {
        _psuhView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 65*ProportionAdapter - 64, screenWidth, 65*ProportionAdapter)];
//        _psuhView.backgroundColor = [UIColor whiteColor];
        [_psuhView addSubview:_psuhBtn];
        [_psuhView addSubview:self.psuhBtn];
    }
    return _psuhView;
}
- (UIButton *)psuhBtn{
    if (_psuhBtn == nil) {
        _psuhBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 65*ProportionAdapter - 20*ProportionAdapter)];
        [_psuhBtn setTitle:@"发布" forState:UIControlStateNormal];
        _psuhBtn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
        _psuhBtn.layer.masksToBounds = YES;
        _psuhBtn.layer.cornerRadius = 8.0 *ProportionAdapter;
        _psuhBtn.userInteractionEnabled = NO;
        [_psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
        [_psuhBtn addTarget:self action:@selector(publishAwardNameListClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _psuhBtn;
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
                [LQProgressHud showMessage:@"发布成功！"];
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
            
            if ([data objectForKey:@"activity"]) {
                [_model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self createHeader];
                
                [_tableView.mj_header beginRefreshing];
            });
            
        }else{
            
        }
    }];
}
#pragma mark -- 下载数据
- (void)loadData{
//    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
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

    } completionBlock:^(id data) {
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
        
        [_bgView removeFromSuperview];
        _bgView = nil;
        if (_dataArray.count == 0) {
            [_tableView addSubview:self.bgView];
        }
        
        [_tableView.mj_header endRefreshing];
        
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
    
    if (_prizeListArray.count >0) {
        if (_isManager == 1 && _psuhView == nil) {
            [self.view addSubview:self.psuhView];
        }
        
        if (_isManager == 1) {
            _tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight -65*ProportionAdapter -64);
        }else{
            _tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
        }
    }else{
        _tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
        [self.psuhView removeFromSuperview];
        self.psuhView = nil;
    }
    
    if (countAware >0) {
        [_psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
        _psuhBtn.userInteractionEnabled = YES;
    }else{
        [_psuhBtn setBackgroundColor:[UIColor lightGrayColor]];
        _psuhBtn.userInteractionEnabled = NO;
        
    }
}
- (UIView *)bgView{
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kHorizontal(220), screenWidth, 300)];
        UIImageView *weifabuImageview = [[UIImageView alloc]initWithFrame:CGRectMake(kWvertical(65), 0, screenWidth - kWvertical(106), kHvertical(153))];
        weifabuImageview.image = [UIImage imageNamed:@"bg_set_awards"];
        [_bgView addSubview:weifabuImageview];
        
        UILabel *weifaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kHvertical(190), screenWidth, 20*ProportionAdapter)];
        weifaLabel.text = @"暂未发布奖项";
        weifaLabel.textAlignment = NSTextAlignmentCenter;
        weifaLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        weifaLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        [_bgView addSubview:weifaLabel];
        
    }
    return _bgView;
}

-(void)createHeader
{
    
    UILabel *backLB = [Helper lableRect:CGRectMake(0, 0, screenWidth, 91 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#F5F5F5"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
    backLB.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    _viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 81*screenWidth/375)];
    _viewBack.backgroundColor = [UIColor whiteColor];
    
    UIImageView* iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 6*screenWidth/375, 69*screenWidth/375, 69*screenWidth/375)];
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
    titleLabel.font = [UIFont systemFontOfSize:17*screenWidth/375];
    titleLabel.textColor = [UIColor colorWithHexString:@"#313131"];
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
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(115*screenWidth/375, 35*screenWidth/375, 230*screenWidth/375, 20*screenWidth/375)];
    timeLabel.font = [UIFont systemFontOfSize:13*screenWidth/375];
    //活动时间componentsSeparatedByString
    NSString *timeString = [[_model.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    if (monthTimeString) {
        timeLabel.text = [NSString stringWithFormat:@"%@月%@日", monthTimeString, dataTimeString];
    }
    
    timeLabel.textColor = [UIColor colorWithHexString:@"#626262"];
    [_viewBack addSubview:timeLabel];
    
    UIImageView* distanceImgv = [[UIImageView alloc]initWithFrame:CGRectMake(95*screenWidth/375, 58*screenWidth/375, 9*screenWidth/375, 14*screenWidth/375)];
    distanceImgv.image = [UIImage imageNamed:@"juli"];
    [_viewBack addSubview:distanceImgv];
    
    UILabel* distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(115*screenWidth/375, 55*screenWidth/375, 250*screenWidth/375, 20*screenWidth/375)];
    distanceLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    distanceLabel.textColor = [UIColor colorWithHexString:@"#626262"];
    if (![Helper isBlankString:_model.ballName]) {
        distanceLabel.text = _model.ballName;
    }
    else{
        distanceLabel.text = @"暂无活动地址";
    }

    [_viewBack addSubview:distanceLabel];
    [backLB addSubview:_viewBack];
    _tableView.tableHeaderView = backLB;
}
#pragma mark --创建TB
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 65*ProportionAdapter -64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
    _tableView.backgroundColor = [UIColor colorWithHexString:BG_color];
}
#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

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
    if (indexPath.section == 0) {
        return kHvertical(50);
    }else{
        
        JGHAwardModel *model = _dataArray[indexPath.row];
        CGFloat rowHeigth = [Helper getSpaceLabelHeight:model.userInfo withFont:[UIFont systemFontOfSize:kHorizontal(15)] withWidth:screenWidth - kWvertical(140)];

        if ([model.isPublish integerValue] == 0) {
            return _isManager ? kHvertical(152) : kHvertical(101);
        }else{
            return _isManager ? kHvertical(152) : kHvertical(152) + rowHeigth;
        }
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
        cell.titleLB.text = [NSString stringWithFormat:@"（%td）", _dataArray.count];
       
        if (_isManager == 1) {
            cell.presentationBtn.hidden = NO;
            cell.chooseImageV.hidden = NO;
        }else{
            cell.presentationBtn.hidden = YES;
            cell.chooseImageV.hidden = YES;
        }
        return cell;
    }else{
        static NSString *JGLPresentAwardTableViewCellID = @"JGLPresentAwardTableViewCell";
        JGLPresentAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGLPresentAwardTableViewCellID];
        if (cell == nil) {
            cell = [[JGLPresentAwardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JGLPresentAwardTableViewCellID];
        }
        cell.isManager = _isManager;
        
        if (_isManager == 1) {
            cell.chooseBtn.tag = indexPath.section + 100 -1;
            [cell.chooseBtn addTarget:self action:@selector(chooseAwarderClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.chooseImageV.hidden = NO;
        }else{
            cell.chooseBtn.hidden = YES;
            cell.chooseImageV.hidden = YES;
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

        }else{
            [self prizeSet];
        }
    }
}
#pragma mark -- 奖项设置
- (void)prizeSet{
    
    JGDAwardSetViewController *setAwardVC = [[JGDAwardSetViewController alloc] init];
    setAwardVC.activityKey = self.activityKey;
    setAwardVC.teamKey = self.teamKey;
    setAwardVC.model = self.model;
    setAwardVC.refreshBlock = ^(){
        [_tableView.mj_header endRefreshing];
        _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [_tableView.mj_header beginRefreshing];
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
