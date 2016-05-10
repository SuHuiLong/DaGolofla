//
//  YueDetailViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueDetailViewController.h"
#import "Setbutton.h"
#import "YueMyBallViewController.h"

#import "HorButtonSet.h"
#import "ChatDetailViewController.h"
#import "PostDataRequest.h"
#import "Helper.h"
#import "TeamApplyViewCell.h"
#import "YueWaitTableViewCell.h"

#import "YueWaitViewController.h"

#import "YueDetailModel.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "YueBallHallView.h"

#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "ShareAlert.h"

#import "YueBallDetailModel.h"
#import "YueHallModel.h"
#import "MBProgressHUD.h"

#import "SelfViewController.h"
#import "PersonHomeController.h"

#import "SDImageCache.h"
#import "SDWebImageDecoder.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"

//邀请好友
#import "TeamInviteViewController.h"
#import "TeamMessageController.h"
#import "ReportViewController.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#define kUserYUe_URL @"aboutBallJoin/update.do"
#define kSaveBall_URL @"aboutBallJoin/save.do"
#define kJoin_URL @"aboutBallJoin/queryPage.do"
#define kUpdate_urk @"aboutBall/update.do"

@interface YueDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UIScrollViewDelegate>
{
    UIView* _viewMore;
    NSMutableString* _strUserId;
    
    NSMutableArray* _arrayWait;
    NSMutableArray* _nameAgreeArr;
    NSMutableArray* _IconAgreeArr;
    
    
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    BOOL _showView;
    UIScrollView* _scrollView;
    
    BOOL _isClick;
    NSMutableDictionary* _dict;
    NSMutableDictionary* _dictAbout;
    
    NSMutableDictionary* _dictCancel;
    NSMutableDictionary* _dictFinish;
    
    YueBallHallView *_viewTanTu;
    
    MBProgressHUD *_prpgressHView;
    MBProgressHUD *_progre;
    YueBallDetailModel *_model;
    
    UIView* _viewBtnBasic;
    
    UIButton* _btnIsState;
    //    NSInteger index;
    //    BOOL _showView;
    
    //好友列表请求的数据
    NSMutableArray* _arrayIndex;
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayData1;
    
    NSMutableArray* _messageArray;
    NSMutableArray* _telArray;
    
    
    CGFloat _height;
}
@end

@implementation YueDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.title = @"约球详情";
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49*ScreenWidth/375)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    //    if (ScreenHeight==480) {
    _scrollView.contentSize = CGSizeMake(0, 568-49*ScreenWidth/375-5);
    
    _dict = [[NSMutableDictionary alloc]init];
    
    _dictAbout = [[NSMutableDictionary alloc]init];
    
    
    _dictCancel = [[NSMutableDictionary alloc]init];
    _dictFinish = [[NSMutableDictionary alloc]init];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _arrayWait = [[NSMutableArray alloc]init];
    _nameAgreeArr = [[NSMutableArray alloc]init];
    _IconAgreeArr = [[NSMutableArray alloc]init];
    
    _strUserId = [[NSMutableString alloc]init];
    
    _strUserId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    
    
    //好友
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    
    
    _prpgressHView = [[MBProgressHUD alloc] initWithView:self.view];
    _prpgressHView.mode = MBProgressHUDModeIndeterminate;
    _prpgressHView.labelText = @"正在加载...";
    [self.view addSubview:_prpgressHView];
    [_prpgressHView show:YES];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    [[PostDataRequest sharedInstance]postDataRequest:@"aboutBall/get.do" parameter:@{@"aboutBallId":_aboutBallId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            //            for (NSDictionary *dataDict in ) {
            _model = [[YueBallDetailModel alloc] init];
            [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
            //            }
            
            //NSLog(@"%@",[dict objectForKey:@"rows"]);
            if (![Helper isBlankString:_model.ballInfo]) {
                _height = [Helper textHeightFromTextString:_model.ballInfo width:(ScreenWidth - 110*ScreenWidth/375) fontSize:15*ScreenWidth/375];
            }
            else
            {
                _height = 20*ScreenWidth/375;
            }
            if (_height < 20*ScreenWidth/375) {
                _height = 20*ScreenWidth/375;
            }
            
            
            [self createViewData];
            
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failed:^(NSError *error) {
    }];
}

//等待审核的成员数据
- (void)getInfoForArray:(NSMutableArray *)arr {
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *sportDic = arr[i];
        YueDetailModel *model = [[YueDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:sportDic];
        [_arrayWait addObject:model];
    }
}

//审核通过的成员数据
- (void)getInfoForAgreeArray:(NSMutableArray *)arr {
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *sportDic = arr[i];
        YueDetailModel *model = [[YueDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:sportDic];
        
        [_IconAgreeArr addObject:model];
        
    }
    
}

//刷新数据
-(void)createViewData
{
    //查询约球人信息
    [[PostDataRequest sharedInstance] postDataRequest:kJoin_URL parameter:@{@"type":@0,@"aboutBallId":_aboutBallId,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            //待审核人
            [self getInfoForArray:[[dict objectForKey:@"rows"] objectForKey:@"type0"]];
            //审核通过
            [self getInfoForAgreeArray:[[dict objectForKey:@"rows"] objectForKey:@"type1"]];
            
        }
        
        
        //基本信息
        [self createBasicInformation];
        //约球要求
        [self createRewardRequest];
        //发布人
        [self createReleasePeople];
        //已成功参加人数
        [self createRewardNumber];
        
        [self createWait];
        
        //最下方的三个按钮
        [self createClickBtn];
        
        
        //控制屏幕滑动
        if ([_model.applystate integerValue] == 1) {
            if (_IconAgreeArr.count != 0) {
                _scrollView.contentSize = CGSizeMake(0, 405*ScreenWidth/375+_height+60*ScreenWidth/375 + 60*ScreenWidth/375*((_IconAgreeArr.count-1)/6+1) + 30*ScreenWidth/375 +_arrayWait.count*55*ScreenWidth/375+44*ScreenWidth/375);
            }
            else{
                _scrollView.contentSize = CGSizeMake(0, 405*ScreenWidth/375+_height + 60*ScreenWidth/375 + 30*ScreenWidth/375 + _arrayWait.count*55*ScreenWidth/375+44*ScreenWidth/375);
            }
        }
        else
        {
            if (_IconAgreeArr.count != 0) {
                _scrollView.contentSize = CGSizeMake(0, 405*ScreenWidth/375+_height+60*ScreenWidth/375 + 60*ScreenWidth/375*((_IconAgreeArr.count-1)/6+1) + 30*ScreenWidth/375 +_arrayWait.count*44*ScreenWidth/375+44*ScreenWidth/375);
            }
            else{
                _scrollView.contentSize = CGSizeMake(0, 405*ScreenWidth/375+_height + 60*ScreenWidth/375 + 30*ScreenWidth/375 + _arrayWait.count*44*ScreenWidth/375+44*ScreenWidth/375*2);
            }
        }
        
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

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
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"我的约球", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home", @"nes", @"yqbar", nil];
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    __weak UINavigationController *nav = self.navigationController;
    _viewTanTu.isXuanSang = 1;
    _viewTanTu.block = ^(UIViewController *vc){
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        [nav pushViewController:vc animated:YES];
    };
    _viewTanTu.blockFirstPage = ^(UIViewController *vc){
        [nav popToRootViewControllerAnimated:YES];
    };
    [_viewTanTu showString:arr];
    [_viewTanTu showImage:imageArr];
    // 设置xib视图的尺寸
    _viewTanTu.frame = CGRectMake((self.view.frame.size.width - 110), 0, 102, 102);
    [self.view addSubview:_viewTanTu];
}

//跳转我的约球界面
-(void)myYueClick:(UIButton*)btn
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        if (btn.tag == 102) {
            YueMyBallViewController *yueVc = [[YueMyBallViewController alloc]init];
            [self.navigationController pushViewController:yueVc animated:YES];
        }
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
//基本信息
-(void)createBasicInformation
{
    
    UIView* viewBaseNews = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 145*ScreenWidth/375+_height)];
    //    viewBaseNews.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:viewBaseNews];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewBaseNews addSubview:infoLabel];
    infoLabel.text = @"  基本信息";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    NSArray* titleArray = @[@"球场：",@"地址：",@"开球时间：",@"人均价格：",@"约球详情："];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 40*ScreenWidth/375 + i * 25*ScreenWidth/375, 75*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelDetail.text = titleArray[i];
        labelDetail.backgroundColor = [UIColor clearColor];
        [viewBaseNews addSubview:labelDetail];
        labelDetail.textColor = [UIColor darkGrayColor];
    }
    
    NSMutableArray *detailArray = [NSMutableArray array];
    if (_model.ballName != nil) {
        [detailArray addObject:_model.ballName];
    }
    else
    {
        [detailArray addObject:@"暂无球场名称"];
    }
    if (_model.address != nil) {
        [detailArray addObject:_model.address];
    }
    else
    {
        [detailArray addObject:@"暂无球场地址"];
    }
    if (_model.playTimes != nil) {
        [detailArray addObject:_model.playTimes];
    }
    else
    {
        [detailArray addObject:@"暂无打球时间"];
    }
    if (_model.pPrice != nil) {
        [detailArray addObject:_model.pPrice];
    }
    else
    {
        [detailArray addObject:@"暂无人均价格"];
    }
    for (int i = 0; i < detailArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 40*ScreenWidth/375 + i * 25*ScreenWidth/375, ScreenWidth - 110*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        //        labelDetail.text = detailArray[i];
        if ([detailArray[i] isKindOfClass:[NSNumber class]]) {
            labelDetail.text = [NSString stringWithFormat:@"%@",detailArray[i]];
        }else{
            labelDetail.text = detailArray[i];
        }
        labelDetail.backgroundColor = [UIColor clearColor];
        [viewBaseNews addSubview:labelDetail];
    }
    
    
    UILabel* labelDetailAll = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 40*ScreenWidth/375 + 4 * 25*ScreenWidth/375, ScreenWidth - 110*ScreenWidth/375, _height)];
    labelDetailAll.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    //        labelDetail.text = detailArray[i];
    
    labelDetailAll.text = [NSString stringWithFormat:@"%@",_model.ballInfo];
    labelDetailAll.numberOfLines = 0;
    labelDetailAll.backgroundColor = [UIColor clearColor];
    [viewBaseNews addSubview:labelDetailAll];
    
}
//发布人
-(void)createRewardRequest
{
    UIView *viewReward = [[UIView alloc]initWithFrame:CGRectMake(0, 145*ScreenWidth/375+_height, ScreenWidth, 170*ScreenWidth/375)];
    [_scrollView addSubview:viewReward];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewReward addSubview:infoLabel];
    infoLabel.text = @"  约球要求";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    NSArray* titleArray = @[@"性别:",@"年龄:",@"球龄:",@"差点:",@"行业:"];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 35*ScreenWidth/375 + i * 25*ScreenWidth/375, 75*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelDetail.text = titleArray[i];
        labelDetail.backgroundColor = [UIColor clearColor];
        [viewReward addSubview:labelDetail];
        labelDetail.textColor = [UIColor darkGrayColor];
    }
    
    NSMutableArray *detailArray = [NSMutableArray array];
    if (_model.sex != nil) {
        if ([_model.sex integerValue] == 0) {
            [detailArray addObject:@"女"];
        }
        else if ([_model.sex integerValue] == 1)
        {
            [detailArray addObject:@"男"];
        }
        else{
            [detailArray addObject:@"不限"];
        }
        
    }
    else
    {
        [detailArray addObject:@"不限"];
    }
    
    if (_model.age == nil  || [_model.age integerValue] == -1) {
        [detailArray addObject:@"不限"];
    }else{
        [detailArray addObject:_model.age];

    }
    
    if (_model.ballYear != nil) {
        [detailArray addObject:_model.ballYear];
    }else{
        [detailArray addObject:@"不限"];
    }
    
    if (_model.almost != nil) {
        [detailArray addObject:_model.almost];
    }else{
        [detailArray addObject:@"不限"];
    }
    
    if (![Helper isBlankString:_model.workName]) {
        [detailArray addObject:_model.workName];
    }else{
        [detailArray addObject:@"不限"];
    }
    
    for (int i = 0; i < detailArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 35*ScreenWidth/375 + i * 25*ScreenWidth/375, ScreenWidth - 110*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        if ([detailArray[i] isKindOfClass:[NSNumber class]]) {
            labelDetail.text = [NSString stringWithFormat:@"%@",detailArray[i]];
        }else{
            labelDetail.text = detailArray[i];
        }
        
        labelDetail.textAlignment = NSTextAlignmentLeft;
        labelDetail.backgroundColor = [UIColor clearColor];
        [viewReward addSubview:labelDetail];
    }
}

#pragma mark --发布人
-(void)createReleasePeople
{
    UIView* viewPeople = [[UIView alloc]initWithFrame:CGRectMake(0, 315*ScreenWidth/375+_height, ScreenWidth, 90*ScreenWidth/375)];
    [_scrollView addSubview:viewPeople];
    
    
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewPeople addSubview:infoLabel];
    infoLabel.text = @"  发布人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    //NSLog(@"%@   %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],_model.userId);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] != [_model.userId integerValue]) {
        UIButton* btnReport = [UIButton buttonWithType:UIButtonTypeCustom];
        //    btnReport.backgroundColor = [UIColor redColor];
        btnReport.frame = CGRectMake(ScreenWidth-40, 0, 40, 30*ScreenWidth/375);
        [btnReport setTitle:@"投诉" forState:UIControlStateNormal];
        btnReport.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [btnReport setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [viewPeople addSubview:btnReport];
        [btnReport addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    }
    

    Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
    item.frame = CGRectMake(5*ScreenWidth/375, 30*ScreenWidth/375, 60*ScreenWidth/375, 60*ScreenWidth/375);
    [viewPeople addSubview:item];
    
    item.imageView.layer.masksToBounds = YES;
    item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
    [item sd_setImageWithURL:[Helper imageIconUrl:_model.uPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
    if (![Helper isBlankString:_model.userName]) {
        
        NoteModel *model = [NoteHandlle selectNoteWithUID:_model.userId];
        if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
            [item setTitle:_model.userName forState:UIControlStateNormal];
        }else{
            [item setTitle:model.userremarks forState:UIControlStateNormal];
        }
    }
    else
    {
        [item setTitle:@"暂无信息" forState:UIControlStateNormal];
    }
//    [item setTitle:_model.userName forState:UIControlStateNormal];
    item.tag = 150;
    item.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [item addTarget:self action:@selector(selfReleaseClick:) forControlEvents:UIControlEventTouchUpInside];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

-(void)reportClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportViewController * reportView = [[ReportViewController alloc]init];
        reportView.otherUserId = _model.userId;
        reportView.typeNum = @14;
        reportView.objId = _model.aboutBallId;
        [self.navigationController pushViewController:reportView animated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self pingbiyonghu:[_dataArray[index] uId]];
        /*
         shileAndRep/shileaboutball.do   屏蔽约球
         参数    对象id     objid
         参数    orderUserId   对方用户id
         参数   userId    用户id
         参数  type     类型
         */
        
        [[PostDataRequest sharedInstance] postDataRequest:@"shileAndRep/shileaboutball.do" parameter:@{@"objid":_model.aboutBallId,@"orderUserId":_model.userId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"type":@14} success:^(id respondsData) {
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


-(void)selfReleaseClick:(UIButton *)btn{
        PersonHomeController* selfVc = [[PersonHomeController alloc]init];
        if (btn.tag > 149) {
            
            selfVc.strMoodId = _model.userId;
            
        }else{
            selfVc.strMoodId = [_IconAgreeArr[btn.tag-101] userId];
        }
        selfVc.messType = @15;
        [self.navigationController pushViewController:selfVc animated:YES];
}
//已成功参加人数
-(void)createRewardNumber{
    UIView* viewAgree = [[UIView alloc]init];
    if (_IconAgreeArr.count == 0) {
        viewAgree.frame = CGRectMake(0, 405*ScreenWidth/375+_height, ScreenWidth, 30*ScreenWidth/375 + 60*ScreenWidth/375);
    }
    else
    {
        viewAgree.frame = CGRectMake(0, 405*ScreenWidth/375+_height, ScreenWidth, 30*ScreenWidth/375 + 60*ScreenWidth/375*((_IconAgreeArr.count-1)/6+1));
    }
    
    //    viewAgree.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:viewAgree];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewAgree addSubview:infoLabel];
    
    infoLabel.text = [NSString stringWithFormat:@"  已获准参加的人数%ld人",(long)_IconAgreeArr.count];
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    if (_IconAgreeArr.count != 0) {
        for (int i = 0; i<_IconAgreeArr.count; i++) {
            Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(7*ScreenWidth/375 + 60*ScreenWidth/375*(i%6),30*ScreenWidth/375 + 60*ScreenWidth/375 * (i/6), 60*ScreenWidth/375, 60*ScreenWidth/375);
            [viewAgree addSubview:item];
            
            item.imageView.layer.masksToBounds = YES;
            item.imageView.layer.cornerRadius = item.imageView.frame.size.height/2;
            [item sd_setImageWithURL:[Helper imageIconUrl:[_IconAgreeArr[i] pic]] forState:UIControlStateNormal];
            [item setTitle:[_IconAgreeArr[i] userName] forState:UIControlStateNormal];
            item.tag = 101 + i;
            item.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
            [item addTarget:self action:@selector(selfReleaseClick:) forControlEvents:UIControlEventTouchUpInside];
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 30*ScreenWidth/375, 200*ScreenWidth/375, 60*ScreenWidth/375)];
        label.text = @"暂时还没有参与约球的人";
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [viewAgree addSubview:label];
    }
    
    
}
//待审核
-(void)createWait
{
    
    UIView* viewAgree = [[UIView alloc]init];
    if (_IconAgreeArr.count != 0) {
        viewAgree.frame = CGRectMake(0, 405*ScreenWidth/375+_height+30*ScreenWidth/375 + 60*ScreenWidth/375*(((_IconAgreeArr.count-1)/6+1)), ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375*_arrayWait.count);
    }
    else
    {
        viewAgree.frame = CGRectMake(0, 405*ScreenWidth/375+_height+30*ScreenWidth/375 + 60*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375 + 44*ScreenWidth/375*_arrayWait.count);
    }
    [_scrollView addSubview:viewAgree];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0*ScreenWidth/375, 0, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewAgree addSubview:infoLabel];
    infoLabel.text = @"  待审核申请人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];

    if ([_model.applystate integerValue] == 1) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 55*ScreenWidth/375*_arrayWait.count) style:UITableViewStylePlain];
    }
    else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375*_arrayWait.count) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [viewAgree addSubview:_tableView];
    

    [_tableView registerNib:[UINib nibWithNibName:@"TeamApplyViewCell" bundle:nil] forCellReuseIdentifier:@"TeamApplyViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"YueWaitTableViewCell" bundle:nil] forCellReuseIdentifier:@"YueWaitTableViewCell"];
    if (_arrayWait.count == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375)];
        label.text = @"暂无待审核申请人";
        label.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
        [viewAgree addSubview:label];
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _arrayWait.count;
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
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_model.applystate integerValue] == 1) {
        TeamApplyViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamApplyViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showYueDetail:_arrayWait[indexPath.row]];
        cell.ballId = [_arrayWait[indexPath.row] aboutBallId];
        cell.userId = [_arrayWait[indexPath.row] userId];
        cell.indexState = 10;
        
        cell.callBackData = ^{
            [_arrayWait removeAllObjects];
            [_IconAgreeArr removeAllObjects];
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
        [cell showData:_arrayWait[indexPath.row]];
        return cell;
    }
    return nil;
    
}

//屏幕最下方点击事件
-(void)createClickBtn
{
    _viewBtnBasic = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49*ScreenWidth/375-64, ScreenWidth, 49*ScreenWidth/375)];
    
    _viewBtnBasic.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    [self.view addSubview:_viewBtnBasic];
    
    
    
    //NSLog(@"%@",_model.startState);
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
            [btnShare addTarget:self action:@selector(shareYueClick) forControlEvents:UIControlEventTouchUpInside];
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
            btnVote.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnVote];
            [btnVote addTarget:self action:@selector(voteFriendClick) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
            btnState.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, 49*ScreenWidth/375);
            [btnState setTitle:@"取消约球" forState:UIControlStateNormal];
            [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnState.backgroundColor = [UIColor orangeColor];
            btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnState.layer.borderWidth = 1.0;
            btnState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnState];
            [btnState addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([_model.startState integerValue] == 2)
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
        else
        {
            UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
            btnState.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            [btnState setTitle:@"约球已取消" forState:UIControlStateNormal];
            [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnState.backgroundColor = [UIColor lightGrayColor];
            btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnState.layer.borderWidth = 1.0;
            btnState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
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
            [btnChat addTarget:self action:@selector(chatYueClick) forControlEvents:UIControlEventTouchUpInside];
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
            [btnShare addTarget:self action:@selector(shareYueClick) forControlEvents:UIControlEventTouchUpInside];
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
        else if ([_model.startState integerValue] == 2)
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
        else
        {
            UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
            btnState.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
            [btnState setTitle:@"约球已取消" forState:UIControlStateNormal];
            [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnState.backgroundColor = [UIColor lightGrayColor];
            btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnState.layer.borderWidth = 1.0;
            btnState.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
            [_viewBtnBasic addSubview:btnState];
            
        }
    }
}

#pragma mark --邀请好友点击事件
-(void)voteFriendClick
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
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/saveMesss.do" parameter:@{@"content":[NSString stringWithFormat:@"%@邀请您参加他的约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]],@"messObjid":_aboutBallId,@"messType":@14,@"idlist":nsIdList,@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                //NSLog(@"dashabi");
                
                _progre.labelText = @"通知好友成功";
                // 延迟1秒执行：
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
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    };
    teamVc.arrayIndex = _arrayIndex;
    teamVc.arrayData = _arrayData1;
    
    [self.navigationController pushViewController:teamVc animated:YES];
}

#pragma mark --取消约球点击事件
-(void)cancelClick
{
    [Helper alertViewWithTitle:@"是否取消本次约球?" withBlockCancle:^{
        
    } withBlockSure:^{
        
        [[PostDataRequest sharedInstance]postDataRequest:@"aboutBall/update.do" parameter:@{@"ballState":@1,@"aboutBallId":_aboutBallId,@"message":[NSString stringWithFormat:@"%@已经取消了这次约球活动",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]],@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[dict objectForKey:@"success"] integerValue] == 1)
            {
                for(UIView *view in [_viewBtnBasic subviews])
                {
                    [view removeFromSuperview];
                }
                UIButton* btnState = [UIButton buttonWithType:UIButtonTypeCustom];
                btnState.frame = CGRectMake(0, 0, ScreenWidth, 49*ScreenWidth/375);
                [btnState setTitle:@"约球已取消" forState:UIControlStateNormal];
                [btnState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnState.backgroundColor = [UIColor lightGrayColor];
                btnState.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btnState.layer.borderWidth = 1.0;
                btnState.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                [_viewBtnBasic addSubview:btnState];
                
            }
        } failed:^(NSError *error) {
            //         [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        
    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
    
    
}

#pragma mark --取消申请加入点击事件
-(void)cancelJoinClick:(UIButton *)btn
{
    [Helper alertViewWithTitle:@"是否取消加入本次约球?" withBlockCancle:^{

    } withBlockSure:^{
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = [UIColor lightGrayColor];
        _prpgressHView.labelText = @"正在加载...";
        [_prpgressHView show:YES];
        
        NSString* str = [NSString stringWithFormat:@"%@已经取消加入这次约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
        [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallJoin/update.do" parameter:@{@"state":@3,@"ballId":_aboutBallId,@"message":str,@"userId":_model.userId,@"send":@0,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[dict objectForKey:@"success"] integerValue] == 1)
            {
                
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = [UIColor orangeColor];
                
                [_arrayWait removeAllObjects];
                [_IconAgreeArr removeAllObjects];
                for (UIView *v in [_scrollView subviews]) {
                    [v removeFromSuperview];
                }
                _model.applystate = @5;
                [self createViewData];
                [_btnIsState setTitle:@"重新加入" forState:UIControlStateNormal];
                [_btnIsState removeTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btnIsState addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
}

#pragma mark --聊天点击事件
-(void)chatYueClick
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
-(void)shareYueClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfoo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
    
}

-(void)shareInfoo:(NSInteger)index
{
    
    NSData *fxData = [NSData dataWithContentsOfURL:[Helper imageUrl:_model.ballPic]];

    NSString*  shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/mood/About_Ball_details.html?ballId=%@&userId=%@",_model.aboutBallId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [UMSocialData defaultData].extConfig.title=_model.ballName;
    if(index==0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_model.ballInfo image:fxData    location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
        }];
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_model.ballInfo image: fxData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
        }];
    }
    else
    {
        //NSLog(@"%@/n%@/n%@",_model.ballName,_model.ballInfo,shareUrl);
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageWithData:fxData];
        data.shareText = [NSString stringWithFormat:@"%@, %@, %@",_model.ballName,_model.ballInfo,shareUrl];
        
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}

-(void)joinClick:(UIButton *)btn
{
    
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    if (btn.selected){
        
    }else{
        
        _prpgressHView.labelText = @"正在加载...";
        [_prpgressHView show:YES];
        NSString* str = [NSString stringWithFormat:@"%@申请加入这次约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
        if (_typeNews == nil) {
            _typeNews = @0;
        }
        else
        {
            _typeNews = @1;
        }
        [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallJoin/save.do" parameter:@{@"aboutBallId":_aboutBallId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"message":str,@"state":_typeNews} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[dict objectForKey:@"success"] integerValue] == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入约球活动成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            //        if ([_model.startState integerValue] == 1) {
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UIColor orangeColor];
            [_arrayWait removeAllObjects];
            [_IconAgreeArr removeAllObjects];
            for (UIView *v in [_scrollView subviews]) {
                [v removeFromSuperview];
            }
            _model.applystate = @3;
            [self createViewData];
            [_btnIsState setTitle:@"取消申请" forState:UIControlStateNormal];
            [_btnIsState removeTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btnIsState addTarget:self action:@selector(cancelJoinClick:) forControlEvents:UIControlEventTouchUpInside];
            

            
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        //
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}

@end
