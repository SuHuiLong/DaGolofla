//
//  ComDetailViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/24.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ComDetailViewController.h"
#import "PersonHomeController.h"
#import "ZanNumViewController.h"

// 相册控制器
#import "PicArrShowViewControllerViewController.h"

#import "ComDetailViewCell.h"


#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PostDataRequest.h"
#import "ComDeatailModel.h"
#import "UIView+ChangeFrame.h"
#import "UserAssistModel.h"

#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "ShareAlert.h"
#import "CommuniteTableViewCell.h"

#import "ReportViewController.h"

#import "MBProgressHUD.h"

#import "YMTableViewCell.h"

#define kComment_URL @"userComment/save.do"

@interface ComDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, UIAlertViewDelegate,UIActionSheetDelegate>{
    NSMutableDictionary* _dict;
    
    UILabel *_labelFoot;
    UILabel *_footNum;
    UILabel *_footTime;
    UILabel *_labelImgvCount;
    
    UITableView* _tableView;
    //    NSMutableArray* _dataArray;
    
    // 记录_tableView每个cell的高度
    NSMutableArray *_cellHeightArr;
    NSMutableArray *_peopleShiJiArr;
    
    UIView* _viewHeader;
    
    /**
     *  键盘
     */
    UITextView *_commentTextView;//输入框
    UIButton *_sendButton;//发送按钮
    
    BOOL _isMove;//是否移动了
    //    NSInteger _moveHight;//移动的高度
    NSInteger _keyHight;//记录上一次键盘的高度
    
    //
    BOOL _isClickText;
    
    UIAlertView *_alertViewContent;
    
    NSInteger _disuccessCount;
    NSInteger _page;
    
    CommunityModel * _comModel;

}



/**
 *  头像背景按钮
 */
@property (strong, nonatomic) UIButton* btn;
/**
 *  头像图片
 */
@property (strong, nonatomic) UIImageView* iconImgv;
//昵称
@property (strong, nonatomic) UILabel* labelTitle;
//时间
@property (strong, nonatomic) UILabel* labelTime;
//用户发布的信息
@property (strong, nonatomic) UILabel* labelContent;
//用户发布的图片
@property (strong, nonatomic) UIImageView* isUseImgv;
//定位图标
@property (strong, nonatomic) UIImageView* locationImg;
//定位
@property (strong, nonatomic) UILabel* labelDistance, *labelCities;
//喜欢的按钮,赞按钮，评论按钮
@property (strong, nonatomic) UIButton* btnLike, *zanBaseBtn, *disCussBtnBase;

//分割线
@property (strong, nonatomic) UIView* viewLine1;
//赞按钮
@property (strong, nonatomic) UIButton* btnZan;
//赞的人数
@property (strong, nonatomic) UILabel* labelZan;
//评论图标
@property (strong, nonatomic) UIButton* btnDiscuss;
//评论人数
@property (strong, nonatomic) UILabel* labelDis;
//分享
@property (strong, nonatomic) UIButton* shareBtn;
//分割线
@property (strong, nonatomic) UIView* viewLine2;
//显示赞的头像图标
@property (strong, nonatomic) UIImageView* discussImg;
//赞的头像
@property (strong, nonatomic) UIButton* btnIcon;

@property (strong, nonatomic) UIView* viewLine3;

@property (strong, nonatomic) UIView* kb;

@property (assign, nonatomic) CGFloat cellHeightt;

@property (assign, nonatomic) NSInteger lou2;


// 记录有还是没有他们的高度

@end

@implementation ComDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"话题详情";
    
    //底层铺设 UIScrollView 让键盘自动收起
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = bgView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    _lou2 = 0;
    _page = 1;
    _disuccessCount = [_model.commentCount integerValue];
    [self createTableView];
    [self creatjudementView];
    _dict = [[NSMutableDictionary alloc]init];
    _cellHeightArr = [NSMutableArray array];
    _mutableArr = [NSMutableArray array];
    
    _isMove = NO;
    _moveHight = 0;
    _keyHight = 0;
    
    
    
    
}


-(void)createTableView
{
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-43)];
    //    _tableView.backgroundColor = [UIColor grayColor];
    // 自定义分割线
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0,5,0,10);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ComDetailViewCell" bundle:nil] forCellReuseIdentifier:@"ComDetailViewCell"];
    [_tableView registerClass:[CommuniteTableViewCell class] forCellReuseIdentifier:@"CommuniteTableViewCell"];
    _tableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.mj_header beginRefreshing];
    
    // tableview 取消多余的分割线
    //    _tableView.tableFooterView=[[UIView alloc]init];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}


// POP回去时 刷新单行
-(void)backButtonClcik{
    
    if (_blockGuanzhuRereshing) {
        _blockGuanzhuRereshing();
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --MJ刷新方法

- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:@"userComment/queryPage.do" parameter:@{@"mId":_mId,@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"]boolValue]) {
            if (page == 1){
                [_cellHeightArr removeAllObjects];
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ComDeatailModel *model = [[ComDeatailModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                
                
                CGFloat cellHeight = [model.commentContent boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size.height;
                
                
                [_cellHeightArr addObject:[NSNumber numberWithFloat:cellHeight]];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
        }
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark --点击事件

#pragma mark -- tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count == 0) {
        return 1;
    }else{
        return _dataArray.count+1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CommuniteTableViewCell* cell = [[CommuniteTableViewCell alloc]init];
        
        CommunityModel *model=[_firstDataArray objectAtIndex:_firstIndexPath];
//        CGFloat moodContentH = [model.moodContent boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
        CGFloat moodContentH = 60;
        
        CGFloat cellH =  moodContentH+cell.iconImgv.frame.size.height+cell.picImage1.frame.size.height
        +cell.FootView.frame.size.height+cell.ClubView.frame.size.height
        +cell.ZPFView.frame.size.height+cell.ZanView.frame.size.height+40;
        
        if (model.pics.count != 0) {
            cellH = cellH;
        }else{
            cellH -=cell.picImage1.frame.size.height;
        }
        if ([model.moodType integerValue] == 1) {
            cellH = cellH;
        }else{
            cellH -=cell.FootView.frame.size.height;
        }
        if ([model.assistCount integerValue] != 0) {
            cellH = cellH;
        }else{
            cellH -=cell.ZanView.frame.size.height;
        }
        
        return cellH;
        
        
    }else{
        
        return ([_cellHeightArr[indexPath.row-1] floatValue])+65 *ScreenWidth/375;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YMTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommuniteTableViewCell" forIndexPath:indexPath];
//        YMTextData *model=[_firstDataArray objectAtIndex:_firstIndexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if ([model.assistState intValue]) {
//            [cell.zanBaseBtn setImage:[UIImage imageNamed:@"dz"] forState:(UIControlStateNormal)];
//        }else{
//            [cell.zanBaseBtn setImage:[UIImage imageNamed:@"zan"] forState:(UIControlStateNormal)];
//        }
//        
//        cell.cellDataArray = _firstDataArray;
//        cell.cellIndexPath = _firstIndexPath;
//        
//        [cell setCommunityModel:model];
//        [cell setZanIcon:model.tUserAssists];
//        
//        [cell.disCussBtnBase setTitle:[NSString stringWithFormat:@"%d",_dataArray.count] forState:UIControlStateNormal];
//
//        
//        //举报点击跳转block
//        cell.blockReportBtn = ^(){
//            [self tousu:_firstIndexPath];
//        };
        
//        
//        //设置自己不能关注自己
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSNumber * myId = [defaults objectForKey:@"userId"];
//        if ([myId isEqualToNumber:model.uId]) {
//            cell.btnLike.hidden = YES;
//        }else{
//            cell.btnLike.hidden = NO;
//        }
//        
//        
//        //个人头像点击跳转block
//        cell.blockIconPush = ^(NSNumber * i){
//            PersonHomeController* selfVc = [[PersonHomeController alloc]init];
//            selfVc.strMoodId = i;
//            selfVc.messType = @2;
//            [self.navigationController pushViewController:selfVc animated:YES];
//        };
//        
//        //图片点击跳转block
//        cell.blockPicPush = ^(NSInteger i , NSMutableArray* arr){
//            PicArrShowViewControllerViewController *picVC = [[PicArrShowViewControllerViewController alloc] initWithIndex:i];
//            picVC.selectImages = [_firstDataArray[_firstIndexPath] pics];
//            [self.navigationController pushViewController:picVC animated:YES];
//        };
//        
//        //评论点击跳转block
//        cell.blockPinglunPush = ^(NSInteger i){
//            [_commentTextView becomeFirstResponder];
//        };
//        
//        cell.blockIsLogin=^{
//            
//        };
//        
//        //点赞block
//        cell.blockAddZanIcon = ^(UIButton* btn){
//            
//            btn.userInteractionEnabled = NO;
//
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setValue:[_firstDataArray[_firstIndexPath] userMoodId] forKey:@"mId"];
//            
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            if (defaults) {
//                NSMutableString* str = [[NSMutableString alloc]init];
//                str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
//                [dic setValue:str forKey:@"userId"];
//            }
//            //未点赞
//            if ([[_firstDataArray[_firstIndexPath] assistState] isEqualToNumber:@0]) {
//                [dic setValue:@1 forKey:@"type"];
//                //点赞的请求
//                [[PostDataRequest sharedInstance] postDataRequest:@"userAssist/change.do" parameter:dic success:^(id respondsData) {
//                    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
//                    if ([[userData objectForKey:@"success"] boolValue]) {
//                        NSInteger a = [[_firstDataArray[_firstIndexPath] assistCount] integerValue] + 1;
//                        [_firstDataArray[_firstIndexPath] setValue:[NSNumber numberWithInteger:a] forKey:@"assistCount"];
//                        [_firstDataArray[_firstIndexPath] setValue:@1 forKey:@"assistState"];
//                        [btn setTitle:[NSString stringWithFormat:@"%ld", (long)a] forState:UIControlStateNormal];
//                        
//                        //点赞之后 暂时 先添加当前用户头像
//                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                        NSNumber *dqId = [defaults objectForKey:@"userId"];
//                        NSString *dqPic = [defaults objectForKey:@"pic"];
//                        CommunityModel *model=[_firstDataArray objectAtIndex:_firstIndexPath];
//                        
//                        UserAssistModel *userAssisModel = [UserAssistModel new];
//                        userAssisModel.userPic = dqPic;
//                        userAssisModel.uId = dqId;
//                        
//                        [_mutableArr removeAllObjects];
//                        
//                        [_mutableArr addObjectsFromArray:model.tUserAssists];
//                        
//                        if (_mutableArr.count == 0) {
//                            [_mutableArr addObject:userAssisModel];
//                            
//                        }else{
//                            
//                            for (int i = _mutableArr.count - 1; i >=0; i--) {
//                                UserAssistModel *userAssisModel = [_mutableArr objectAtIndex: i];
//                                
//                                if ([userAssisModel.uId isEqualToNumber:dqId]) {
//                                    
//                                    [_mutableArr removeObject:userAssisModel];
//                                }
//                            }
//                            [_mutableArr addObject:userAssisModel];
//                            
//                        }
//                        
//                        model.tUserAssists = _mutableArr;
//                        
//                        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:0];
//                        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//                        [btn setImage:[UIImage imageNamed:@"dz"] forState:(UIControlStateNormal)];
//                        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//                        btn.userInteractionEnabled = YES;
//
//                    }else {
//                        btn.userInteractionEnabled = YES;
//
//                    }
//                } failed:^(NSError *error) {
//                    btn.userInteractionEnabled = YES;
//
//                }];
//            }
//            //已点赞
//            else
//            {
//                [dic setValue:@0 forKey:@"type"];
//                [[PostDataRequest sharedInstance] postDataRequest:@"userAssist/change.do" parameter:dic success:^(id respondsData) {
//                    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
//                    
//                    if ([[userData objectForKey:@"success"] boolValue]) {
//                        NSInteger a = [[_firstDataArray[_firstIndexPath] assistCount] integerValue] - 1;
//                        [_firstDataArray[_firstIndexPath] setValue:[NSNumber numberWithInteger:a] forKey:@"assistCount"];
//                        [_firstDataArray[_firstIndexPath] setValue:@0 forKey:@"assistState"];
//                        [btn setTitle:[NSString stringWithFormat:@"%ld", (long)a] forState:UIControlStateNormal];
//                        
//                        
//                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                        NSNumber *dqId = [defaults objectForKey:@"userId"];
//                        CommunityModel *model=[_firstDataArray objectAtIndex:_firstIndexPath];
//                        [_mutableArr removeAllObjects];
//                        
//                        [_mutableArr addObjectsFromArray:model.tUserAssists];
//                        
//                        for (int i = _mutableArr.count - 1; i >=0; i--) {
//                            UserAssistModel *userAssisModel = [_mutableArr objectAtIndex: i];
//                            if ([userAssisModel.uId isEqualToNumber:dqId]) {
//                                
//                                [_mutableArr removeObject:userAssisModel];
//                            }
//                        }
//                        
//                        model.tUserAssists = _mutableArr;
//                        
//                        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:0];
//                        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//                        [btn setImage:[UIImage imageNamed:@"zan"] forState:(UIControlStateNormal)];
//                        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//                        
//                        btn.userInteractionEnabled = YES;
//
//                    }else {
//                        btn.userInteractionEnabled = YES;
//
//                    }
//                } failed:^(NSError *error) {
//                    btn.userInteractionEnabled = YES;
//
//                }];
//            }
//        };
//        
//        
//        // 更多点赞 点击跳到 ZanNumViewController
//        cell.blockMoreZan = ^(){
//            ZanNumViewController* zanVc = [[ZanNumViewController alloc]init];
//            
//            zanVc.comModel = _firstDataArray[_firstIndexPath];
//            
//            
//            [self.navigationController pushViewController:zanVc animated:YES];
//        };
//
//        
//        cell.blockShare = ^(){
//            
//            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
//                
//                _comModel =[_firstDataArray objectAtIndex:_firstIndexPath];
//                
//                ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
//                alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
//                [alert setCallBackTitle:^(NSInteger index) {
//                    [self shareInfo:index];
//                }];
//                [UIView animateWithDuration:0.2 animations:^{
//                    [alert show];
//                    
//                }];
//            }else {
//            }
//        };
        
        
        //添加长摁举报手势
        
//        UILongPressGestureRecognizer *longEnt = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
//        longEnt.minimumPressDuration = 1.0f;
//        
//        [_tableView addGestureRecognizer:longEnt];
        
        

        
        return cell;
        
    }else {
        ComDetailViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ComDetailViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showData:_dataArray[indexPath.row-1]];
        
        return cell;
    }
}

-(void)tousu:(NSInteger)index{
    
//    //NSLog(@"%@",[_dataArray[index] userMoodId]);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportViewController * reportView = [[ReportViewController alloc]init];
//        reportView.userMood = [_firstDataArray[index] userMoodId];
        
        reportView.otherUserId = [_firstDataArray[index] uId];
        reportView.typeNum = @2;
        reportView.objId = [_firstDataArray[index] userMoodId];
        [self.navigationController pushViewController:reportView animated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pingbiyonghu:[_firstDataArray[index] uId]];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)pingbiyonghu:(NSNumber *)shieldUserId
{
    [self.view endEditing:YES];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *dqId = [defaults objectForKey:@"userId"];
        
        [[PostDataRequest sharedInstance] postDataRequest:@"moodShield/save.do" parameter:@{@"shieldUserId":shieldUserId,@"userId":dqId} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            
            if ([[dict objectForKey:@"success"] boolValue]) {
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                
                //                [_firstDataArray removeAllObjects];
                //                [_tableView.mj_header endRefreshing];
                //                _tableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                //                [_tableView.mj_header beginRefreshing];
                //                [_tableView reloadData];
                
                UIAlertController *alerT = [UIAlertController alertControllerWithTitle:@"提示" message:@"屏蔽成功!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self backButtonClcik];
                }];
                [alerT addAction:aler1];
                
                [self.navigationController presentViewController:alerT animated:YES completion:nil];
                
            }else {
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                if ([dqId isEqualToNumber:shieldUserId]) {
                    [Helper alertViewNoHaveCancleWithTitle:@"不能屏蔽自己!" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                }else{
                    [Helper alertViewNoHaveCancleWithTitle:@"网络状况不佳,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                }
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            [Helper alertViewNoHaveCancleWithTitle:@"请求失败,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }];
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"loadMessageData" object:nil];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
}





-(void)shareInfo:(NSInteger)index
{
    
    NSData *fiData;
    
    if (_comModel.pics.count == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper imageUrl:_comModel.uPic]];
    }else{
        fiData = [NSData dataWithContentsOfURL:[Helper imageUrl:_comModel.pics[0]]];
    }
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/mood/Topic_details.html?id=%@",_comModel.userMoodId];
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"来自%@的话题",_comModel.userName];
    if (index == 0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"来自%@的话题:%@ %@",_comModel.userName,_comModel.moodContent,shareUrl]  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"来自%@的话题:%@ %@",_comModel.userName,_comModel.moodContent,shareUrl] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
            }
        }];
    }
    else
    {
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//创建评论输入框视图
- (void)creatjudementView {
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-43-64, ScreenWidth, 48)];
    _commentView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 7, ScreenWidth-5-40-10-10, 30)];
    _commentTextView.backgroundColor = [UIColor whiteColor];
    _commentTextView.clipsToBounds = YES;
    _commentTextView.layer.cornerRadius = 5;
    _commentTextView.returnKeyType = UIReturnKeySend;
    //    _commentTextView.keyboardType = UIKeyboardTypeNamePhonePad;
    _commentTextView.delegate = self;
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendButton.frame = CGRectMake(ScreenWidth-10-40, 12, 40, 21);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_commentView addSubview:_sendButton];
    [_commentView addSubview:_commentTextView];
    [self.view addSubview:_commentView];
}

//发送评论
- (void)sendBtnClick {
    
    _isClickText = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSMutableString* str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
        [_dict setValue:str forKey:@"uId"];
    }
    [_dict setValue:_commentTextView.text forKey:@"commentContent"];
    [_dict setValue:_mId forKey:@"mId"];
    
    if (_commentTextView.text != nil) {
        [[PostDataRequest sharedInstance] postDataRequest:kComment_URL parameter:_dict success:^(id respondsData) {
            
            NSInteger a = [[_firstDataArray[_firstIndexPath] commentCount] integerValue] + 1;
            [_firstDataArray[_firstIndexPath] setValue:[NSNumber numberWithInteger:a] forKey:@"commentCount"];
            
            [_tableView.mj_header beginRefreshing];
            
        } failed:^(NSError *error) {
            ////NSLog(@"%@",error);
        }];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    _commentTextView.text = nil;
    [_commentTextView endEditing:YES];
    
    //详情内评论之后 外部+1
    //    self.blockPinglun();
    ////NSLog(@"发送评论！");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendBtnClick];
    }
    return YES;
}


@end
