//
//  AllianceVipViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "AllianceVipViewController.h"
#import "AddVipCardViewController.h"

#import "VipCardHeaderCollectionReusableView.h"
#import "VipCardCollectionViewCell.h"
#import "VipCardModel.h"

#import "CardHistoryTableViewCell.h"
#import "CardHIstoryModel.h"
#import "UseMallViewController.h"
#import "VipCardGoodsListViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
@interface AllianceVipViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>
//背景界面
@property(nonatomic,strong)UIScrollView *baseScrollView;
//有效会员卡数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
//无效的卡片个数
@property(nonatomic,strong)NSMutableArray *noCanUseArray;
//会员卡界面
@property(nonatomic,strong)UIView *vipCardView;
//使用历史记录界面
@property(nonatomic,strong)UIView *historyView;
//列表界面
@property(nonatomic,strong)UICollectionView *mainCollectionView;
//使用记录数据源
@property(nonatomic,strong)NSMutableArray *listArray;
//使用记录
@property(nonatomic,strong)UITableView *mainTableView;
//卡片列表页数
@property(nonatomic,assign)NSInteger cardPage;
//使用记录列表页面
@property(nonatomic,assign)NSInteger historyPage;
//用户未添加的卡片数
@property(nonatomic,assign)NSInteger unAddCardNum;

@end

@implementation AllianceVipViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
-(NSMutableArray *)noCanUseArray{
    if (!_noCanUseArray) {
        _noCanUseArray = [NSMutableArray array];
    }
    return _noCanUseArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏上下导航电池栏
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_wbg"] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建刷新
    [self createHistoryRefresh];
}

#pragma mark - CreateView
-(void)createView{
    self.view.backgroundColor = RGBA(238, 238, 238, 1);
    //创建上导航
    [self createNavi];
    //底部scrollview
    [self createBaseView];
    //会员卡界面
    [self createColletionView];
    //使用记录界面
    [self createHistoryView];
}
//自定义上导航
-(void)createNavi{
    //消除阴影线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //左按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@")-2"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    backBtn.tintColor = [UIColor colorWithHexString:Bar_Segment];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //右按钮
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_allianceAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick)];
    addBtn.tintColor = [UIColor colorWithHexString:Bar_Segment];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    //选择
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"会员卡",@"使用记录",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(screenWidth/2 - kWvertical(60), kHvertical(25), kWvertical(120), kHvertical(25));
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor colorWithHexString:Bar_Color];
    //有基本四种样式
    self.navigationItem.titleView = segmentedControl;
}
//滚动背景界面
-(void)createBaseView{
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    self.baseScrollView.contentSize = CGSizeMake(screenWidth*2, screenHeight-64);
    self.baseScrollView.scrollEnabled = FALSE;
    self.baseScrollView.showsVerticalScrollIndicator = FALSE;
    [self.view addSubview:self.baseScrollView];
    //会员卡界面
    _vipCardView = [Factory createViewWithBackgroundColor:RGBA(238, 238, 238, 1) frame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    //使用记录界面
    _historyView = [Factory createViewWithBackgroundColor:RGBA(238, 238, 238, 1) frame:CGRectMake(screenWidth, 0, screenWidth, screenHeight - 64)];
    
    _vipCardView.userInteractionEnabled = YES;
    _historyView.userInteractionEnabled = YES;
    
    [_baseScrollView addSubview:_vipCardView];
    [_baseScrollView addSubview:_historyView];
}
//会员卡界面
-(void)createColletionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =CGSizeMake(screenWidth, kHvertical(214));
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _mainCollectionView.backgroundColor = RGBA(238, 238, 238, 1);
    [_mainCollectionView registerClass:[VipCardCollectionViewCell class] forCellWithReuseIdentifier:@"VipCardCollectionViewCellId"];
    [_mainCollectionView registerClass:[VipCardHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipCardCollectionViewHeaderId"];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    [self createCardRefresh];
}

//使用记录
-(void)createHistoryView{
    _mainTableView = [[UITableView alloc] init];
    _mainTableView.frame = CGRectMake(0, 0, screenWidth, _historyView.height);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerClass:[CardHistoryTableViewCell class] forCellReuseIdentifier:@"CardHistoryTableViewCell"];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_historyView addSubview:_mainTableView];
}

#pragma mark - LoadData
//viewWillAppre调用
-(void)initViewWillApperData{
    _cardPage = 0;
    [self loadCardListData];
}

//获取卡片列表数据
-(void)loadCardListData{
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_cardPage];
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]];
    
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"off":page,
                           @"md5":md5Value,
                           };
    [[JsonHttp jsonHttp] httpRequest:@"league/getUserCardList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (![self.vipCardView.subviews containsObject:_mainCollectionView]) {
            [self.vipCardView addSubview:_mainCollectionView];
        }
        [self cardEndRefresh];
    } completionBlock:^(id data) {
        BOOL Success = [[data objectForKey:@"packSuccess"] boolValue];
        if (Success) {
            _unAddCardNum = [[data objectForKey:@"canBuildNumber"] integerValue];
            if (_cardPage == 0) {
                self.dataArray = [NSMutableArray array];
                self.noCanUseArray = [NSMutableArray array];
            }
            NSArray *listArray = [data objectForKey:@"canCardList"];
            NSArray *noCanCardListArray = [data objectForKey:@"noCanCardList"];
            for (NSDictionary *listDict in listArray) {
                VipCardModel *model = [[VipCardModel alloc] init];
                model.imagePicUrl = [listDict objectForKey:@"bigPicURL"];
                model.cardState = 1;
                model.cardId = [listDict objectForKey:@"timeKey"];
                [self.dataArray addObject:model];
            }
            
            for (NSDictionary *listDict in noCanCardListArray) {
                VipCardModel *model = [[VipCardModel alloc] init];
                model.imagePicUrl = [listDict objectForKey:@"bigPicURL"];
                model.cardState = 0;
                model.cardStr = [listDict objectForKey:@"stateString"];
                model.cardId = [listDict objectForKey:@"timeKey"];
                [self.noCanUseArray addObject:model];
            }
        }
        if (![self.vipCardView.subviews containsObject:_mainCollectionView]) {
            [self.vipCardView addSubview:_mainCollectionView];
        }
        [_mainCollectionView reloadData];
        
        [self cardEndRefresh];
    }];
}
//添加已有数据获取
-(void)addUnaddCard{
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           };
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"league/doFastBuildUserCard" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL parkSucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (parkSucess) {
            [self loadCardListData];
        }
    }];
}

//使用记录数据
-(void)loadHistoryData{
    
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_historyPage];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"md5":md5Value,
                           @"off":page
                           };
    [[JsonHttp jsonHttp]httpRequest:@"league/getUserCardUsedLogList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self historyEndRefresh];
    } completionBlock:^(id data) {
        NSLog(@"%@",data);
        BOOL sucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (sucess) {
            NSArray *listArray = [data objectForKey:@"logList"];
            if (_historyPage==0) {
                self.listArray= [NSMutableArray array];
            }
            for (NSDictionary *dict in listArray) {
                CardHIstoryModel *model = [[CardHIstoryModel alloc] init];
                //使用时间
                NSString *usedDate = [dict objectForKey:@"usedDate"];
                usedDate = [self dataFormat:usedDate];
                //小图片
                NSString *smallPicURL = [dict objectForKey:@"smallPicURL"];
                //球场名
                NSString *ballName = [dict objectForKey:@"ballName"];
                
                model.timeStr = usedDate;
                model.picUrl = smallPicURL;
                model.parkStr = ballName;
                [self.listArray addObject:model];
            }
            [self.mainTableView reloadData];
        }
        [self historyEndRefresh];
        
    }];
    
}

#pragma mark - Action
//返回点击
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//加号点击
-(void)addBtnClick{
    AddVipCardViewController *vc = [[AddVipCardViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
//选择器改变
-(void)segmentAction:(UISegmentedControl *)segment{
    NSInteger selectIndex = segment.selectedSegmentIndex;
    switch (selectIndex) {
        case 0:{
            self.baseScrollView.contentOffset = CGPointMake( 0, 0);
        }break;
        case 1:{
            self.baseScrollView.contentOffset = CGPointMake( screenWidth, 0);
        }break;
        default:
            break;
    }
}
//立即添加按钮点击
-(void)addNowBtnClick{
    //获取被添加数据
    [self addUnaddCard];
}
//跳转至联盟卡商城
-(void)clickToGoodsList{
    VipCardGoodsListViewController *vc = [[VipCardGoodsListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MJRefresh
//卡片列表刷新
-(void)createCardRefresh{
    _mainCollectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(collectionHeaderRefreshing)];
}
//历史记录刷新
-(void)createHistoryRefresh{
    _mainTableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerHeaderRefreshing)];
    _mainTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(headerFooterRefreshing)];
    [_mainTableView.mj_header beginRefreshing];
    
}

//卡片下拉刷新
-(void)collectionHeaderRefreshing{
    _cardPage = 0;
    [self loadCardListData];
}
//卡片上拉加载
-(void)collectionFooterRefreshing{
    _cardPage ++ ;
    [self loadCardListData];
}
//卡片结束刷新
-(void)cardEndRefresh{
    if (_cardPage==0) {
        [_mainCollectionView.mj_header endRefreshing];
    }else{
        [_mainCollectionView.mj_footer endRefreshing];
    }
}

//打球记录下拉刷新
-(void)headerHeaderRefreshing{
    _historyPage = 0;
    [self loadHistoryData];
}
//打球记录上拉加载
-(void)headerFooterRefreshing{
    _historyPage ++ ;
    [self loadHistoryData];
}
//记录结束刷新
-(void)historyEndRefresh{
    if (_historyPage==0) {
        [_mainTableView.mj_header endRefreshing];
    }else{
        [_mainTableView.mj_footer endRefreshing];
    }
    
}


#pragma mark - UICollectionViewDelegate
//section个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger add = 0;
    if (self.unAddCardNum>0) {
        add = 1;
    }
    if (self.noCanUseArray.count>0) {
        return 2+add;
    }
    return 1+add;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return self.dataArray.count;
    } else if (section == 1){
        return self.noCanUseArray.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VipCardCollectionViewCell *cell = (VipCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VipCardCollectionViewCellId" forIndexPath:indexPath];
    
    //配置cell
    if (indexPath.section==0) {
        [cell configModel:self.dataArray[indexPath.item]];
    }else{
        [cell configModel:self.noCanUseArray[indexPath.item]];
    }
    
    
    
    return cell;
}

//上下行cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


// 设置section头视图的参考大小，
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSInteger totalCardNum = self.dataArray.count + self.noCanUseArray.count;
    if (totalCardNum == 0) {
        return CGSizeMake(screenWidth, screenHeight);
    }
    if (_unAddCardNum>0) {
        if (self.noCanUseArray.count==0&&section==1){
            return CGSizeMake(screenWidth, kHvertical(200));
        }else if (section==2){
            return CGSizeMake(screenWidth, kHvertical(200));
        }
    }
    if (section == 1) {
        return CGSizeMake(screenWidth, kHvertical(80));
    }
    return CGSizeMake(0, 0);
}
// 设置collectionView的头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    VipCardHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipCardCollectionViewHeaderId"forIndexPath:indexPath];
    headView.userInteractionEnabled = TRUE;
    headView.alertImageView.hidden = TRUE;
    headView.descLabel.hidden = TRUE;
    headView.addNowBtn.hidden = TRUE;
    headView.line.hidden = TRUE;
    headView.nocanDescLabel.hidden = TRUE;
    headView.goodsListButton.hidden = TRUE;
    NSInteger totalCardNum = self.dataArray.count + self.noCanUseArray.count;
    
    //没有未添加卡片文字描述
    NSString *noneCard = @"您还未添加任何君高高尔夫联盟会员卡，点击右上角『+』，添加您的联盟会员卡。添加会员卡后，就能在APP中享受联盟会员价预订球场的权益。";
    //用户手机号上有未添加的卡片
    NSString *unAddCardNum = [NSString stringWithFormat:@"%ld",(long)_unAddCardNum];
    NSString *mobile = [UserDefaults objectForKey:@"mobile"];
    NSString *haveCard = [NSString stringWithFormat:@"您的手机号%@下有 %@ 张联盟卡可绑定。绑定后可通过君高高尔夫APP，以联盟价预订联盟球场，并可随时查看联盟卡使用情况。被绑定的联盟卡可随时解绑。",mobile,unAddCardNum];
    
    if (indexPath.section==0&&totalCardNum==0) {
        headView.goodsListButton.hidden = FALSE;
        //没卡提示图片
        headView.alertImageView.hidden = FALSE;
        headView.descLabel.hidden = FALSE;
        headView.descLabel.text = noneCard;
        
        if (_unAddCardNum>0) {
            headView.alertImageView.hidden = TRUE;
            headView.descLabel.y = kHvertical(105);
            headView.descLabel.text = haveCard;
            unAddCardNum = @"11";
            headView.descLabel = [self AttributedStringLabel:headView.descLabel rang:NSMakeRange(5, 11) changeColor:[UIColor colorWithHexString:Bar_Segment] rang:NSMakeRange(18, unAddCardNum.length+1) changeColor:BlackColor];
            //立即添加按钮
            headView.addNowBtn.hidden = FALSE;
            [headView.addNowBtn addTarget:self action:@selector(addNowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        [headView.descLabel changeLineWithSpace:5.0f];
        
    }else if(indexPath.section == 1){
        headView.line.hidden = FALSE;
        headView.nocanDescLabel.hidden = FALSE;
    }
    if (indexPath.section==_mainCollectionView.numberOfSections-1&&_unAddCardNum>0) {
        headView.alertImageView.hidden = TRUE;
        headView.descLabel.hidden = FALSE;
        headView.goodsListButton.hidden = FALSE;
        haveCard = [NSString stringWithFormat:@"%@ 立即绑定",haveCard];
        headView.descLabel.y = kHvertical(0);
        headView.descLabel.text = haveCard;
        headView.descLabel = [self AttributedStringLabel:headView.descLabel rang:NSMakeRange(5, 11) changeColor:[UIColor colorWithHexString:Bar_Segment] rang:NSMakeRange(18, unAddCardNum.length+1) changeColor:BlackColor];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithAttributedString:headView.descLabel.attributedText];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(0,134,73) range:NSMakeRange(AttributedStr.length-4, 4)];
        headView.descLabel.attributedText = AttributedStr;
        
        headView.descLabel.enabledTapEffect = NO;
        [headView.descLabel yb_addAttributeTapActionWithStrings:@[@"立即绑定"] tapClicked:^(NSString *string, NSRange range,NSInteger index) {
            
        }];
        
        [headView.descLabel sizeToFit];
        headView.goodsListButton.y = headView.descLabel.y_height+kHvertical(55);
    }
    [headView.goodsListButton addTarget:self action:@selector(clickToGoodsList) forControlEvents:UIControlEventTouchUpInside];
    
    
    return headView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选中位置
    NSInteger index = indexPath.item;
    VipCardModel *model = [[VipCardModel alloc] init];
    //判定卡片是否有效
    if (indexPath.section==0) {
        model = _dataArray[index];
    }else{
        model = _noCanUseArray[index];
    }
    
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"cardKey=%@&userKey=%@dagolfla.com",model.cardId, DEFAULF_USERID]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/league/leagueUserCardInfo.html?md5=%@&winzoom=1&cardKey=%@&userKey=%@",md5Value,model.cardId,DEFAULF_USERID];
    
    //跳转
    UseMallViewController *vc = [[UseMallViewController alloc]init];
    vc.linkUrl = urlString;
    //设置电池栏白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listArray.count==0) {
        //        return 10;
    }
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listArray.count==0) {
        return screenHeight/2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(70);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardHistoryTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CardHistoryTableViewCell"];
    cell.topLineImageView.hidden = NO;
    cell.bottomLineImageView.hidden = NO;
    if (indexPath.row==0) {
        cell.topLineImageView.hidden = YES;
    }
    if (indexPath.row==self.listArray.count-1) {
        cell.bottomLineImageView.hidden = YES;
    }
    [cell configModel:self.listArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];
    self.mainTableView.backgroundColor = WhiteColor;
    if (self.listArray.count==0) {
        self.mainTableView.backgroundColor = RGBA(238, 238, 238, 1);
        headerView =  [Factory createViewWithBackgroundColor:RGBA(238, 238, 238, 1) frame:CGRectMake(0, 0, screenWidth, screenHeight/2)];
        //没卡提示图片
        UIImageView *alertImageView = [Factory createImageViewWithFrame:CGRectMake(screenWidth/2-kWvertical(53.5), kHvertical(110), kWvertical(107), kWvertical(107)) Image:[UIImage imageNamed:@"bg-shy"]];
        NSString *noneCard = @"你还没有使用记录哦";
        //文字描述
        UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(22), alertImageView.y_height+kHvertical(15), screenWidth - kWvertical(44), kHvertical(80)) textColor:LightGrayColor fontSize:kHorizontal(15) Title:noneCard];
        descLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:alertImageView];
        [headerView addSubview:descLabel];
        
    }
    return headerView;
}



#pragma mark - 富文本&&时间处理
//富文本
-(UILabel *)AttributedStringLabel:(UILabel *)putLabel rang:(NSRange )changeRang changeColor:(UIColor *)changeColor rang:(NSRange )changeRang2 changeColor:(UIColor *)changeColor2{
    UILabel *testLabel = putLabel;
    if (!putLabel) {
        return testLabel;
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:testLabel.text];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:changeColor range:changeRang];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:changeColor2 range:changeRang2];
    
    
    testLabel.attributedText = AttributedStr;
    return testLabel;
}
//时间处理
-(NSString *)dataFormat:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString * comfromTimeStr = [formatter stringFromDate:date];
    
    return comfromTimeStr;
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
