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

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "JGPhotoListModel.h"
#import "JGTeamPhotoShowViewController.h"

#import "JGLPhotosUpDataViewController.h"
#import "SDPhotoBrowser.h"
#define SDPhotoBrowserShowImageAnimationDuration 0.8f


@interface JGPhotoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
{
    UICollectionView* _collectionView;
    
    NSMutableDictionary* _dictPhoto;
    
    NSMutableArray* _dataArray;
    NSInteger _page;
    
    BOOL _isUpdata;
    
    NSString* _teamName;
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
    
    if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
    [self uiConfig];
    
}

-(void)upDataClick
{
    
    JGLPhotosUpDataViewController* upVc = [[JGLPhotosUpDataViewController alloc]init];
    upVc.albumKey = _albumKey;
    upVc.blockRefresh = ^(){
        if (_collectionView.header.isRefreshing == YES) {
            [_collectionView.header endRefreshing];
        }
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        _isUpdata = YES;
        [_collectionView.header beginRefreshing];
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
    
    _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _collectionView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_collectionView.header beginRefreshing];
    
    
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
            [_collectionView.header endRefreshing];
        }else {
            [_collectionView.footer endRefreshing];
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
            NSLog(@"%ld",_dataArray.count);
            _page++;
            [_collectionView reloadData];
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_collectionView reloadData];
        if (isReshing) {
            [_collectionView.header endRefreshing];
        }else {
            [_collectionView.footer endRefreshing];
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


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    //设置SectionHeader
//    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
//        _headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JGPhotoTimeReusableView"forIndexPath:indexPath];
//
//
//        _headView.timeLabel.text = [NSString stringWithFormat:@"2016年5月%ld号",(long)indexPath.section];
//        _headView.backgroundColor = [UIColor lightGrayColor];
//        return _headView;
//    }
//    return nil;
//}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 7) {
    //        JGPhotoShowCollectionViewCell *cell = [[JGPhotoShowCollectionViewCell alloc]init];
    //        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell" forIndexPath:indexPath];
    //        cell.backgroundColor = [UIColor whiteColor];
    //        cell.iconImgv.hidden = YES;
    //        cell.addBtn.hidden = NO;
    //        return cell;
    //    }
    //    else
    //    {
    JGPhotoShowCollectionViewCell *cell = [[JGPhotoShowCollectionViewCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iconImgv.hidden = NO;
    cell.iconImgv.layer.masksToBounds = YES;
    cell.iconImgv.contentMode = UIViewContentModeScaleAspectFill;
    cell.addBtn.hidden = YES;
    [cell.iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[_dataArray[indexPath.row] timeKey] integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
    return cell;
    //    }
    
    
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
    //    NSMutableArray * arr = [[NSMutableArray alloc]init];
    //    for (int i = 0; i < _dataArray.count; i++) {
    //        [arr addObject:[_dataArray[i]timeKey]];
    //    }
    //    JGTeamPhotoShowViewController *picVC = [[JGTeamPhotoShowViewController alloc]initWithIndex:indexPath.row];
    //    picVC.selectImages = arr;
    //    picVC.power = _power;
    //    picVC.dataArray = [[NSMutableArray alloc]init];
    //    for (int i = 0;  i < _dataArray.count; i ++) {
    //        [picVC.dataArray addObject:_dataArray[i]];
    //    }
    //    picVC.state = _state;
    //    picVC.teamTimeKey = _teamTimeKey;
    //    picVC.userKey = _userKey;
    //    picVC.teamName = _teamName;
    //    picVC.strTitle = _strTitle;
    //    picVC.deleteBlock = ^(NSInteger index) {
    //        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    //        [_collectionView.header beginRefreshing];
    //        [_collectionView reloadData];
    //    };
    //
    //    [self.navigationController pushViewController:picVC animated:YES];
    
    
    //    SDBrowserImageView *ymImageV = [[SDBrowserImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews withLittleArray:littleArray];
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _dataArray.count; i++) {
        [arr addObject:[_dataArray[i]timeKey]];
    }
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
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
        
        [_collectionView.header endRefreshing];
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_collectionView.header beginRefreshing];
        [_collectionView reloadData];
    };
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        
    } completion:^(BOOL finished) {
        [browser show];
    }];
    
    
    
    //    [sdImgV show:maskview didFinish:^(){
    //
    //        [UIView animateWithDuration:0.5f animations:^{
    //
    //            ymImageV.alpha = 0.0f;
    //            maskview.alpha = 0.0f;
    //
    //            JKSlideViewController *jks = self.navc.viewControllers[0];
    //            [UIApplication sharedApplication].windows[0].backgroundColor = [UIColor blackColor];
    //            jks.leftBtn.hidden = NO;
    //            jks.rightBtn.hidden = NO;
    //            jks.slideSwitchView.topView.hidden = NO;
    //
    //        } completion:^(BOOL finished) {
    //
    //            scrol.scrollEnabled = YES;
    //            [ymImageV removeFromSuperview];
    //            [maskview removeFromSuperview];
    //        }];
    //
    //    }];
    
    
    
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
