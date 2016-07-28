//
//  ManageDetailController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageDetailController.h"
#import "Helper.h"

#import "Setbutton.h"

#import "ManageApplyModel.h"

#import "UIButton+WebCache.h"

#import "PostDataRequest.h"
#import "Helper.h"

#import "MBProgressHUD.h"

#import "ScoreByGameViewController.h"

#import "ManageWatchViewController.h"

#import "CustomIOSAlertView.h"

#import "ChatDetailViewController.h"

#import "SelfViewController.h"
#import "PersonHomeController.h"

#import "TeamMessageController.h"

#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "ManageSelfDetTableViewCell.h"
#import "ManageOtherTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"
#import "TeamInviteViewController.h"
#import "NoteHandlle.h"
#import "NoteModel.h"

#import "ReportViewController.h"

@interface ManageDetailController ()<UITextFieldDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView* _scrollView;
    
    UIView* _viewHeader;
    
    UIView* _viewBase;
    
    UIView* _viewContext;
    
    UIView* _viewIntro;
    CGFloat _labelHeight;
    
    UIView* _viewFaqi;
    
    UIView* _viewCanyu;
    
    UIView* _voteView;
    
    UITextField* _textField;
    UITextField* _textFieldWatch;
    UITextField* _textFieldJoin;
    
    NSArray* _arrayTitle;
    UIButton* _btnBase;
    
    UIView* _viewSure;
    
    UIButton* _btnJoin;
    
    //更改浏览人数
    NSMutableDictionary* _dictChange;
    //取消赛事
    NSMutableDictionary* _dictCancel;
    //取消申请
    NSMutableDictionary* _dictDeleJoin;
    //申请加入
    NSMutableDictionary* _dictJoin;
    
    
    MBProgressHUD *_progressHud;
    //待审核
    NSMutableArray* _dataWaitArray;
    
    //参赛成员
    NSMutableArray* _dataArrPeo;
    
    GameModel* _model;
    
    CustomIOSAlertView* _alertView;
    
    
    NSInteger _stateNum;
    
    MBProgressHUD* _progress;
    MBProgressHUD* _progre;
    
    UITableView* _tableView;
    
    NSMutableArray* _arrayIndex,* _arrayData1,* _arrayData,* _messageArray,* _telArray;
    
}
@end

@implementation ManageDetailController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [[IQKeyboardManager sharedManager] setEnable:NO];
    [_dictChange setValue:_model.eventId forKey:@"eventId"];
    [_dictChange setValue:@1 forKey:@"eventClickNums"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tballevent/update.do" parameter:_dictChange success:^(id respondsData) {
        
    } failed:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赛事详情";
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60*ScreenWidth/375)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dictChange = [[NSMutableDictionary alloc]init];
    _dictCancel = [[NSMutableDictionary alloc]init];
    _dictDeleJoin = [[NSMutableDictionary alloc]init];
    _dictJoin = [[NSMutableDictionary alloc]init];
    _dataArrPeo = [[NSMutableArray alloc]init];
    _dataWaitArray = [[NSMutableArray alloc]init];
    
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"正在加载...";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
    
    NSMutableDictionary* dictData = [[NSMutableDictionary alloc]init];
    [dictData setObject:_eventId forKeyedSubscript:@"eventId"];
    [dictData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKeyedSubscript:@"userId"];
    [[PostDataRequest sharedInstance]postDataRequest:@"tballevent/get.do" parameter:dictData success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        
        
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            _model = [[GameModel alloc]init];
            
            [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
        }
        [self showDataView];
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
}

-(void)fieldClick
{
    [self.view endEditing:YES];
    _btnBase.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
}

-(void)showDataView
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@-1 forKey:@"page"];
    [dict setObject:@-1 forKey:@"rows"];
    [dict setObject:@12 forKey:@"type"];
    if (_model.eventId != nil) {
        [dict setObject:_model.eventId forKey:@"teamId"];
    }
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [dict setObject:@-1 forKey:@"userId"];
    
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/queryByUserandapplyList.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([[dictD objectForKey:@"success"] boolValue]) {
            for (NSDictionary *dataDict in [[dictD objectForKey:@"rows"] objectForKey:@"userlist"]) {
                ManageApplyModel *model = [[ManageApplyModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArrPeo addObject:model];
            }
            for (NSDictionary *dataDict in [[dictD objectForKey:@"rows"] objectForKey:@"applys"]) {
                ManageApplyModel *model = [[ManageApplyModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataWaitArray addObject:model];
            }
            //标题头
            [self createHeadeView];
            //基本信息
            [self createBaseView];
            //赛事简介
            [self createIntroView];
            //发起人
            [self fabuSendView];
            //参与人数
            [self cansaiView];
            //待审核人员列表
            [self waitApplysView];
            
            [self sureBtn];
            
            
            //控制屏幕滑动
            if ([_model.forrelevant integerValue] == 1) {
                if (_dataArrPeo.count != 0) {
                    if (_dataWaitArray.count == 0) {
                        _scrollView.contentSize = CGSizeMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1) + 25*ScreenWidth/375 + 55*ScreenWidth/375);
                    }
                    else
                    {
                        _scrollView.contentSize = CGSizeMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1) + 25*ScreenWidth/375 + 55*ScreenWidth/375* _dataWaitArray.count);
                    }
                }
                else{
                    if (_dataWaitArray.count == 0) {
                        _scrollView.contentSize = CGSizeMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight+ 25*ScreenWidth/375 + 55*ScreenWidth/375);
                    }
                    else{
                        _scrollView.contentSize = CGSizeMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight+ 25*ScreenWidth/375 + 55*ScreenWidth/375*_dataWaitArray.count);
                    }
                    
                }
            }
            else
            {
                if (_dataArrPeo.count != 0) {
                    if (_dataWaitArray.count == 0) {
                        _scrollView.contentSize = CGSizeMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1) + 35*ScreenWidth/375 + 44*ScreenWidth/375);
                    }
                    else
                    {
                        _scrollView.contentSize = CGSizeMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1) + 35*ScreenWidth/375 + 44*ScreenWidth/375* _dataWaitArray.count);
                    }
                }
                else{
                    if (_dataWaitArray.count == 0) {
                        _scrollView.contentSize = CGSizeMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight+ 35*ScreenWidth/375 + 44*ScreenWidth/375);
                    }
                    else{
                        _scrollView.contentSize = CGSizeMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight+ 35*ScreenWidth/375 + 44*ScreenWidth/375*_dataWaitArray.count);
                    }
                    
                }
            }
            
            
            
            _btnBase = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnBase.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [self.view addSubview:_btnBase];
            _btnBase.hidden = YES;
            [_btnBase addTarget:self action:@selector(fieldClick) forControlEvents:UIControlEventTouchUpInside];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dictD objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}


#pragma mark --标题头
-(void)createHeadeView{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60*ScreenWidth/375)];
    [_scrollView addSubview:_viewHeader];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 5*ScreenWidth/375, 50*ScreenWidth/375, 50*ScreenWidth/375)];
    if (![Helper isBlankString:_model.eventPic]) {
        [imgv sd_setImageWithURL:[Helper imageIconUrl:_model.eventPic]];
    }
    else
    {
        imgv.image = [UIImage imageNamed:@"sais"];
    }
    imgv.layer.cornerRadius = 8*ScreenWidth/375;
    imgv.layer.masksToBounds = YES;
    [_viewHeader addSubview:imgv];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(70*ScreenWidth/375, 20*ScreenWidth/375, ScreenWidth-78*ScreenWidth/375, 20*ScreenWidth/375)];
    label.text = [NSString stringWithFormat:@"%@",_model.eventTite];
    label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewHeader addSubview:label];
}
#pragma mark --基本信息
-(void)createBaseView
{
    _arrayTitle = [[NSArray alloc]init];
    if ([_model.eventIsPrivate integerValue] == 2) {
        if ([_model.forrelevant integerValue] == 1) {
            _arrayTitle = @[@"比赛日期:",@"比赛时间:",@"结束日期:",@"球场名称:",@"赛事类型:", @"参赛码:",@"观赛码:"];
        }
        else
        {
            _arrayTitle = @[@"比赛日期:",@"比赛时间:",@"结束日期:",@"球场名称:",@"赛事类型:"];
        }
    }
    else{
        _arrayTitle = @[@"比赛日期:",@"比赛时间:",@"结束日期:",@"球场名称:",@"赛事类型:"];
    }
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 60*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375 + 30*ScreenWidth/375*_arrayTitle.count)];
    [_scrollView addSubview:_viewBase];
    _viewBase.backgroundColor = [UIColor whiteColor];
    
    UIView* viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    viewTitle.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_viewBase addSubview:viewTitle];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    labelTitle.text = @"基本信息";
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewTitle addSubview:labelTitle];
    
    
    
    for (int i = 0; i < _arrayTitle.count; i ++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 30*ScreenWidth/375+30*ScreenWidth/375*i, 80*ScreenWidth/375, 30*ScreenWidth/375)];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        label.text = _arrayTitle[i];
        [_viewBase addSubview:label];
        label.textColor = [UIColor darkGrayColor];
    }
    
    NSString* strDate = [NSString stringWithFormat:@"%@  %@",_model.eventdate,_model.evnntWeek];
    NSString* strTime = [NSString stringWithFormat:@"%@",_model.eventTime];
    NSString* strEndDate = [NSString stringWithFormat:@"%@  %@",_model.eventendDate,_model.eventendWeek];
    NSString* strBallName = [NSString stringWithFormat:@"%@",_model.eventBallName];
    NSString* strState;
    if ([_model.eventIsPrivate integerValue] == 1) {
        strState = [NSString stringWithFormat:@"公开"];
    }
    else
    {
        strState = [NSString stringWithFormat:@"私密"];
    }
    NSString* strJoin;
    NSString* strWatch;
    if ([_model.eventIsPrivate integerValue] == 2) {
        strJoin = [NSString stringWithFormat:@"%@",_model.eventCompetitionNums];
        strWatch = [NSString stringWithFormat:@"%@",_model.eventWatchNums];
    }
    NSArray* arrayType = [[NSArray alloc]init];
    if ([_model.eventIsPrivate integerValue] == 2) {
        if ([_model.forrelevant integerValue] == 1) {
            arrayType = @[strDate, strTime, strEndDate, strBallName, strState,strJoin,strWatch];
        }
        else
        {
            arrayType = @[strDate, strTime, strEndDate, strBallName, strState];
        }
    }
    else{
        arrayType = @[strDate, strTime, strEndDate, strBallName, strState];
    }
    
    for (int i = 0; i < _arrayTitle.count; i ++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 30*ScreenWidth/375+30*ScreenWidth/375*i, ScreenWidth- 90*ScreenWidth/375, 30*ScreenWidth/375)];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        label.text = arrayType[i];
        [_viewBase addSubview:label];
    }
    
}
#pragma mark --赛事简介
-(void)createIntroView
{
    
    
    NSString* str = _model.eventContext;
    _labelHeight = [Helper textHeightFromTextString:str width:ScreenWidth-20*ScreenWidth/375 fontSize:14*ScreenWidth/375];
    if (_labelHeight <= 30*ScreenWidth/375) {
        _labelHeight = 30*ScreenWidth/375;
    }
    
    _viewIntro = [[UIView alloc]init];
    _viewIntro.backgroundColor = [UIColor whiteColor];
    UILabel* labelIntro = [[UILabel alloc]init];
    
    _viewIntro.frame = CGRectMake(0, 90*ScreenWidth/375 + 30*ScreenWidth/375*_arrayTitle.count, ScreenWidth, 30*ScreenWidth/375 + _labelHeight+ 20*ScreenWidth/375);
    [_scrollView addSubview:_viewIntro];
    labelIntro.frame = CGRectMake(10*ScreenWidth/375, 40*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, _labelHeight+10*ScreenWidth/375);
    labelIntro.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    if (![Helper isBlankString:_model.eventContext]) {
        labelIntro.text = str;
    }
    else
    {
        labelIntro.text = @"暂无简介";
    }
    labelIntro.textColor = [UIColor colorWithRed:0.69f green:0.69f blue:0.69f alpha:1.00f];
    [_viewIntro addSubview:labelIntro];
    labelIntro.numberOfLines = 0;
    labelIntro.backgroundColor = [UIColor whiteColor];
    
    
    UIView* viewTit = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    [_viewIntro addSubview:viewTit];
    viewTit.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    label.text = @"赛事简介";
    [viewTit addSubview:label];
    
    
    
}
#pragma mark --发起人
-(void)fabuSendView
{
    _viewFaqi = [[UIView alloc]initWithFrame:CGRectMake(0, 140*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth, 40*ScreenWidth/375 + 60*ScreenWidth/375)];
    [_scrollView addSubview:_viewFaqi];
    _viewFaqi.backgroundColor = [UIColor whiteColor];
    
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_viewFaqi addSubview:view];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    label.text = @"发起人";
    label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [view addSubview:label];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] != [_model.userId integerValue])
    {
        UIButton* btnReport = [UIButton buttonWithType:UIButtonTypeCustom];
        //    btnReport.backgroundColor = [UIColor redColor];
        btnReport.frame = CGRectMake(ScreenWidth-40, 0, 40, 30*ScreenWidth/375);
        [btnReport setTitle:@"投诉" forState:UIControlStateNormal];
        btnReport.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [btnReport setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:btnReport];
        [btnReport addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
    item.frame = CGRectMake(7*ScreenWidth/375,35*ScreenWidth/375, 60*ScreenWidth/375, 60*ScreenWidth/375);
    [_viewFaqi addSubview:item];
    item.imageView.layer.masksToBounds = YES;
    item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
    item.tag = 150;
    
    NoteModel *model = [NoteHandlle selectNoteWithUID:_model.eventCreateUserId];
    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        [item setTitle:_model.userName forState:UIControlStateNormal];
    }else{
        [item setTitle:model.userremarks forState:UIControlStateNormal];
    }
//    [item setTitle:_model.userName forState:UIControlStateNormal];
    [item sd_setImageWithURL:[Helper imageIconUrl:_model.userPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
    item.tag = 100;
    item.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [item addTarget:self action:@selector(selfDetClick:) forControlEvents:UIControlEventTouchUpInside];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}

-(void)reportClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportViewController * reportView = [[ReportViewController alloc]init];
        reportView.otherUserId = _model.eventCreateUserId;
        reportView.typeNum = @12;
        reportView.objId = _model.eventballId;
        [self.navigationController pushViewController:reportView animated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [self pingbiyonghu:[_dataArray[index] uId]];
        [[PostDataRequest sharedInstance] postDataRequest:@"shileAndRep/shileaboutball.do" parameter:@{@"objid":_model.eventballId,@"orderUserId":_model.eventCreateUserId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"type":@12} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                UIAlertController *alerT = [UIAlertController alertControllerWithTitle:@"提示" message:@"屏蔽成功!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    _blockRefresh();
                }];
                [alerT addAction:aler1];
                
                [self.navigationController presentViewController:alerT animated:YES completion:nil];
            }
            else
            {
                [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        } failed:^(NSError *error) {
            
        }];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)selfDetClick:(UIButton *)btn
{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = _model.eventCreateUserId;
    selfVc.messType = @2;
    [self.navigationController pushViewController:selfVc animated:YES];
}
#pragma mark --参与人数
-(void)cansaiView{
    if (_dataArrPeo.count != 0) {
        _viewCanyu = [[UIView alloc]initWithFrame:CGRectMake(0, 240*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth,30*ScreenWidth/375 + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1))];
    }
    else
    {
        _viewCanyu = [[UIView alloc]initWithFrame:CGRectMake(0, 240*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth, 30*ScreenWidth/375 + 60*ScreenWidth/375)];
    }
    
    [_scrollView addSubview:_viewCanyu];
    _viewCanyu.backgroundColor = [UIColor whiteColor];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_viewCanyu addSubview:view];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    label.text = [NSString stringWithFormat:@"参加人数:%ld人",(unsigned long)_dataArrPeo.count];
    label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [view addSubview:label];
    if (_dataArrPeo.count != 0) {
        for (int i = 0; i<_dataArrPeo.count; i++) {
            Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(7*ScreenWidth/375 + 60*ScreenWidth/375*(i%6),30*ScreenWidth/375 + 60*ScreenWidth/375 * (i/6), 60*ScreenWidth/375, 60*ScreenWidth/375);
            [_viewCanyu addSubview:item];
            
            item.imageView.layer.masksToBounds = YES;
            item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
            [item sd_setImageWithURL:[Helper imageIconUrl:[_dataArrPeo[i] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
            
            NoteModel *model = [NoteHandlle selectNoteWithUID:[_dataArrPeo[i] userId]];
            if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                [item setTitle:[_dataArrPeo[i] userName] forState:UIControlStateNormal];
            }else{
                [item setTitle:model.userremarks forState:UIControlStateNormal];
            }

            
//            [item setTitle:[_dataArrPeo[i] userName] forState:UIControlStateNormal];
            item.tag = 101 + i;
            item.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
            [item addTarget:self action:@selector(otherDClick:) forControlEvents:UIControlEventTouchUpInside];
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-16*ScreenWidth/375, 60*ScreenWidth/375)];
        label.text = @"暂时还没有参与约球的人";
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewCanyu addSubview:label];
    }
    
    
}
//查看参赛人员
-(void)otherDClick:(UIButton*)btn{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = [_dataArrPeo[btn.tag - 101] userId];
    selfVc.messType = @2;
    [self.navigationController pushViewController:selfVc animated:YES];
    
    
}


#pragma mark--待审核人员
-(void)waitApplysView
{
    
    UIView* viewAgree = [[UIView alloc]init];
    if ([_model.forrelevant integerValue] == 1) {
        if (_dataArrPeo.count != 0) {
            if (_dataWaitArray.count == 0) {
                viewAgree.frame = CGRectMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375);
            }
            else
            {
                viewAgree.frame = CGRectMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375*_dataWaitArray.count);
            }
        }
        else
        {
            if (_dataWaitArray.count == 0) {
                viewAgree.frame = CGRectMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375);
            }
            else{
                viewAgree.frame = CGRectMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375*_dataWaitArray.count);
            }
        }
    }
    else
    {
        if (_dataArrPeo.count != 0) {
            if (_dataWaitArray.count == 0) {
                viewAgree.frame = CGRectMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375 + 55*ScreenWidth/375);
            }
            else
            {
                viewAgree.frame = CGRectMake(0, 270*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight + 60*ScreenWidth/375*((_dataArrPeo.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375 + 55*ScreenWidth/375*_dataWaitArray.count);
            }
        }
        else
        {
            if (_dataWaitArray.count == 0) {
                viewAgree.frame = CGRectMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth, 30*ScreenWidth/375 + 55*ScreenWidth/375);
            }
            else{
                viewAgree.frame = CGRectMake(0, 330*ScreenWidth/375 + 30*ScreenWidth/375* _arrayTitle.count+_labelHeight, ScreenWidth, 30*ScreenWidth/375 + 55*ScreenWidth/375*_dataWaitArray.count);
            }
        }
    }
    viewAgree.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewAgree];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0*ScreenWidth/375, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewAgree addSubview:infoLabel];
    infoLabel.text = @"  待审核申请人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    if (_dataWaitArray.count != 0) {
        if ([_model.forrelevant integerValue] == 1) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 55*ScreenWidth/375*_dataWaitArray.count) style:UITableViewStylePlain];
        }
        else
        {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375*_dataWaitArray.count) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [viewAgree addSubview:_tableView];
        
        [_tableView registerClass:[ManageOtherTableViewCell class] forCellReuseIdentifier:@"ManageOtherTableViewCell"];
        [_tableView registerClass:[ManageSelfDetTableViewCell class] forCellReuseIdentifier:@"ManageSelfDetTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    else
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375)];
        label.text = @"暂无待审核申请人";
        label.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
        [viewAgree addSubview:label];
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _dataWaitArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.forrelevant integerValue] == 1) {
        return 55*ScreenWidth/375;
    }
    else
    {
        return 44*ScreenWidth/375;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_model.forrelevant integerValue] == 1) {
        
        ManageSelfDetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ManageSelfDetTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showManDetail:_dataWaitArray[indexPath.row]];
        cell.ballId = [_dataWaitArray[indexPath.row] teamApplyId];
        cell.userId = [_dataWaitArray[indexPath.row] userId];
        cell.callBackData = ^{
            [_dataWaitArray removeAllObjects];
            [_dataArrPeo removeAllObjects];
            for (UIView *v in [_scrollView subviews]) {
                [v removeFromSuperview];
            }
            [self showDataView];
        };
        return cell;
    }
    else
    {
        ManageOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageOtherTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataWaitArray[indexPath.row]];
        return cell;
    }
    return nil;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _btnBase.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if(textField.tag == 333)
        {
            if (ScreenHeight > 568) {
                _scrollView.contentOffset = CGPointMake(0, 210);
            }
            else if (ScreenHeight == 568)
            {
                _scrollView.contentOffset = CGPointMake(0, 250*ScreenWidth/375);
            }
            else
            {
                _scrollView.contentOffset = CGPointMake(0, 300);
            }
        }
        else
        {
            if (ScreenHeight > 568) {
                _scrollView.contentOffset = CGPointMake(0, 250);
            }
            else if (ScreenHeight == 568)
            {
                _scrollView.contentOffset = CGPointMake(0, 300*ScreenWidth/375);
            }
            else
            {
                _scrollView.contentOffset = CGPointMake(0, 350);
            }
        }
        
    }];
    
}

-(void)sureBtn
{
    _viewSure = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50*ScreenWidth/375-64, ScreenWidth, 50*ScreenWidth/375)];
    [self.view addSubview:_viewSure];
    _viewSure.userInteractionEnabled = YES;
    
    UIButton* btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChat.frame = CGRectMake(0, 0, ScreenWidth/3, 50*ScreenWidth/375);
    [_viewSure addSubview:btnChat];
    [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
    [btnChat setImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
    btnChat.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -50*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
    btnChat.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
    btnChat.tag = 1000;
    btnChat.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
    //    [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
    [btnChat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnChat.layer.borderWidth = 1.0;
    btnChat.backgroundColor = [UIColor whiteColor];
    
    UIButton* btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(ScreenWidth/3-1, 0, ScreenWidth/3+1, 50*ScreenWidth/375);
    [_viewSure addSubview:btnShare];
    [btnShare setTitle:@"分享" forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    btnShare.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -40*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
    btnShare.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
    btnShare.tag = 1000;
    btnShare.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
    
    [btnShare setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnShare.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShare.layer.borderWidth = 1.0;
    btnShare.backgroundColor = [UIColor whiteColor];
    
    
    _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnJoin.backgroundColor = [UIColor orangeColor];
    [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_viewSure addSubview:_btnJoin];
    _btnJoin.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 50*ScreenWidth/375);
    _btnJoin.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    //公开
    if ([_model.eventIsPrivate integerValue] == 1) {
        //未开始
        if ([_model.eventisEndStart integerValue] == 2) {
            //我创建的
            if ([_model.forrelevant integerValue] == 1) {
                [btnChat setTitle:@"分享" forState:UIControlStateNormal];
                [btnChat setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
                //分享点击事件
                [btnChat addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare setTitle:@"邀请" forState:UIControlStateNormal];
                [btnShare addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
                
                [_btnJoin setTitle:@"取消赛事" forState:UIControlStateNormal];
                [_btnJoin addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
            }
            //我参与的
            else if ([_model.forrelevant integerValue] == 2 || [_model.forrelevant integerValue] == 5)
            {
                [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                
                [_btnJoin addTarget:self action:@selector(cancelJoinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"取消加入" forState:UIControlStateNormal];
            }
            //未参加
            else
            {
                [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                
                [_btnJoin addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"申请加入" forState:UIControlStateNormal];
            }
        }
        //已经开始
        else if ([_model.eventisEndStart integerValue] == 1){
            
            //我创建的
            if ([_model.forrelevant integerValue] == 1) {
                for (UIView *v in [_viewSure subviews]) {
                    [v removeFromSuperview];
                }
                UIButton* btnScore = [UIButton buttonWithType:UIButtonTypeCustom];
                btnScore.frame = CGRectMake(0, 0, ScreenWidth/2, 50*ScreenWidth/375);
                [btnScore setTitle:@"记分" forState:UIControlStateNormal];
                [_viewSure addSubview:btnScore];
                btnScore.titleLabel.font = [UIFont systemFontOfSize:19*ScreenWidth/375];
                [btnScore addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
                [btnScore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnScore.backgroundColor = [UIColor orangeColor];
                
                UIButton* btnWatch = [UIButton buttonWithType:UIButtonTypeCustom];
                btnWatch.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50*ScreenWidth/375);
                [btnWatch setTitle:@"观赛" forState:UIControlStateNormal];
                [_viewSure addSubview:btnWatch];
                btnWatch.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
                [btnWatch addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
                [btnWatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnWatch.backgroundColor = [UIColor orangeColor];
                
            }
            //我参与的
            else if ([_model.forrelevant integerValue] == 2)
            {
                //                [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
                [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
                [btnShare setTitle:@"记分" forState:UIControlStateNormal];
                
                [_btnJoin addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"查看赛事" forState:UIControlStateNormal];
            }
            //未参加
            else
            {
                for (UIView *v in [_viewSure subviews]) {
                    [v removeFromSuperview];
                }
                
                UIButton *enter = [UIButton buttonWithType:UIButtonTypeCustom];
                
                enter.backgroundColor = [UIColor orangeColor];
                enter.frame = CGRectMake(ScreenWidth/2+2, 0, ScreenWidth/2-1, 50*ScreenWidth/375);
                [enter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [enter addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
                [enter setTitle:@"查看赛事" forState:UIControlStateNormal];
                [_viewSure addSubview:enter];
                
                _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnJoin.backgroundColor = [UIColor orangeColor];
                _btnJoin.frame = CGRectMake(0, 0, ScreenWidth/2-1, 50*ScreenWidth/375);
                [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_btnJoin addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"申请加入" forState:UIControlStateNormal];
                [_viewSure addSubview:_btnJoin];
            }
        }
        //结束
        else
        {
            for (UIView *v in [_viewSure subviews]) {
                [v removeFromSuperview];
            }
            _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnJoin.backgroundColor = [UIColor orangeColor];
            [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_viewSure addSubview:_btnJoin];
            _btnJoin.frame = CGRectMake(0, 0, ScreenWidth, 50*ScreenWidth/375);
            [_btnJoin setTitle:@"查看赛事" forState:UIControlStateNormal];
            [_btnJoin addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //私有
    else
    {
        //未开始
        if ([_model.eventisEndStart integerValue] == 2) {
            //我创建的
            if ([_model.forrelevant integerValue] == 1) {
                [btnChat setTitle:@"分享" forState:UIControlStateNormal];
                [btnChat setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
                //分享点击事件
                [btnChat addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare setTitle:@"邀请" forState:UIControlStateNormal];
                [btnShare addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
                
                [_btnJoin setTitle:@"取消赛事" forState:UIControlStateNormal];
                [_btnJoin addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
            }
            //我参与的
            else if ([_model.forrelevant integerValue] == 2 || [_model.forrelevant integerValue] == 5)
            {
                [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                
                [_btnJoin addTarget:self action:@selector(cancelJoinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"取消加入" forState:UIControlStateNormal];
            }
            //未参加
            else
            {
                //弹窗
                [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                
                [_btnJoin addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"申请加入" forState:UIControlStateNormal];
            }
        }
        //已经开始
        else if ([_model.eventisEndStart integerValue] == 1)
        {
            //我创建的
            if ([_model.forrelevant integerValue] == 1) {
                for (UIView *v in [_viewSure subviews]) {
                    [v removeFromSuperview];
                }
                UIButton* btnScore = [UIButton buttonWithType:UIButtonTypeCustom];
                btnScore.frame = CGRectMake(0, 0, ScreenWidth/2, 50*ScreenWidth/375);
                [btnScore setTitle:@"记分" forState:UIControlStateNormal];
                [_viewSure addSubview:btnScore];
                btnScore.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
                [btnScore addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
                [btnScore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnScore.backgroundColor = [UIColor orangeColor];
                
                UIButton* btnWatch = [UIButton buttonWithType:UIButtonTypeCustom];
                btnWatch.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50*ScreenWidth/375);
                [btnWatch setTitle:@"观赛" forState:UIControlStateNormal];
                [_viewSure addSubview:btnWatch];
                btnWatch.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
                [btnWatch addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
                [btnWatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnWatch.backgroundColor = [UIColor orangeColor];
                
            }
            //我参与的
            else if ([_model.forrelevant integerValue] == 2)
            {
                //                [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
                [btnChat addTarget:self action:@selector(siliaoClick) forControlEvents:UIControlEventTouchUpInside];
                
                [btnShare addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
                [btnShare setTitle:@"记分" forState:UIControlStateNormal];
                
                [_btnJoin addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"查看赛事" forState:UIControlStateNormal];
            }
            //未参加
            else
            {
                //弹窗
                for (UIView *v in [_viewSure subviews]) {
                    [v removeFromSuperview];
                }
                _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnJoin.backgroundColor = [UIColor orangeColor];
                [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_viewSure addSubview:_btnJoin];
                _btnJoin.frame = CGRectMake(0, 0, ScreenWidth, 50*ScreenWidth/375);
                [_btnJoin addTarget:self action:@selector(watchSecretClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin setTitle:@"查看赛事" forState:UIControlStateNormal];
            }
        }
        //结束
        else
        {
            //弹窗
            for (UIView *v in [_viewSure subviews]) {
                [v removeFromSuperview];
            }
            _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnJoin.backgroundColor = [UIColor orangeColor];
            [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_viewSure addSubview:_btnJoin];
            _btnJoin.frame = CGRectMake(0, 0, ScreenWidth, 50*ScreenWidth/375);
            [_btnJoin setTitle:@"查看赛事" forState:UIControlStateNormal];
            //需要弹窗
            if ([_model.forrelevant integerValue] == 3) {
                [_btnJoin addTarget:self action:@selector(watchSecretClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [_btnJoin addTarget:self action:@selector(watchClick) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
    }
    
    
}

//私聊
-(void)siliaoClick
{
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    //设置聊天类型
    vc.conversationType = ConversationType_PRIVATE;
    //设置对方的id
    vc.targetId = [NSString stringWithFormat:@"%@",_model.eventCreateUserId];
    //设置对方的名字
    //    vc.userName = model.conversationTitle;
    //设置聊天标题
    vc.title = _model.userName;
    //设置不现实自己的名称  NO表示不现实
    vc.displayUserNameInCell = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//分享点击事件
-(void)shareClick
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
    NSData *fxData;
    UIImage* fxImg;
    if (![Helper isBlankString:_model.userPic]) {
        fxData = [NSData dataWithContentsOfURL:[Helper imageUrl:_model.userPic]];
    }
    else
    {
        fxImg = [UIImage imageNamed:@"logo"];
    }
    
    NSString * shareUrl = [NSString stringWithFormat:@"http://139.196.9.49:8081/dagaoerfu/html5/team/Event_details.html?id=%@",_model.eventId];
    [UMSocialData defaultData].extConfig.title=_model.eventTite;
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        if (![Helper isBlankString:_model.userPic]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_model.eventContext image:fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_model.eventContext image:fxImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        
        
        if (![Helper isBlankString:_model.userPic]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_model.eventContext image:fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_model.eventContext image:fxImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        if (![Helper imageIconUrl:_model.userPic]) {
            data.shareImage = [UIImage imageWithData:fxData];
        }
        else
        {
            data.shareImage = [UIImage imageNamed:@"logo"];
        }
        data.shareText = [NSString stringWithFormat:@"%@%@%@",_model.eventTite,_model.eventContext,shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        
    }
}



//邀请好友点击事件
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
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/saveMesss.do" parameter:@{@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"content":[NSString stringWithFormat:@"%@邀请您参加他的赛事",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]],@"messObjid":_model.eventId,@"messType":@12,@"idlist":nsIdList} success:^(id respondsData) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    };
    teamVc.arrayIndex = _arrayIndex;
    teamVc.arrayData = _arrayData1;
    
    [self.navigationController pushViewController:teamVc animated:YES];
}
//取消赛事点击事件
-(void)cancelClick
{
    [Helper alertViewWithTitle:@"您是否确定要取消此赛事" withBlockCancle:^{
        
    } withBlockSure:^{
        [_dictCancel setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        [_dictCancel setValue:_model.eventId forKey:@"ids"];
        [_dictCancel setValue:@"您参加的球队活动已被取消" forKey:@"context"];
        
        [[PostDataRequest sharedInstance] postDataRequest:@"tballevent/delete.do" parameter:_dictCancel success:^(id respondsData) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                for (UIView *v in [_viewSure subviews]) {
                    [v removeFromSuperview];
                }
                _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnJoin.backgroundColor = [UIColor orangeColor];
                [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_viewSure addSubview:_btnJoin];
                _btnJoin.frame = CGRectMake(0, 0, ScreenWidth, 50*ScreenWidth/375);
                [_btnJoin setTitle:@"已取消" forState:UIControlStateNormal];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
        } failed:^(NSError *error) {
            
        }];
    } withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
    
}
//取消申请点击事件
-(void)cancelJoinClick
{
    
    [Helper alertViewWithTitle:@"是否取消申请?" withBlockCancle:^{
        
        
    } withBlockSure:^{
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        _progress.mode = MBProgressHUDModeIndeterminate;
        _progress.labelText = @"正在取消申请...";
        [self.view addSubview:_progress];
        [_progressHud show:YES];
        [_dictDeleJoin setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        [_dictDeleJoin setValue:@12 forKey:@"applyType"];
        [_dictDeleJoin setValue:_model.eventId forKey:@"teamId"];
        
        [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/delete.do" parameter:_dictDeleJoin success:^(id respondsData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                
                [_dataWaitArray removeAllObjects];
                [_dataArrPeo removeAllObjects];
                for (UIView *v in [_scrollView subviews]) {
                    [v removeFromSuperview];
                }
                [self showDataView];
                _model.forrelevant = @3;
                [_btnJoin setTitle:@"报名参赛" forState:UIControlStateNormal];
                [_btnJoin removeTarget:self action:@selector(cancelJoinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
                
            }else {
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alert show];
            }
            
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        
    } withBlock:^(UIAlertController *alertView) {
        
        [self presentViewController:alertView animated:YES completion:nil];
    }];
    
}
//申请加入点击事件
-(void)joinClick
{
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在取消申请...";
    [self.view addSubview:_progress];
    [_progressHud show:YES];
    //公开赛事
    if ([_model.eventIsPrivate integerValue] == 1) {
        [_dictJoin setValue:_model.eventId forKey:@"teamId"];
        [_dictJoin setValue:@12 forKey:@"applyType"];
        [_dictJoin setValue:[NSString stringWithFormat:@"%@申请加入您的赛事",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
        [_dictJoin setValue:_model.eventCreateUserId forKey:@"userIds"];
        [_dictJoin setValue:_model.eventIsPrivate forKey:@"eventIsPrivate"];
        [_dictJoin setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        //        type
        if (_typeNews != nil) {
            [_dictJoin setObject:@1 forKey:@"type"];
        }
        else
        {
            [_dictJoin setObject:@2 forKey:@"type"];
        }

        [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/save.do" parameter:_dictJoin success:^(id respondsData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                
                
                
                [_dataWaitArray removeAllObjects];
                [_dataArrPeo removeAllObjects];
                for (UIView *v in [_scrollView subviews]) {
                    [v removeFromSuperview];
                }
                [self showDataView];
                _model.forrelevant = @5;
                [_btnJoin setTitle:@"取消申请" forState:UIControlStateNormal];
                [_btnJoin removeTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
                [_btnJoin addTarget:self action:@selector(cancelJoinClick) forControlEvents:UIControlEventTouchUpInside];
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else
    {
        _stateNum = 1;
        //自定义的显示框
        _alertView = [[CustomIOSAlertView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定",nil]];//添加按钮
        //[alertView setDelegate:self];
        _alertView.delegate = self;
        _alertView.tag = 1024;
        [_alertView setContainerView:[self createSecret]];
        [_alertView show];
    }
    
}
#pragma mark --自定义UIalert
//自定义alert视图
- (UIView *)createSecret
{
    
    //    UICollectionView
    UIView *actView = [[UIView alloc] initWithFrame:CGRectMake(0*ScreenWidth/375, 0, ScreenWidth-40*ScreenWidth/375, 150*ScreenWidth/375)];
    //标题
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, actView.frame.size.width-20*ScreenWidth/375, 60*ScreenWidth/375)];
    
    labelTitle.text = @"请输入邀请码";
    labelTitle.numberOfLines = 0;
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [actView addSubview:labelTitle];
    
    
    
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth-16*ScreenWidth/375, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    [actView addSubview:viewLine];
    
    
    if (_stateNum == 1) {
        UILabel * labelWatch = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 85*ScreenWidth/375, 80*ScreenWidth/375, 44*ScreenWidth/375)];
        labelWatch.text = @"参赛码";
        labelWatch.backgroundColor = [UIColor orangeColor];
        labelWatch.textColor = [UIColor whiteColor];
        [actView addSubview:labelWatch];
        labelWatch.layer.masksToBounds = YES;
        labelWatch.layer.cornerRadius = 8*ScreenWidth/375;
        labelWatch.textAlignment = NSTextAlignmentCenter;
        
        _textFieldJoin = [[UITextField alloc]initWithFrame:CGRectMake(100*ScreenWidth/375, 85*ScreenWidth/375, ScreenWidth-110*ScreenWidth/375, 44*ScreenWidth/375)];
        _textFieldJoin.placeholder = @"请输入参赛码";
        [actView addSubview:_textFieldJoin];
        _textFieldJoin.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _textFieldJoin.tag = 123;
        _textFieldJoin.delegate = self;
        _textFieldJoin.layer.cornerRadius = 5;
        _textFieldJoin.layer.masksToBounds = YES;
    }
    else
    {
        UILabel * labelWatch = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 85*ScreenWidth/375, 80*ScreenWidth/375, 44*ScreenWidth/375)];
        labelWatch.text = @"观赛码";
        labelWatch.backgroundColor = [UIColor orangeColor];
        labelWatch.textColor = [UIColor whiteColor];
        [actView addSubview:labelWatch];
        labelWatch.layer.masksToBounds = YES;
        labelWatch.layer.cornerRadius = 8*ScreenWidth/375;
        labelWatch.textAlignment = NSTextAlignmentCenter;
        
        _textFieldWatch = [[UITextField alloc]initWithFrame:CGRectMake(100*ScreenWidth/375, 85*ScreenWidth/375, ScreenWidth-110*ScreenWidth/375, 44*ScreenWidth/375)];
        _textFieldWatch.placeholder = @"请输入观赛码";
        [actView addSubview:_textFieldWatch];
        _textFieldWatch.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _textFieldWatch.tag = 124;
        _textFieldWatch.delegate = self;
        _textFieldWatch.layer.cornerRadius = 5;
        _textFieldWatch.layer.masksToBounds = YES;
        
    }
    
    return actView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    [self.view endEditing:YES];
    if (alertView.tag == 1024) {
        if ((int)buttonIndex == 0) {
            
        }
        else
        {
            
            //参赛
            if ([_textFieldJoin.text isEqualToString:_model.eventCompetitionNums]) {
                
                
                
                [_dictJoin setValue:_model.eventId forKey:@"teamId"];
                [_dictJoin setValue:@12 forKey:@"applyType"];
                [_dictJoin setValue:[NSString stringWithFormat:@"%@申请加入您的赛事",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
                [_dictJoin setValue:_model.eventCreateUserId forKey:@"userIds"];
                [_dictJoin setValue:_model.eventIsPrivate forKey:@"eventIsPrivate"];
                [_dictJoin setValue:@1 forKey:@"type"];
                [_dictJoin setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
                _progress = [[MBProgressHUD alloc] initWithView:self.view];
                _progress.mode = MBProgressHUDModeIndeterminate;
                _progress.labelText = @"正在取消申请...";
                [self.view addSubview:_progress];
                [_progressHud show:YES];
                [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/save.do" parameter:_dictJoin success:^(id respondsData) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"] boolValue]) {
                        
                        
                        [_dataWaitArray removeAllObjects];
                        [_dataArrPeo removeAllObjects];
                        for (UIView *v in [_scrollView subviews]) {
                            [v removeFromSuperview];
                        }
                        [self showDataView];
                        _model.forrelevant = @5;
                        [_btnJoin setTitle:@"取消申请" forState:UIControlStateNormal];
                        [_btnJoin removeTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
                        [_btnJoin addTarget:self action:@selector(cancelJoinClick) forControlEvents:UIControlEventTouchUpInside];
                        
                    }else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failed:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的邀请码有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    else
    {
        
        
        if ((int)buttonIndex == 0) {
            
        }
        else
        {
            //观赛
            if ([_textFieldWatch.text isEqualToString:_model.eventWatchNums]) {
                ManageWatchViewController* watchVc = [[ManageWatchViewController alloc]init];
                watchVc.type1 = @12;
                watchVc.manageId = _model.eventId;
                
                [self.navigationController pushViewController:watchVc animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的邀请码有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        }
    }
    
    [alertView close];
}

//记分点击事件
-(void)scoreClick
{
    ScoreByGameViewController* scVc = [[ScoreByGameViewController alloc]init];
    if ([_model.isjf integerValue] > 0) {
        scVc.isSave = @10;
    }
    scVc.strTitle = _model.eventTite;
    scVc.pic = _model.eventPic;
    scVc.ballId = [_model.eventballId integerValue];
    scVc.ballName = _model.eventBallName;
    scVc.scoreType = @12;
    scVc.createTime = _model.eventCreateTime;
    scVc.eventObjId = _model.eventId;
    [self.navigationController pushViewController:scVc animated:YES];
}
//观赛点击事件
-(void)watchClick
{
    ManageWatchViewController* watchVc = [[ManageWatchViewController alloc]init];
    watchVc.type1 = @12;
    watchVc.manageId = _model.eventId;
    
    [self.navigationController pushViewController:watchVc animated:YES];
}
-(void)watchSecretClick
{
    //自定义的显示框
    _stateNum = 2;
    _alertView = [[CustomIOSAlertView alloc] init];
    _alertView.backgroundColor = [UIColor whiteColor];
    [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定",nil]];//添加按钮
    //[alertView setDelegate:self];
    _alertView.delegate = self;
    [_alertView setContainerView:[self createSecret]];
    [_alertView show];
    _alertView.tag = 1025;
}




@end
