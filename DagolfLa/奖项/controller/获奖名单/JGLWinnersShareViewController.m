//
//  JGLWinnersShareViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLWinnersShareViewController.h"
#import "JGLWinnersShareTableViewCell.h"
#import "JGHActivityBaseCell.h"
#import "JGDPrizeViewController.h"
#import "JGLWinnerShareModel.h"
#import "JGHLoginViewController.h"

@interface JGLWinnersShareViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _dataArray;
    UITableView* _tableView;
    UIView* _viewBack;
    NSInteger _page;
}
@end

@implementation JGLWinnersShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    itemleft.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = itemleft;
    
    self.navigationItem.title = @"获奖名单";
    
    _dataArray = [[NSMutableArray alloc]init];
    _page = 0;
    
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBarItemClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    
//    [self createHeader];
    [self uiConfig];
    
  
}
#pragma mark --返回
- (void)backButtonClcik{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGDPrizeViewController class]]) {
//            JGDPrizeViewController *prizeCtrl = [[JGDPrizeViewController alloc]init];
//            prizeCtrl.model = _model;
//            prizeCtrl.activityKey = [_activeKey integerValue];
//            prizeCtrl.teamKey = _teamKey;
            [self.navigationController popToViewController:controller animated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}

-(void)shareBarItemClick
{
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
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
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
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[self.activeKey integerValue] andIsSetWidth:YES andIsBackGround:YES]];
    
    
    //
    shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/awardedPrize.html?teamKey=%td&activityKey=%td&userKey=%@", _teamKey,[self.activeKey integerValue],DEFAULF_USERID];
    
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

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _viewBack;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[JGLWinnersShareTableViewCell class] forCellReuseIdentifier:@"JGLWinnersShareTableViewCell"];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    //587857      587860
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_activeKey forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getAwardedInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }
    } completionBlock:^(id data) {
        NSLog(@"%@",data);
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"list"])
            {
                JGLWinnerShareModel *model = [[JGLWinnerShareModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:[data objectForKey:@"packResultMsg"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}


#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*screenWidth/375;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*screenWidth/375)];
//    view.backgroundColor = [UIColor colorWithHexString:BG_color];
//    return view;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


static CGFloat height;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    height = 25*screenWidth/375;
    if (_dataArray.count != 0) {
        height = [Helper textHeightFromTextString:[_dataArray[indexPath.row] userInfo] width:screenWidth - 54*screenWidth/375 fontSize:14*screenWidth/375];
    }
    return indexPath.section == 0 ? 80*screenWidth/375 : 44*screenWidth/375 + height + 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *JGHActivityBaseCellIdentifier = @"JGHActivityBaseCell";
        JGHActivityBaseCell *activityBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityBaseCellIdentifier];
        if (activityBaseCell == nil) {
            activityBaseCell = [[[NSBundle mainBundle]loadNibNamed:@"JGHActivityBaseCell" owner:self options:nil] lastObject];
        }

        [activityBaseCell configJGTeamActivityModel:_model];
        return activityBaseCell;
    }
    else{
        JGLWinnersShareTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLWinnersShareTableViewCell" forIndexPath:indexPath];
        cell.nameLabel.frame = CGRectMake(44*screenWidth/375, 44*screenWidth/375, screenWidth - 54*screenWidth/375, height);
        cell.nameLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
