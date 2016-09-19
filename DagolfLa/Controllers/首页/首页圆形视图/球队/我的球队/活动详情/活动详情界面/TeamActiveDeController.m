//
//  TeamActiveDeController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamActiveDeController.h"
#import "TeamMessageController.h"
#import "Setbutton.h"
#import "HorButtonSet.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "ActiveManageController.h"

#import "ActiveNumViewController.h"

#import "ScoreByActiveViewController.h"

#import "TeamPeopleModel.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "ChatDetailViewController.h"

#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "TeamInviteViewController.h"

//#import "ManageWatchViewController.h"

#import "PersonHomeController.h"


@interface TeamActiveDeController ()<UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    
    NSString* _str;
    CGFloat _height;
    
    NSMutableDictionary* _dict;
    MBProgressHUD* _progressHud;
    
    NSMutableArray* _dataArray;
    
    MBProgressHUD* _progre;
        
    NSMutableArray* _arrayIndex,* _arrayData1,* _arrayData,* _messageArray,* _telArray;
}

@end

@implementation TeamActiveDeController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
}
-(void)manageClick
{
    ActiveManageController* actVc = [[ActiveManageController alloc]init];
    actVc.teamactId = _model.teamActivityId;
    actVc.teamId = _model.team_Id;
    [self.navigationController pushViewController:actVc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    
    
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamActivityId forKeyedSubscript:@"teamActivityId"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKeyedSubscript:@"userId"];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_scrollView];
    _dataArray = [[NSMutableArray alloc]init];
    
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"正在刷新...";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
    [[PostDataRequest sharedInstance] postDataRequest:@"TTeamActivity/get.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        //NSLog(@"%@",dictData);
        
        if ([[dictData objectForKey:@"success"]integerValue] == 1) {
            
            _model = [[TeamActiveModel alloc]init];
            [_model setValuesForKeysWithDictionary:[dictData objectForKey:@"rows"]];
            _str = [[NSString alloc]init];
            //右边按钮
            if ([_model.forrelevant integerValue] == 1) {
                UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(manageClick)];
                rightBtn.tintColor = [UIColor whiteColor];
                self.navigationItem.rightBarButtonItem = rightBtn;
            }
            if ([Helper isBlankString:_model.activityContent]) {
                _str = @"暂无简介。。。";
            }
            else
            {
                _str = _model.activityContent;
            }
            _height = [Helper textHeightFromTextString:_str width:ScreenWidth-20*ScreenWidth/320 fontSize:14*ScreenWidth/320];
            if (_height < 30*ScreenWidth/320) {
                _height = 30*ScreenWidth/320;
            }
            
            
            
            _dict = [[NSMutableDictionary alloc]init];
            
            [self showPeoView];
            
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_progressHud animated:YES];
    }];
    
}

-(void)showPeoView
{
    
    if (_dataArray.count != 0) {
        [_dataArray removeAllObjects];
    }
    NSMutableDictionary* dictPeo = [[NSMutableDictionary alloc]init];
    [dictPeo setObject:@-1 forKey:@"page"];
    [dictPeo setObject:@-1 forKey:@"rows"];
    [dictPeo setObject:@11 forKey:@"type"];
    [dictPeo setObject:_teamActivityId forKey:@"teamId"];
    [[PostDataRequest sharedInstance]postDataRequest:@"tTeamApply/queryByUserList.do" parameter:dictPeo success:^(id respondsData) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
//        //NSLog(@"%@",dictData);
        
        if ([[dictData objectForKey:@"success"] integerValue] == 1) {
            
            for (NSDictionary* dictD in [dictData objectForKey:@"rows"]) {
                TeamPeopleModel* model = [[TeamPeopleModel alloc]init];
                [model setValuesForKeysWithDictionary:dictD];
                [_dataArray addObject:model];
            }
        }
        //最上的头视图
        [self createMainHead];
        //简介
        [self creteTeamDetail];
        //发起人
        [self createPeopleView];
        //已报名人数
        [self createMember];
        //活动详情
        [self createDetail];
        //活动记分
        [self createBtnRecord];
        
        if (_dataArray.count == 0) {
            _scrollView.contentSize = CGSizeMake(0, 410*ScreenWidth/320 + 30*ScreenWidth/320 + _height);
        }
        else
        {
            _scrollView.contentSize = CGSizeMake(0,  380*ScreenWidth/320 + 60*ScreenWidth/320*((_dataArray.count-1)/6+1) + _height);
        }
        
    } failed:^(NSError *error) {
        
    }];
}

/**
 *  最上方视图
 */
-(void)createMainHead
{
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 5*ScreenWidth/320, 60*ScreenWidth/320, 60*ScreenWidth/320)];
    //    imgv.image = [UIImage imageNamed:@"tu3"];
    [imgv sd_setImageWithURL:[Helper imageIconUrl:_model.treamPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    [_scrollView addSubview:imgv];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/320, 20*ScreenWidth/320, ScreenWidth-90*ScreenWidth/320, 30*ScreenWidth/320)];
    //    labelTitle.text = @"球队名称：高尔夫";
    
    if ([Helper isBlankString:_model.treamName]) {
        _model.treamName  = @"暂无球队名";
    }
    
    labelTitle.text = [NSString stringWithFormat:@"球队名:%@",_model.treamName];
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/320];
    [_scrollView addSubview:labelTitle];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 69*ScreenWidth/320, ScreenWidth, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:viewLine];
    
    
}

-(void)creteTeamDetail
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 70*ScreenWidth/320, ScreenWidth, 160*ScreenWidth/320)];
    [_scrollView addSubview:viewBase];
    /**
     *  球队介绍
     */
    NSString* strTitle = [NSString stringWithFormat:@"标题:%@",_model.teamActivityTitle];
    NSString* strBall = [NSString stringWithFormat:@"球场:%@",_model.ballName];
    NSString* strPrice, *strPeo, * strPhone,* strStart,* strEnd;
    if ([_model.onePeooleprices integerValue] == -1) {
        strPrice = [NSString stringWithFormat:@"价格:不限"];

    }
    else
    {
        strPrice = [NSString stringWithFormat:@"价格:%@",_model.onePeooleprices];
    }
    
    
    if (![Helper isBlankString:_model.contactperson]) {
        strPeo = [NSString stringWithFormat:@"联系人:%@",_model.contactperson];
    }
    else
    {
        strPeo = [NSString stringWithFormat:@"联系人:活动暂无联系人"];
    }
    if (![Helper isBlankString:_model.contactphone]) {
        strPhone = [NSString stringWithFormat:@"联系人电话:%@",_model.contactphone];
    }
    else
    {
        strPhone = [NSString stringWithFormat:@"联系人电话:暂无联系人电话"];
    }
    if (![Helper isBlankString:_model.beginDate]) {
        strStart = [NSString stringWithFormat:@"活动开始时间:%@",_model.beginDate];
    }
    else
    {
        strStart = [NSString stringWithFormat:@"活动开始时间:不限时间"];
    }
    if (![Helper isBlankString:_model.endDate]) {
        strEnd = [NSString stringWithFormat:@"活动结束时间:%@",_model.endDate];
    }
    else
    {
        strStart = [NSString stringWithFormat:@"活动结束时间:不限时间"];
    }
    
    
    NSArray* titleArr = @[strTitle,strBall,strPrice,strStart,strEnd,strPeo,strPhone];
    for (int i = 0; i < 7; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 10*ScreenWidth/320+20*ScreenWidth/320*i, ScreenWidth-20*ScreenWidth/320, 20*ScreenWidth/320)];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
        label.text = titleArr[i];
        [viewBase addSubview:label];
    }
}


/**
 *  创建者头像点击事件
 */
-(void)createPeopleView
{
    UIView* viewPeople = [[UIView alloc]initWithFrame:CGRectMake(0, 230*ScreenWidth/320, ScreenWidth, 90*ScreenWidth/320)];
    [_scrollView addSubview:viewPeople];
    
    
    
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/320)];
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"   发起人";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [viewPeople addSubview:labelFenge];
    
    Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
    item.frame = CGRectMake(10*ScreenWidth/320, 35*ScreenWidth/320, 50*ScreenWidth/320, 60*ScreenWidth/320);
    [viewPeople addSubview:item];
    item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
    item.imageView.layer.masksToBounds = YES;
    item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [item setTitle:_model.userName forState:UIControlStateNormal];
//    [item sd_setImageWithURL:[Helper imageIconUrl:_model.userPic] forState:UIControlStateNormal];
    [item sd_setImageWithURL:[Helper imageIconUrl:_model.userPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item addTarget:self action:@selector(selfDetailClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selfDetailClick {
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = _model.activityCreateUser;
    selfVc.messType = @11;
    [self.navigationController pushViewController:selfVc animated:YES];
}


//球队成员
-(void)createMember
{
    UIView * view = [[UIView alloc]init];
    if (_dataArray.count == 0) {
        view.frame = CGRectMake(0, 320*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320 + 60*ScreenWidth/320);
    }
    else
    {
        view.frame = CGRectMake(0, 320*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320 + 60*ScreenWidth/320*((_dataArray.count-1)/6+1));
        
    }
    
    [_scrollView addSubview:view];
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/320)];
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"   参加成员";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [view addSubview:labelFenge];
    


    if (_dataArray.count != 0) {
        for (int i = 0; i<_dataArray.count; i++) {
            Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(7*ScreenWidth/320 + 60*ScreenWidth/320*(i%6),30*ScreenWidth/320 + 60*ScreenWidth/320 * (i/6), 60*ScreenWidth/320, 60*ScreenWidth/320);
            [view addSubview:item];
            
            item.imageView.layer.masksToBounds = YES;
            item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
            if (![Helper isBlankString:[_dataArray[i] userPic]]) {
                [item sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[i] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
            }
           
            [item setTitle:[_dataArray[i] userName] forState:UIControlStateNormal];
            item.tag = 101 + i;
            item.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];

            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 30*ScreenWidth/375, 200*ScreenWidth/320, 60*ScreenWidth/320)];
        label.text = @"暂时还没有参与活动的人";
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
        [view addSubview:label];
    }
}
-(void)morePeopleClick
{
    //查看活动详细人数
    ActiveNumViewController* numVc = [[ActiveNumViewController alloc]init];
    numVc.teamId = _model.team_Id;
    [self.navigationController pushViewController:numVc animated:YES];
}

-(void)createDetail
{
    UIView* view = [[UIView alloc]init];
    if (_dataArray.count == 0) {
        view.frame = CGRectMake(0, 410*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320 + _height);
    }
    else
    {
        view.frame = CGRectMake(0, 350*ScreenWidth/320 + 60*ScreenWidth/320*((_dataArray.count-1)/6+1), ScreenWidth, 30*ScreenWidth/320 + _height);
    }
    [_scrollView addSubview:view];
    
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/320)];
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"   活动详情";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [view addSubview:labelFenge];
    
    
    UIView* baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/320, ScreenWidth, _height)];
    [view addSubview:baseView];
    
    
    UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 0, ScreenWidth-20*ScreenWidth/320, _height)];
    labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    labelDetail.text = _str;
    labelDetail.numberOfLines = 0;
    [baseView addSubview:labelDetail];
    
}
-(void)createBtnRecord
{
    
    UIView* viewBasic = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49*ScreenWidth/375-64, ScreenWidth, 49*ScreenWidth/375)];
    
    viewBasic.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    [self.view addSubview:viewBasic];
    
    
    UIButton* btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    btnInvite.frame = CGRectMake(0, 0, ScreenWidth/2-1, 49*ScreenWidth/375);
    [viewBasic addSubview:btnInvite];
    btnInvite.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
    [btnInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnInvite.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnInvite.layer.borderWidth = 1.0;
    btnInvite.backgroundColor = [UIColor orangeColor];
    
    UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 49*ScreenWidth/375);
    [viewBasic addSubview:btnCancel];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnCancel.layer.borderWidth = 1.0;
    btnCancel.backgroundColor = [UIColor orangeColor];
    
    
    //我创建的,
    if ([_model.forrelevant integerValue] == 1) {
        //直播中
        if([_model.isendTime integerValue] == 1)
        {
            //查看
            [btnInvite setTitle:@"查看记分" forState:UIControlStateNormal];
            [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
            
            //记分
            [btnCancel setTitle:@"记分" forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([_model.isendTime integerValue] == 2)
        {
            //邀请
            [btnInvite setTitle:@"邀请好友" forState:UIControlStateNormal];
            [btnInvite addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
            //取消
            [btnCancel setTitle:@"取消活动" forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            //记分
            btnCancel.hidden = YES;
            btnInvite.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            [btnInvite setTitle:@"查看记分" forState:UIControlStateNormal];
            [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //我参与的,
    else if ([_model.forrelevant integerValue] == 2)
    {
        //1、直播中，2，未开始，3已过期
        if([_model.isendTime integerValue] == 1)
        {
            //查看
            [btnInvite setTitle:@"查看记分" forState:UIControlStateNormal];
            [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
            
            //记分
            [btnCancel setTitle:@"记分" forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([_model.isendTime integerValue] == 2)
        {
            //私聊
            btnInvite.hidden = YES;
            UIButton* btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
            btnChat.frame = CGRectMake(0, 0, ScreenWidth/2-1, 49*ScreenWidth/375);
            [viewBasic addSubview:btnChat];
            [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
            [btnChat setImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
            btnChat.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -50*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
            btnChat.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
            btnChat.tag = 1000;
            btnChat.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [btnChat addTarget:self action:@selector(chatActiveClick) forControlEvents:UIControlEventTouchUpInside];
            [btnChat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btnChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnChat.layer.borderWidth = 1.0;
            btnChat.backgroundColor = [UIColor whiteColor];
            
            //退出
            [btnCancel setTitle:@"退出活动" forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            //记分
            btnCancel.hidden = YES;
            btnInvite.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            [btnInvite setTitle:@"查看记分" forState:UIControlStateNormal];
            [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    //未参加的
    else{
        //先要判断是否是球队的成员，否则没有权限
        if ([_teamStand integerValue] == 1 || [_teamStand integerValue] == 2 || [_teamStand integerValue] == 4) {
            //1、直播中，2，未开始，3已过期
            if([_model.isendTime integerValue] == 1)
            {
                //记分
                btnCancel.hidden = YES;
                btnInvite.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
                [btnInvite setTitle:@"查看记分" forState:UIControlStateNormal];
                [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([_model.isendTime integerValue] == 2)
            {
                //私聊
                btnInvite.hidden = YES;
                UIButton* btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
                btnChat.frame = CGRectMake(0, 0, ScreenWidth/2-1, 49*ScreenWidth/375);
                [viewBasic addSubview:btnChat];
                [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
                [btnChat setImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
                btnChat.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -50*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
                btnChat.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
                btnChat.tag = 1000;
                btnChat.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
                [btnChat addTarget:self action:@selector(chatActiveClick) forControlEvents:UIControlEventTouchUpInside];
                [btnChat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                btnChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btnChat.layer.borderWidth = 1.0;
                btnChat.backgroundColor = [UIColor whiteColor];
                
                //退出
                [btnCancel setTitle:@"加入活动" forState:UIControlStateNormal];
                [btnCancel addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                //记分
                btnCancel.hidden = YES;
                btnInvite.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
                [btnInvite setTitle:@"查看记分" forState:UIControlStateNormal];
                [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            //记分
            btnCancel.hidden = YES;
            btnInvite.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            btnInvite.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            btnInvite.backgroundColor = [UIColor lightGrayColor];
            [btnInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnInvite setTitle:@"非球队成员不能查看详细内容" forState:UIControlStateNormal];
            [btnInvite addTarget:self action:@selector(watchPointClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
        
}
#pragma mark --邀请好友
-(void)inviteClick
{
    TeamInviteViewController *teamVc = [[TeamInviteViewController alloc]init];
    
    teamVc.block = ^(NSMutableArray* arrayIndex, NSMutableArray* arrayData, NSMutableArray *addressArray){
        //接收数据
        [_arrayIndex removeAllObjects];
        [_arrayData1 removeAllObjects];
        [_arrayData removeAllObjects];
        
        [_messageArray removeAllObjects];
        [_telArray removeAllObjects];
        
        _arrayIndex=arrayIndex;
        _arrayData1=arrayData;
        
        for (int i = 0; i < [addressArray[0] count]; i++) {
            [_telArray addObject:addressArray[0][i]];
        }
        
        [_arrayData addObjectsFromArray:arrayData[0]];
        [_arrayData addObjectsFromArray:arrayData[1]];
        //        [_arrayData addObjectsFromArray:arrayData[2]];
        //存储短信数组
        [_messageArray addObjectsFromArray:arrayData[2]];
        
        
        //        //NSLog(@"%@",[_arrayData[0] userId]);
        //        NSString *strId;
        NSMutableArray* arrayIdLis = [[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < _arrayData.count; i++) {
            [arrayIdLis addObject:[_arrayData[i] userId]];
        }
        NSString *nsIdList=[arrayIdLis componentsJoinedByString:@","];
        _progre = [[MBProgressHUD alloc] initWithView:self.view];
        _progre.mode = MBProgressHUDModeIndeterminate;
        _progre.labelText = @"正在通知好友...";
        [self.view addSubview:_progre];
        [_progre show:YES];
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/saveMesss.do" parameter:@{@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"content":[NSString stringWithFormat:@"%@邀请您参加他的球队活动",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]],@"messObjid":_model.teamActivityId,@"messType":@11,@"idlist":nsIdList} success:^(id respondsData) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                //NSLog(@"dashabi");
                
                _progre.labelText = @"通知好友成功";
                // 延迟2秒执行：
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // code to be executed on the main queue after delay
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (_messageArray.count != 0) {
                        
                        [Helper alertViewWithTitle:@"是否立即发送短信邀请好友" withBlockCancle:^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        } withBlockSure:^{
                            TeamMessageController* team = [[TeamMessageController alloc]init];
                            team.dataArray = _messageArray;
                            team.telArray = _telArray;
                            [self.navigationController pushViewController:team animated:YES];
                            
                        } withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                });
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    };
    teamVc.arrayIndex = _arrayIndex;
    teamVc.arrayData = _arrayData1;
    
    [self.navigationController pushViewController:teamVc animated:YES];
}

#pragma mark --查看积分
-(void)watchPointClick
{
//    ManageWatchViewController* watchVc = [[ManageWatchViewController alloc]init];
//    watchVc.type1 = @11;
//    watchVc.manageId = _model.teamActivityId;
//    
//    [self.navigationController pushViewController:watchVc animated:YES];

}

-(void)chatActiveClick
{
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    //设置聊天类型
    vc.conversationType = ConversationType_PRIVATE;
    //设置对方的id
    vc.targetId = [NSString stringWithFormat:@"%@",_model.userId];
    //设置对方的名字
    //    vc.userName = model.conversationTitle;
    //设置聊天标题
    vc.title = _model.userName;
    //设置不现实自己的名称  NO表示不现实
    vc.displayUserNameInCell = NO;
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)deleteClick
{
    [Helper alertViewWithTitle:@"是否取消活动" withBlockCancle:^{
    } withBlockSure:^{
        [_dict setValue:_model.teamActivityId forKey:@"teamActivityId"];
        [_dict setValue:_model.userId forKey:@"userId"];
        [_dict setValue:@"球队活动被取消了" forKey:@"context"];
        [[PostDataRequest sharedInstance] postDataRequest:@"TTeamActivity/delete.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
        } failed:^(NSError *error) {
            ////NSLog(@"%@",error);
        }];

        
    } withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}
-(void)scoreClick
{

    ScoreByActiveViewController* scVc = [[ScoreByActiveViewController alloc]init];
//    simpVc.isSave = @10;
    if ([_model.isjf integerValue] > 0) {
        scVc.isSave = @10;
    }
    scVc.strTitle = _model.teamActivityTitle;
    scVc.createTime = _model.createTime;
    scVc.pic = _model.treamPic;
    scVc.ballName = _model.ballName;
    scVc.ballId = [_model.activityBallId integerValue];
    scVc.scoreType = @11;
    scVc.activeObjId = _model.teamActivityId;
    [self.navigationController pushViewController:scVc animated:YES];
}


-(void)joinClick:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_model.teamActivityId forKeyedSubscript:@"teamId"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKeyedSubscript:@"userId"];
    [dict setObject:@11 forKeyedSubscript:@"applyType"];
    [dict setObject:[NSString stringWithFormat:@"%@加入了球队活动",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKeyedSubscript:@"NoticeString"];
    [dict setObject:_model.userId forKeyedSubscript:@"userIds"];
    [dict setObject:@1 forKeyedSubscript:@"type"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/save.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
        if ([[dict objectForKey:@"success"]integerValue] == 1) {
            for (UIView *v in [_scrollView subviews]) {
                [v removeFromSuperview];
            }
            _model.forrelevant = @2;
            [self showPeoView];
            btn.userInteractionEnabled = YES;
            
            [btn removeTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"退出活动" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
        }
//        [_dataArray removeAllObjects];
        btn.backgroundColor = [UIColor orangeColor];

    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
        btn.backgroundColor = [UIColor orangeColor];
    }];
}
-(void)cancelJoinClick:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@11 forKeyedSubscript:@"teamType"];
    [dict setObject:_model.teamActivityId forKeyedSubscript:@"teamId"];
    [dict setObject:_model.teamActivityId forKeyedSubscript:@"teamTeamId"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKeyedSubscript:@"teamfrindUser"];
    [dict setObject:[NSString stringWithFormat:@"%@已经退出了这个球队活动",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]] forKeyedSubscript:@"context"];
    [dict setObject:@0 forKeyedSubscript:@"userId"];
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/deleteUser.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
        
//        [_dataArray removeAllObjects];
        for (UIView *v in [_scrollView subviews]) {
            [v removeFromSuperview];
        }
        _model.forrelevant = @3;
        [self showPeoView];
        
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor orangeColor];
        [btn removeTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
    }];
}

@end
