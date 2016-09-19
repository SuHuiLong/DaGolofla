//
//  CommunityViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommuniteTableViewCell.h"
#import "CommunityModel.h"
#import "UserAssistModel.h"

#import "PersonHomeController.h"
#import "SelfViewController.h"
#import "ComDetailViewController.h"

#import "NewsMessageViewController.h"
#import "ZanNumViewController.h"
#import "PublishViewController.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"


#import "PostDataRequest.h"
#import "Helper.h"

#import "EnterViewController.h"
#import "UserDataInformation.h"

#import "PicArrShowViewControllerViewController.h"
#import "UIButton+WebCache.h"

#import "ReportViewController.h"

#import "MBProgressHUD.h"
#import "UITabBar+badge.h"
@interface CommunityViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView* _tableView;
    UISegmentedControl *_segmentedControl;
    NSInteger _page;
    NSMutableArray *_mutableArr;
    
    CommunityModel * _comModel;
}

@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation CommunityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] && ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstEnter"] intValue] != 3)) {
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        [user setObject:@3 forKey:@"isFirstEnter"];
        [user synchronize];
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_tableView.header beginRefreshing];
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstEnter"] intValue] == 1){
            NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
            [user setObject:@2 forKey:@"isFirstEnter"];
            [user synchronize];
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            [_tableView.header beginRefreshing];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xinxi"] style:UIBarButtonItemStylePlain target:self action:@selector(moreLeftClick)];
    //    leftBtn.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //右边按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fabu"] style:UIBarButtonItemStylePlain target:self action:@selector(moreRightClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    //左边按钮
    _dataArray = [[NSMutableArray alloc]init];
    _mutableArr = [NSMutableArray array];
    
    [self createTableView];
    [self createSegMent];
}

//发布话题
-(void)moreRightClick{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        PublishViewController* pubVc = [[PublishViewController alloc]init];
        //发布完成回调刷新
        pubVc.blockRereshing = ^(){
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            [_tableView.header beginRefreshing];
        };
        [self.navigationController pushViewController:pubVc animated:YES];
        
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


-(void)createSegMent
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40*ScreenWidth/375)];
    _tableView.tableHeaderView = viewBase;
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [viewBase addSubview:viewLine];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"球友圈",@"附近的人",nil];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(13*ScreenWidth/375, 5*ScreenWidth/375, ScreenWidth-26*ScreenWidth/375, 30*ScreenWidth/375);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.tintColor = [UIColor lightGrayColor];
    
    [viewBase addSubview:_segmentedControl];
    [_segmentedControl addTarget:self action:@selector(controllerPressed:) forControlEvents:UIControlEventValueChanged];
    
}


- (void) controllerPressed:(id)sender {
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    NSInteger selectedIndex = [ _segmentedControl selectedSegmentIndex ];
    /* 添加代码,处理值的变化 */
    if (selectedIndex == 1) {
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        //        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [_tableView.header beginRefreshing];
    }
    else if (selectedIndex == 2)
    {
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        //        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [_tableView.header beginRefreshing];
    }
    else
    {
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        //        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [_tableView.header beginRefreshing];
    }
}


-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_tableView];
    _tableView.separatorInset = UIEdgeInsetsMake(0,5,0,10);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CommuniteTableViewCell class] forCellReuseIdentifier:@"cellid"];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    //    addHeaderWithTarget: 是第三方类库中UIScrolView的category。
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.header beginRefreshing];
    
}

#pragma mark --MJ刷新方法

- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSInteger index = [_segmentedControl selectedSegmentIndex];
    NSNumber* numIndex = [NSNumber numberWithInteger:index-1];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSNumber *userId = [user objectForKey:@"userId"];
    NSNumber *lat = [user objectForKey:@"lat"];
    NSNumber *lng = [user objectForKey:@"lng"];
    //    //NSLog(@"%@    %@",lat,lng);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([user objectForKey:@"userId"] != nil)
    {
        [dic setValue:userId forKey:@"userId"];
    }
    else
    {
        [dic setObject:@0 forKey:@"userId"];
    }
    
    [dic setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    if (lng != nil)
    {
        [dic setValue:lng forKey:@"yIndex"];
    }
    if (lat != nil) {
        [dic setValue:lat forKey:@"xIndex"];
    }
    [dic setValue:@10 forKey:@"rows"];
    
    
    [dic setValue:numIndex forKey:@"searchState"];
    [dic setValue:@0 forKey:@"moodType"];
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"userMood/queryPage.do" parameter:dic success:^(id respondsData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        //        //NSLog(@"%@",dict);
        
        if ([[dict objectForKey:@"success"]boolValue]) {
            if (page == 1)
            {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                CommunityModel *model = [[CommunityModel alloc] init];
                model.tUserAssists = [NSMutableArray array];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
                
                // 添加userAssists
                NSMutableArray *tempAss = [NSMutableArray array];
                [tempAss addObject:[dataDict objectForKey:@"tUserAssists"]];
                
                for (NSMutableArray *obj in tempAss) {
                    NSMutableArray *te = [NSMutableArray array];
                    if (![obj isEqual:[NSNull null]]) {
                        for (NSDictionary *userAssists in obj) {
                            UserAssistModel *mo = [[UserAssistModel alloc] init];
                            [mo setValuesForKeysWithDictionary:userAssists];
                            [te addObject:mo];
                        }
                    }
                    if (te.count > 0) {
                        model.tUserAssists = te;
                    }
                }
            }
            _page++;
            [_tableView reloadData];
            
        } else {
            if (page == 1)
            {
                [_dataArray removeAllObjects];
            }
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        
        [Helper alertViewNoHaveCancleWithTitle:@"您的网络异常,请稍后重试." withBlock:^(UIAlertController *alertView) {
            
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
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
    _page++;
    [self downLoadData:_page isReshing:NO];
}


#pragma mark -- tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell行高判定
    
    CommunityModel *model=[_dataArray objectAtIndex:indexPath.row];
    CommuniteTableViewCell* cell = [[CommuniteTableViewCell alloc]init];
    
    CGFloat moodContentH = [model.moodContent boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    CGFloat cellH =  moodContentH+cell.iconImgv.frame.size.height+cell.picImage1.frame.size.height
    +cell.FootView.frame.size.height+cell.ClubView.frame.size.height
    +cell.ZPFView.frame.size.height+cell.ZanView.frame.size.height+43*ScreenWidth/375;
    
    if ([_dataArray[indexPath.row] pics].count != 0) {
        cellH = cellH;
    }else{
        cellH -=cell.picImage1.frame.size.height + 1;
    }
    if ([model.moodType integerValue] == 1) {
        cellH = cellH;
    }else{
        cellH -=cell.FootView.frame.size.height + 1;
    }
    if ([model.assistCount integerValue] != 0) {
        cellH = cellH;
    }else{
        cell.ZanView.hidden = YES;
        cellH -=cell.ZanView.frame.size.height + 5;
    }
    
    return cellH;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count != 0) {
        CommunityModel *model=[_dataArray objectAtIndex:indexPath.row];
        CommuniteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        // 判断是否点过赞
        if ([model.assistState intValue]) {
            [cell.zanBaseBtn setImage:[UIImage imageNamed:@"dz"] forState:(UIControlStateNormal)];
        }else{
            [cell.zanBaseBtn setImage:[UIImage imageNamed:@"zan"] forState:(UIControlStateNormal)];
        }
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //    if (_dataArray.count > 0) {
        //
        //        cell.model = _dataArray [indexPath.row];
        //    }
        
        cell.cellDataArray = _dataArray;
        cell.cellIndexPath = indexPath.row;
        
        [cell setCommunityModel:model];
        
        [cell setZanIcon:model.tUserAssists];
        
        
        //举报点击跳转block
        cell.blockReportBtn = ^(){
            [self tousu:indexPath.row];
        };
        
        //设置自己不能关注自己
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber * myId = [defaults objectForKey:@"userId"];
        if ([myId isEqualToNumber:model.uId]) {
            cell.btnLike.hidden = YES;
        }else{
            cell.btnLike.hidden = NO;
        }
        
        //各种头像点击跳转block
        cell.blockIconPush = ^(NSNumber * i){
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
                PersonHomeController* selfVc = [[PersonHomeController alloc]init];
                selfVc.strMoodId = i;
                selfVc.messType = @2;
                [self.navigationController pushViewController:selfVc animated:YES];
            }else {
                [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
                } withBlockSure:^{
                    EnterViewController *vc = [[EnterViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        };
        
        //图片点击跳转block
        cell.blockPicPush = ^(NSInteger i , NSMutableArray* arr){
            PicArrShowViewControllerViewController *picVC = [[PicArrShowViewControllerViewController alloc]initWithIndex:i];
            picVC.selectImages = [_dataArray[indexPath.row] pics];
            [self.navigationController pushViewController:picVC animated:YES];
        };
        
        //评论点击跳转block
        cell.blockPinglunPush = ^(NSInteger i){
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                
                ComDetailViewController* comVc = [[ComDetailViewController alloc]init];
                comVc.firstDataArray = _dataArray;
                comVc.firstIndexPath = indexPath.row;
                comVc.model = _dataArray[indexPath.row];
                comVc.mId = [_dataArray[indexPath.row] userMoodId];
                
                // POP回来时 刷新单行
                comVc.blockGuanzhuRereshing = ^(){
                    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
                    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                
                [self.navigationController pushViewController:comVc animated:YES];
                
            }else {
                [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
                } withBlockSure:^{
                    EnterViewController *vc = [[EnterViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        };
        
        //详情内关注 判断登录
        cell.blockIsLogin=^{
            //暂时未用到
            [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            } withBlockSure:^{
                EnterViewController *vc = [[EnterViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            
        };
        
        //点赞事件
        
        cell.blockAddZanIcon = ^(UIButton* btn){
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
                
                btn.userInteractionEnabled = NO;
                
                NSInteger dianJi = btn.tag - 100000;
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                [dic setValue:[_dataArray[dianJi] userMoodId] forKey:@"mId"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (defaults) {
                    NSMutableString* str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
                    [dic setValue:str forKey:@"userId"];
                }
                
                //未点赞
                if ([[_dataArray[dianJi] assistState] isEqualToNumber:@0]) {
                    [dic setValue:@1 forKey:@"type"];
                    //点赞的请求
                    [[PostDataRequest sharedInstance] postDataRequest:@"userAssist/change.do" parameter:dic success:^(id respondsData) {
                        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        if ([[userData objectForKey:@"success"] boolValue]) {
                            
                            
                            NSInteger a = [[_dataArray[dianJi] assistCount] integerValue] + 1;
                            [_dataArray[dianJi] setValue:[NSNumber numberWithInteger:a] forKey:@"assistCount"];
                            [_dataArray[dianJi] setValue:@1 forKey:@"assistState"];
                            [btn setTitle:[NSString stringWithFormat:@"%ld", (long)a] forState:UIControlStateNormal];
                            
                            //点赞之后 暂时 先添加当前用户头像
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSNumber *dqId = [defaults objectForKey:@"userId"];
                            NSString *dqPic = [defaults objectForKey:@"pic"];
                            CommunityModel *model=[_dataArray objectAtIndex:dianJi];
                            
                            UserAssistModel *userAssisModel = [UserAssistModel new];
                            userAssisModel.userPic = dqPic;
                            userAssisModel.uId = dqId;
                            
                            [model.tUserAssists replacementObjectForCoder:userAssisModel];
                            
                            [_mutableArr removeAllObjects];
                            
                            [_mutableArr addObjectsFromArray:model.tUserAssists];
                            
                            if (_mutableArr.count == 0) {
                                [_mutableArr addObject:userAssisModel];
                            }else{
                                
                                for (int i = _mutableArr.count - 1; i >=0; i--) {
                                    UserAssistModel *userAssisModel = [_mutableArr objectAtIndex: i];
                                    
                                    if ([userAssisModel.uId isEqualToNumber:dqId]) {
                                        [_mutableArr removeObject:userAssisModel];
                                    }
                                }
                                [_mutableArr addObject:userAssisModel];
                            }
                            model.tUserAssists = _mutableArr;
                            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:dianJi inSection:0];
                            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                            [btn setImage:[UIImage imageNamed:@"dz"] forState:(UIControlStateNormal)];
                            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                            btn.userInteractionEnabled = YES;
                            
                        }else {
                            
                            btn.userInteractionEnabled = YES;
                            
                        }
                    } failed:^(NSError *error) {
                        
                        btn.userInteractionEnabled = YES;
                        
                    }];
                }
                //已点赞
                else
                {
                    [dic setValue:@0 forKey:@"type"];
                    [[PostDataRequest sharedInstance] postDataRequest:@"userAssist/change.do" parameter:dic success:^(id respondsData) {
                        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        
                        if ([[userData objectForKey:@"success"] boolValue]) {
                            
                            
                            NSInteger a = [[_dataArray[dianJi] assistCount] integerValue] - 1;
                            [_dataArray[dianJi] setValue:[NSNumber numberWithInteger:a] forKey:@"assistCount"];
                            [_dataArray[dianJi] setValue:@0 forKey:@"assistState"];
                            [btn setTitle:[NSString stringWithFormat:@"%ld", (long)a] forState:UIControlStateNormal];
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSNumber *dqId = [defaults objectForKey:@"userId"];
                            CommunityModel *model=[_dataArray objectAtIndex:dianJi];
                            [_mutableArr removeAllObjects];
                            
                            [_mutableArr addObjectsFromArray:model.tUserAssists];
                            
                            for (int i = _mutableArr.count - 1; i >=0; i--) {
                                UserAssistModel *userAssisModel = [_mutableArr objectAtIndex: i];
                                if ([userAssisModel.uId isEqualToNumber:dqId]) {
                                    [_mutableArr removeObject:userAssisModel];
                                }
                            }
                            model.tUserAssists = _mutableArr;
                            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:dianJi inSection:0];
                            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                            [btn setImage:[UIImage imageNamed:@"zan"] forState:(UIControlStateNormal)];
                            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                            btn.userInteractionEnabled = YES;
                            
                        }else {
                            
                            btn.userInteractionEnabled = YES;
                            
                        }
                    } failed:^(NSError *error) {
                        
                        btn.userInteractionEnabled = YES;
                        
                    }];
                }
            }else {
                [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
                } withBlockSure:^{
                    EnterViewController *vc = [[EnterViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        };
        
        // 更多点赞 点击跳到 ZanNumViewController
        cell.blockMoreZan = ^(){
            ZanNumViewController* zanVc = [[ZanNumViewController alloc]init];
            zanVc.comModel = _dataArray[indexPath.row];
            [self.navigationController pushViewController:zanVc animated:YES];
        };
        cell.blockShare = ^(){
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
                _comModel =[_dataArray objectAtIndex:indexPath.row];
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
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        };
        //添加长摁举报手势
        UILongPressGestureRecognizer *longEnt = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
        longEnt.minimumPressDuration = 1.0f;
        [_tableView addGestureRecognizer:longEnt];
        return cell;
    }else{
        return nil;
    }
}
-(void)tousu:(NSInteger)index{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportViewController * reportView = [[ReportViewController alloc]init];
        
        reportView.otherUserId = [_dataArray[index] uId];
        reportView.typeNum = @2;
        reportView.objId = [_dataArray[index] userMoodId];
        
        [self.navigationController pushViewController:reportView animated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pingbiyonghu:[_dataArray[index] uId]];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:_tableView];
        NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReportViewController * reportView = [[ReportViewController alloc]init];
            reportView.otherUserId = [_dataArray[indexPath.row] uId];;
            reportView.typeNum = @2;
            reportView.objId = [_dataArray[indexPath.row] userMoodId];
            
            [self.navigationController pushViewController:reportView animated:YES];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pingbiyonghu:[_dataArray[indexPath.row] uId]];
            
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [alertVC addAction:action3];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        //add your code here
    }
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
                [_dataArray removeAllObjects];
                [_tableView.header endRefreshing];
                _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                [_tableView.header beginRefreshing];
                [_tableView reloadData];
                
                UIAlertController *alerT = [UIAlertController alertControllerWithTitle:@"提示" message:@"屏蔽成功!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alerT addAction:aler1];
                
                [self.navigationController presentViewController:alerT animated:YES completion:nil];
                
            }else {
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                
                [Helper alertViewNoHaveCancleWithTitle:@"网络状况不佳,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                    
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            //            //NSLog(@"%@",error);
            [Helper alertViewNoHaveCancleWithTitle:@"网络状况不佳,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }];
        
        
        
    }else {
        
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
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
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"打高尔夫啦",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        //点击cell进入详情
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        ComDetailViewController* comDevc = [[ComDetailViewController alloc]init];
        comDevc.firstDataArray = _dataArray;
        comDevc.firstIndexPath = indexPath.row;
        comDevc.mId = [_dataArray[indexPath.row] userMoodId];
        
        // POP回来时 刷新单行
        comDevc.blockGuanzhuRereshing = ^(){
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:comDevc animated:YES];
        
    }else {
        
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
}
@end
