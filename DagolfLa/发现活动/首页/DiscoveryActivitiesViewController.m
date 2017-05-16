//
//  DiscoveryActivitiesViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "DiscoveryActivitiesViewController.h"
#import "DiscoveryActivitiesCollectionViewCell.h"
#import "DisCoveryActivityModel.h"
#import "SearchWithCityViewController.h"
#import "SearchWithMapViewController.h"
#import "ActivityMyApplyViewController.h"
#import "DicoveryMapViewViewController.h"
@interface DiscoveryActivitiesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//省份按钮
@property (nonatomic,copy) UIButton *leftBtn;
// 主视图
@property (nonatomic,copy) UICollectionView *mainClolllectionView;
// 数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
// 页数
@property (nonatomic,assign) NSInteger offset;
// 排序 0：日期 1：距离
@property (nonatomic,assign) NSInteger sortType;
// 选中城市
@property (nonatomic,copy) NSString *province;
@end

@implementation DiscoveryActivitiesViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavagationType];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Back_Color;
    [self initRefresh];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigation];
    [self createSelectBar];
    [self createCollectionView];
}
//导航
-(void)createNavigation{
    //当前省份
    _province = [UserDefaults objectForKey:PROVINCENAME];
    //选择省份按钮
    _leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(70), kWvertical(40)) titleFont:kHorizontal(15) textColor:BarRGB_Color backgroundColor:ClearColor target:self selector:@selector(leftBtnClick) Title:nil];
    UIImage *image = [UIImage imageNamed:@"zk"];
    [_leftBtn setImage:image forState:UIControlStateNormal];
    [self createLeftBtn];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBarButtonItems];
    
    //地图查看
    UIBarButtonItem *viewInMapBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mapsearch_location"] style:(UIBarButtonItemStylePlain) target:self action:@selector(pushMapView)];
    [viewInMapBtn setTintColor:BarRGB_Color];
    //我的报名
    UIBarButtonItem *myApply = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_myactivity"] style:(UIBarButtonItemStylePlain) target:self action:@selector(myApplyClick)];
    [myApply setTintColor:BarRGB_Color];
    self.navigationItem.rightBarButtonItems = @[myApply,viewInMapBtn];
    [self setNavagationType];
}
//导航样式
-(void)setNavagationType{
    //设置背景颜色为白色。
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_wbg"]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BlackColor}];
}
//城市选择按钮
-(void)createLeftBtn{
    if ([_province containsString:@"黑龙江"]||[_province containsString:@"内蒙古"]) {
        _province = [_province substringToIndex:3];
        _leftBtn.width = kWvertical(80);
    }else{
        _province = [_province substringToIndex:2];
        _leftBtn.width = kWvertical(70);
    }
    [_leftBtn setTitle:_province forState:UIControlStateNormal];
    UILabel *testLabel = _leftBtn.titleLabel;
    UIImage *image = [UIImage imageNamed:@"zk"];
    [testLabel sizeToFit];
    _leftBtn.width = testLabel.width + kWvertical(15) + image.size.width;
    
    [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width+kWvertical(10), 0, image.size.width+kWvertical(5))];
    [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _leftBtn.width-image.size.width, 0,0)];
}
//选择导航
-(void)createSelectBar{
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(50))];
    //日期优先
    UIButton *dateBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, screenWidth/2, kHvertical(50)) titleFont:kHorizontal(17) textColor:RGB(160,160,160) backgroundColor:ClearColor target:self selector:@selector(dateBtnClick:) Title:@"日期优先"];
    [dateBtn setTitleColor:BarRGB_Color forState:UIControlStateSelected];
    dateBtn.selected = true;
    [backView addSubview:dateBtn];
    //距离优先
    UIButton *distanceBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, kHvertical(50)) titleFont:kHorizontal(17) textColor:RGB(160,160,160) backgroundColor:ClearColor target:self selector:@selector(distanceBtnClick:) Title:@"距离优先"];
    [distanceBtn setTitleColor:BarRGB_Color forState:UIControlStateSelected];
    distanceBtn.selected = false;
    [backView addSubview:distanceBtn];
    //分割线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(screenWidth/2, kHvertical(17), 1, kHvertical(16))];
    [self.view addSubview:backView];
    [self.view addSubview:line];
}
//主视图
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth, kHvertical(262));
    UICollectionView *mainClollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHvertical(50), screenWidth, screenHeight-kHvertical(50)-64-44) collectionViewLayout:layout];
    mainClollectionView.backgroundColor = ClearColor;
    [mainClollectionView registerClass:[DiscoveryActivitiesCollectionViewCell class] forCellWithReuseIdentifier:@"DiscoveryActivitiesCollectionViewCellID"];
    mainClollectionView.delegate = self;
    mainClollectionView.dataSource = self;
    [self.view addSubview:mainClollectionView];
    _mainClolllectionView = mainClollectionView;
}
#pragma mark - MJRefresh
-(void)initRefresh{
    //刷新
    self.mainClolllectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    //加载
    self.mainClolllectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
//刷新
-(void)headerRefresh{
    _offset = 0;
    [self initCollectionViewData];
}
//加载
-(void)footerRefresh{
    _offset ++ ;
    [self initCollectionViewData];
}


#pragma mark - InitData
-(void)initData{
    [self initCollectionViewData];
}
//获取列表数据
-(void)initCollectionViewData{
    
    NSString *offset = [NSString stringWithFormat:@"%ld",(long)_offset];
    NSString *sortType = [NSString stringWithFormat:@"%ld",(long)_sortType];
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]];
    NSString *lat = [UserDefaults objectForKey:BDMAPLAT];
    NSString *lon = [UserDefaults objectForKey:BDMAPLNG];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                            @"offset":offset,
                            @"sortType":sortType,
                            @"province":_province,
                            @"latitude":lat,
                            @"longitude":lon,
                            @"md5":md5Value,
                           };
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivityListByProvince" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.mainClolllectionView.mj_footer endRefreshing];
        [self.mainClolllectionView.mj_header endRefreshing];

    } completionBlock:^(id data) {
        [self.mainClolllectionView.mj_footer endRefreshing];
        [self.mainClolllectionView.mj_header endRefreshing];
        BOOL parkSuccess = [data objectForKey:@"packSuccess"];
        if (parkSuccess) {
            if (_offset==0) {
                self.dataArray = [NSMutableArray array];
            }
            NSArray *dataArray = [data objectForKey:@"list"];
            for (NSDictionary *dataDict in dataArray) {
                DisCoveryActivityModel *model = [DisCoveryActivityModel modelWithDictionary:dataDict];
                
                [self.dataArray addObject:model];
            }
            [self.mainClolllectionView reloadData];
        }
    }];
    
}


#pragma mark - Action
//城市选择
-(void)leftBtnClick{
    SearchWithCityViewController *vc = [[SearchWithCityViewController alloc] init];
    __weak typeof(self) weakself = self;
    vc.blockAddress = ^(NSString *city) {
        __strong typeof(weakself) strongSelef = weakself;
        strongSelef.province = city;
        [strongSelef createLeftBtn];
        [strongSelef.mainClolllectionView.mj_header beginRefreshing];
    };
    vc.hidesBottomBarWhenPushed = true;
    vc.requestType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//地图icon点击
-(void)pushMapView{
    DicoveryMapViewViewController *vc = [[DicoveryMapViewViewController alloc] init];
    __weak typeof(self) weakself = self;
    vc.blockProvince = ^(NSString *province) {
        __strong typeof(weakself) strongSelef = weakself;
        strongSelef.province = province;
        [strongSelef createLeftBtn];
        [strongSelef.mainClolllectionView.mj_header beginRefreshing];
    };
    vc.hidesBottomBarWhenPushed = true;
    vc.cityName = _province;
    [self.navigationController pushViewController:vc animated:YES];
}
//我的报名
-(void)myApplyClick{
    ActivityMyApplyViewController *vc = [[ActivityMyApplyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:YES];
}
//日期优先
-(void)dateBtnClick:(UIButton *)btn{
    _sortType = 0;
    UIView *superView = btn.superview;
    UIButton *dateBtn = superView.subviews[1];
    dateBtn.selected = false;
    btn.selected = true;
    [self.mainClolllectionView.mj_header beginRefreshing];
}
//距离优先
-(void)distanceBtnClick:(UIButton *)btn{
    _sortType = 1;
    UIView *superView = btn.superview;
    UIButton *dateBtn = superView.subviews[0];
    dateBtn.selected = false;
    btn.selected = true;
    [self.mainClolllectionView.mj_header beginRefreshing];
}

#pragma mark - UICollectionViewDelegate&DateSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryActivitiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoveryActivitiesCollectionViewCellID" forIndexPath:indexPath];
    DisCoveryActivityModel *model = self.dataArray[indexPath.item];
    [cell configModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

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
