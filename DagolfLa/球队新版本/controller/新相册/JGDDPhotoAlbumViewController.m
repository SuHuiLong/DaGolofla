//
//  JGDDPhotoAlbumViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDDPhotoAlbumViewController.h"
#import "MSSBrowseDefine.h"
#import "UIImageView+WebCache.h"
#import "MSSCollectionViewCell.h"

#import "JGPhotoListModel.h"
#import "JGLPhotosUpDataViewController.h" // 上传
#import "MakePhotoTextViewController.h"
#import "MakePhotoTextViewModel.h"

#import "SaveScheduleView.h"

@interface JGDDPhotoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate>
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
//数据源
@property (nonatomic, strong) NSMutableArray* dataArray;
//底部view
@property (nonatomic, copy) UIView *bottomView;
//选中照片的数组
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation JGDDPhotoAlbumViewController

-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createView];
}
#pragma mark - CreateView
-(void)createView{
    if (![Helper isBlankString:_strTitle]) {
        self.title = _strTitle;
    }else{
        self.title = @"球队相册";
    }
    self.view.backgroundColor = [UIColor whiteColor]; //
    [self createCollectionView];
    [self createBottomView];
}
//创建列表
-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5 , 5 , 5 , 5 );
    flowLayout.itemSize = CGSizeMake((screenWidth - 20)/3, (screenWidth - 20)/3);
    flowLayout.minimumLineSpacing = 5 ;
    flowLayout.minimumInteritemSpacing = 5 ;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MSS_SCREEN_WIDTH, MSS_SCREEN_HEIGHT - 64 ) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //cell注册
    [_collectionView registerClass:[MSSCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [_collectionView.mj_header beginRefreshing];
}
//创建选择后底部按钮
-(void)createBottomView{
    //弹出的view
    _bottomView = [Factory createViewWithBackgroundColor:RGBA(248,248,248,0.97) frame:CGRectMake(0, screenHeight, screenWidth, kHvertical(51))];
    [self.view addSubview:_bottomView];
    //各个操作按钮
    NSArray *titleArray = @[@"制作图文",@"保存",@"删除"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [Factory createButtonWithFrame:CGRectMake(screenWidth*i/3, 0, screenWidth/3, _bottomView.height) titleFont:kHorizontal(18) textColor:RGB(160,160,160) backgroundColor:ClearColor target:self selector:@selector(handleBtnClick:) Title:titleArray[i]];
        [btn setTitleColor:NormalColor forState:UIControlStateSelected];
        btn.userInteractionEnabled = false;
        btn.selected = false;
        [_bottomView addSubview:btn];
    }
}
#pragma mark - initData
- (void)dataDownLoad{
    NSString* strMd = [JGReturnMD5Str getTeamCompeteSignUpListWithAlbumKey:[_albumKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:@{
                           @"userKey":DEFAULF_USERID,
                           }];
    NSString *request = @"team/getTeamMediaRoleList";
    
    if (_isGetAll) {
        [dict setValue:_teamTimeKey forKey:@"teamKey"];
        [dict setValue:[NSNumber numberWithInteger:_page] forKey:@"off"];
        strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%@dagolfla.com",  DEFAULF_USERID,_teamTimeKey]];
        if (self.activityKey) {
            [dict setObject:self.activityKey forKey:@"activityKey"];
        }
        request = @"team/getTeamMediaListAll";
    }else{
        [dict setValue:_albumKey forKey:@"albumKey"];
        [dict setValue:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    }
    [dict setValue:strMd forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:request JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (_page == 0){
                //清除数组数据 _smallUrlArray
                [self.dataArray removeAllObjects];
                if (!_isGetAll&&[[data objectForKey:@"isTeamMemeber"] integerValue] == 1) {
                    [self.dataArray addObject:[[JGPhotoListModel alloc] init]];
                    if ([_rightItem.title isEqualToString:@"取消"]) {
                        [self.dataArray removeAllObjects];
                    }
                }
            }
            //数据解析
            NSArray *listArray = [data objectForKey:@"teamMediaList"];
            if (_isGetAll) {
                listArray = [data objectForKey:@"mediaList"];
            }
            for (NSDictionary *dicList in listArray) {
                JGPhotoListModel *model = [[JGPhotoListModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [self.dataArray addObject:model];
            }
            _teamName = [data objectForKey:@"teamName"];
            _state = [data objectForKey:@"isTeamMemeber"];
            if (!_isGetAll) {
                _power = [data objectForKey:@"power"];
                _teamTimeKey = [data objectForKey:@"teamKey"];
                _strTitle = [data objectForKey:@"albumName"];
                self.title = _strTitle;
            }else{
                _strTitle = _teamName;
            }
            if (!_rightItem) {
                if ([[data objectForKey:@"isTeamMemeber"] integerValue] == 1||_isGetAll) {
                    _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBtnCLick:)];
                    [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kWvertical(15)], NSFontAttributeName, nil] forState:UIControlStateNormal];
                    _rightItem.tintColor = [UIColor whiteColor];
                    self.navigationItem.rightBarButtonItem = _rightItem;
                }
            }
            [_collectionView reloadData];
      
            
            
            
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{

            if ([data objectForKey:@"pos"] && ([[data objectForKey:@"pos"] integerValue] != 0)) {
                
                NSInteger pos = [[data objectForKey:@"pos"] integerValue];
                //
                
                [_collectionView setContentOffset:CGPointMake(0, ((screenWidth - 20)/3 + 5) * (pos / 3)) animated:NO];

            }
            
        }];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}


#pragma mark - Action
//选择取消按钮点击
-(void)rightButtonCLick{
    UIBarButtonItem *rightBarButton = self.navigationItem.rightBarButtonItem;
    [self selectBtnCLick:rightBarButton];
}
//选择
-(void)selectBtnCLick:(UIBarButtonItem *)barBtn{
    //按钮失效
    for (NSInteger i = 0; i<3; i++) {
        UIButton *indexBtn = _bottomView.subviews[i];
        indexBtn.selected = false;
        indexBtn.userInteractionEnabled = false;
    }
    if ([barBtn.title isEqualToString:@"选择"]) {
        barBtn.title = @"取消";
        if (!_isGetAll) {
            [self.dataArray removeObjectAtIndex:0];
        }
        [UIView animateWithDuration:0.5 animations:^{
            _bottomView.y = screenHeight - 64 - kHvertical(51);
            _collectionView.height = _bottomView.y;
        }];
    }else{
        barBtn.title = @"选择";
        for (int i = 0; i<self.dataArray.count; i++) {
            JGPhotoListModel *Model = self.dataArray[i];
            if (Model.isSelect) {
                Model.isSelect = false;
            }
            [self.dataArray replaceObjectAtIndex:i withObject:Model];
        }
        if (!_isGetAll) {
            [self.dataArray insertObject:[[JGPhotoListModel alloc] init] atIndex:0];
        }
        self.selectArray = [NSMutableArray array];
        [UIView animateWithDuration:0.5 animations:^{
            _bottomView.y = screenHeight;
            _collectionView.height = screenHeight - 64;
        }];
    }

    [self.collectionView reloadData];

}
//操作按钮点击
-(void)handleBtnClick:(UIButton *)btn{
    NSInteger index = 0;
    for (NSInteger i = 0; i<3; i++) {
        UIButton *indexBtn = _bottomView.subviews[i];
        if (indexBtn == btn) {
            index = i;
        }
    }
    
    switch (index) {
        case 0:{
            //图文制作
            [self takePhotoText];
        }break;
        case 1:{
            //本地保存
            [self saveLocation];
        }break;
        case 2:{
            //删除
            [self deleatePhoto];
        } break;
            
        default:
            break;
    }

}

// 上传
- (void)upDataClick{
    
    JGLPhotosUpDataViewController* upVc = [[JGLPhotosUpDataViewController alloc]init];
    upVc.albumName = _strTitle;
    upVc.albumKey = _albumKey;
    upVc.blockRefresh = ^(){
        if (_collectionView.mj_header.isRefreshing == YES) {
            [_collectionView.mj_header endRefreshing];
        }
        _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        _isUpdata = YES;
        [_collectionView.mj_header beginRefreshing];
        [_collectionView reloadData];
    };
    [self.navigationController pushViewController:upVc animated:YES];
    return;
}
//选中照片
-(void)selectPhotoModel:(JGPhotoListModel *)indexModel index:(NSInteger)index{

    if (indexModel.isSelect) {
        //选中的取消选中
        indexModel.isSelect = false;
        [self.selectArray removeObject:indexModel];
            for (NSInteger i = 0; i<3; i++) {
                
                UIButton *indexBtn = _bottomView.subviews[i];
                indexBtn.selected = true;
                indexBtn.userInteractionEnabled = true;
                if (i==2&&![_power containsString:@"1005"]) {
                    for (JGPhotoListModel *model in _selectArray) {
                        if ([model.userKey integerValue] != [DEFAULF_USERID integerValue]) {
                            indexBtn.selected = false;
                            indexBtn.userInteractionEnabled = false;
                        }
                    }
                }
                if (self.selectArray.count==0) {
                indexBtn.selected = false;
                indexBtn.userInteractionEnabled = false;
            }
        }
        
    }else{
        //未选中的设为选中
        indexModel.isSelect = true;
        [self.selectArray addObject:indexModel];

        for (NSInteger i = 0; i<3; i++) {
            UIButton *indexBtn = _bottomView.subviews[i];
            indexBtn.selected = true;
            indexBtn.userInteractionEnabled = true;
            
            if (i==2&&![_power containsString:@"1005"]) {
                for (JGPhotoListModel *model in _selectArray) {
                    if ([model.userKey integerValue] != [DEFAULF_USERID integerValue]) {
                        indexBtn.selected = false;
                        indexBtn.userInteractionEnabled = false;
                    }
                }
            }
        
        
        }
    }
    

    [self.dataArray replaceObjectAtIndex:index withObject:indexModel];
    [self.collectionView reloadData];

}

// 清除缓存
- (void)btnClick
{
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [_collectionView reloadData];
    }];
}

#pragma mark - 图文制作&&分享&&本地保存&&删除
//图文制作
-(void)takePhotoText{
    MakePhotoTextViewController *vc = [[MakePhotoTextViewController alloc] init];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (JGPhotoListModel *model in self.selectArray) {
        MakePhotoTextViewModel *Model = [[MakePhotoTextViewModel alloc] init];
        Model.timeKey = model.timeKey;
        NSMutableArray *photoArray = [NSMutableArray array];
        [photoArray addObject:Model];
        [dataArray addObject:photoArray];
    }
    vc.dataArray = dataArray;
    vc.teamTimeKey = _teamTimeKey;
    vc.teamName = _teamName;
    [self.navigationController pushViewController:vc animated:YES];
    [self rightButtonCLick];
}


//本地保存
-(void)saveLocation{
    NSArray *picArray = [NSArray arrayWithArray:_selectArray];
    [self rightButtonCLick];
    SaveScheduleView *sv = [[SaveScheduleView alloc] initWithImageArray:picArray];

    [[UIApplication sharedApplication].keyWindow addSubview:sv];
    
    
    
//                    NSString *dowloadNum = [NSString stringWithFormat:@"第%d张下载完成",photoNum];

}
//删除
-(void)deleatePhoto{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (JGPhotoListModel *model in self.selectArray) {
        NSString *photoKey =  [NSString stringWithFormat:@"%@",model.timeKey];
        [photoArray addObject:photoKey];
    }
    
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":_teamTimeKey,
                           @"timeKeyList":photoArray
                           };
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"team/batchDeleteTeamMedia" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL parkSucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (parkSucess) {
            [self.dataArray removeObjectsInArray:self.selectArray];
            [self.collectionView reloadData];
            [self rightButtonCLick];
        }
    }];

    

}
#pragma mark - Refresh

- (void)headRereshing{
    _page = 0;
    [self dataDownLoad];
}

- (void)footerRefreshing{
    _page ++;
    [self dataDownLoad];
}

#pragma mark - UITableViewDelegate

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int differ = 0;
    if (!_isGetAll&&[_state integerValue] == 1) {
        differ = 1;
    }
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    JGPhotoListModel *indexModel = self.dataArray[indexPath.item];
    if (_bottomView.y != screenHeight) {
        if (indexModel.timeKey) {
            //选中照片
            [self selectPhotoModel:indexModel index:indexPath.item];
        }
        return;
    }
    
    if (indexModel.timeKey==nil) {
        //上传
        [self upDataClick];
        return;
    }
    for(int i = differ;i < [self.dataArray count];i++)
    {
        JGPhotoListModel *model = self.dataArray[i];
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        //browseItem.bigImageUrl = [NSString stringWithFormat:@"%@", [Helper setImageIconUrl:@"album/media" andTeamKey:[model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:NO]];// 加载网络图片大图地址
        
        browseItem.bigImageUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/album/media/%@.jpg", model.timeKey];
        //[self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/album/media/%td.jpg@400w_400h_2o", timeKey]] placeholderImage:[UIImage imageNamed:@"teamPhotoGroupDefault"]];
        browseItem.smallImageView = imageView;// 小图
       
        browseItem.timeKey = _teamTimeKey;
        browseItem.albumTitle = _strTitle;
//        browseItem.albumKey = model.albumKey;
        browseItem.teamName = _teamName;
        browseItem.power = _power;
        browseItem.currentPhotoKey = model.timeKey;
        
        [browseItemArray addObject:browseItem];
    }
    NSIndexPath *indexPathNext = [NSIndexPath indexPathForItem:indexPath.item-differ inSection:indexPath.section];
    MSSCollectionViewCell *cell = (MSSCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPathNext];
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 100];
    bvc.blockRef = ^(){
        if (_collectionView.mj_header.isRefreshing == YES) {
            [_collectionView.mj_header endRefreshing];
        }
        _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        _isUpdata = YES;
        [_collectionView.mj_header beginRefreshing];
        [_collectionView reloadData];
    };
    bvc.closeAutorotate = ^(){
        
    };
    //    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
    
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

@end

