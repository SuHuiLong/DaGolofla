//
//  SelectPhotoAsHeaderViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/31.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SelectPhotoAsHeaderViewController.h"
#import "MSSCollectionViewCell.h"
#import "JGPhotoListModel.h"

@interface SelectPhotoAsHeaderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//主视图
@property (nonatomic,strong) UICollectionView *collectionView;
//数据源
@property (nonatomic, strong) NSMutableArray* dataArray;
//分页
@property (nonatomic,assign) NSInteger off;
@end

@implementation SelectPhotoAsHeaderViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择相册封面";
    // Do any additional setup after loading the view.
    [self createView];
    [self dataDownLoad];
}
#pragma mark - CreateView
-(void)createView{
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
    _collectionView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [_collectionView.mj_header beginRefreshing];
}

#pragma mark - Refresh
- (void)headRereshing{
    _off = 0;
    [self dataDownLoad];
}
- (void)footerRefreshing{
    _off ++;
    [self dataDownLoad];
}
#pragma mark - initData
- (void)dataDownLoad{
    NSString* md5Key = [JGReturnMD5Str getTeamCompeteSignUpListWithAlbumKey:[_albumKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    NSDictionary* dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"albumKey":_albumKey,
                           @"offset":[NSNumber numberWithInteger:_off],
                           @"md5":md5Key
                           };
    NSString *request = @"team/getTeamMediaRoleList";
    [[JsonHttp jsonHttp]httpRequest:request JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (_off == 0){
                self.dataArray = [NSMutableArray array];
            }
            
            NSArray *listArray = [data objectForKey:@"teamMediaList"];
            for (NSDictionary *dicList in listArray) {
                JGPhotoListModel *model = [[JGPhotoListModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [self.dataArray addObject:model];
            }
        }
        [_collectionView reloadData];

    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCollectionViewCell" forIndexPath:indexPath];
    if (cell){
        JGPhotoListModel *model = self.dataArray[indexPath.item];
        [cell configModel:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JGPhotoListModel *model = self.dataArray[indexPath.item];
    self.selectUrl([model.timeKey integerValue]);
    [self.navigationController popViewControllerAnimated:YES];
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
