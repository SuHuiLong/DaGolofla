//
//  MakePhotoTextSelectFromAllViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextSelectFromAllViewController.h"
#import "MSSCollectionViewCell.h"
#import "MakePhotoTextViewModel.h"
#import "MakePhotoTextViewController.h"
@interface MakePhotoTextSelectFromAllViewController  ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    //页码
    NSInteger _page;
    //右按钮
    UIBarButtonItem *_rightItem;
}

@end

@implementation MakePhotoTextSelectFromAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - CreateView
-(void)createView{
    [self createNavagationView];
    [self createCollectionView];
}
//创建上导航
-(void)createNavagationView{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.title = @"所有照片";
    _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnCLick)];
    _rightItem.tintColor = [UIColor lightGrayColor];
    [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kWvertical(15)], NSFontAttributeName, nil] forState:UIControlStateNormal];
    if (_canMultipleChoice) {
        self.navigationItem.rightBarButtonItem = _rightItem;
    }
}
//创建colletionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5 , 5 , 5 , 5 );
    flowLayout.itemSize = CGSizeMake((screenWidth - 20)/3, (screenWidth - 20)/3);
    flowLayout.minimumLineSpacing = 5 ;
    flowLayout.minimumInteritemSpacing = 5 ;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 ) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //cell注册
    [_collectionView registerClass:[MSSCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshing)];
    _collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [_collectionView.mj_header beginRefreshing];
    
}

#pragma mark - initData
-(void)initData{
    NSString *strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%@dagolfla.com",  DEFAULF_USERID,_teamTimeKey]];
    NSDictionary* dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":_teamTimeKey,
                           @"off":[NSNumber numberWithInteger:_page],
                           @"md5":strMd
                           };
    NSString *request = @"team/getTeamMediaListAll";
    
    [[JsonHttp jsonHttp]httpRequest:request JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (_page == 0){
                //清除数组数据 _smallUrlArray
                [self.dataArray removeAllObjects];
            }
            //数据解析
            NSArray *listArray = [data objectForKey:@"mediaList"];
            for (NSDictionary *dicList in listArray) {
                JGPhotoListModel *model = [[JGPhotoListModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [self.dataArray addObject:model];
            }
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_collectionView reloadData];
        
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - Action
//左按钮点击
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//右按钮点击
-(void)rightBtnCLick{
    if ([_rightItem.tintColor isEqual:LightGrayColor]) {
        return;
    }
    
    //block传值
    NSMutableArray *mArray = [NSMutableArray array];
    for (JGPhotoListModel *model in self.dataArray) {
        if (model.isSelect) {
            MakePhotoTextViewModel *Model = [[MakePhotoTextViewModel alloc] init];
            Model.timeKey = model.timeKey;
            NSMutableArray *photoArray = [NSMutableArray array];
            [photoArray addObject:Model];
            [mArray addObject:photoArray];
        }
    }
    
    if (self.selectPhotoBlock!=nil) {
        self.selectPhotoBlock(mArray);
    }
    //返回到图文界面
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MakePhotoTextViewController class]]) {
            MakePhotoTextViewController *A =(MakePhotoTextViewController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }
    
    
}
//设置block
-(void)SetSelectPhotoBlock:(selectPhotoBlock)selectPhotoBlock{
    self.selectPhotoBlock = selectPhotoBlock;
}

#pragma mark - refresh
//刷新
- (void)headRefreshing{
    _page = 0;
    [self initData];
}
//加载
- (void)footerRefreshing{
    _page++;
    [self initData];
}



#pragma mark - ClollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCollectionViewCell" forIndexPath:indexPath];
    if (cell)
    {
        JGPhotoListModel *model = self.dataArray[indexPath.item];
        [cell configModel:model];
        cell.imageView.tag = indexPath.item + 100;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JGPhotoListModel *model = self.dataArray[indexPath.item];
    if (model.isSelect) {
        model.isSelect = false;
        BOOL isSelect = false;
        for (int i =0; i<self.dataArray.count; i++) {
            JGPhotoListModel *Model = self.dataArray[i];
            if (Model.isSelect) {
                isSelect = true;
            }
        }
        if (!isSelect) {
            _rightItem.tintColor = LightGrayColor;
        }
        [self.dataArray replaceObjectAtIndex:indexPath.item withObject:model];
        [_collectionView reloadData];
    }else{
        if (!_canMultipleChoice) {
            for (int i =0; i<self.dataArray.count; i++) {
                JGPhotoListModel *Model = self.dataArray[i];
                if (Model.isSelect) {
                    Model.isSelect = false;
                }
                [self.dataArray replaceObjectAtIndex:i withObject:Model];
            }
            _rightItem.tintColor = WhiteColor;

            model.isSelect = true;
            [self.dataArray replaceObjectAtIndex:indexPath.item withObject:model];
            if (_selectPhotoBlock!=nil) {
                NSMutableArray *mArray = [NSMutableArray array];
                MakePhotoTextViewModel *Model = [[MakePhotoTextViewModel alloc] init];
                Model.timeKey = model.timeKey;
                [mArray addObject:Model];
                NSMutableArray *dataArray = [NSMutableArray array];
                [dataArray addObject:mArray];
                _selectPhotoBlock(dataArray);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            model.isSelect = true;
            _rightItem.tintColor = WhiteColor;
            [self.dataArray replaceObjectAtIndex:indexPath.item withObject:model];
        }
        [_collectionView reloadData];
    }

    
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
