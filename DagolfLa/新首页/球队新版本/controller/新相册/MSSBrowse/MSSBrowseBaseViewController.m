//
//  MSSBrowseBaseViewController.m
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBrowseBaseViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+MSSScale.h"
#import "MSSBrowseRemindView.h"
#import "MSSBrowseActionSheet.h"
#import "MSSBrowseDefine.h"

@interface MSSBrowseBaseViewController ()

@property (nonatomic,strong)NSArray *browseItemArray;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)BOOL isRotate;// 判断是否正在切换横竖屏
@property (nonatomic,strong)UILabel *countLabel;// 当前图片位置
@property (nonatomic,strong)UIView *snapshotView;
@property (nonatomic,strong)NSMutableArray *verticalBigRectArray;
@property (nonatomic,strong)NSMutableArray *horizontalBigRectArray;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)UIDeviceOrientation currentOrientation;
@property (nonatomic,strong)MSSBrowseActionSheet *browseActionSheet;
@property (nonatomic,strong)MSSBrowseRemindView *browseRemindView;

@end

@implementation MSSBrowseBaseViewController


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    _closeAutorotate();
    
}

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex
{
    self = [super init];
    if(self)
    {
        _browseItemArray = browseItemArray;
        _currentIndex = currentIndex;
        _isEqualRatio = YES;
        _isFirstOpen = YES;
        _screenWidthD = MSS_SCREEN_WIDTH;
        _screenHeightD = MSS_SCREEN_HEIGHT;
        _currentOrientation = UIDeviceOrientationPortrait;
        _verticalBigRectArray = [[NSMutableArray alloc]init];
        _horizontalBigRectArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)showBrowseViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else
    {
        _snapshotView = [rootViewController.view snapshotViewAfterScreenUpdates:NO];
    }
    [rootViewController presentViewController:self animated:NO completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self createBrowseView];
}

- (void)initData
{
    for (MSSBrowseModel *browseItem in _browseItemArray)
    {
        CGRect verticalRect = CGRectZero;
        CGRect horizontalRect = CGRectZero;
        // 等比可根据小图宽高计算大图宽高
        if(_isEqualRatio)
        {
            if(browseItem.smallImageView)
            {
                verticalRect = [browseItem.smallImageView.image mss_getBigImageRectSizeWithScreenWidth:MSS_SCREEN_WIDTH screenheight:MSS_SCREEN_HEIGHT];
                horizontalRect = [browseItem.smallImageView.image mss_getBigImageRectSizeWithScreenWidth:MSS_SCREEN_HEIGHT screenheight:MSS_SCREEN_WIDTH];
            }
        }
        NSValue *verticalValue = [NSValue valueWithCGRect:verticalRect];
        [_verticalBigRectArray addObject:verticalValue];
        NSValue *horizontalValue = [NSValue valueWithCGRect:horizontalRect];
        [_horizontalBigRectArray addObject:horizontalValue];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)createBrowseView
{
    self.view.backgroundColor = [UIColor blackColor];
    if(_snapshotView)
    {
        _snapshotView.hidden = YES;
        [self.view addSubview:_snapshotView];
    }
    
    _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    // 布局方式改为从上至下，默认从左到右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // Section Inset就是某个section中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 每行内部cell item的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 每行的间距
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _screenWidthD + kBrowseSpace, _screenHeightD) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[MSSBrowseCollectionViewCell class] forCellWithReuseIdentifier:@"MSSBrowserCell"];
    _collectionView.contentOffset = CGPointMake(_currentIndex * (_screenWidthD + kBrowseSpace), 0);
    [_bgView addSubview:_collectionView];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.frame = CGRectMake(0, _screenHeightD - 50, _screenWidthD, 50);
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentIndex + 1,(long)_browseItemArray.count];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_countLabel];
    
    _browseRemindView = [[MSSBrowseRemindView alloc]initWithFrame:_bgView.bounds];
    [_bgView addSubview:_browseRemindView];
}


#pragma mark UIColectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSBrowserCell" forIndexPath:indexPath];
    if(cell)
    {        
        MSSBrowseModel *browseItem = [_browseItemArray objectAtIndex:indexPath.row];
        // 还原初始缩放比例
        cell.zoomScrollView.frame = CGRectMake(0, 0, _screenWidthD, _screenHeightD);
        cell.zoomScrollView.zoomScale = 1.0f;
        // 将scrollview的contentSize还原成缩放前
        cell.zoomScrollView.contentSize = CGSizeMake(_screenWidthD, _screenHeightD);
        cell.zoomScrollView.zoomImageView.contentMode = browseItem.smallImageView.contentMode;
        cell.zoomScrollView.zoomImageView.clipsToBounds = browseItem.smallImageView.clipsToBounds;
        [cell.loadingView mss_setFrameInSuperViewCenterWithSize:CGSizeMake(30, 30)];
        CGRect bigImageRect = [_verticalBigRectArray[indexPath.row] CGRectValue];
        if(_currentOrientation != UIDeviceOrientationPortrait)
        {
            bigImageRect = [_horizontalBigRectArray[indexPath.row] CGRectValue];
        }
        [self loadBrowseImageWithBrowseItem:browseItem Cell:cell bigImageRect:bigImageRect];
        
        __weak __typeof(self)weakSelf = self;
        [cell tapClick:^(MSSBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf tap:browseCell];
        }];
        [cell longPress:^(MSSBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [[SDImageCache sharedImageCache] diskImageExistsWithKey:browseItem.bigImageUrl completion:^(BOOL isInCache) {
                if (isInCache) {
                    [strongSelf longPress:browseCell];
                }
            }];
        }];
    }
    return cell;
}

// 子类重写此方法
- (void)loadBrowseImageWithBrowseItem:(MSSBrowseModel *)browseItem Cell:(MSSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect
{

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _browseItemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_screenWidthD + kBrowseSpace, _screenHeightD);
}

#pragma mark UIScrollViewDeletate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_isRotate)
    {
        _currentIndex = scrollView.contentOffset.x / (_screenWidthD + kBrowseSpace);
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentIndex + 1,(long)_browseItemArray.count];
    }
    _isRotate = NO;
}

#pragma mark Tap Method
- (void)tap:(MSSBrowseCollectionViewCell *)browseCell
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    if(_snapshotView)
    {
        _snapshotView.hidden = NO;
    }
    else
    {
        self.view.backgroundColor = [UIColor clearColor];
    }
    // 集合视图背景色设置为透明
    _collectionView.backgroundColor = [UIColor clearColor];
    // 动画结束前不可点击透明背景后的内容
    _collectionView.userInteractionEnabled = NO;
    // 显示状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    // 停止加载
    NSArray *cellArray = _collectionView.visibleCells;
    for (MSSBrowseCollectionViewCell *cell in cellArray)
    {
        [cell.loadingView stopAnimation];
    }
    [_countLabel removeFromSuperview];
    _countLabel = nil;
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:browseCell];
    browseCell.zoomScrollView.zoomScale = 1.0f;
    MSSBrowseModel *browseItem = _browseItemArray[indexPath.row];
    /*
     建议小图列表的collectionView尽量不要复用，因为当小图的列表collectionview复用时，传进来的BrowseItem数组只有当前显示cell的smallImageView，在当前屏幕外的cell上的小图由于复用关系实际是没有的，所以只能有简单的渐变动画
     */
    if(browseItem.smallImageView)
    {
        CGRect rect = [self getFrameInWindow:browseItem.smallImageView];
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        if(_currentOrientation == UIDeviceOrientationLandscapeLeft)
        {
            transform = CGAffineTransformMakeRotation(- M_PI / 2);
            rect = CGRectMake(rect.origin.y, MSS_SCREEN_WIDTH - rect.size.width - rect.origin.x, rect.size.height, rect.size.width);
        }
        else if(_currentOrientation == UIDeviceOrientationLandscapeRight)
        {
            transform = CGAffineTransformMakeRotation(M_PI / 2);
            rect = CGRectMake(MSS_SCREEN_HEIGHT - rect.size.height - rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
        }
        [UIView animateWithDuration:0.5 animations:^{
            browseCell.zoomScrollView.zoomImageView.transform = transform;
            browseCell.zoomScrollView.zoomImageView.frame = rect;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }];
    }
}

- (void)longPress:(MSSBrowseCollectionViewCell *)browseCell
{
    [_browseActionSheet removeFromSuperview];
    _browseActionSheet = nil;
    __weak __typeof(self)weakSelf = self;
    
    
    if ([_browseItemArray[0] power]) {
        if ([[_browseItemArray[0] power] containsString:@"1005"] == YES) {
            _browseActionSheet = [[MSSBrowseActionSheet alloc]initWithTitleArray:@[@"保存",@"分享",@"删除"] cancelButtonTitle:@"取消" didSelectedBlock:^(NSInteger index) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf browseActionSheetDidSelectedAtIndex:index currentCell:browseCell];
            }];
            
        }else{
            _browseActionSheet = [[MSSBrowseActionSheet alloc]initWithTitleArray:@[@"保存",@"分享"] cancelButtonTitle:@"取消" didSelectedBlock:^(NSInteger index) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf browseActionSheetDidSelectedAtIndex:index currentCell:browseCell];
            }];
        }
    }else{
        // 社区过来的
        _browseActionSheet = [[MSSBrowseActionSheet alloc]initWithTitleArray:@[@"保存图片"] cancelButtonTitle:@"取消" didSelectedBlock:^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf browseActionSheetDidSelectedAtIndex:index currentCell:browseCell];
        }];

    }
    

    [_browseActionSheet showInView:_bgView];
}

#pragma mark StatusBar Method
- (BOOL)prefersStatusBarHidden
{
//    if(!_collectionView.userInteractionEnabled)
//    {
        return NO;
//    }
//    return YES;
}

#pragma mark Orientation Method
- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        _isRotate = YES;
        _currentOrientation = orientation;
        if(_currentOrientation == UIDeviceOrientationPortrait)
        {
            _screenWidthD = MSS_SCREEN_WIDTH;
            _screenHeightD = MSS_SCREEN_HEIGHT;
            [UIView animateWithDuration:0.5 animations:^{
                _bgView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        else
        {
            _screenWidthD = MSS_SCREEN_HEIGHT;
            _screenHeightD = MSS_SCREEN_WIDTH;
            if(_currentOrientation == UIDeviceOrientationLandscapeLeft)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    _bgView.transform = CGAffineTransformMakeRotation(M_PI / 2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    _bgView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
                }];
            }
        }
        _bgView.frame = CGRectMake(0, 0, MSS_SCREEN_WIDTH, MSS_SCREEN_HEIGHT);
        _browseRemindView.frame = CGRectMake(0, 0, _screenWidthD, _screenHeightD);
        if(_browseActionSheet)
        {
            [_browseActionSheet updateFrame];
        }
        _countLabel.frame = CGRectMake(0, _screenHeightD - 50, _screenWidthD, 50);
        [_collectionView.collectionViewLayout invalidateLayout];
        _collectionView.frame = CGRectMake(0, 0, _screenWidthD + kBrowseSpace, _screenHeightD);
        _collectionView.contentOffset = CGPointMake((_screenWidthD + kBrowseSpace) * _currentIndex, 0);
        [_collectionView reloadData];
    }
}

#pragma mark MSSActionSheetClick
- (void)browseActionSheetDidSelectedAtIndex:(NSInteger)index currentCell:(MSSBrowseCollectionViewCell *)currentCell
{    // 保存图片
    if(index == 0)
    {
        UIImageWriteToSavedPhotosAlbum(currentCell.zoomScrollView.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    // 复制图片地址
    else if(index == 1)
    {
        
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.tag = 1001;
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index];
        }];
        [self.view addSubview:alert];

        
//        [self shareInfo:_currentIndex];
//        MSSBrowseModel *currentBwowseItem = _browseItemArray[_currentIndex];
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = currentBwowseItem.bigImageUrl;
//        [self showBrowseRemindViewWithText:@"复制图片地址成功"];
    }else if (index == 2)
    {
        [self deleteImage];
    }

    
    //     if ([_power containsString:@"1005"] == YES || [DEFAULF_USERID integerValue] == [_userKey integerValue]) {

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *text = nil;
    if(error)
    {
        text = @"保存图片失败";
    }
    else
    {
        text = @"保存图片成功";
    }
    [self showBrowseRemindViewWithText:text];
}

#pragma mark RemindView Method
- (void)showBrowseRemindViewWithText:(NSString *)text
{
    [_browseRemindView showRemindViewWithText:text];
    _bgView.userInteractionEnabled = NO;
    [self performSelector:@selector(hideRemindView) withObject:nil afterDelay:0.7];
}

- (void)hideRemindView
{
    [_browseRemindView hideRemindView];
    _bgView.userInteractionEnabled = YES;
}


//删除按钮
-(void)deleteImage
{
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"正在删除...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@[[_browseItemArray[_currentIndex] currentPhotoKey]] forKey:@"timeKeyList"];
    [dict setObject:[_browseItemArray[_currentIndex] timeKey] forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/batchDeleteTeamMedia" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    } completionBlock:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            _blockRef();
            dispatch_main_async_safe(^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}


#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
    
    //meida的timekey和球队key
    //    JGPhotoListModel* model = _arrayData[self.currentImageIndex];
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamPhotoShare.html?mediaKey=%@&teamKey=%@",[_browseItemArray[self.currentIndex] currentPhotoKey], [_browseItemArray[self.currentIndex] timeKey]];
    [UMSocialData defaultData].extConfig.title = [_browseItemArray[self.currentIndex] albumTitle];
    NSData* fiData;
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[_browseItemArray[self.currentIndex] currentPhotoKey] integerValue] andIsSetWidth:NO andIsBackGround:NO]];
    if (index == 0){
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[_browseItemArray[self.currentIndex] teamName]  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            [self removeFromSuperview];
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
                
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[_browseItemArray[self.currentIndex] teamName] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            [self removeFromSuperview];
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(nil,[UMSocialControllerService defaultControllerService],YES);
//        [self removeFromSuperview];
    }
    
}









@end
