//
//  JGPhotoAlbumViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGPhotoAlbumViewController.h"

#import "JGTeamMemberController.h"

#import "JGPhotoShowCollectionViewCell.h"
#import "JGPhotoTimeReusableView.h"

#import "SXPickPhoto.h"



#import "JGPhotoListModel.h"
#import "JGTeamPhotoShowViewController.h"

#import "JGLPhotosUpDataViewController.h"
#import "SDPhotoBrowser.h"
#import "SDBrowserImageView.h"

#define SDPhotoBrowserShowImageAnimationDuration 0.8f


@interface JGPhotoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
{
    UICollectionView* _collectionView;
    
    NSMutableDictionary* _dictPhoto;
    
    NSMutableArray* _dataArray;
    NSInteger _page;
    
    BOOL _isUpdata;
    
    NSString* _teamName;
    UIBarButtonItem* _rightItem;
    
    NSInteger _shouldAutorotate;//0-不能旋转，1-旋转；实现逻辑点开图片后可以旋转，回到图片列表后不支持旋转
    
    CGRect _imageViewRect;//记录旋转试图的frame
    NSInteger _rotating;//记录是否旋转过，0-表示第一次旋转，第一次记录frame
}
@property (nonatomic,strong)  SXPickPhoto * pickPhoto;//相册类
@property (strong, nonatomic) JGPhotoTimeReusableView *headView;
@end

@implementation JGPhotoAlbumViewController


-(void)backButtonClcik{
    if (_isUpdata == YES) {
        _blockRefresh();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    _isUpdata = NO;
    _dictPhoto = [[NSMutableDictionary alloc]init];
    self.pickPhoto = [[SXPickPhoto alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    
    _shouldAutorotate = 0;//不能旋转
    _rotating = 0;
    
    if (![Helper isBlankString:_strTitle]) {
        self.title = _strTitle;
    }
    else
    {
        self.title = @"球队相册";
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    [self uiConfig];
    
}

-(void)upDataClick
{
    
    JGLPhotosUpDataViewController* upVc = [[JGLPhotosUpDataViewController alloc]init];
    upVc.albumName = _teamName;
    upVc.albumKey = _albumKey;
    upVc.blockRefresh = ^(){
        if (_collectionView.mj_header.isRefreshing == YES) {
            [_collectionView.mj_header endRefreshing];
        }
        _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        _isUpdata = YES;
        [_collectionView.mj_header beginRefreshing];
        [_collectionView reloadData];
    };
    [self.navigationController pushViewController:upVc animated:YES];
    return;

}

-(void)uiConfig
{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=1.f;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) collectionViewLayout:flowLayout];
    //    _collectionView.frame = _yuansuScrollview.frame;
    [self.view addSubview:_collectionView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    //    _collectionView.bounces = NO;
    //    _collectionView.scrollEnabled = NO;
    _collectionView.contentSize = CGSizeMake(0, 0);
    //注册cell
    [_collectionView registerNib: [UINib nibWithNibName:@"JGPhotoShowCollectionViewCell"
                                                 bundle:nil] forCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell"];
    /**
     *  如果是使用的xib文件则使用这个方法，    //获取含有UICollectionReusableView的Nib文件,
     UINib *headerNib = [UINib nibWithNibName: @"HeaderCollectionReusableView" bundle: [NSBundle mainBundle]];
     */
    //获取含有UICollectionReusableView的class文件。
    [_collectionView registerClass:[JGPhotoTimeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JGPhotoTimeReusableView"];
    
    _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_collectionView.mj_header beginRefreshing];
    
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_albumKey forKey:@"albumKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    NSString* strMd = [JGReturnMD5Str getTeamCompeteSignUpListWithAlbumKey:[_albumKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMd forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMediaRoleList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_collectionView.mj_header endRefreshing];
        }else {
            [_collectionView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"teamMediaList"]) {
                JGPhotoListModel *model = [[JGPhotoListModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            _teamName = [data objectForKey:@"teamName"];
            _page++;
            _state = [data objectForKey:@"isTeamMemeber"];
            _power = [data objectForKey:@"power"];
            _teamTimeKey = [data objectForKey:@"teamKey"];
            _strTitle = [data objectForKey:@"albumName"];
            self.title = _strTitle;
            if (!_rightItem) {
                if ([[data objectForKey:@"isTeamMemeber"] integerValue] == 1) {
                    _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
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
        if (isReshing) {
            [_collectionView.mj_header endRefreshing];
        }else {
            [_collectionView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark -- uicollection方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(screenWidth, 15*ScreenWidth/375);
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGPhotoShowCollectionViewCell *cell = [[JGPhotoShowCollectionViewCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iconImgv.hidden = NO;
    cell.iconImgv.layer.masksToBounds = YES;
    cell.iconImgv.contentMode = UIViewContentModeScaleAspectFill;
    cell.addBtn.hidden = YES;
    [cell.iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[_dataArray[indexPath.row] timeKey] integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(115*ScreenWidth/375, 115*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _dataArray.count; i++) {
        [arr addObject:[_dataArray[i]timeKey]];
    }
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.tag = 100;
    
    JGPhotoShowCollectionViewCell *cell = (JGPhotoShowCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    browser.sourceImagesContainerView = cell;
    
    browser.imageCount = _dataArray.count;
    
    browser.currentImageIndex = (int)indexPath.row;
    browser.teamTimeKey = _teamTimeKey;
    browser.delegate = self;
    browser.state = _state;
    browser.arrayData = arr;
    browser.power = _power;
    browser.strTitle = _strTitle;
    browser.teamName = _teamName;
    browser.userKey = _userKey;
    browser.blockRef = ^(){
        
        [_collectionView.mj_header endRefreshing];
        _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_collectionView.mj_header beginRefreshing];
        [_collectionView reloadData];
    };
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        
    } completion:^(BOOL finished) {
        [browser show];
    }];
    
    _shouldAutorotate = 1;
    [self shouldAutorotate];
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSLog(@"%td",index);
    if (index >= _dataArray.count) {
        index = _dataArray.count-1;
    }
    if (_dataArray.count == 0) {
        return nil;
    }
    return [Helper setImageIconUrl:@"album/media" andTeamKey:[[_dataArray[index]timeKey] integerValue] andIsSetWidth:NO andIsBackGround:NO];
}
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"xiangcemoren"];
}

- (BOOL)shouldAutorotate
{
    // 因为是取反值，所以返回NO的控制器，就可以旋转
    // 因为是取反值，不重写这个方法的控制器，默认就不支持旋转
    if (_shouldAutorotate == 0) {
        return YES;//不能旋转
    }else{
        return NO;
    }
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait | UIDeviceOrientationLandscapeRight;
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         NSLog(@"转屏前调入");
//     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         NSLog(@"转屏后调入");
//     }];
//    
////    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    NSLog(@"fromInterfaceOrientation == %td", fromInterfaceOrientation);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SDPhotoBrowser *browser = [window viewWithTag:100];
    
    SDBrowserImageView *browserImageView = [browser.scrollView viewWithTag:browser.currentImageIndex];
    browser.center = window.center;
    browser.frame = window.frame;
    browser.scrollView.frame = window.frame;
    
    NSLog(@"%@", browserImageView);
   
    
    UIScrollView *browserImageViewScroll = [browserImageView viewWithTag:1000];
    
    NSLog(@"browserImageViewScroll == %@", browserImageViewScroll.subviews);
    
    UIImageView *subImageView = [browserImageViewScroll viewWithTag:10000];
    
     NSLog(@"subviews == %@", subImageView.subviews);
    
    if (_rotating == 0) {
        _imageViewRect = subImageView.frame;
    }
    
    _rotating ++;
    
    //张数
    UILabel *indexLabel = [browser viewWithTag:200];
    
    if (fromInterfaceOrientation == 3) {
        
        subImageView.frame = _imageViewRect;
        
        indexLabel.center = CGPointMake(screenHeight * 0.5, 30);
    }else{
        self.navigationController.navigationBarHidden = YES;
        
        indexLabel.bounds = CGRectMake(0, 0, 80, 30);
        indexLabel.center = CGPointMake(screenWidth * 0.5, 30);
        
        subImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//
        
//        browserImageViewScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        
        //逆时针 旋转180度
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.2]; //动画时长
//        browserImageViewScroll.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
//        CGAffineTransform tranform = browserImageViewScroll.transform;
//        //第二个值表示横向放大的倍数，第三个值表示纵向缩小的程度
//        tranform = CGAffineTransformScale(tranform, 1,1);
//        browserImageViewScroll.transform = tranform;
//        [UIView commitAnimations];
//        
//        //逆时针 旋转180度
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.2]; //动画时长
//        subImageView.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
//        CGAffineTransform transform = subImageView.transform;
//        //第二个值表示横向放大的倍数，第三个值表示纵向缩小的程度
//        transform = CGAffineTransformScale(transform, 1,1);
//        subImageView.transform = transform;
//        [UIView commitAnimations];
        
    }
}
- (void)viewDidLayoutSubviews{
    
}

//- (void)loadView{
//    
//}

#pragma mark -- 移除 SDPhotoBrowser
- (void)removePhotoBrowser{
    self.navigationController.navigationBarHidden = NO;
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    //
    _shouldAutorotate = 0;
    _rotating = 0;
    [self shouldAutorotate];
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
