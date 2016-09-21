//
//  JGTeamGroupViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamGroupViewController.h"
#import "JGTeamGroupCollectionViewCell.h"
#import "JGMenberTableViewCell.h"
#import "JGGroupdetailsCollectionViewCell.h"
#import "JGHTeamMembersViewController.h"
#import "JGHPlayersModel.h"
#import "JGTeamActibityNameViewController.h"

static NSString *const JGTeamGroupCollectionViewCellIdentifier = @"JGTeamGroupCollectionViewCell";
static NSString *const JGGroupdetailsCollectionViewCellIdentifier = @"JGGroupdetailsCollectionViewCell";

@interface JGTeamGroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JGGroupdetailsCollectionViewCellDelegate, JGHTeamMembersViewControllerDelegate, UIScrollViewDelegate>
{
    NSInteger _collectionHegith;
    
    NSInteger _groupDetailsCollectionViewCount;//cell的个数,默认0
    
    NSString *_power;//权限判断
    
    NSInteger _maxGroup;//当前分组数。。默认4
    
    UILabel *_waitGroupLabel;//待分组
    
    NSInteger _addGroup;//添加分组后页面下滑标志
    
    NSInteger _deleGroup;//判断是否存在可删除成员
}

@property (nonatomic, weak) UICollectionView *collectionView;//上列表

@property (nonatomic, strong) UICollectionView *groupDetailsCollectionView;//下列表

@property (nonatomic, strong)NSMutableArray *teamGroupAllDataArray;//未分组数据

@property (nonatomic, strong)NSMutableArray *alreadyDataArray;//已分组数据

@property (nonatomic, assign)NSInteger newTeamKey;

@property (nonatomic, strong)UIView *collectionHeaderView;//collectionHeaderView

@property (nonatomic, copy)NSString *teamName;
@property (nonatomic, copy)NSString *activityName;

@end

@implementation JGTeamGroupViewController

- (UIView *)collectionHeaderView{
    if (_collectionHeaderView == nil) {
        self.collectionHeaderView = [[UIView alloc]init];
    }
    return _collectionHeaderView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"活动分组";
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fenxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareBtn)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
    self.teamGroupAllDataArray = [NSMutableArray array];
    self.alreadyDataArray = [NSMutableArray array];
     _groupDetailsCollectionViewCount = 0;
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.view addSubview:view];
    //待分组label
   UILabel *linelable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 10*ProportionAdapter, 30)];
    linelable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linelable];
    
    _waitGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10, screenWidth, 30)];
    _waitGroupLabel.text = @"待分组";
    _waitGroupLabel.backgroundColor = [UIColor whiteColor];
    _waitGroupLabel.textAlignment = NSTextAlignmentLeft;
    _waitGroupLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_waitGroupLabel];
    
    //添加分组
    UIButton *autoGroupBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 100 *ProportionAdapter, 14.5 *ProportionAdapter, 80 *ProportionAdapter, 21 *ProportionAdapter)];
    [autoGroupBtn setTitle:@"按差点分组" forState:UIControlStateNormal];
    autoGroupBtn.layer.masksToBounds = YES;
    [autoGroupBtn setTitleColor:[UIColor colorWithHexString:@"#7DDFFD"] forState:UIControlStateNormal];
    autoGroupBtn.backgroundColor = [UIColor colorWithHexString:BG_color];
    autoGroupBtn.layer.borderWidth = 1.0;
    autoGroupBtn.layer.borderColor = [UIColor colorWithHexString:@"#7DDFFD"].CGColor;
    autoGroupBtn.titleLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    [autoGroupBtn addTarget:self action:@selector(autoGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [autoGroupBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:autoGroupBtn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, screenWidth - 20, 1)];
    lineLabel.backgroundColor = [UIColor redColor];
    [_waitGroupLabel addSubview:lineLabel];
    
    _maxGroup = 4;

    if (iPhone5) {
        _collectionHegith = 200;
    }else{
        _collectionHegith = screenHeight/3-20;
    }
    
    //设置头视图的大小
//    self.collectionHeaderView.backgroundColor = [UIColor colorWithHexString:BG_color];
//    self.collectionHeaderView.frame = CGRectMake(0, 0, screenWidth, _collectionHegith + 12 + 21 + 21);
    //列表
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, screenWidth, _collectionHegith)
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"JGTeamGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:JGTeamGroupCollectionViewCellIdentifier];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    //提示语
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, collectionView.frame.size.height+_waitGroupLabel.frame.size.height+20, screenWidth, 12)];
    promptLabel.text = @"提示:点击任意“待添加”，实现自动分组";
    promptLabel.textColor = [UIColor colorWithHexString:Prompt_Color];
    promptLabel.backgroundColor = [UIColor colorWithHexString:BG_color];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    [self.view addSubview:promptLabel];
    //好友分组label
    UILabel *groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, self.collectionView.frame.size.height+_waitGroupLabel.frame.size.height+30 + 10, screenWidth-90, 21)];
    groupLabel.text = @"好友分组";
    groupLabel.backgroundColor = [UIColor colorWithHexString:BG_color];
    groupLabel.textAlignment = NSTextAlignmentLeft;
    groupLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:groupLabel];
    //添加分组
    UIButton *addGroupBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 80 *ProportionAdapter, self.collectionView.frame.size.height+_waitGroupLabel.frame.size.height+30+10, 60 *ProportionAdapter, 21 *ProportionAdapter)];
    [addGroupBtn setTitle:@"添加分组" forState:UIControlStateNormal];
    addGroupBtn.layer.masksToBounds = YES;
    [addGroupBtn setTitleColor:[UIColor colorWithHexString:@"#7DDFFD"] forState:UIControlStateNormal];
    addGroupBtn.backgroundColor = [UIColor colorWithHexString:BG_color];
    addGroupBtn.layer.borderWidth = 1.0;
    addGroupBtn.layer.borderColor = [UIColor colorWithHexString:@"#7DDFFD"].CGColor;
    addGroupBtn.titleLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    [addGroupBtn addTarget:self action:@selector(addGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addGroupBtn];
    
    //4方格
    UICollectionViewFlowLayout *gridlayout = [UICollectionViewFlowLayout new];
    gridlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.groupDetailsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, groupLabel.frame.origin.y + groupLabel.frame.size.height + 10, screenWidth, screenHeight - groupLabel.frame.size.height-groupLabel.frame.origin.y - 64) collectionViewLayout:gridlayout];
    self.groupDetailsCollectionView.backgroundColor = [UIColor whiteColor];
    self.groupDetailsCollectionView.dataSource = self;
    self.groupDetailsCollectionView.delegate = self;
    [self.groupDetailsCollectionView registerNib:[UINib nibWithNibName:@"JGGroupdetailsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:JGGroupdetailsCollectionViewCellIdentifier];
    [self.view addSubview:self.groupDetailsCollectionView];
    
    [self loadData:0];
}
#pragma mark -- 自动分组
- (void)autoGroupBtnClick:(UIButton *)btn{
    btn.enabled = NO;
    [[ShowHUD showHUD]showAnimationWithText:@"分组中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_teamActivityKey) forKey:@"activity"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/automaticGroup" JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [[ShowHUD showHUD]showToastWithText:@"分组失败" FromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue]==1) {
            [self loadData:1];
        }else{
            [[ShowHUD showHUD]showToastWithText:@"分组失败" FromView:self.view];
        }
    }];
    
    btn.enabled = YES;
}
#pragma mark -- 返回事件
- (void)backButtonClcik:(UIButton *)btn{
    if (_activityFrom == 1) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JGTeamActibityNameViewController class]]) {
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -- 分享
- (void)shareBtn{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    
    [self.view addSubview:alert];
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData = [[NSData alloc]init];
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_teamActivityKey andIsSetWidth:YES andIsBackGround:YES]];
    
    
    NSString* strMd = [JGReturnMD5Str getTeamGroupNameListTeamKey:0 activityKey:_teamActivityKey userKey:[DEFAULF_USERID integerValue]];
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/group.html?teamKey=0&activityKey=%td&userKey=%td&share=1&md5=%@", _teamActivityKey, [DEFAULF_USERID integerValue],strMd];
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@分组表",self.activityName];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"【%@】%@分组表", self.teamName,self.activityName]  image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@球队%@活动的分组表", self.teamName,self.activityName] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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


#pragma mark -- 添加分组
- (void)addGroupBtnClick:(UIButton *)btn{
    [[ShowHUD showHUD]showAnimationWithText:@"" FromView:self.view];
    _maxGroup += 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%td", _maxGroup] forKey:@"maxGroup"];
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamActivityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivityMaxGroup" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 0) {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }else{
            [[ShowHUD showHUD]showToastWithText:@"分组添加成功！" FromView:self.view];
            _addGroup = 1;
        }
        
        [self loadData:0];//刷新页面
    }];
}
#pragma mark -- 获取报名人员列表信息 1－表示分组
- (void)loadData:(NSInteger)fenzu{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamActivityKey] forKey:@"activityKey"];
    [dict setObject:@0 forKey:@"teamKey"];
    
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:_teamActivityKey userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        
        self.teamName = [data objectForKey:@"teamName"];
        self.activityName = [data objectForKey:@"activityName"];
        
        [self.alreadyDataArray removeAllObjects];
        [self.teamGroupAllDataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _power = [[data objectForKey:@"member"] objectForKey:@"power"];
            _maxGroup = [[data objectForKey:@"maxGroup"] integerValue];//获取分组数
        }else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            
            return ;
        }
        
        NSArray *dataArray = [data objectForKey:@"teamSignUpList"];
        _groupDetailsCollectionViewCount = [dataArray count];
        for (NSDictionary *dict in dataArray) {
            JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            if (model.groupIndex == -1) {
                //为分组
                [self.teamGroupAllDataArray addObject:model];
            }else{
                //已经分组
                [self.alreadyDataArray addObject:model];
            }
        }
        
        _waitGroupLabel.text = [NSString stringWithFormat:@"待分组:%ld(人)", (unsigned long)[self.teamGroupAllDataArray count]];
        
        if (fenzu == 1) {
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"已分组成功!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        if (_addGroup == 1) {
            [self.groupDetailsCollectionView setContentOffset:CGPointMake(0,(screenWidth/2)*(int)((_maxGroup-1)/2)) animated:YES];
            _addGroup = 0;
        }
        
        if (_deleGroup == 1) {
            _deleGroup = 0;
            [[ShowHUD showHUD]showToastWithText:@"删除成功！" FromView:self.view];
        }
        
        [self.collectionView reloadData];
        [self.groupDetailsCollectionView reloadData];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        return CGSizeMake((screenWidth - 50)/5, (_collectionHegith - 20)/2);
    }else{
        return CGSizeMake(screenWidth/2 - 10, screenWidth/2 - 10);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.collectionView]) {
        return _teamGroupAllDataArray.count;
    }else{
        return _maxGroup;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.collectionView]) {
        JGTeamGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGTeamGroupCollectionViewCellIdentifier forIndexPath:indexPath];
        JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
        model = self.teamGroupAllDataArray[indexPath.item];
        [cell configJGHPlayersModel:model];
        return cell;
    }else{
        JGGroupdetailsCollectionViewCell *groupCell = [collectionView dequeueReusableCellWithReuseIdentifier:JGGroupdetailsCollectionViewCellIdentifier forIndexPath:indexPath];
        groupCell.delegate = self; 
        groupCell.tag = indexPath.item;
        [groupCell configGroupName:@"dd"];
        if (_alreadyDataArray.count !=0) {
            [groupCell configCellWithModelArray:_alreadyDataArray];
        }
        
        return groupCell;
    }
}
#pragma mark --这个方法是返回 Header的大小 size
/**
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(screenWidth, _collectionHegith);
}

#pragma mark --这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JGPhotoTimeReusableView" forIndexPath:indexPath];
//        NSString *title = [[NSString alloc] initWithFormat:@"Recipe Group #%i",indexPath.section +1];
//        
//        headerView.title.text = title;
//        
//        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
//        
//        headerView.backgroundImage.image = headerImage;
        
//        reusableView = _collectionHeaderView;
        
    }
    
    
    return headerView;
    
//    NSString *CellIdentifier = @"header";
    //从缓存中获取 Headercell
//    _collectionHeaderView *self = (_collectionHeaderView *)[[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    return cell;
}
 */
#pragma mark -- 点击头像图片的代理方法JGGroupdetailsCollectionViewCellDelegate
- (void)didSelectHeaderImage:(UIButton *)btn JGGroupCell:(JGGroupdetailsCollectionViewCell *)cell{

    if ([_power containsString:@"1001"]) {
        //管理员 -- 进入球队列表页码
        JGHTeamMembersViewController *teamMemberCtrl = [[JGHTeamMembersViewController alloc]init];
        NSMutableArray *listArray = [NSMutableArray arrayWithArray:self.alreadyDataArray];
        [listArray addObjectsFromArray:self.teamGroupAllDataArray];
        teamMemberCtrl.teamGroupAllDataArray = listArray;
        teamMemberCtrl.delegate = self;
        //组号
        teamMemberCtrl.groupIndex = cell.tag;
        //排序索引
        teamMemberCtrl.sortIndex = btn.tag;
        // 老的球队活动报名人timeKey
        //获取老球员
        for (JGHPlayersModel *model in self.alreadyDataArray) {
            NSLog(@"%ld", (long)cell.tag);
            NSLog(@"%ld", (long)model.groupIndex);
            if (model.groupIndex == cell.tag) {
                if (model.sortIndex == btn.tag) {
                    teamMemberCtrl.oldSignUpKey = model.timeKey;//29242 29248
                    break;
                }
            }else{
                teamMemberCtrl.oldSignUpKey = -1;
            }    
        }
        
        [self.navigationController pushViewController:teamMemberCtrl animated:YES];
    }else{

        for (JGHPlayersModel *model in self.alreadyDataArray) {
            if (model.groupIndex == cell.tag) {
                if (model.sortIndex == btn.tag) {
                    [Helper alertViewNoHaveCancleWithTitle:@"该分组已被分组，如有疑问，请联系管理员！" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                    
                    return;
                }
            }
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (JGHPlayersModel *model in self.teamGroupAllDataArray) {
                if (model.userKey == [[userdef objectForKey:userID] integerValue]) {
                    [dict setObject:[NSString stringWithFormat:@"%td", model.timeKey] forKey:@"newSignUpKey"]; // 新的球队活动报名人timeKey
                }
            }
            
            [dict setObject:@-1 forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
            
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)cell.tag] forKey:@"groupIndex"]; // 组号
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)btn.tag] forKey:@"sortIndex"]; // 排序索引
            [self updateTeamActivityGroupIndex:dict];
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"是否加入该组！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark -- 长按头像删除分组
- (void)handleLongPressWithBtnTag:(NSInteger)tag JGGroupCell:(JGGroupdetailsCollectionViewCell *)cell{
    for (JGHPlayersModel *model in self.alreadyDataArray) {
        if (model.groupIndex == cell.tag) {
            if (model.sortIndex == tag) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@-1 forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
                [dict setObject:[NSString stringWithFormat:@"%td", model.timeKey] forKey:@"newSignUpKey"]; // 新的球队活动报名人timeKey
                [dict setObject:[NSString stringWithFormat:@"%td", cell.tag] forKey:@"groupIndex"]; // 组号
                [dict setObject:[NSString stringWithFormat:@"%td", tag] forKey:@"sortIndex"]; // 排序索引
                _deleGroup = 1;
                [self updateTeamActivityGroupIndex:dict];
            }
        }
    }
    
    if (_deleGroup != 1) {
        [self deleteGroupClick];
    }
}
#pragma mark -- 无可删除的成员
- (void)deleteGroupClick{
    _deleGroup = 0;
    [[ShowHUD showHUD]showToastWithText:@"该分组无可删除的成员！" FromView:self.view];
}
#pragma mark -- 更新组
- (void)updateTeamActivityGroupIndex:(NSMutableDictionary *)dict{
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivityGroupIndex" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errtype === %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data === %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            // 重新加载数据
            [self loadData:1];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 管理员替换队员与分配队员代理
- (void)didSelectMembers:(NSMutableDictionary *)dict{
    [self updateTeamActivityGroupIndex:dict];
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
