//
//  TeamDeMessViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamDeMessViewController.h"
#import "Helper.h"
#import "Setbutton.h"
#import "HorButtonSet.h"
#import "TeamManageViewController.h"
#import "TeamNumViewController.h"

#import "TeamApplyViewController.h"
//球队相册
#import "TeamPhotoViewController.h"
//高球活动
#import "TeamGaoActiveController.h"

#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PostDataRequest.h"

#import "TeamPeopleModel.h"
#import "TeamJoinSetTableViewCell.h"
#import "TeamActiveModel.h"
#import "TeamPhotoModel.h"

#import "PersonHomeController.h"

#import "TeamMessageController.h"

#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "TeamInviteViewController.h"

#import "MBProgressHUD.h"
#import "TeamJoinReasonViewController.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#import "ChatDetailViewController.h"
@interface TeamDeMessViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView* _scrollView;
    //简介高度
    NSString *_str;
    CGFloat _heightIntro;
    UIButton* _btnPost;
    NSMutableDictionary* _dictJoin;
    
    NSMutableArray* _dataArray;
    
    UITableView* _tableView;
    NSMutableArray* _dataJoinArray;
    
    NSMutableArray* _dataApplyArray;
    
    MBProgressHUD* _progressHud;
    //好友列表请求的数据
    NSMutableArray* _arrayIndex;
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayData1;
    
    NSMutableArray* _messageArray;
    NSMutableArray* _telArray;
    TeamModel* _model;
    MBProgressHUD* _progre;
}

@end

@implementation TeamDeMessViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *v in [self.view subviews]) {
        [v removeFromSuperview];
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    
    _dictJoin = [[NSMutableDictionary alloc]init];
    _str = [[NSString alloc]init];
    _dataJoinArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _dataApplyArray = [[NSMutableArray alloc]init];
    
    
    
    
    
    //好友
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    
    

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    
    
    [self createViewData];
    
    
}

-(void)backButtonClcik
{
    if (_isBack == YES) {
        if (_forBlock) {
            _forBlock(_forrelvant,_indexNum);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)manage1Click
{
    TeamManageViewController* manVc =[[TeamManageViewController alloc]init];
    if (_model != nil) {
        manVc.state = _forrelvant;
        manVc.teamId = _teamId;
        manVc.strInMess = _str;
        manVc.teamNumCount = _dataArray.count;
        manVc.teamUserId = _modelMian.teamCreteUser;
        if (![Helper isBlankString:_modelMian.teamArea]) {
            manVc.strCity = _modelMian.teamArea;
        }
        
        if (![Helper isBlankString:_modelMian.teamName]) {
            manVc.strTeamName = _modelMian.teamName;
        }
        else
        {
            manVc.strTeamName = @"球队管理";
        }
    }
    
    [self.navigationController pushViewController:manVc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队详情";
    
//    //NSLog(@"%@",_forrelvant);

}


//刷新数据
-(void)createViewData
{
    
    if (_arrayIndex.count != 0) {
        [_arrayIndex removeAllObjects];
    }
    if (_arrayData.count != 0) {
        [_arrayData removeAllObjects];
    }
    if (_arrayData1.count != 0) {
        [_arrayData1 removeAllObjects];
    }
    if (_messageArray.count != 0) {
        [_messageArray removeAllObjects];
    }
    if (_telArray.count != 0) {
        [_telArray removeAllObjects];
    }
    if (_dataApplyArray.count != 0) {
        [_dataApplyArray removeAllObjects];
    }
    if (_dataArray.count != 0) {
        [_dataArray removeAllObjects];
    }
    if (_dataJoinArray.count != 0) {
        [_dataJoinArray removeAllObjects];
    }
    if (_dictJoin.count != 0) {
        [_dictJoin removeAllObjects];
    }
    
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"正在加载...";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
    [[PostDataRequest sharedInstance] postDataRequest:@"team/get.do" parameter:@{@"id":_teamId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
//        //NSLog(@"%@",[dict objectForKey:@"rows"]);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            _model = [[TeamModel alloc]init];
            [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
            
            if (![Helper isBlankString:_model.teamSign]) {
                _str = _model.teamSign;
            }
            
            if ([_forrelvant integerValue] == 1 || [_forrelvant integerValue] == 4) {
                UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"genduo3"] style:UIBarButtonItemStylePlain target:self action:@selector(manage1Click)];
                rightBtn.tintColor = [UIColor whiteColor];
                
                self.navigationItem.rightBarButtonItem = rightBtn;
            }
            
            _heightIntro = [Helper textHeightFromTextString:_str width:ScreenWidth-20*ScreenWidth/320 fontSize:14*ScreenWidth/320];
            if (_heightIntro < 30*ScreenWidth/320) {
                _heightIntro = 30*ScreenWidth/320;
            }
            [self createMainHead];
            ////            //球队详情
            [self creteTeamDetail];
            ////            //球队简介
            [self createTeamIntro];
            ////            //创建者
            [self createPeople];
            ////            //球队成员
            [self createMember];
            ////            //球队活动
            [self createActive];
            ////            //球队相册
            [self createPhoto];
            ////            //申请
            [self createApply];
            ////            //最下方按钮
            [self createBtnLast];
            
            [_tableView reloadData];
            
            
            
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


/**
 *  最上方视图
 */
-(void)createMainHead
{
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 5*ScreenWidth/320, 60*ScreenWidth/320, 60*ScreenWidth/320)];
    imgv.layer.masksToBounds = YES;
    imgv.layer.cornerRadius = 8*ScreenWidth/375;
    if (![Helper isBlankString:_model.tramPic]) {
        [imgv sd_setImageWithURL:[Helper imageIconUrl:_model.tramPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    }
    
    [_scrollView addSubview:imgv];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/320, 20*ScreenWidth/320, ScreenWidth-90*ScreenWidth/320, 30*ScreenWidth/320)];
    if (![Helper isBlankString:_model.teamName]) {
        labelTitle.text = _model.teamName;

    }
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/320];
    [_scrollView addSubview:labelTitle];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 69*ScreenWidth/320, ScreenWidth, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:viewLine];
    
    
}

-(void)creteTeamDetail
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 70*ScreenWidth/320, ScreenWidth, 110*ScreenWidth/320)];
//    viewBase.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:viewBase];
    /**
     *  球队介绍
     */
    NSMutableAttributedString* strPeo;
    NSMutableAttributedString* strTime;
    NSMutableAttributedString* strNum;
    if (_model.userName) {
//        strPeo = [NSString stringWithFormat:@"球队队长: %@",_model.userName];
        strPeo = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"球队队长: %@",_model.userName]];
    }
    else
    {
        strPeo = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"球队队长: 暂无队长"]];
    }
    if (_model.establishmentDate) {
        strTime = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"成立日期: %@",_model.establishmentDate]];
    }
    else
    {
        strTime = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"成立日期: 暂无日期"]];
    }
    if (_model.joinCount != nil) {
        strNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"会员人数: %@",_model.joinCount]];
    }
    else
    {
        strNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"会员人数: 暂无会员"]];
    }
    
    
    NSMutableAttributedString* strState;
    if ([_model.teamType integerValue] == 0) {
        strState = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"入会申请: 需要管理员同意方可加入"]];
    }
    else
    {
        strState = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"入会申请: 无需管理员同意即可加入"]];
    }
    NSMutableAttributedString* strArea;
    if (![Helper isBlankString:_model.teamCrtyName]) {
//        strArea = [NSString stringWithFormat:@"所属地区: %@",_model.teamCrtyName];
        strArea = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"所属地区: %@",_model.teamCrtyName]];
    }
    else
    {
        strArea = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"所属地区: 暂无地区"]];
    }
    
    
    NSArray* titleArr = @[strPeo, strTime,strNum, strState,strArea];
    for (int i = 0; i < 5; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 5*ScreenWidth/320+20*ScreenWidth/320*i, ScreenWidth-20*ScreenWidth/320, 20*ScreenWidth/320)];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
//        label.text = titleArr[i];
        [viewBase addSubview:label];

        [titleArr[i] addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,6)];



        label.attributedText = titleArr[i];
        
    }
}

-(void)createTeamIntro
{
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]initWithFrame:CGRectMake(0, 180*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320)];
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"    球队简介";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [_scrollView addSubview:labelFenge];
    
    /**
     球队简介
     */
   
    UIView* viewBase = [[UIView alloc]init];
    [_scrollView addSubview:viewBase];
    UILabel* labelIntro = [[UILabel alloc]init];
    if ([Helper isBlankString:_str]) {
        viewBase.frame = CGRectMake(0, 210*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320);
        labelIntro.frame = CGRectMake(10*ScreenWidth/320, 0, ScreenWidth-20*ScreenWidth/320, 30*ScreenWidth/320);
        labelIntro.text = @"暂无简介";
    }
    else
    {
        viewBase.frame = CGRectMake(0, 210*ScreenWidth/320, ScreenWidth, _heightIntro);
        labelIntro.frame = CGRectMake(10*ScreenWidth/320, 0, ScreenWidth-20*ScreenWidth/320, _heightIntro);
        labelIntro.text = _str;
    }
    labelIntro.numberOfLines = 0;
    labelIntro.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [viewBase addSubview:labelIntro];
}

-(void)createPeople
{
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]init];
    if ([Helper isBlankString:_str]) {
        labelFenge.frame = CGRectMake(0, 240*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320);
    }
    else
    {
        labelFenge.frame = CGRectMake(0, 210*ScreenWidth/320+_heightIntro, ScreenWidth, 30*ScreenWidth/320);
    }
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"    创建者";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [_scrollView addSubview:labelFenge];
    
    Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
    item.imageView.layer.masksToBounds = YES;
    item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
    item.frame = CGRectMake(10*ScreenWidth/320, 243*ScreenWidth/320+_heightIntro, 60*ScreenWidth/375, 60*ScreenWidth/375);
    if ([Helper isBlankString:_str]) {
         item.frame = CGRectMake(10*ScreenWidth/320, 273*ScreenWidth/320, 60*ScreenWidth/375, 60*ScreenWidth/375);
    }
    else
    {
         item.frame = CGRectMake(10*ScreenWidth/320, 243*ScreenWidth/320+_heightIntro, 60*ScreenWidth/375, 60*ScreenWidth/375);
    }

    [_scrollView addSubview:item];
    item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    if (![Helper isBlankString:_model.userName]) {
        NoteModel *model = [NoteHandlle selectNoteWithUID:_model.teamCreteUser];
        if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
            [item setTitle:_model.userName forState:UIControlStateNormal];
        }else{
            [item setTitle:model.userremarks forState:UIControlStateNormal];
        }

//        [item setTitle:_model.userName forState:UIControlStateNormal];
    }
    if (![Helper isBlankString:_model.userPic]) {
        [item sd_setImageWithURL:[Helper imageIconUrl:_model.userPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
    }
    item.tag = 100;
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item addTarget:self action:@selector(selfMessDetClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  创建者头像点击事件
 */
-(void)selfMessDetClick
{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    
    selfVc.strMoodId = _model.teamCreteUser;
    selfVc.messType = @15;
    [self.navigationController pushViewController:selfVc animated:YES];
}

//球队成员
-(void)createMember
{
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]init];
    if ([Helper isBlankString:_str]) {
        labelFenge.frame = CGRectMake(0, 330*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320);
    }
    else
    {
        labelFenge.frame = CGRectMake(0, 300*ScreenWidth/320+_heightIntro, ScreenWidth, 30*ScreenWidth/320);
    }
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"    球队成员";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [_scrollView addSubview:labelFenge];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/queryByUserList.do" parameter:@{@"page":@1,@"rows":@10,@"type":@10,@"teamId":_teamId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamPeopleModel *model = [[TeamPeopleModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            if (_dataArray.count == 0) {
                UILabel* label = [[UILabel alloc]initWithFrame: CGRectMake(10*ScreenWidth/320, 360*ScreenWidth/320, 150*ScreenWidth/320, 50*ScreenWidth/320)];
                label.text = @"暂无球队成员";
                label.font = [UIFont systemFontOfSize:15*ScreenWidth/320];
                [_scrollView addSubview:label];
            }
            else
            {
                if ([_forrelvant integerValue] == 1 || [_forrelvant integerValue] == 4) {
                    for (int i = 0; i < _dataArray.count; i++) {
                        if(i < 5)
                        {
                            Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
                            item.imageView.layer.masksToBounds = YES;
                            item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
                            if ([Helper isBlankString:_str]) {
                                item.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*i, 360*ScreenWidth/320, 50*ScreenWidth/320, 60*ScreenWidth/320);
                            }else{
                                item.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*i, 330*ScreenWidth/320+_heightIntro, 50*ScreenWidth/320, 60*ScreenWidth/320);
                            }
                            [_scrollView addSubview:item];
                            item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            //数据库中根据userid查询备注
                            NoteModel *model = [NoteHandlle selectNoteWithUID:_model.teamCreteUser];
                            if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                                [item setTitle:[_dataArray[i] userName] forState:UIControlStateNormal];
                            }else{
                                [item setTitle:model.userremarks forState:UIControlStateNormal];
                            }
//                            [item setTitle:[_dataArray[i] userName] forState:UIControlStateNormal];
                            [item sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[i] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
                            item.tag = 100+i;
                            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [item addTarget:self action:@selector(selfDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        else
                        {
                            UIButton* btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btnMore setImage:[UIImage imageNamed:@"genduo"] forState:UIControlStateNormal];
                            if ([Helper isBlankString:_str]) {
                                btnMore.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*5, 360*ScreenWidth/320, 50*ScreenWidth/320, 60*ScreenWidth/320);
                            }
                            else
                            {
                                btnMore.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*5, 330*ScreenWidth/320+_heightIntro, 50*ScreenWidth/320, 60*ScreenWidth/320);
                            }
                            
                            [_scrollView addSubview:btnMore];
                            [btnMore addTarget:self action:@selector(teamPeopleClick) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                }
                else
                {
                    for (int i = 0; i < _dataArray.count; i++) {
                        if(i < 6)
                        {
                            Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
                            item.imageView.layer.masksToBounds = YES;
                            item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
                            if ([Helper isBlankString:_str]) {
                                item.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*i, 360*ScreenWidth/320, 50*ScreenWidth/320, 60*ScreenWidth/320);
                            }
                            else
                            {
                                item.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*i, 330*ScreenWidth/320+_heightIntro, 50*ScreenWidth/320, 60*ScreenWidth/320);
                            }
                            [_scrollView addSubview:item];
                            item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            
                            NoteModel *model = [NoteHandlle selectNoteWithUID:[_dataArray[i] userId]];
                            if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                                [item setTitle:[_dataArray[i] userName] forState:UIControlStateNormal];
                            }else{
                                [item setTitle:model.userremarks forState:UIControlStateNormal];
                            }

//                            [item setTitle:[_dataArray[i] userName] forState:UIControlStateNormal];
                            [item sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[i] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
                            item.tag = 100+i;
                            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [item addTarget:self action:@selector(selfDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        else
                        {
                            
                        }
                    }
                }
                
            }
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
           } failed:^(NSError *error) {
        
    }];
    
   
    
}

-(void)selfDetailClick:(UIButton *)btn
{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = [_dataArray[btn.tag-100] userId];
    selfVc.messType = @15;
    [self.navigationController pushViewController:selfVc animated:YES];
}
-(void)teamPeopleClick
{
    //球队成员
    TeamNumViewController* numVc = [[TeamNumViewController alloc]init];
    numVc.teamId = _model.teamId;
    numVc.teamStatus = _forrelvant;
    numVc.teamNumCount = _dataApplyArray.count;
    [self.navigationController pushViewController:numVc animated:YES];
    
}
//球队活动
-(void)createActive
{
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]init];
    if ([Helper isBlankString:_str]) {
        labelFenge.frame = CGRectMake(0, 420*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320);
    }
    else
    {
        labelFenge.frame = CGRectMake(0, 390*ScreenWidth/320+_heightIntro, ScreenWidth, 30*ScreenWidth/320);
    }
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"    球队活动";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [_scrollView addSubview:labelFenge];
    
    
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 420*ScreenWidth/320+_heightIntro, ScreenWidth, 50*ScreenWidth/320)];
    if ([Helper isBlankString:_str]) {
        viewBase.frame = CGRectMake(0, 450*ScreenWidth/320, ScreenWidth, 50*ScreenWidth/320);
    }
    else
    {
        viewBase.frame = CGRectMake(0, 420*ScreenWidth/320 + _heightIntro, ScreenWidth, 50*ScreenWidth/320);
    }
    [_scrollView addSubview:viewBase];
//    //NSLog(@"%@",_model.teamId);
    [[PostDataRequest sharedInstance] postDataRequest:@"TTeamActivity/queryByList.do" parameter:@{@"page":@1,@"rows":@1,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"team_Id":_model.teamId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
//        //NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            TeamActiveModel *model = [[TeamActiveModel alloc] init];
            [model setValuesForKeysWithDictionary:[[dict objectForKey:@"rows"][0] objectForKey:@"activityList"][0]];
            UILabel* labelTit = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 0, ScreenWidth-70*ScreenWidth/320, 25*ScreenWidth/320)];
            labelTit.text = [NSString stringWithFormat:@"标题:%@",model.teamActivityTitle];
            labelTit.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
            [viewBase addSubview:labelTit];
            
            UILabel* labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 25*ScreenWidth/320, ScreenWidth - 70*ScreenWidth/320, 25*ScreenWidth/320)];
            labelTime.text = [NSString stringWithFormat:@"活动时间:%@",model.startTime];
            labelTime.font = [UIFont systemFontOfSize:13*ScreenWidth/320];
            labelTime.textColor = [UIColor lightGrayColor];
            [viewBase addSubview:labelTime];
        }
        else
        {
            UILabel* labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 10*ScreenWidth/320, ScreenWidth - 70*ScreenWidth/320, 30*ScreenWidth/320)];
            labelTime.text =@"暂无球队活动";
            labelTime.font = [UIFont systemFontOfSize:13*ScreenWidth/320];
            labelTime.textColor = [UIColor blackColor];
            [viewBase addSubview:labelTime];
        }
        
        
    } failed:^(NSError *error) {
        
    }];
    
    
    UIButton* btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMore setImage:[UIImage imageNamed:@"genduo"] forState:UIControlStateNormal];
    btnMore.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*5, 0, 50*ScreenWidth/320, 50*ScreenWidth/320);
    [viewBase addSubview:btnMore];
    [btnMore addTarget:self action:@selector(moreActiveClick) forControlEvents:UIControlEventTouchUpInside];
    
   
    
}
#pragma mark --球队活动跳转页面点击事件
-(void)moreActiveClick
{
    
    TeamGaoActiveController* actVc = [[TeamGaoActiveController alloc]init];
//    //NSLog(@"%@",_forrelvant);
    actVc.teamId = _model.teamId;
    actVc.teamStand = _forrelvant;
    [self.navigationController pushViewController:actVc animated:YES];
}
//球队相册
-(void)createPhoto
{
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]init];
    if ([Helper isBlankString:_str]) {
        labelFenge.frame = CGRectMake(0, 500*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320);
    }
    else
    {
        labelFenge.frame = CGRectMake(0, 470*ScreenWidth/320 + _heightIntro, ScreenWidth, 30*ScreenWidth/320);
    }
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"    球队相册";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [_scrollView addSubview:labelFenge];
    
    
    UIView* vieBase = [[UIView alloc]init];
    if ([Helper isBlankString:_str]) {
        vieBase.frame = CGRectMake(0, 530*ScreenWidth/320, ScreenWidth, 50*ScreenWidth/320);
    }
    else
    {
        vieBase.frame = CGRectMake(0, 500*ScreenWidth/320+_heightIntro, ScreenWidth, 50*ScreenWidth/320);
    }
    [_scrollView addSubview:vieBase];
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"photos/queryByGroups.do" parameter:@{@"page":@1,@"rows":@1,@"teamId":_model.teamId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            TeamPhotoModel *model = [[TeamPhotoModel alloc] init];
            [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"][0]];
            
            UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 5*ScreenWidth/320, 40*ScreenWidth/320, 40*ScreenWidth/320)];
            [imgv sd_setImageWithURL:[Helper imageIconUrl:model.photoGroupsHomePic] placeholderImage:[UIImage imageNamed:@"zwt"]];
            imgv.layer.masksToBounds = YES;
            imgv.layer.cornerRadius = 8*ScreenWidth/375;
            [vieBase addSubview:imgv];
            
            UILabel* labelTit = [[UILabel alloc]initWithFrame:CGRectMake(60*ScreenWidth/320, 5*ScreenWidth/320, ScreenWidth-130*ScreenWidth/320, 20*ScreenWidth/320)];
            labelTit.text = [NSString stringWithFormat:@"活动时间:%@",model.photoGroupsName];
            labelTit.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
            [vieBase addSubview:labelTit];
            
            UILabel* labelNum = [[UILabel alloc]initWithFrame:CGRectMake(60*ScreenWidth/320, 25*ScreenWidth/320, ScreenWidth-130*ScreenWidth/320, 20*ScreenWidth/320)];
            labelNum.text = [NSString stringWithFormat:@"共%@张",model.photoNums];
            labelNum.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
            [vieBase addSubview:labelNum];
        }else{
            UILabel* labelNum = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 15*ScreenWidth/320, ScreenWidth-100*ScreenWidth/320, 20*ScreenWidth/320)];
            labelNum.text = @"暂时没有球队相册,点按钮去添加吧";
            labelNum.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
            [vieBase addSubview:labelNum];
        }
        
    } failed:^(NSError *error) {
        
    }];
    UIButton* btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMore setImage:[UIImage imageNamed:@"genduo"] forState:UIControlStateNormal];
    btnMore.frame = CGRectMake(10*ScreenWidth/320 + 50*ScreenWidth/320*5, 0, 50*ScreenWidth/320, 50*ScreenWidth/320);
    [vieBase addSubview:btnMore];
    [btnMore addTarget:self action:@selector(morePhotoClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --球队相册跳转页面点击事件
-(void)morePhotoClick
{
//    //NSLog(@"%@",_forrelvant);
    TeamPhotoViewController* photoVc = [[TeamPhotoViewController alloc]init];
    photoVc.teamId = _model.teamId;
    photoVc.teamPhotoTitle = _model.teamName;
    photoVc.forrevent = _forrelvant;
    [self.navigationController pushViewController:photoVc animated:YES];
}
//申请
-(void)createApply
{
    //分隔label
    UILabel* labelFenge = [[UILabel alloc]init];
    ////NSLog(@"%@",_str);
    if ([Helper isBlankString:_str]) {
        labelFenge.frame = CGRectMake(0, 580*ScreenWidth/320, ScreenWidth, 30*ScreenWidth/320);
    }
    else
    {
        labelFenge.frame = CGRectMake(0, 550*ScreenWidth/320+_heightIntro, ScreenWidth, 30*ScreenWidth/320);
    }
    labelFenge.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelFenge.text = @"    申请人";
    labelFenge.font = [UIFont systemFontOfSize:14*ScreenWidth/320];
    [_scrollView addSubview:labelFenge];
    
    if ([_forrelvant integerValue] == 1 || [_forrelvant integerValue] == 4) {
        UIButton* btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMore setTitle:@"更多..." forState:UIControlStateNormal];
        [btnMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([Helper isBlankString:_str]) {
            btnMore.frame = CGRectMake(ScreenWidth-60*ScreenWidth/320, 585*ScreenWidth/320, 50*ScreenWidth/320, 20*ScreenWidth/320);
        }
        else
        {
            btnMore.frame = CGRectMake(ScreenWidth-60*ScreenWidth/320, 555*ScreenWidth/320+_heightIntro, 50*ScreenWidth/320, 20*ScreenWidth/320);
        }
        btnMore.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:btnMore];
        btnMore.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [btnMore addTarget:self action:@selector(applyMoreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/queryPage.do" parameter:@{@"teamId":_teamId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":@1,@"rows":@10,@"applyType":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamJoinModel *model = [[TeamJoinModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataApplyArray addObject:model];
            }
            
            
            if (_dataApplyArray.count != 0) {
                if (_dataApplyArray.count >= 2) {
                    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 590*ScreenWidth/320+_heightIntro, ScreenWidth, 55*2*ScreenWidth/320) style:UITableViewStylePlain];
                }
                else
                {
                    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 590*ScreenWidth/320+_heightIntro, ScreenWidth, 55*_dataApplyArray.count*ScreenWidth/320) style:UITableViewStylePlain];
                }
            }
            else
            {
                
            }
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [_scrollView addSubview:_tableView];
//            [_tableView registerNib:[UINib nibWithNibName:@"TeamJoinSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeamJoinSetTableViewCell"];
            [_tableView registerClass:[TeamJoinSetTableViewCell class] forCellReuseIdentifier:@"TeamJoinSetTableViewCell"];
//            [_tableView reloadData];
     
        }else {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/320, 590*ScreenWidth/320+_heightIntro, ScreenWidth-20*ScreenWidth/320, 35*ScreenWidth/320)];
            label.font = [UIFont systemFontOfSize:15*ScreenWidth/320];
            label.text = @"暂时还没有球队申请人，快去邀请吧";
            [_scrollView addSubview:label];
        }
        if (_dataApplyArray.count >= 2) {
            _scrollView.contentSize = CGSizeMake(0, 620*ScreenWidth/320+_heightIntro+55*ScreenWidth/320);
        }
        else if (_dataApplyArray.count == 1)
        {
            _scrollView.contentSize = CGSizeMake(0, 620*ScreenWidth/320+_heightIntro);
        }
        else
        {
            _scrollView.contentSize = CGSizeMake(0, 620*ScreenWidth/320+_heightIntro);
        }
        
        
    } failed:^(NSError *error) {
        
    }];
    
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataApplyArray.count >=2 ? 2 : _dataApplyArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",_dataApplyArray.count);
    TeamJoinSetTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"TeamJoinSetTableViewCell" forIndexPath:indexPath];
    [cellid showTeamJoin:_dataApplyArray[indexPath.row]];
    cellid.agreeBtn.hidden = YES;
    cellid.disMissBtn.hidden = YES;
    cellid.btnDetail.hidden = YES;
    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellid;
}




/**
 *  更多申请人点击事件
 */
-(void)applyMoreClick
{
    
    TeamApplyViewController* appVc = [[TeamApplyViewController alloc]init];
    appVc.teamId = _model.teamId;
    [self.navigationController pushViewController:appVc animated:YES];
    
}


/**
 *  最下方按钮
 */
//是否是我参与的  1  我创建的  2 我参与的  3 未参与    4 管理员   5申请中
-(void)createBtnLast
{
    UIView* viewBasic = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49*ScreenWidth/320-57, ScreenWidth, 49*ScreenWidth/320)];

    [self.view addSubview:viewBasic];
    
    
    
    
    
    UIButton* btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChat.frame = CGRectMake(0, 0, ScreenWidth/3, 49*ScreenWidth/375);
    //只有在不是自己创建的时候才会有私聊
    if ([_forrelvant integerValue] != 1) {
        [viewBasic addSubview:btnChat];
    }
    [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
    [btnChat setImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
    btnChat.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -50*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
    btnChat.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
    btnChat.tag = 1000;
    btnChat.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
    [btnChat addTarget:self action:@selector(chatTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [btnChat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnChat.layer.borderWidth = 1.0;
    btnChat.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UIButton* btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([_forrelvant integerValue] == 1) {
        btnShare.frame = CGRectMake(0, 0, ScreenWidth/2+1, 49*ScreenWidth/375);
    }
    else
    {
        btnShare.frame = CGRectMake(ScreenWidth/3-1, 0, ScreenWidth/3+1, 49*ScreenWidth/375);
    }
    [viewBasic addSubview:btnShare];
    [btnShare setTitle:@"分享" forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareTeamClick) forControlEvents:UIControlEventTouchUpInside];
    btnShare.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -20*ScreenWidth/375, -5*ScreenWidth/375, 0*ScreenWidth/375);
    btnShare.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
    btnShare.tag = 1000;
    btnShare.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
//    [btnShare addTarget:self action:@selector(shareYueClick) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnShare.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShare.layer.borderWidth = 1.0;
    btnShare.backgroundColor = [UIColor whiteColor];

    
    
    
    
    
    //邀请
    _btnPost = [UIButton buttonWithType:UIButtonTypeSystem];
    if ([_forrelvant integerValue] == 1) {
        _btnPost.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 49*ScreenWidth/375);
    }
    else
    {
        _btnPost.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
    }
    [viewBasic addSubview:_btnPost];
    _btnPost.backgroundColor = [UIColor colorWithRed:0.95f green:0.60f blue:0.19f alpha:1.00f];
    //0需要审核，1不需要
    //NSLog(@"%@",_forrelvant);
    if ([_model.teamType integerValue] == 0) {
        if ([_forrelvant integerValue] == 1) {
            [_btnPost setTitle:@"邀请好友" forState:UIControlStateNormal];
        }
        else if([_forrelvant integerValue] == 2 || [_forrelvant integerValue] == 4)
        {
            [_btnPost setTitle:@"退出" forState:UIControlStateNormal];
        }
        else if([_forrelvant integerValue] == 3)
        {
            [_btnPost setTitle:@"加入" forState:UIControlStateNormal];
        }
        else{
            [_btnPost setTitle:@"取消申请" forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([_forrelvant integerValue] == 1) {
            [_btnPost setTitle:@"邀请好友" forState:UIControlStateNormal];
        }
        else if([_forrelvant integerValue] == 2 || [_forrelvant integerValue] == 4)
        {
            [_btnPost setTitle:@"退出" forState:UIControlStateNormal];
        }
        else if([_forrelvant integerValue] == 3)
        {
            [_btnPost setTitle:@"加入" forState:UIControlStateNormal];
        }
        else
        {
            [_btnPost setTitle:@"取消申请" forState:UIControlStateNormal];
        }
    }
    
    [_btnPost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPost addTarget:self action:@selector(btnPostClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnPost.tag = 1002;

}

-(void)chatTeamClick
{    
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    //设置聊天类型
    vc.conversationType = ConversationType_PRIVATE;
    //设置对方的id
    vc.targetId = [NSString stringWithFormat:@"%@",_model.teamCreteUser];
    //设置对方的名字
    //    vc.userName = model.conversationTitle;
    //设置聊天标题
    NoteModel *modell = [NoteHandlle selectNoteWithUID:_model.teamCreteUser];
    if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
        vc.title = _model.userName;
    }else{
        vc.title  = modell.userremarks;
    }
    //设置不现实自己的名称  NO表示不现实
    vc.displayUserNameInCell = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)shareTeamClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}
-(void)shareInfo:(NSInteger)index
{
    NSData *fxData = [NSData dataWithContentsOfURL:[Helper imageUrl:_model.tramPic]];

    NSString*  shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/team/Team_details.html?id=%@&userId=%@",_teamId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [UMSocialData defaultData].extConfig.title=_model.teamName;
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_model.teamSign image:fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_model.teamSign  image:fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
    }
    else
    {
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageWithData:fxData];
        data.shareText = [NSString stringWithFormat:@"%@%@%@",_model.teamName,_model.teamSign,shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}

/**
 *  邀请好友点击事件，
 *
 *  @param btn 点击的按钮
 */

//是否是我参与的  1  我创建的  2 我参与的  3 未参与    4 管理员   5申请中
-(void)btnPostClick:(UIButton *)btn
{
    
    btn.userInteractionEnabled = NO;
    //我创建的
    if ([_forrelvant integerValue] == 1) {
        //邀请好友
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

            //存储短信数组
            [_messageArray addObjectsFromArray:arrayData[2]];
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
            if (arrayIdLis.count != 0) {
                [[PostDataRequest sharedInstance] postDataRequest:@"mess/saveMesss.do" parameter:@{@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"content":[NSString stringWithFormat:@"%@邀请您加入他的球队",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]],@"messObjid":_teamId,@"messType":@10,@"idlist":nsIdList} success:^(id respondsData) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    btn.userInteractionEnabled = YES;
                    if ([[dict objectForKey:@"success"] integerValue] == 1) {
                        ////NSLog(@"dashabi");
                        
                        _progre.labelText = @"通知好友成功";
                        // 延迟2秒执行：
                        double delayInSeconds = 1.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            // code to be executed on the main queue after delay
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            if (_messageArray.count != 0) {
                                [Helper alertViewWithTitle:@"是否立即发送短信邀请好友" withBlockCancle:^{
                                    
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
                    btn.userInteractionEnabled = YES;
                }];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (_messageArray.count != 0) {
                    [Helper alertViewWithTitle:@"是否立即发送短信邀请好友" withBlockCancle:^{
                        
                    } withBlockSure:^{
                        TeamMessageController* team = [[TeamMessageController alloc]init];
                        team.dataArray = _messageArray;
                        team.telArray = _telArray;
                        [self.navigationController pushViewController:team animated:YES];
                        
                    } withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                    btn.userInteractionEnabled = YES;
                }
            }
            
        };
        teamVc.arrayIndex = _arrayIndex;
        teamVc.arrayData = _arrayData1;
        
        [self.navigationController pushViewController:teamVc animated:YES];
        
        
    }
    //是否是我参与的  1  我创建的  2 我参与的  3 未参与    4 管理员   5申请中
    //已经加入
    else if ([_forrelvant integerValue] == 2 || [_forrelvant integerValue] == 4 || [_forrelvant integerValue] == 5){
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:_teamId forKey:@"teamId"];
        [dict setObject:@10 forKey:@"applyType"];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        [dict setObject:@0 forKey:@"teamApplyState"];
        
        
        
        NSString* strTitle;
        if ([_forrelvant integerValue] == 2) {
            strTitle = @"是否退出球队?";
        }
        else if ([_forrelvant integerValue] == 4)
        {
            strTitle = @"是否退出球队?";
        }
        else
        {
            strTitle = @"是否取消申请?";
        }
        [Helper alertViewWithTitle:strTitle withBlockCancle:^{
            btn.userInteractionEnabled = YES;
        } withBlockSure:^{
            [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/delete.do" parameter:dict success:^(id respondsData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                btn.userInteractionEnabled = YES;
                if ([dict objectForKey:@"success"]) {
                    
                    
                    for (UIView *v in [_scrollView subviews]) {
                        [v removeFromSuperview];
                    }
                    _forrelvant = @3;
                    [self createViewData];
                }
            } failed:^(NSError *error) {
                btn.userInteractionEnabled = YES;
            }];
            
            
        } withBlock:^(UIAlertController *alertView) {
            
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    
    }
    //没有加入，申请加入
    else if ([_forrelvant integerValue] == 3)
    {
        
        if ([_model.teamType integerValue] == 1) {
            [_dictJoin setObject:_teamId forKey:@"teamId"];
            [_dictJoin setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]  forKey:@"userId"];
            [_dictJoin setObject:@10 forKey:@"applyType"];
            [_dictJoin setObject:_teamId forKey:@"userIds"];

            [_dictJoin setObject:@1 forKey:@"type"];
        
            [_dictJoin setObject:[NSString stringWithFormat:@"%@申请加入您的球队",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
            [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/save.do" parameter:_dictJoin success:^(id respondsData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                btn.userInteractionEnabled = YES;
                if ([dict objectForKey:@"success"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alertView show];
                    for (UIView *v in [_scrollView subviews]) {
                        [v removeFromSuperview];
                    }
                    if ([_model.teamType integerValue] == 0) {
                        _forrelvant = @5;
                    }
                    else{
                        _forrelvant = @2;
                    }
                    
                    [self createViewData];
                }
                
            } failed:^(NSError *error) {

                btn.userInteractionEnabled = YES;
            }];

        }
        else
        {
            btn.userInteractionEnabled = YES;
            TeamJoinReasonViewController* joinVc = [[TeamJoinReasonViewController alloc]init];
            joinVc.teamId = _teamId;
            joinVc.teamType = _model.teamType;
            
            joinVc.blockJoin = ^(NSString* strTitle, NSNumber* index) {
                [_btnPost setTitle:strTitle forState:UIControlStateNormal];
                _forrelvant = index;
                
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:joinVc animated:YES];
        }
        

    }
    else
    {
        
    }
}

@end
