//
//  JGDPrizeViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPrizeViewController.h"
#import "JGDtopTableViewCell.h"
#import "JGDprizeTableViewCell.h"
#import "JGDActvityPriziSetTableViewCell.h"
#import "JGLPresentAwardViewController.h"
#import "JGHSetAwardViewController.h"
#import "JGHActivityBaseCell.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "EnterViewController.h"
#import "JGLWinnersShareViewController.h"

@interface JGDPrizeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation JGDPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动奖项";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self createTableView];
    
    [self createPublishAwardNameListBtn];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:(UIBarButtonItemStyleDone) target:self action:@selector(shareAct)];
    barBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barBtn;
    // Do any additional setup after loading the view.
}

#pragma mark -分享
- (void)shareAct{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        //        self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexRow];
        
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
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
#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{

    
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
    if ([_model.timeKey integerValue] == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES]];
        
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamPrize.html?activityKey=%ld&userKey=%@",(long)self.activityKey,DEFAULF_USERID];
    }
    else
    {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue]andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamPrize.html?activityKey=%ld&userKey=%@",(long)self.activityKey,DEFAULF_USERID];
    }
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@ 奖品", _model.name];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@ 奖品", _model.name]  image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@ 奖品", _model.name] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -65*ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDprizeTableViewCell class] forCellReuseIdentifier:@"prizeCell"];
    UINib *activityBaseCellNib = [UINib nibWithNibName:@"JGHActivityBaseCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib:activityBaseCellNib forCellReuseIdentifier:@"topCell"];
    [self.tableView registerClass:[JGDActvityPriziSetTableViewCell class] forCellReuseIdentifier:@"setCell"];
    _page = 0;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];

    [self.view addSubview:self.tableView];
}
#pragma mark -- 创建工具栏
- (void)createPublishAwardNameListBtn{
    UIView *psuhView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 65*ProportionAdapter - 64, screenWidth, 65*ProportionAdapter)];
    psuhView.backgroundColor = [UIColor whiteColor];
    UIButton *psuhBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 65*ProportionAdapter - 20*ProportionAdapter)];
    [psuhBtn setTitle:@"公布获奖名单" forState:UIControlStateNormal];
    [psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
    psuhBtn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    psuhBtn.layer.masksToBounds = YES;
    psuhBtn.layer.cornerRadius = 8.0;
    [psuhBtn addTarget:self action:@selector(publishAwardNameListClick:) forControlEvents:UIControlEventTouchUpInside];
    [psuhView addSubview:psuhBtn];
    [self.view addSubview:psuhView];
}
#pragma mark -- 公布获奖名单
- (void)publishAwardNameListClick:(UIButton *)btn{
    btn.enabled = NO;
    
    [Helper alertViewWithTitle:@"确定公布获奖名单？" withBlockCancle:^{
        //
    } withBlockSure:^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(_activityKey) forKey:@"activityKey"];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        //    [dict setObject:_prizeListArray forKey:@"prizeList"];
        [[JsonHttp jsonHttp]httpRequest:@"team/doPublishNameList" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
            btn.enabled = YES;
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [[ShowHUD showHUD]showToastWithText:@"发布成功！" FromView:self.view];
                [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
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
    JGLWinnersShareViewController *winnerCtrl = [[JGLWinnersShareViewController alloc]init];
    winnerCtrl.model = _model;
    winnerCtrl.activeKey = [NSNumber numberWithInteger:_activityKey];
    winnerCtrl.teamKey = _teamKey;
    [self.navigationController pushViewController:winnerCtrl animated:YES];
}
// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:self.activityKey] forKey:@"activityKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getPublishPrizeList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errtype == %@", errType);
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            self.dataArray = [data objectForKey:@"list"];
            
            if (self.dataArray.count == 0) {

                self.tableView.frame = CGRectMake(0, 0, screenWidth, 144 * ProportionAdapter);
                self.tableView.scrollEnabled = NO;
              
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(150 * ProportionAdapter, 200 * ProportionAdapter, 76 * ProportionAdapter, 76 * ProportionAdapter)];
                imageV.image = [UIImage imageNamed:@"weifabutishi"];
                [self.view addSubview:imageV];
               
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(143 * ProportionAdapter, 280 * ProportionAdapter, 200 * ProportionAdapter, 76 * ProportionAdapter)];
                lable.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
                lable.textColor = [UIColor colorWithHexString:@"#999999"];
                lable.text = @"暂未发布奖项";
                [self.view addSubview:lable];
                
            }else{
                
            }
            
            [self.tableView reloadData];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }

    }];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JGHActivityBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        [cell configJGTeamActivityModel:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            JGDActvityPriziSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLB.text = [NSString stringWithFormat:@"活动奖项（%td）",self.dataArray.count];
            
            if (self.isManager != 1) {
                
                [cell.contentView addSubview:cell.presentationBtn];
                [cell.contentView addSubview:cell.prizeBtn];
                
                [cell.presentationBtn addTarget:self action:@selector(present) forControlEvents:(UIControlEventTouchUpInside)];
                [cell.prizeBtn addTarget:self action:@selector(prizeSet) forControlEvents:(UIControlEventTouchUpInside)];
            }
            return cell;
        }else{
            
            JGDprizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prizeCell"];
            cell.nameLabel.text = [self.dataArray[indexPath.row - 1] objectForKey:@"name"];
            cell.prizeLbel.text = [self.dataArray[indexPath.row - 1] objectForKey:@"prizeName"];
            cell.numberLabel.text = [[self.dataArray[indexPath.row - 1] objectForKey:@"prizeSize"] stringValue];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
    }
}

//
- (void)prizeSet{
    JGHSetAwardViewController *setAwardVC = [[JGHSetAwardViewController alloc] init];
    setAwardVC.activityKey = self.activityKey;
    setAwardVC.teamKey = self.teamKey;
    setAwardVC.model = self.model;
    setAwardVC.refreshBlock = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:setAwardVC animated:YES];
}


//立即颁奖
- (void)present{
    
    JGLPresentAwardViewController *preVC = [[JGLPresentAwardViewController alloc] init];
    preVC.activityKey = _activityKey;
    preVC.model = _model;
    preVC.refreshBlock = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:preVC animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80 * ProportionAdapter;
    }else{
        return 44 * ProportionAdapter;
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
