//
//  JGHShadowPhotoAlbumViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHShadowPhotoAlbumViewController.h"
#import "MSSBrowseDefine.h"
#import "UIImageView+WebCache.h"
#import "MSSCollectionViewCell.h"

#import "JGPhotoListModel.h"
#import "JGLPhotosUpDataViewController.h" // 上传
#import "JGDNewTeamDetailViewController.h"

@interface JGHShadowPhotoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate>
{
    UICollectionView* _collectionView;
    
    NSMutableDictionary* _dictPhoto;
    
    NSInteger _page;
    
    BOOL _isUpdata;
    
    NSString* _teamName;
    UIBarButtonItem* _rightItem;
    
}
@property (nonatomic,strong)UICollectionView *collectionView;
//@property (nonatomic,strong)NSArray *smallUrlArray;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation JGHShadowPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![Helper isBlankString:_strTitle]) {
        self.title = _strTitle;
    }
    else
    {
        self.title = @"球队相册";
    }
    
    self.view.backgroundColor = [UIColor whiteColor]; //
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"查看球队" style:UIBarButtonItemStylePlain target:self action:@selector(toViewTeam)];
    item.tintColor=[UIColor whiteColor];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15*ProportionAdapter],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(5 , 5 , 5 , 5 );
    flowLayout.itemSize = CGSizeMake((screenWidth - 20)/3, (screenWidth - 20)/3);
    //    flowLayout.itemSize = CGSizeMake((screenWidth - 20)/3, 115);
    flowLayout.minimumLineSpacing = 5 ;
    flowLayout.minimumInteritemSpacing = 5 ;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MSS_SCREEN_WIDTH, MSS_SCREEN_HEIGHT - 64 * ProportionAdapter) collectionViewLayout:flowLayout];
    NSLog(@"%f", _collectionView.frame.origin.y);
    NSLog(@"%f", _collectionView.frame.size.height);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //cell注册
    [_collectionView registerClass:[MSSCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _collectionView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self dataDownLoad];
    
}

- (void)toViewTeam{
    JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
    newTeamVC.timeKey = _teamTimeKey;
    [self.navigationController pushViewController:newTeamVC animated:YES];
}

- (void)headRereshing{
    _page = 0;
    [self dataDownLoad];
}

- (void)footerRefreshing{
    
    [self dataDownLoad];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCollectionViewCell" forIndexPath:indexPath];
    if (cell)
    {
        
        [cell.imageView sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[self.dataArray[indexPath.item] timeKey] integerValue] andIsSetWidth:NO andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
        cell.imageView.tag = indexPath.item + 100;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < [self.dataArray count];i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = [NSString stringWithFormat:@"%@", [Helper setImageIconUrl:@"album/media" andTeamKey:[[self.dataArray[i] timeKey] integerValue] andIsSetWidth:NO andIsBackGround:NO]];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        
        browseItem.timeKey = _teamTimeKey;
        browseItem.albumTitle = _strTitle;
//        browseItem.albumKey = [self.dataArray[i] albumKey];
        browseItem.teamName = _teamName;
        //browseItem.power = _power;
        browseItem.currentPhotoKey = [self.dataArray[i] timeKey];
        
        [browseItemArray addObject:browseItem];
    }
    MSSCollectionViewCell *cell = (MSSCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 100];
    bvc.blockRef = ^(){
        if (_collectionView.header.isRefreshing == YES) {
            [_collectionView.header endRefreshing];
        }
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        _isUpdata = YES;
        [_collectionView.header beginRefreshing];
        [_collectionView reloadData];
    };
    bvc.closeAutorotate = ^(){
        
    };
    //    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
    
}


//- (BOOL)shouldAutorotate
//{
//    // 因为是取反值，所以返回NO的控制器，就可以旋转
//    // 因为是取反值，不重写这个方法的控制器，默认就不支持旋转
//        return YES;//不能旋转
//}

- (void)dataDownLoad{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_albumKey forKey:@"albumKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    NSString* strMd = [JGReturnMD5Str getTeamCompeteSignUpListWithAlbumKey:[_albumKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMd forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMediaRoleList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (_page == 0)
            {
                //清除数组数据 _smallUrlArray
                [self.dataArray removeAllObjects];
            }
            //数据解析
            if ([data objectForKey:@"teamMediaList"]) {
                for (NSDictionary *dicList in [data objectForKey:@"teamMediaList"]) {
                    JGPhotoListModel *model = [[JGPhotoListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicList];
                    [self.dataArray addObject:model];
                    
                }
                _page++;
            }
            _teamName = [data objectForKey:@"teamName"];
            //_state = [data objectForKey:@"isTeamMemeber"];
            //_power = [data objectForKey:@"power"];
            _teamTimeKey = [data objectForKey:@"teamKey"];
            _strTitle = [data objectForKey:@"albumName"];
            self.title = _strTitle;
            /*
            if (!_rightItem) {
                if ([[data objectForKey:@"isTeamMemeber"] integerValue] == 1) {
                    _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
                    _rightItem.tintColor = [UIColor whiteColor];
                    self.navigationItem.rightBarButtonItem = _rightItem;
                }
            }
             */
            [_collectionView reloadData];
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    }];
    
}

// 上传
- (void)upDataClick{
    
    JGLPhotosUpDataViewController* upVc = [[JGLPhotosUpDataViewController alloc]init];
    upVc.albumName = _strTitle;
    upVc.albumKey = _albumKey;
    upVc.blockRefresh = ^(){
        if (_collectionView.header.isRefreshing == YES) {
            [_collectionView.header endRefreshing];
        }
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        _isUpdata = YES;
        [_collectionView.header beginRefreshing];
        [_collectionView reloadData];
    };
    [self.navigationController pushViewController:upVc animated:YES];
    return;
}

// 清除缓存
- (void)btnClick
{
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [_collectionView reloadData];
    }];
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
