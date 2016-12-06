//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"

 
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================
@class JGPhotoAlbumViewController;
@implementation SDPhotoBrowser 
{
//    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
//    UILabel *_indexLabel;
    UIButton *_saveButton, * _shareButton,*_deleteButton;
    UIButton* _btnBack;
    UIActivityIndicatorView *_indicatorView;
    
//    int _indexScroll;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indexScroll = 0;
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
        
        _btnBack = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnBack.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        _btnBack.backgroundColor = [UIColor clearColor];
        [self addSubview:_btnBack];
        [_btnBack addTarget:self action:@selector(hideShareClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)hideShareClick:(UIButton *)btn
{
    
    [self didMoveToSuperview];
}

- (void)didMoveToSuperview
{
//    self.hidden = YES;

    ShareAlert* alert = (ShareAlert* )[self viewWithTag:1001];
    [alert removeFromSuperview];
    
    [self setupScrollView];
    
    [self setupToolbars];
    
    
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.tag = 200;
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"%d/%ld", self.currentImageIndex+1, (long)self.imageCount];
        _indexScroll = _currentImageIndex;
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    // 1.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
    
    
    
    //2.删除按钮
    if ([_power containsString:@"1005"] == YES || [DEFAULF_USERID integerValue] == [_userKey integerValue]) {
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        deleteButton.frame = CGRectMake(ScreenWidth/2 - 25, self.bounds.size.height - 70, 50, 25);
        deleteButton.layer.cornerRadius = 5;
        deleteButton.clipsToBounds = YES;
        [deleteButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton = deleteButton;
        [self addSubview:deleteButton];
    }

    
    
    
    
    // 3.分享按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    shareButton.frame = CGRectMake(ScreenWidth - 80, self.bounds.size.height - 70, 50, 25);
    shareButton.layer.cornerRadius = 5;
    shareButton.clipsToBounds = YES;
    [shareButton addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    _shareButton = shareButton;
    [self addSubview:shareButton];
    
}
//删除按钮
-(void)deleteImage
{
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"正在删除...";
    [self addSubview:progress];
    [progress show:YES];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@[[self.arrayData objectAtIndex:_indexScroll]] forKey:@"timeKeyList"];
    [dict setObject:_teamTimeKey forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/batchDeleteTeamMedia" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [MBProgressHUD hideAllHUDsForView:self animated:NO];
    } completionBlock:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self animated:NO];
        
        
        self.hidden = YES;
        _saveButton.hidden = YES;
        _shareButton.hidden = YES;
        _deleteButton.hidden = YES;
        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
        _blockRef();
    }];
}


#pragma mark --分享点击事件
-(void)shareImage
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.tag = 1001;
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self addSubview:alert];
//        self.hidden = YES;
        _saveButton.hidden = YES;
        _shareButton.hidden = YES;
        _deleteButton.hidden = YES;

        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
            
        } completion:^(BOOL finished) {
            _saveButton.hidden = NO;
            _shareButton.hidden = NO;
            _deleteButton.hidden = NO;
        }];
    
    }];
}
static int _indexScroll = 0;
#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
    
    //meida的timekey和球队key
//    JGPhotoListModel* model = _arrayData[self.currentImageIndex];
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamPhotoShare.html?mediaKey=%@&teamKey=%@",_arrayData[_indexScroll],_teamTimeKey];
    [UMSocialData defaultData].extConfig.title = _strTitle;
    NSData* fiData;
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[self.arrayData objectAtIndex:_indexScroll] integerValue] andIsSetWidth:NO andIsBackGround:NO]];
    if (index == 0){
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_teamName  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            [self removeFromSuperview];
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
                
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_teamName image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            [self removeFromSuperview];
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
        [self removeFromSuperview];
    }
    
}


#pragma mark --保存图片
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
//        imageView.tag = 1000;
        
        imageView.tag = i;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:singleTap];
        [_scrollView addSubview:imageView];
    }
    
    
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    if (imageView.hasLoadedImage) {
        return;
    }
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(removePhotoBrowser)]) {
            [self.delegate removePhotoBrowser];
        }
        
        [self removeFromSuperview];
    }];
    
    
//    _scrollView.hidden = YES;
//    
//    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
//    NSInteger currentIndex = currentImageView.tag;
//    
//    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
//    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
//    
//    UIImageView *tempView = [[UIImageView alloc] init];
//    tempView.image = currentImageView.image;
//    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
//    
//    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
//        h = self.bounds.size.height;
//    }
//    
//    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
//    tempView.center = self.center;
//    
//    [self addSubview:tempView];
//
//    _saveButton.hidden = YES;
//    _shareButton.hidden = YES;
//    _deleteButton.hidden = YES;
//    
//    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
//        tempView.frame = targetTemp;
//        self.backgroundColor = [UIColor clearColor];
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = SDPhotoBrowserImageViewMargin;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    
//    if (!_hasShowedFistView) {
//        [self showFirstImage];
//    }
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)showFirstImage
{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}


#pragma mark --delegate
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    NSArray  *arr  =  _scrollView.subviews;
    if( index > 0 ){
        SDBrowserImageView *imageView  =  arr[index-1];
        [imageView reset:[self placeholderImageForIndex:(index-1)]];
    }
    if( index < arr.count-1 ){
        SDBrowserImageView *imageView  =  arr[index+1];
        [imageView reset:[self placeholderImageForIndex:(index+1)]];
    }
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    _indexScroll = index;
    [self setupImageOfImageViewForIndex:index];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
