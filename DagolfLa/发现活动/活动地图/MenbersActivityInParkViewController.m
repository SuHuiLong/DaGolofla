//
//  MenbersActivityInParkViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MenbersActivityInParkViewController.h"
#import "DiscoveryActivitiesCollectionViewCell.h"
#import "DisCoveryActivityModel.h"
#import "ActivityDetailViewController.h"
@interface MenbersActivityInParkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 主视图
@property (nonatomic,copy) UICollectionView *mainClolllectionView;
// 数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
// 页数
@property (nonatomic,assign) NSInteger offset;

@end

@implementation MenbersActivityInParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Back_Color;
    // Do any additional setup after loading the view.
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createCollectionView];
}
//创建导航
-(void)createNavigationView{
    self.title = [NSString stringWithFormat:@"%@活动",_parkName];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航背景
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
//主视图
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth, kHvertical(262));
    layout.minimumLineSpacing = 1;//设置最小行间距
    UICollectionView *mainClollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) collectionViewLayout:layout];
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
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&ballKey=%@dagolfla.com", DEFAULF_USERID,_parkKey]];
    NSString *lat = [UserDefaults objectForKey:BDMAPLAT];
    NSString *lon = [UserDefaults objectForKey:BDMAPLNG];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"offset":offset,
                           @"ballKey":_parkKey,
                           @"latitude":lat,
                           @"longitude":lon,
                           @"md5":md5Value,
                           };
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivityListByBall" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
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
    ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
    DisCoveryActivityModel *model = self.dataArray[indexPath.item];
    vc.activityKey = model.timeKey;
    [self.navigationController pushViewController:vc animated:YES];
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
