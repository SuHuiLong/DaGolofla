//
//  VipCardGoodsListViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardGoodsListViewController.h"
#import "VipCardGoodsListCollectionViewCell.h"
#import "VipCardGoodsListModel.h"
#import "VipCardOrderListViewController.h"
#import "VipCardGoodDetailViewController.h"

@interface VipCardGoodsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 主视图
 */
@property(nonatomic,copy)UICollectionView *mainCollectionView;
/**
 卡片数据源
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation VipCardGoodsListViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigation];
    [self createCollectionView];
}
/**
 创建导航
 */
-(void)createNavigation{
    
    self.title = @"联盟商城";
    [self.navigationController.navigationBar setTintColor:WhiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航背景
    [self.navigationController.navigationBar setTintColor:WhiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //backL
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //rightBtn
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(pushOrderList)];
    rightBtn.tintColor = WhiteColor;
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kWvertical(15)], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
/**
 创建主视图
 */
-(void)createCollectionView{
    UIView *backView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:backView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =CGSizeMake(screenWidth, kHvertical(312));
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) collectionViewLayout:layout];
    mainCollectionView.backgroundColor = RGBA(238, 238, 238, 1);
    [mainCollectionView registerClass:[VipCardGoodsListCollectionViewCell class] forCellWithReuseIdentifier:@"VipCardGoodsListCollectionViewCellId"];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [self.view addSubview:mainCollectionView];
    _mainCollectionView = mainCollectionView;
}



#pragma mark - initData
-(void)initData{
    [self initCollectionViewData];
}
/**
 获取卡片列表数据
 */
-(void)initCollectionViewData{
    
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]];
    
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"md5":md5Value,
                           };
    [[JsonHttp jsonHttp] httpRequest:@"league/getLeagueCardTypeList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL Success = [[data objectForKey:@"packSuccess"] boolValue];
        if (Success) {
            NSArray *listArray = [data objectForKey:@"cardTypeList"];
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *listDict in listArray) {
                VipCardGoodsListModel *model = [VipCardGoodsListModel modelWithDictionary:listDict];
                [self.dataArray addObject:model];
            }
            [_mainCollectionView reloadData];
        }
    }];
}


#pragma mark - Action
/**
 左按钮
 */
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 右按钮
 */
-(void)pushOrderList{
    VipCardOrderListViewController *vc = [[VipCardOrderListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 隐藏球场列表
 */
-(void)hideTableView{

}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 10;
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VipCardGoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipCardGoodsListCollectionViewCellId" forIndexPath:indexPath];
    VipCardGoodsListModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VipCardGoodsListModel *model = self.dataArray[indexPath.item];
    NSString *timeKey = model.timeKey;
    
    VipCardGoodDetailViewController *vc = [[VipCardGoodDetailViewController alloc] init];
    vc.cardTypeKey = timeKey;
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
