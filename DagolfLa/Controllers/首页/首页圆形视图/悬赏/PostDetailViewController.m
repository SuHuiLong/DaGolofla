//
//  PostDetailViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Setbutton.h"
#import "HorButtonSet.h"

#import "PersonHomeController.h"
#import "MineRewardViewController.h"

#import "ChatDetailViewController.h"

#import "AppraiseViewController.h"
#import "YueBallHallView.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "ShareAlert.h"

#import "TeamMessageController.h"

#import "RewardWaitViewController.h"
#import "YueWaitTableViewCell.h"

#import "RewardDetailModel.h"
#import "RewordCheckModel.h"
#import "MBProgressHUD.h"
#import "RewardArravelTableViewCell.h"
#import "ReportViewController.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#define kUserChange_URL @"aboutBallRewardJoin/update.do"
#define kSaveBall_URL @"aboutBallRewardJoin/save.do"
#define kJoin_URL @"aboutBallRewardJoin/queryPage.do"
#define kUpdate_urk @"aboutBallReward/update.do"
#import "TeamInviteViewController.h"
@interface PostDetailViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIView* _viewMore;
    //    BOOL _showView;
    UIScrollView* _scrollView;
    NSMutableString* _strUserId;
    
    
    NSMutableArray* _waitArray;
    NSMutableArray* _agreeArray;
    
    BOOL _isClick;
    BOOL _isFinish;
    NSMutableDictionary* _dict;
    UIButton* _btnPost;
    
    YueBallHallView *_viewTanTu;
    BOOL _showView;
    
    UITableView* _tableView;
    RewardDetailModel* _model;
    UIView* _viewBtnBasic;
    UIButton* _btnIsState;
    MBProgressHUD* _progressHud;
    MBProgressHUD* _progre;
    
    CGFloat _height;
    NSMutableArray* _arrayIndex,* _arrayData1,* _arrayData,* _messageArray,* _telArray;
}
@end

@implementation PostDetailViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _showView = NO;
    
    
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
    
    
    self.title = @"悬赏详情";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        
        _strUserId = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
    }
    
    _dict = [[NSMutableDictionary alloc]init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49*ScreenWidth/375)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(0, 568-49);
    _scrollView.delegate = self;
    
    _waitArray = [[NSMutableArray alloc]init];
    _agreeArray = [[NSMutableArray alloc]init];
    
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"正在刷新...";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"aboutBallReward/get.do" parameter:@{@"aboutBallReId":_aboutBallId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            //            for (NSDictionary *dataDict in ) {
            _model = [[RewardDetailModel alloc] init];
            [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
            
            //NSLog(@"%@",[dict objectForKey:@"rows"]);
            
            if (![Helper isBlankString:_model.reInfo]) {
                _height = [Helper textHeightFromTextString:_model.reInfo width:(ScreenWidth - 110*ScreenWidth/375) fontSize:15*ScreenWidth/375];
            }
            else
            {
                _height = 20*ScreenWidth/375;
            }
            if (_height < 20*ScreenWidth/375) {
                _height = 20*ScreenWidth/375;
            }
            
            [self createViewData];
            
            
            
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view  animated:NO];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
        
    }];
    
    
}

-(void)createViewData
{
    [[PostDataRequest sharedInstance] postDataRequest:kJoin_URL parameter:@{@"aboutBallReId":_aboutBallId,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];

        [MBProgressHUD hideHUDForView:self.view  animated:NO];
        if ([[dictData objectForKey:@"state"] integerValue] == 1) {
            if ([[dictData objectForKey:@"success"] boolValue]) {
                
                //待审核
                [self getInfoForAddArray:[[dictData objectForKey:@"rows"] objectForKey:@"type0"]];
                //已通过
                [self getInfoForAgrArray:[[dictData objectForKey:@"rows"] objectForKey:@"type1"]];
            }
            //基本信息
            [self createBasicInformation];
            //    //悬赏要求
            [self createRewardRequest];
            //发布人
            [self createReleasePeople];
            
            [self createClickBtn];
            
            //已成功应赏人数
            [self createRewardNumber];
            
            [self createWaitView];
            
            //控制屏幕滑动
            
            if ([_model.applystate integerValue] == 1) {
                if (_agreeArray.count != 0) {
                    _scrollView.contentSize = CGSizeMake(0, 390*ScreenWidth/375 +_height + 60*ScreenWidth/375 + 60*ScreenWidth/375*((_agreeArray.count-1)/6+1) + 55*ScreenWidth/375*_waitArray.count-15*ScreenWidth/375);
                }
                else{
                    _scrollView.contentSize = CGSizeMake(0, 390*ScreenWidth/375 +_height + 60*ScreenWidth/375 + 30*ScreenWidth/375 + _waitArray.count*44*ScreenWidth/375+44*ScreenWidth/375);
                }
            }
            else
            {
                if (_agreeArray.count != 0) {
                    //
                    _scrollView.contentSize = CGSizeMake(0, 390*ScreenWidth/375 +_height + 60*ScreenWidth/375*(((_agreeArray.count-1)/6+1)) + 45*ScreenWidth/375 + 44*ScreenWidth/375*_waitArray.count);
                }
                else{
                    _scrollView.contentSize = CGSizeMake(0, 390*ScreenWidth/375 +_height + 60*ScreenWidth/375 + 30*ScreenWidth/375 + 44*ScreenWidth/375*_waitArray.count);
                }
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dictData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
        
    }];
}

//待审核
- (void)getInfoForAddArray:(NSMutableArray *)arr {
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *sportDic = arr[i];
        RewordCheckModel *model = [[RewordCheckModel alloc] init];
        [model setValuesForKeysWithDictionary:sportDic];
        [_waitArray addObject:model];
    }
    
}
//已通过
- (void)getInfoForAgrArray:(NSMutableArray *)arr {
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *sportDic = arr[i];
        RewordCheckModel *model = [[RewordCheckModel alloc] init];
        [model setValuesForKeysWithDictionary:sportDic];
        //        if (![Helper isBlankString:model.userName]) {
        [_agreeArray addObject:model];
    }
}

-(void)ShowViewClick{
    
    if (_showView == NO) {
        _showView = YES;
        
        if (_viewTanTu) {
            _viewTanTu.hidden = NO;
        } else {
            [self createBtnView];
        }
    }
    else
    {
        _showView = NO;
        
        _viewTanTu.hidden = YES;
    }
    
}
//点击弹出窗
-(void)createBtnView
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"我的悬赏", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home", @"nes", @"xsbar", nil];
    
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    [_viewTanTu showString:arr];
    [_viewTanTu showImage:imageArr];
    __weak UINavigationController *nav = self.navigationController;
    _viewTanTu.isXuanSang = 2;
    _viewTanTu.block = ^(UIViewController *vc){
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        ////NSLog(@"%@", vc.title);
        [nav pushViewController:vc animated:YES];
    };
    _viewTanTu.blockFirstPage = ^(UIViewController *vc){
        [nav popToRootViewControllerAnimated:YES];
    };
    // 设置xib视图的尺寸
    _viewTanTu.frame = CGRectMake((self.view.frame.size.width - 110), 0, 102, 102);
    [self.view addSubview:_viewTanTu];
    
    
}
//跳转我的悬赏界面
-(void)myPostClick:(UIButton*)btn
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        if (btn.tag == 152) {
            MineRewardViewController* mineVc = [[MineRewardViewController alloc]init];
            [self.navigationController pushViewController:mineVc animated:YES];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
-(void)createBasicInformation
{
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  基本信息";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    NSArray* titleArray = @[@"悬赏标题：",@"悬赏金额：",@"开球时间：",@"球场：",@"悬赏详情："];
    for (int i = 0; i < 5; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 40*ScreenWidth/375 + i * 25*ScreenWidth/375, 75*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelDetail.text = titleArray[i];
        labelDetail.backgroundColor = [UIColor clearColor];
        labelDetail.textColor = [UIColor darkGrayColor];
        [_scrollView addSubview:labelDetail];
    }
    
    NSMutableArray *detailArray = [NSMutableArray array];
    if (_model.reTitle != nil) {
        [detailArray addObject:_model.reTitle];
    }
    else
    {
        [detailArray addObject:@"暂无标题"];
    }
    if (_model.reMoney != nil) {
        if ([_model.reMoney integerValue] == -1) {
            [detailArray addObject:@"不限"];
        }
        else{
            [detailArray addObject:_model.reMoney];
        }
        
    }else
    {
        [detailArray addObject:@"不限金额"];
    }
    if (![Helper isBlankString:_model.playTimes]) {
        [detailArray addObject:_model.playTimes];
    } else {
        [detailArray addObject:@"不限时间"];
    }
    
    if (_model.ballName != nil) {
        [detailArray addObject:_model.ballName];
    } else {
        [detailArray addObject:@"不限球场"];
    }
    
    for (int i = 0; i < detailArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 40*ScreenWidth/375 + i * 25*ScreenWidth/375, ScreenWidth - 110*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        if ([detailArray[i] isKindOfClass:[NSNumber class]]) {
            labelDetail.text = [NSString stringWithFormat:@"%@",detailArray[i]];
        }else{
            labelDetail.text = detailArray[i];
        }
        
        labelDetail.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:labelDetail];
    }
    UILabel* labelDetData = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 40*ScreenWidth/375 + 4 * 25*ScreenWidth/375, ScreenWidth - 110*ScreenWidth/375, _height)];
    labelDetData.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    if (![Helper isBlankString:_model.reInfo]) {
        labelDetData.text = [NSString stringWithFormat:@"%@",_model.reInfo];
    }else{
        labelDetData.text = @"暂无消息";
    }
    labelDetData.numberOfLines = 0;
    labelDetData.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:labelDetData];
    
}
-(void)createRewardRequest
{
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150*ScreenWidth/375+_height, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  悬赏要求";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    NSArray* titleArray = @[@"性别：",@"球龄：",@"差点："];
    for (int i = 0; i < 3; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 190*ScreenWidth/375 + i * 25*ScreenWidth/375 +_height, 75*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelDetail.text = titleArray[i];
        labelDetail.backgroundColor = [UIColor clearColor];
        labelDetail.textColor = [UIColor darkGrayColor];
        [_scrollView addSubview:labelDetail];
    }
    
    //    NSArray* detailArray = @[@"不限",@"不限",@"不限"];
    //    NSArray* detailArray = @[_model.sex,_model.ballYear,_model.almost];
    
    NSMutableArray *detailArray = [NSMutableArray array];
    if (_model.sex != nil) {
        if ([_model.sex integerValue] == 2) {
            [detailArray addObject:@"男"];
        } else if ([_model.sex integerValue] == 1){
            [detailArray addObject:@"女"];
        } else {
            [detailArray addObject:@"不限"];
        }
        
    } else {
        [detailArray addObject:@"不限"];
    }
    if (![Helper isBlankString:_model.ballYear]) {
        [detailArray addObject:_model.ballYear];
    } else {
        [detailArray addObject:@"不限"];
    }
    if (![Helper isBlankString:_model.almost]) {
        [detailArray addObject:_model.almost];
        
    } else {
        [detailArray addObject:@"不限"];
    }
    for (int i = 0; i < detailArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 190*ScreenWidth/375 + i * 25*ScreenWidth/375 +_height, ScreenWidth - 110*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        if ([detailArray[i] isKindOfClass:[NSNumber class]]) {
            labelDetail.text = [NSString stringWithFormat:@"%@",detailArray[i]];
        }else{
            labelDetail.text = detailArray[i];
        }
        
        labelDetail.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:labelDetail];
    }
}
-(void)createReleasePeople
{
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 265*ScreenWidth/375+_height, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  发布人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    //NSLog(@"%@   %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],_model.userId);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] != [_model.userId integerValue]) {
        UIButton* btnReport = [UIButton buttonWithType:UIButtonTypeCustom];
        //    btnReport.backgroundColor = [UIColor redColor];
        btnReport.frame = CGRectMake(ScreenWidth-40, 265*ScreenWidth/375+_height, 40, 30*ScreenWidth/375);
        [btnReport setTitle:@"投诉" forState:UIControlStateNormal];
        btnReport.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [btnReport setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnReport];
        [btnReport addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
    item.frame = CGRectMake(10*ScreenWidth/375, 295*ScreenWidth/375+_height, 60*ScreenWidth/375, 60*ScreenWidth/375);
    [_scrollView addSubview:item];
    item.imageView.layer.masksToBounds = YES;
    item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
    item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    
    
    NoteModel *model = [NoteHandlle selectNoteWithUID:_model.userId];
    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        [item setTitle:_model.userName forState:UIControlStateNormal];
    }else{
        [item setTitle:model.userremarks forState:UIControlStateNormal];

    }
    
//    [item setTitle:_model.userName forState:UIControlStateNormal];
    [item sd_setImageWithURL:[Helper imageIconUrl:_model.uPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
    item.tag = 100;
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item addTarget:self action:@selector(selfDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)reportClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportViewController * reportView = [[ReportViewController alloc]init];
        reportView.otherUserId = _model.userId;
        reportView.typeNum = @15;
        reportView.objId = _model.aboutBallReId;
        [self.navigationController pushViewController:reportView animated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [self pingbiyonghu:[_dataArray[index] uId]];
        
        [[PostDataRequest sharedInstance] postDataRequest:@"shileAndRep/shileaboutball.do" parameter:@{@"objid":_model.aboutBallReId,@"orderUserId":_model.userId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"type":@15} success:^(id respondsData) {
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

-(void)createRewardNumber
{
    UIView* viewAgree = [[UIView alloc]init];
    if (_agreeArray.count == 0) {
        viewAgree.frame =  CGRectMake(0, 360*ScreenWidth/375+_height, ScreenWidth, 40*ScreenWidth/375 + 60*ScreenWidth/375);
    }
    else
    {
        viewAgree.frame = CGRectMake(0, 360*ScreenWidth/375+_height, ScreenWidth, 40*ScreenWidth/375 + 60*ScreenWidth/375*((_agreeArray.count-1)/6+1));
    }
    
    [_scrollView addSubview:viewAgree];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewAgree addSubview:infoLabel];
    infoLabel.text = [NSString stringWithFormat:@"  已获准参加的人数%ld/%ld人",(unsigned long)_agreeArray.count,(unsigned long)_agreeArray.count + (unsigned long)_waitArray.count];
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    if (_agreeArray.count != 0) {
        for (int i = 0; i<_agreeArray.count; i++) {
            Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(7*ScreenWidth/375 + 60*ScreenWidth/375*(i%6),30*ScreenWidth/375 + 60*ScreenWidth/375 * (i/6), 60*ScreenWidth/375, 60*ScreenWidth/375);
            [viewAgree addSubview:item];
            item.imageView.layer.masksToBounds = YES;
            item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
            
            NoteModel *model = [NoteHandlle selectNoteWithUID:[_agreeArray[i] userId]];
            if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                [item setTitle:[_agreeArray[i] userName] forState:UIControlStateNormal];
            }else{
                [item setTitle:model.userremarks forState:UIControlStateNormal];

                
            }

            
//            [item setTitle:[_agreeArray[i] userName] forState:UIControlStateNormal];
            [item sd_setImageWithURL:[Helper imageIconUrl:[_agreeArray[i] pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
            
            item.tag = 101 + i;
            item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            [item addTarget:self action:@selector(selfDeClick:) forControlEvents:UIControlEventTouchUpInside];
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 60*ScreenWidth/375)];
        [viewAgree addSubview:label];
        label.text = @" 暂无已获准参加的人员";
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    }
    
}


//点击跳转到个人中心
-(void)selfDeClick:(UIButton *)btn
{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = [_agreeArray[btn.tag-101] userId];
    selfVc.messType = @15;
    [self.navigationController pushViewController:selfVc animated:YES];
}
//点击跳转到个人中心
-(void)selfDetailClick:(UIButton *)btn
{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = _model.userId;
    selfVc.messType = @15;
    [self.navigationController pushViewController:selfVc animated:YES];
}




-(void)createWaitView
{
    UIView* viewAgree = [[UIView alloc]init];
    
    if (_agreeArray.count == 0) {
        viewAgree.frame = CGRectMake(0, 390*ScreenWidth/375 +_height + 60*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375*_waitArray.count);
    }
    else
    {
        viewAgree.frame = CGRectMake(0, 390*ScreenWidth/375 +_height + 60*ScreenWidth/375*(((_agreeArray.count-1)/6+1)), ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375*_waitArray.count);
    }
    [_scrollView addSubview:viewAgree];
    
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0*ScreenWidth/375, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewAgree addSubview:infoLabel];
    infoLabel.text = @"  待审核申请人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
//    if (_waitArray.count != 0) {
        if ([_model.applystate integerValue] == 1) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 55*ScreenWidth/375*_waitArray.count) style:UITableViewStylePlain];
        }
        else
        {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375*_waitArray.count) style:UITableViewStylePlain];
        }
//    }
//    else
//    {
    
//    }
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [viewAgree addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"YueWaitTableViewCell" bundle:nil] forCellReuseIdentifier:@"YueWaitTableViewCell"];
    [_tableView registerClass:[RewardArravelTableViewCell class] forCellReuseIdentifier:@"RewardArravelTableViewCell"];
    if (_waitArray.count == 0) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
        [viewAgree addSubview:label];
        label.text = @" 暂无待审核人";
        label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _waitArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.applystate integerValue] == 1) {
        return 55*ScreenWidth/375;
    }
    else
    {
        return 44*ScreenWidth/375;
    }
    //    return [_model.applystate integerValue] == 1 ? 55*ScreenWidth/375 : 44*ScreenWidth/375;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.applystate integerValue] == 1) {
        RewardArravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardArravelTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showRewardDetail:_waitArray[indexPath.row]];
        
        cell.callBackData = ^{
            [_agreeArray removeAllObjects];
            [_waitArray removeAllObjects];
            for (UIView *v in [_scrollView subviews]) {
                [v removeFromSuperview];
            }
            [self createViewData];
        };
        
        return cell;
    }
    else
    {
        YueWaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YueWaitTableViewCell" forIndexPath:indexPath];
        [cell showData:_waitArray[indexPath.row]];
        return cell;
    }
    
}

//屏幕最下方点击事件
-(void)createClickBtn
{
    _viewBtnBasic = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49*ScreenWidth/375-64, ScreenWidth, 49*ScreenWidth/375)];
    
    _viewBtnBasic.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_viewBtnBasic];
    
    
    if ([_model.applystate integerValue] == 1) {
        if ([_model.startState integerValue] == 1) {
            UIButton* btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
            btnShare.frame = CGRectMake(0, 0, ScreenWidth/3, 49*ScreenWidth/375);
            [_viewBtnBasic addSubview:btnShare];
            [btnShare setTitle:@"分享" forState:UIControlStateNormal];
            [btnShare setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
            btnShare.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -40*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
            btnShare.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
            btnShare.tag = 1000;
            btnShare.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [btnShare addTarget:self action:@selector(shareReClick) forControlEvents:UIControlEventTouchUpInside];
            [btnShare setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btnShare.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnShare.layer.borderWidth = 1.0;
            
            UIButton* btnVote = [UIButton buttonWithType:UIButtonTypeCustom];
            btnVote.frame = CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, 49*ScreenWidth/375);
            [btnVote setTitle:@"邀请好友" forState:UIControlStateNormal];
            [btnVote setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnVote.backgroundColor = [UIColor orangeColor];
            btnVote.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnVote.layer.borderWidth = 1.0;
            btnVote.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnVote];
            [btnVote addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
            btnState.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
            [btnState setTitle:@"取消悬赏" forState:UIControlStateNormal];
            [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnState.backgroundColor = [UIColor orangeColor];
            btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnState.layer.borderWidth = 1.0;
            btnState.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnState];
            [btnState addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            
            
            UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
            btnState.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            [btnState setTitle:@"已结束" forState:UIControlStateNormal];
            [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnState.backgroundColor = [UIColor lightGrayColor];
            btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnState.layer.borderWidth = 1.0;
            btnState.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnState];
            
            
        }
        
    }
    else
    {
        if ([_model.startState integerValue] == 1) {
            UIButton* btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
            btnChat.frame = CGRectMake(0, 0, ScreenWidth/3, 49*ScreenWidth/375);
            [_viewBtnBasic addSubview:btnChat];
            [btnChat setTitle:@"私聊" forState:UIControlStateNormal];
            [btnChat setImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
            btnChat.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -50*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
            btnChat.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
            btnChat.tag = 1000;
            btnChat.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [btnChat addTarget:self action:@selector(chatReClick) forControlEvents:UIControlEventTouchUpInside];
            [btnChat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btnChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnChat.layer.borderWidth = 1.0;
            
            UIButton* btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
            btnShare.frame = CGRectMake(ScreenWidth/3-1, 0, ScreenWidth/3+1, 49*ScreenWidth/375);
            [_viewBtnBasic addSubview:btnShare];
            [btnShare setTitle:@"分享" forState:UIControlStateNormal];
            [btnShare setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
            btnShare.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -40*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
            btnShare.titleEdgeInsets = UIEdgeInsetsMake(0, 20*ScreenWidth/375, 0, 0);
            btnShare.tag = 1000;
            btnShare.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [btnShare addTarget:self action:@selector(shareReClick) forControlEvents:UIControlEventTouchUpInside];
            [btnShare setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btnShare.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnShare.layer.borderWidth = 1.0;
            
            if ([_model.applystate integerValue] == 2) {
                //需要点击事件
                _btnIsState = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnIsState.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
                [_btnIsState setTitle:@"申请加入" forState:UIControlStateNormal];
                [_btnIsState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _btnIsState.backgroundColor = [UIColor orangeColor];
                _btnIsState.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _btnIsState.layer.borderWidth = 1.0;
                _btnIsState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
                [_viewBtnBasic addSubview:_btnIsState];
                [_btnIsState addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([_model.applystate integerValue] == 3)
            {
                _btnIsState = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnIsState.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
                [_btnIsState setTitle:@"取消申请" forState:UIControlStateNormal];
                [_btnIsState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _btnIsState.backgroundColor = [UIColor orangeColor];
                _btnIsState.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _btnIsState.layer.borderWidth = 1.0;
                _btnIsState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
                [_viewBtnBasic addSubview:_btnIsState];
                [_btnIsState addTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if ([_model.applystate integerValue] == 4)
            {
                _btnIsState = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnIsState.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
                [_btnIsState setTitle:@"已加入" forState:UIControlStateNormal];
                [_btnIsState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _btnIsState.backgroundColor = [UIColor orangeColor];
                _btnIsState.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _btnIsState.layer.borderWidth = 1.0;
                _btnIsState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
                [_viewBtnBasic addSubview:_btnIsState];
            }
            else
            {
                
                //需要点击事件
                _btnIsState = [UIButton buttonWithType:UIButtonTypeCustom];
                _btnIsState.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
                [_btnIsState setTitle:@"重新加入" forState:UIControlStateNormal];
                [_btnIsState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _btnIsState.backgroundColor = [UIColor orangeColor];
                _btnIsState.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _btnIsState.layer.borderWidth = 1.0;
                _btnIsState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
                [_viewBtnBasic addSubview:_btnIsState];
                [_btnIsState addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            
            UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
            btnState.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            [btnState setTitle:@"已结束" forState:UIControlStateNormal];
            [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnState.backgroundColor = [UIColor lightGrayColor];
            btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnState.layer.borderWidth = 1.0;
            btnState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnState];
            
            
        }
    }
    
}
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
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/saveMesss.do" parameter:@{@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"content":[NSString stringWithFormat:@"%@邀请您参加他的悬赏",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]],@"messObjid":_model.aboutBallReId,@"messType":@15,@"idlist":nsIdList} success:^(id respondsData) {
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
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        } withBlockSure:^{
                            TeamMessageController* team = [[TeamMessageController alloc]init];
                            team.dataArray = _messageArray;
                            team.telArray = _telArray;
                            [self.navigationController pushViewController:team animated:YES];
                            
                        } withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark --聊天点击事件
-(void)chatReClick
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
#pragma mark --分享点击事件
-(void)shareReClick
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
    
    NSData *fxData = [NSData dataWithContentsOfURL:[Helper imageUrl:_model.uPic]];

    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/mood/Reward_details.html?ballReId=%@&userId=%@",_aboutBallId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [UMSocialData defaultData].extConfig.title=_model.reTitle;
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_model.reInfo image:fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_model.reInfo image:fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
        }];
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageWithData:fxData];
        data.shareText = [NSString stringWithFormat:@"%@\n %@\n %@",_model.reTitle,_model.reInfo,shareUrl];
        
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
}


#pragma mark --取消悬赏
-(void)cancelClick
{
    
    [Helper alertViewWithTitle:@"是否取消本次悬赏?" withBlockCancle:^{
    } withBlockSure:^{
        
        [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallReward/update.do" parameter:@{@"ballState":@1,@"aboutBallReId":_aboutBallId} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"success"] integerValue] == 1)
            {
                for(UIView *view in [_viewBtnBasic subviews])
                {
                    [view removeFromSuperview];
                }
                UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
                btnState.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
                [btnState setTitle:@"悬赏已取消" forState:UIControlStateNormal];
                [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnState.backgroundColor = [UIColor lightGrayColor];
                btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btnState.layer.borderWidth = 1.0;
                btnState.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                [_viewBtnBasic addSubview:btnState];
                
            }
        } failed:^(NSError *error) {
        }];
    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
    
    }
#pragma mark --加入悬赏点击事件
-(void)joinClick:(UIButton *)btn
{
    if (btn.selected) {
        
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"%@申请加入这次悬赏",[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]];
        
        if (_typeNews == nil) {
            _typeNews = @0;
        }
        else{
            _typeNews = @1;
        }
        [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallRewardJoin/save.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"aboutBallReId":_aboutBallId,@"userIds":_model.userId,@"message":str,@"state":_typeNews} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"success"] integerValue] == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                [_waitArray removeAllObjects];
                [_agreeArray removeAllObjects];
                for (UIView *v in [_scrollView subviews]) {
                    [v removeFromSuperview];
                }
                _model.applystate = @3;
                [self createViewData];
                
                [_btnIsState setTitle:@"取消申请" forState:UIControlStateNormal];
                [_btnIsState removeTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btnIsState addTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        } failed:^(NSError *error) {
        }];
    }
    
}

#pragma mark --取消加入悬赏点击事件
-(void)cancelJoinClick:(UIButton *)btn
{
    if (btn.selected){
        
    }else{
        NSString* str = [NSString stringWithFormat:@"%@取消加入这次悬赏",[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]];
        [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallRewardJoin/update.do" parameter:@{@"state":@3,@"aboutBallReId":_aboutBallId,@"userIds":_model.userId,@"message":str,@"send":@0,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"success"] integerValue] == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                [_waitArray removeAllObjects];
                [_agreeArray removeAllObjects];
                for (UIView *v in [_scrollView subviews]) {
                    [v removeFromSuperview];
                }
                _model.applystate = @2;
                [self createViewData];
                
                [_btnIsState setTitle:@"重新加入" forState:UIControlStateNormal];
                [_btnIsState removeTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btnIsState addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {

            }
        } failed:^(NSError *error) {
        }];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}


@end
