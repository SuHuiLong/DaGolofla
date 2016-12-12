//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFActionSheet.h"

#define dataCount 10
#define kLocationToBottom 20


#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
#import "PostDataRequest.h"
#import "Helper.h"

#import "MyNewsBoxViewController.h"
#import "PublishViewController.h"
#import "ZanNumViewController.h"
#import "PersonHomeController.h"
#import "ReportViewController.h"


#import "UMSocial.h"
#import "ShareAlert.h"
#import "UMSocialData.h"
#import "ShareAlert.h"
#import "UMSocialConfig.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "CommuniteTableViewCell.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialControllerService.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#import "VedioPlayViewController.h"

#import "JKSlideViewController.h"


@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate, VedioPlayViewControllerDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//数据
    
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    
    
    UIView *popView;
    
    YMReplyInputView *replyView;
    
    NSInteger _replyIndex;
    
    NSInteger _page;
    
    
    
    NSInteger _clickIndex;
    NSInteger _replyUserIndex;
    
    
    
}

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) YMTextData *ymData;
@property (nonatomic,strong) UITableView *mainTable;


@end

@implementation WXViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
    //处理TableView偏移问题
    self.mainTable.frame = CGRectMake(0, 0, self.view.frame.size.width,ScreenHeight - 115);
}

- (void)returnFirRef{
    self.mainTable.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.mainTable.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.mainTable.header endRefreshing];
    [self.mainTable.header beginRefreshing];
}


- (void)viewDidCurrentView{
    //    NSLog(@"加载为当前视图 = %@",self.title);
    //    NSLog(@"当前视图Type = %d",self.state);
    //
    
    if ([self.title isEqualToString:@"球友"]) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
            
        }else {
            
            [self.mainTable.header endRefreshing];
            [self.mainTable.footer endRefreshing];
            
            [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            } withBlockSure:^{

                JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
                vc.reloadCtrlData = ^(){
                    
                };
                [self.navc pushViewController:vc animated:YES];

            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _page = 1;
    
    _replyIndex = -1;//代表是直接评论
    
    _tableDataSource = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //    }
    [self initTableview];
}

- (void)backToPre{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) initTableview{
    
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,ScreenHeight - 115)];
    self.mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTable];
    
    self.mainTable.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.mainTable.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.mainTable.header beginRefreshing];
}

#pragma mark --MJ刷新方法

- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [user objectForKey:@"userId"];
    NSNumber *lat = [user objectForKey:@"lat"];
    NSNumber *lng = [user objectForKey:@"lng"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (userId == nil)
    {
        userId = @0;
    }
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    if (lng != nil){
        [dic setValue:lng forKey:@"yIndex"];
    }else{
        [dic setValue:@0 forKey:@"yIndex"];
    }
    if (lat != nil) {
        [dic setValue:lat forKey:@"xIndex"];
    }else{
        [dic setValue:@0 forKey:@"xIndex"];
    }
    [dic setValue:@10 forKey:@"rows"];
    
    if ([self.title isEqualToString:@"最新"]) {
        [dic setValue:@-1 forKey:@"searchState"];
    }else if ([self.title isEqualToString:@"热门"]){
        [dic setValue:@2 forKey:@"searchState"];
    }else if ([self.title isEqualToString:@"球友"]){
        [dic setValue:@0 forKey:@"searchState"];
    }else{
        [dic setValue:@1 forKey:@"searchState"];
    }
    
    [dic setValue:@0 forKey:@"moodType"];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"userMood/queryPage.do" parameter:dic success:^(id respondsData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        //        NSLog(@"%@",dict);
        
        if ([[dict objectForKey:@"success"]boolValue]) {
            
            if (page == 1)
            {
                [_tableDataSource removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                
                NSMutableArray *replyArr = [NSMutableArray array];
                
                if ([dataDict objectForKey:@"userComments"]) {
                    
                    for (NSDictionary * replyDic in [dataDict objectForKey:@"userComments"]) {
                        
                        WFReplyBody *body = [[WFReplyBody alloc] init];
                        
                        NoteModel *model1 = [NoteHandlle selectNoteWithUID:[replyDic objectForKey:@"uId"]];
                        if ([model1.userremarks isEqualToString:@"(null)"] || [model1.userremarks isEqualToString:@""] || model1.userremarks == nil) {
                            body.replyUser = [NSString stringWithFormat:@"%@",[replyDic objectForKey:@"userName"]];
                        }else{
                            body.replyUser= model1.userremarks;
                        }
                        
                        
                        NoteModel *model = [NoteHandlle selectNoteWithUID:[replyDic objectForKey:@"replyUid"]];
                        if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                            body.repliedUser = [NSString stringWithFormat:@"%@",[replyDic objectForKey:@"replyUserName"]];
                        }else{
                            body.repliedUser = model.userremarks;
                        }
                        
                        body.replyInfo = [NSString stringWithFormat:@"%@",[replyDic objectForKey:@"commentContent"]];
                        body.replyId =  [replyDic objectForKey:@"replyUid"];
                        body.userCommentId =  [replyDic objectForKey:@"userCommentId"];
                        body.otherUid = [replyDic objectForKey:@"uId"];
                        [replyArr addObject:body];
                    }
                }
                
                
                WFMessageBody *messBody = [[WFMessageBody alloc] init];
                
                if (![Helper isBlankString:[dataDict objectForKey:@"userName"]]) {
                    messBody.posterName = [dataDict objectForKey:@"userName"];
                }
                messBody.posterImgstr = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/%@",[dataDict objectForKey:@"uPic"]];
                //视频缩略图
                messBody.thumbnailImageURL = [NSString stringWithFormat:@"%@%@", imageBaseUrl, [dataDict objectForKey:@"videosmall_img"]];
                //http://192.168.2.38:8088/image/userMoodVideoimage/20160504/20160504140482206512.png
                
                
                messBody.posterIntro = [dataDict objectForKey:@"createTime"];
                messBody.posterContent = [dataDict objectForKey:@"moodContent"];
                messBody.posterPostImage = [dataDict objectForKey:@"pics"];
                messBody.posterReplies = replyArr;
                
                messBody.videoPath = [NSString stringWithFormat:@"%@%@", imageBaseUrl, [dataDict objectForKey:@"videoPath"]];
                
                //点赞姓名提取 放进新数组重新赋值
                NSMutableArray *newFavourArray = [NSMutableArray array];
                for (NSDictionary *favourDic in [dataDict objectForKey:@"tUserAssists"]) {
                    
                    NoteModel *model = [NoteHandlle selectNoteWithUID:[favourDic objectForKey:@"uId"]];
                    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                        [newFavourArray addObject:[favourDic objectForKey:@"userName"]];
                    }else{
                        [newFavourArray addObject:model.userremarks];
                    }
                    
                    
                    //                    [newFavourArray addObject:[favourDic objectForKey:@"userName"]];
                }
                
                //分享姓名提取 放进新数组重新赋值
                NSMutableArray *newShareArray = [NSMutableArray array];
                for (NSDictionary *shareDic in [dataDict objectForKey:@"userForwards"]) {
                    
                    NoteModel *model = [NoteHandlle selectNoteWithUID:[shareDic objectForKey:@"uId"]];
                    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                        [newShareArray addObject:[shareDic objectForKey:@"userName"]];
                    }else{
                        [newShareArray addObject:model.userremarks];
                    }
                    
                    //                    [newShareArray addObject:[shareDic objectForKey:@"userName"]];
                }
                messBody.posterShare = newShareArray;
                messBody.posterFavour = newFavourArray;
                messBody.isFavour = NO;
                
                YMTextData *ymData = [[YMTextData alloc] init];
                ymData.moodType = [dataDict objectForKey:@"moodType"];
                ymData.messageBody = messBody;
                //点赞和评论数
                ymData.assistCount = [dataDict objectForKey:@"assistCount"];
                ymData.commentCount = [dataDict objectForKey:@"commentCount"];
                ymData.forwardNum = [dataDict objectForKey:@"forwardNum"];
                ymData.golfName = [dataDict objectForKey:@"golfName"];
                ymData.distance = [dataDict objectForKey:@"distance"];
                ymData.poleNum = [dataDict objectForKey:@"poleNum"];
                ymData.playTime = [dataDict objectForKey:@"playTime"];
                ymData.userMoodId = [dataDict objectForKey:@"userMoodId"];
                ymData.assistState = [dataDict objectForKey:@"assistState"];
                ymData.uId = [dataDict objectForKey:@"uId"];
                ymData.followState = [dataDict objectForKey:@"followState"];
                ymData.tUserAssists = [dataDict objectForKey:@"tUserAssists"];
                
                ymData.userForwards = [dataDict objectForKey:@"userForwards"];
                ymData.pics = [dataDict objectForKey:@"pics"];
                ymData.uPic = [dataDict objectForKey:@"uPic"];
                ymData.userName = [dataDict objectForKey:@"userName"];
                ymData.moodContent = [dataDict objectForKey:@"moodContent"];
                //                ymData.userCommentId = [dataDict objectForKey:@"userCommentId"];
                
                //                [dataDict objectForKey:@"userCommentId"];
                
                //                NSLog(@"%@", ymData.userCommentId);
                
                if ([[dataDict objectForKey:@"images"] count]> 0) {
                    NSDictionary *dic = [[dataDict objectForKey:@"images"] firstObject];
                    NSInteger imageHeight = [[dic objectForKey:@"small_imageHeight"] intValue];
                    NSInteger imageWidth = [[dic objectForKey:@"small_imageWidth"] intValue];
                    
                    if (imageHeight > imageWidth) {
                        ymData.JavaRubbish = 1;
                    }else if (imageHeight < imageWidth){
                        ymData.JavaRubbish = 2;
                    }else{
                        ymData.JavaRubbish = 3;
                    }
                }
                
                //计算高度
                ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
                ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
                ymData.shareHeight = [ymData calculateShareHeightWithWidth:self.view.frame.size.width];
                [_tableDataSource addObject:ymData];
            }
            
            if (isReshing) {
                [self.mainTable.header endRefreshing];
            }else {
                [self.mainTable.footer endRefreshing];
            }
            
            //            _page++;
            [self.mainTable reloadData];
            
        } else {
            if (page == 1)
            {
                [_tableDataSource removeAllObjects];
                [self.mainTable reloadData];
                
                if (isReshing) {
                    [self.mainTable.header endRefreshing];
                }else {
                    [self.mainTable.footer endRefreshing];
                }
            }
        }
        
    } failed:^(NSError *error) {
        
        //        NSLog(@"%@",[dic objectForKey:@"message"]);
        if (isReshing) {
            [self.mainTable.header endRefreshing];
        }else {
            [self.mainTable.footer endRefreshing];
        }
        [Helper alertViewNoHaveCancleWithTitle:@"您的网络异常,请稍后重试." withBlock:^(UIAlertController *alertView) {
            
            [self.navc presentViewController:alertView animated:YES completion:nil];
        }];
        
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing{
    _page++;
    [self downLoadData:_page isReshing:NO];
}


//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL distance = [ym.golfName isKindOfClass:[NSNull class]] || ([ym.distance intValue] == 0);
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + ym.showImageHeight + 75 + ym.replyHeight  +  (([ym.moodType intValue] == 0)?0:30) +  (ym.favourHeight == 0?0:20*screenWidth/375) + ([ym.forwardNum intValue] == 0?0:20*screenWidth/375) +(ym.islessLimit?0:30*screenWidth/375) - (distance ? 30 : 0) *screenWidth/375 +5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.attentionBtn addTarget:self action:@selector(attentionAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.moreLikeBtn addTarget:self action:@selector(moreLikeAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.moreShareBtn addTarget:self action:@selector(moreLikeAct:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    
    WS(ws);
    cell.didSelectedOperationCompletion = ^(WFOperationType operationType) {
        switch (operationType) {
            case WFOperationTypeLike:
                
                [ws addLike:indexPath.row];
                break;
            case WFOperationTypeReply:
                [ws replyMessage:nil indexPath:indexPath.row];
                break;
            case WFOperationTypeShare:
                [ws addShare:indexPath.row];
                break;
            default:
                break;
        }
    };
    
    
    
    cell.blockSelf = ^(NSInteger i){
        //        NSLog(@">>>>>>>%d",i);
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
            PersonHomeController* selfVc = [[PersonHomeController alloc]init];
            selfVc.strMoodId = [NSNumber numberWithInteger:i];
            selfVc.messType = @2;
            [self.navc pushViewController:selfVc animated:YES];
        }else {
            [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            } withBlockSure:^{
                
                JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
                vc.reloadCtrlData = ^(){
                    
                };
                [self.navc pushViewController:vc animated:YES];

            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    };
    
    //添加长摁举报手势
    UILongPressGestureRecognizer *longEnt = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
    longEnt.minimumPressDuration = 0.5f;
    [self.mainTable addGestureRecognizer:longEnt];
    return cell;
}

//举报事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    //    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath];
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        CGPoint point = [gesture locationInView:self.mainTable];
        
        NSIndexPath * indexPath = [self.mainTable indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReportViewController * reportView = [[ReportViewController alloc]init];
            reportView.otherUserId = [_tableDataSource[indexPath.row] uId];;
            reportView.typeNum = @2;
            reportView.objId = [_tableDataSource[indexPath.row] userMoodId];
            
            [self.navc pushViewController:reportView animated:YES];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pingbiyonghu:[_tableDataSource[indexPath.row] uId]];
            
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

//屏蔽用户
-(void)pingbiyonghu:(NSNumber *)shieldUserId
{
    [self.view endEditing:YES];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *dqId = [defaults objectForKey:@"userId"];
        
        [[PostDataRequest sharedInstance] postDataRequest:@"moodShield/save.do" parameter:@{@"shieldUserId":shieldUserId,@"userId":dqId} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            
            if ([[dict objectForKey:@"success"] boolValue]) {
                //                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                [_tableDataSource removeAllObjects];
                [self.mainTable.header endRefreshing];
                self.mainTable.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                [self.mainTable.header beginRefreshing];
                [self.mainTable reloadData];
                
                UIAlertController *alerT = [UIAlertController alertControllerWithTitle:@"提示" message:@"屏蔽成功!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alerT addAction:aler1];
                
                [self presentViewController:alerT animated:YES completion:nil];
                
            }else {
                //                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                
                [Helper alertViewNoHaveCancleWithTitle:@"网络状况不佳,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                    
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        } failed:^(NSError *error) {
            //            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            //            NSLog(@"%@",error);
            [Helper alertViewNoHaveCancleWithTitle:@"网络状况不佳,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }];
    }else {
        
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}



#pragma mark 点赞列表-------

- (void)moreLikeAct:(UIButton *)button{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        NSIndexPath *indexPath = [self.mainTable indexPathForCell:(YMTableViewCell *)[[button superview] superview]];
        ZanNumViewController* zanVc = [[ZanNumViewController alloc]init];
        zanVc.likeOrShar = button.tag;
        zanVc.ymModel = _tableDataSource[indexPath.row];
        //        NSLog(@"%ld", (long)button.tag);
        [self.navc pushViewController:zanVc animated:YES];
        
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
           
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


#pragma mark -分享

- (void)addShare:(NSInteger)indexRow{
    
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexRow];
        
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index cellIndex:indexRow];
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
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
};

//  分享成功后调用接口
- (void)shareS:(NSInteger)indexRow{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
        [dic setValue:self.ymData.userMoodId forKey:@"mId"];
        [dic setValue:@1 forKey:@"type"];
        [[PostDataRequest sharedInstance] postDataRequest:@"userForward/change.do" parameter:dic success:^(id respondsData) {
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            
            if ([userData objectForKey:@"rows"] == [NSNull null]) {
                return ;
            }
            
            
            WFMessageBody *m = self.ymData.messageBody;
            
            [m.posterShare addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
            
            self.ymData.messageBody = m;
            
            //清空属性数组。否则会重复添加
            
            [self.ymData.attributedDataShare removeAllObjects];
            self.ymData.shareHeight = [self.ymData calculateShareHeightWithWidth:self.view.frame.size.width];
            
            [_tableDataSource replaceObjectAtIndex:indexRow withObject:self.ymData];
            
            [self.mainTable reloadData];
            
            if ([[userData objectForKey:@"success"] boolValue]) {
                NSInteger a = [self.ymData.forwardNum integerValue] + 1;
                [self.ymData setValue:[NSNumber numberWithInteger:a] forKey:@"forwardNum"];
                
                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexRow inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                [self.mainTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
            }
        } failed:^(NSError *error) {
        }];
        
        
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){

            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}

#pragma mark －－－ 关注/撤销 按钮点击方法
- (void)attentionAct:(UIButton *)button{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{

            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }else{
        
        NSIndexPath *indexPath = [self.mainTable indexPathForCell:(YMTableViewCell *)[[button superview] superview]];
        
        self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] == [self.ymData.uId intValue]) {
            
            [Helper alertViewWithTitle:@"是否删除此动态?" withBlockCancle:^{
            } withBlockSure:^{
                
                NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
                [muDic setValue:_ymData.userMoodId forKey:@"mId"];
                [[PostDataRequest sharedInstance] postDataRequest:@"userMood/delete.do" parameter:muDic success:^(id respondsData) {
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([[dict objectForKey:@"success"]boolValue]) {
                        [_tableDataSource removeObjectAtIndex:indexPath.row];
                        [self.mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
                    }else{
                        [Helper alertViewWithTitle:@"撤销失败" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                } failed:^(NSError *error) {
                    
                }];
            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
            if (![self.ymData.followState intValue]) {
                [button setTitle:@"已关注" forState:(UIControlStateNormal)];
                self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
                self.ymData.followState = @1;
                _tableDataSource[indexPath.row] = self.ymData;
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
                [dic setValue:self.ymData.uId forKey:@"otherUserId"];
                [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/saveFollow.do" parameter:dic success:^(id respondsData) {
                    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([[userData objectForKey:@"success"] boolValue]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        
                    }else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        
                    }
                } failed:^(NSError *error) {
                }];
            }
        }
    }
}

#pragma mark - 赞
- (void)addLike:(NSInteger)indexPath{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *udName = [ud objectForKey:@"userName"];
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath];
    WFMessageBody *m = ymData.messageBody;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *uud = [NSUserDefaults standardUserDefaults];
    NSNumber *useID = [uud objectForKey:@"userId"];
    
    //    NSLog(@"%@",useID);
    if (useID) {
        [dic setValue:useID forKey:@"userId"];
        [dic setValue:ymData.userMoodId forKey:@"mId"];
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath inSection:0];
        
        YMTableViewCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath_1];
        //        cell.zanBtn.userInteractionEnabled = NO;
        cell.zanBtn.enabled = NO;
        
        if ([ymData.assistState isEqualToNumber:@0]) {
            [dic setValue:@1 forKey:@"type"];
            //点赞的请求
            [[PostDataRequest sharedInstance] postDataRequest:@"userAssist/change.do" parameter:dic success:^(id respondsData) {
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([[userData objectForKey:@"success"] boolValue]) {
                    NSInteger a = [ymData.assistCount integerValue] + 1;
                    [ymData setValue:[NSNumber numberWithInteger:a] forKey:@"assistCount"];
                    [ymData setValue:@1 forKey:@"assistState"];
                    
                    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath inSection:0];
                    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                    
                    YMTableViewCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath_1];
                    
                    if ([ymData.assistState intValue] == 0) {
                        [cell.zanBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
                    }else{
                        [cell.zanBtn setImage:[UIImage imageNamed:@"dz"] forState:UIControlStateNormal];
                    }
                    
                    
                    [self.mainTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }else {
                    //                    cell.zanBtn.userInteractionEnabled = YES;
                    cell.zanBtn.enabled = YES;
                }
            } failed:^(NSError *error) {
                //                cell.zanBtn.userInteractionEnabled = YES;
                cell.zanBtn.enabled = YES;
            }];
            [m.posterFavour addObject:udName];
            //            cell.zanBtn.userInteractionEnabled = YES;
            cell.zanBtn.enabled = YES;
        }else{
            [dic setValue:@0 forKey:@"type"];
            [[PostDataRequest sharedInstance] postDataRequest:@"userAssist/change.do" parameter:dic success:^(id respondsData) {
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                
                if ([[userData objectForKey:@"success"] boolValue]) {
                    NSInteger a = [ymData.assistCount integerValue] - 1;
                    [ymData setValue:[NSNumber numberWithInteger:a] forKey:@"assistCount"];
                    [ymData setValue:@0 forKey:@"assistState"];
                    
                    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath inSection:0];
                    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                    [self.mainTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }else {
                    //                    cell.zanBtn.userInteractionEnabled = YES;
                    cell.zanBtn.enabled = YES;
                }
            } failed:^(NSError *error) {
                //                cell.zanBtn.userInteractionEnabled = YES;
                cell.zanBtn.enabled = YES;
            }];
            
            [m.posterFavour removeObject:udName];
            //            cell.zanBtn.userInteractionEnabled = YES;
            cell.zanBtn.enabled = YES;
        }
    }else {
        
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
    }
    
    ymData.messageBody = m;
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:indexPath withObject:ymData];
    
    [self.mainTable reloadData];
    
}

#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender indexPath:(NSInteger)indexPath{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        //    replyView.replyTag = _selectedIndexPath.row;
        replyView.replyTag = indexPath;
        [self.view addSubview:replyView];
        
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{

            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [self.mainTable reloadData];
    
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag withLittleArray:(NSMutableArray *)littleArray{
    
    UIScrollView* scrol = (UIScrollView*)[self.view superview];
    scrol.scrollEnabled = NO;
    
    
    JKSlideViewController *jks = self.navc.viewControllers[0];
    [UIApplication sharedApplication].windows[0].backgroundColor = [UIColor blackColor];
    jks.leftBtn.hidden = YES;
    jks.rightBtn.hidden = YES;
    jks.slideSwitchView.topView.hidden = YES;
    jks.slideSwitchView.backgroundColor = [UIColor blackColor];
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews withLittleArray:littleArray];
    
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
            JKSlideViewController *jks = self.navc.viewControllers[0];
            [UIApplication sharedApplication].windows[0].backgroundColor = [UIColor blackColor];
            jks.leftBtn.hidden = NO;
            jks.rightBtn.hidden = NO;
            jks.slideSwitchView.topView.hidden = NO;
            
        } completion:^(BOOL finished) {
            
            scrol.scrollEnabled = YES;
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
}

#pragma mark -- 点击图片－播放视频
- (void)playWithStopVideoURL:(NSString *)videoURL{
    NSLog(@"%@", videoURL);
    VedioPlayViewController *vedioPlay = [[VedioPlayViewController alloc]initWithNibName:@"VedioPlayViewController" bundle:nil];
    vedioPlay.delegate = self;
    vedioPlay.vedioURL = videoURL;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vedioPlay];
    navigation.navigationBarHidden = YES;
//    navigation.delegate = self;
    [self presentViewController:navigation animated:YES completion:nil];
}
#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *udName = [ud objectForKey:@"userName"];
        //        NSNumber *udId = [ud objectForKey:@"userId"];
        
        _replyIndex = replyIndex;
        _clickIndex = index;
        _replyUserIndex = replyIndex;
        
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
        WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
        
        NSMutableDictionary *delectDic = [[NSMutableDictionary alloc] init];
        [delectDic setValue:ymData.userMoodId forKey:@"mId"];
        [delectDic setValue:[ymData.messageBody.posterReplies[replyIndex] userCommentId] forKey:@"userCommentId"];
        
        
        if ([b.replyUser isEqualToString:udName]) {
            [Helper alertViewWithTitle:@"是否删除评论?" withBlockCancle:^{
                
            } withBlockSure:^{
                
                [[PostDataRequest sharedInstance] postDataRequest:@"userComment/remove.do" parameter:delectDic success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([[dict objectForKey:@"success"]boolValue]) {
                        
                        NSInteger a = [[_tableDataSource[index] commentCount] integerValue] - 1;
                        [_tableDataSource[index] setValue:[NSNumber numberWithInteger:a] forKey:@"commentCount"];
                        
                        [self.mainTable reloadData];
                        
                        
                        [Helper alertViewNoHaveCancleWithTitle:@"删除成功!" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                        
                        //delete
                        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
                        WFMessageBody *m = ymData.messageBody;
                        [m.posterReplies removeObjectAtIndex:_replyIndex];
                        ymData.messageBody = m;
                        [ymData.completionReplySource removeAllObjects];
                        [ymData.attributedDataReply removeAllObjects];
                        
                        
                        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                        [_tableDataSource replaceObjectAtIndex:index withObject:ymData];
                        [self.mainTable reloadData];
                        
                        
                    }else{
                        [Helper alertViewWithTitle:@"当前网络状况不佳,删除失败!" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                    
                    _replyIndex = -1;
                    
                    
                } failed:^(NSError *error) {
                }];
            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
            
        }else{
            //回复
            if (replyView) {
                return;
            }
            replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, screenWidth,44) andAboveView:self.view];
            replyView.delegate = self;
            replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
            replyView.replyTag = index;
            [self.view addSubview:replyView];
        }
        
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{

            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
            };
            [self.navc pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *udName = [ud objectForKey:@"userName"];
    NSNumber *udId = [ud objectForKey:@"userId"];
    __block YMTextData *ymData = nil;
    //-1的时候是直接添加回复，否则就是二级回复
    
    
    if (_replyIndex == -1) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[_tableDataSource[inputTag] userMoodId] forKey:@"mId"];
        [dict setObject:replyText forKey:@"commentContent"];
        [dict setObject:udId forKey:@"uId"];
        [dict setObject:udName forKey:@"userName"];
        
        //直接回复用户，replyUid传0
        
        [[PostDataRequest sharedInstance] postDataRequest:@"userComment/saveNew.do" parameter:dict success:^(id respondsData) {
            NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dataDic objectForKey:@"success"] integerValue] == 1) {
                
                
                
                //              NSLog(@"%@",dataDic);
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUser = udName;
                body.repliedUser = @"";
                body.replyInfo = replyText;
                body.userCommentId = [[dataDic objectForKey:@"rows"] objectForKey:@"userCommentId"];
                
                
                ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
                WFMessageBody *m = ymData.messageBody;
                [m.posterReplies addObject:body];
                ymData.messageBody = m;
                
                //清空属性数组。否则会重复添加
                [ymData.completionReplySource removeAllObjects];
                [ymData.attributedDataReply removeAllObjects];
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
                
                NSInteger a = [[_tableDataSource[inputTag] commentCount] integerValue] + 1;
                [_tableDataSource[inputTag] setValue:[NSNumber numberWithInteger:a] forKey:@"commentCount"];
                
                [self.mainTable reloadData];

                
            }else{
                [Helper alertViewNoHaveCancleWithTitle:@"发布评论失败" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        } failed:^(NSError *error) {
            //            NSLog(@"%@",[dict objectForKey:@"message"]);
        }];
    }else{
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_clickIndex];
        WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:_replyIndex];
        
        WFMessageBody *m = ymData.messageBody;
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[_tableDataSource[inputTag] userMoodId] forKey:@"mId"];
        [dict setObject:replyText forKey:@"commentContent"];
        [dict setObject:udId forKey:@"uId"];
        [dict setObject:udName forKey:@"userName"];
        //        [dict setObject:b.replyId forKey:@"replyUid"];
        [dict setObject:b.otherUid forKey:@"replyUid"];
        //        NSLog(@"%@",b.replyId);
        [dict setObject:b.replyUser forKey:@"replyUserName"];
        [[PostDataRequest sharedInstance] postDataRequest:@"userComment/saveNew.do" parameter:dict success:^(id respondsData) {
            NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            
            if ([[dataDic objectForKey:@"success"] integerValue] == 1) {
                
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUser = udName;
                body.repliedUser = b.replyUser;
                body.replyInfo = replyText;
                body.userCommentId = [[dataDic objectForKey:@"rows"] objectForKey:@"userCommentId"];
                
                
                [m.posterReplies addObject:body];
                ymData.messageBody = m;
                
                //清空属性数组。否则会重复添加
                [ymData.completionReplySource removeAllObjects];
                [ymData.attributedDataReply removeAllObjects];
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
                
                NSInteger a = [[_tableDataSource[inputTag] commentCount] integerValue] + 1;
                [_tableDataSource[inputTag] setValue:[NSNumber numberWithInteger:a] forKey:@"commentCount"];
                
                [self.mainTable reloadData];
                
                //                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:inputTag inSection:0];
                //                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                //                [mainTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } failed:^(NSError *error) {
        }];
    }
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
}


- (void)dealloc{
    
    //    NSLog(@"销毁");
    
}

-(void)shareInfo:(NSInteger)index cellIndex:(NSInteger)indexRow{
    
    NSData *fiData = [[NSData alloc]init];
    
    if (self.ymData.pics.count == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper imageUrl:self.ymData.uPic]];
    }else{
        fiData = [NSData dataWithContentsOfURL:[Helper imageUrl:self.ymData.pics[0]]];
    }
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/mood/Topic_details.html?id=%@",self.ymData.userMoodId];
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"来自%@的话题",self.ymData.userName];
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"来自%@的话题:%@ %@",self.ymData.userName,self.ymData.moodContent,shareUrl]  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [self shareS:indexRow];
            }
        }];
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"来自%@的话题:%@ %@",self.ymData.userName,self.ymData.moodContent,shareUrl] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        //        [self shareS:indexRow];
        
        self.mainTable.frame = CGRectMake(0, 64, ScreenWidth, screenHeight - 64 - 49);
        
    }
    
}

#pragma mark -- 结束播放回调
- (void)closeVideo{
    //处理TableView偏移问题
    self.mainTable.frame = CGRectMake(0, 64, self.view.frame.size.width,ScreenHeight - 115);
}

@end
