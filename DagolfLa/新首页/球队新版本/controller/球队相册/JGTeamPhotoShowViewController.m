//
//  PicArrShowViewControllerViewController.m
//  DagolfLa
//
//  Created by 张天宇 on 15/10/23.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "JGTeamPhotoShowViewController.h"
#import "JGPhotoListModel.h"
@interface JGTeamPhotoShowViewController ()<UIScrollViewDelegate>
{
    BOOL _isDelete;
}
@property (assign, nonatomic) NSInteger lastIndex;


@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) CGPoint offset;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger svIndex;//滑动后所展示图的比例，width/screenwidth


@property (strong, nonatomic) UIImageView *imageView;



@end

@implementation JGTeamPhotoShowViewController

- (instancetype)initWithIndex:(NSInteger)index{
    
    self = [super init];
    
    if (self) {
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [NSString stringWithFormat:@"第%td/%lu张", (long)self.index + 1, (unsigned long)self.selectImages.count];
    [self initializeUserInterface];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
}
#pragma mark --分享点击事件
-(void)shareButtonClcik
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(210));
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
    
    //meida的timekey和球队key
    JGPhotoListModel* model = _dataArray[self.index];
    NSString*  shareUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/share/team/teamPhotoShare.html?mediaKey=%@&teamKey=%@",model.timeKey,_teamTimeKey];
    [UMSocialData defaultData].extConfig.title = _strTitle;
    NSData* fiData;
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[self.selectImages objectAtIndex:self.index] integerValue] andIsSetWidth:NO andIsBackGround:NO]];
    if (index == 0){
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_teamName  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_teamName image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:fiData];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    
}

#pragma mark --没有权限只能保存图片
-(void)saveClick
{
    
    [Helper alertViewWithTitle:@"是否确定要保存照片" withBlockCancle:^{
        
    } withBlockSure:^{
    if (_svIndex < 3) {
        _svIndex = self.index;
    }
    UIImageView *svView = [self.view viewWithTag:_svIndex+11];
    UIImageWriteToSavedPhotosAlbum(svView.image ,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    } withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}
#pragma mark --有权限可以删除图片
-(void)editImageClick {
    
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //保存
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"保存照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (_svIndex < 3) {
            _svIndex = self.index;
        }
        UIImageView *svView = [self.view viewWithTag:_svIndex+11];
        UIImageWriteToSavedPhotosAlbum(svView.image ,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);

    }];
    //删除
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"删除照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Helper alertViewWithTitle:@"是否确定要删除照片" withBlockCancle:^{
            
        } withBlockSure:^{
            
            MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
            progress.mode = MBProgressHUDModeIndeterminate;
            progress.labelText = @"正在删除...";
            [self.view addSubview:progress];
            [progress show:YES];
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            [dict setObject:@[[self.selectImages objectAtIndex:self.index]] forKey:@"timeKeyList"];
            [dict setObject:_teamTimeKey forKey:@"teamKey"];
            [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
            [[JsonHttp jsonHttp]httpRequest:@"team/batchDeleteTeamMedia" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
                NSLog(@"errType == %@", errType);
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            } completionBlock:^(id data) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                _isDelete = YES;
                if (_deleteBlock) {
                    _deleteBlock(_index);
                }
                int flag = 0;
                if (self.index + 1 == self.selectImages.count) {
                    flag = 1;
                    self.index --;
                } else {
                    for (NSInteger i = self.index + 1; i < self.scrollView.subviews.count; i ++) {
                        UIView *subView = self.scrollView.subviews[i];
                        [subView setFrame:CGRectMake(subView.frame.origin.x - CGRectGetWidth(subView.bounds), 0, CGRectGetWidth(subView.bounds), CGRectGetHeight(subView.bounds))];
                    }
                }
                
                if (self.index == -1) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.selectImages removeAllObjects];
                    return;
                }
                [self.selectImages removeObjectAtIndex:self.index + flag];
                [self.scrollView.subviews[self.index + flag] removeFromSuperview];
                self.title = [NSString stringWithFormat:@"第%ld/%lu张", (long)self.index + 1, (unsigned long)self.selectImages.count];
                self.scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.selectImages.count, _scrollView.bounds.size.height);
            }];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    if(!error){
        [[ShowHUD showHUD]showToastWithText:@"照片保存成功!" FromView:self.view];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"照片保存失败!" FromView:self.view];
    }
}

- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.selectImages.count, _scrollView.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(_index * _scrollView.bounds.size.width, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    self.offset = _scrollView.contentOffset;
    [self.view addSubview:_scrollView];
    /**
     *  在图片上加长按手势
     */
    if ([_state integerValue] == 1) {
        if ([_power containsString:@"1005"] == YES || [DEFAULF_USERID integerValue] == [_userKey integerValue]) {
            //像这种控件的长按事件有些地方是有系统自带的。但有些时候用起来也不太方便。下面这个可能以后能用到
            UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editImageClick)];
            longPressReger.minimumPressDuration = 1.0;
            [_scrollView addGestureRecognizer:longPressReger];
        }
        else
        {
            //像这种控件的长按事件有些地方是有系统自带的。但有些时候用起来也不太方便。下面这个可能以后能用到
            UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveClick)];
            longPressReger.minimumPressDuration = 1.0;
            [_scrollView addGestureRecognizer:longPressReger];
        }
    }
    else
    {
        //像这种控件的长按事件有些地方是有系统自带的。但有些时候用起来也不太方便。下面这个可能以后能用到
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveClick)];
        longPressReger.minimumPressDuration = 1.0;
        [_scrollView addGestureRecognizer:longPressReger];
    }
    
    [self resetScrollViewSubViews];
    
}

- (void)resetScrollViewSubViews {
    
    for (int i = 0; i < self.selectImages.count; i++) {
        
        UIScrollView *smallScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight - 64)];
        //        smallScrollview.backgroundColor = [UIColor blueColor];
        smallScrollview.showsHorizontalScrollIndicator = NO;
        smallScrollview.showsVerticalScrollIndicator = NO;
        smallScrollview.tag = 200;
        ////NSLog(@"%d",i);
        
        UIImageView *smView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [smView sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[self.selectImages objectAtIndex:i] integerValue] andIsSetWidth:NO andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xiangcemoren"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [smView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * (smView.image.size.height/smView.image.size.width))];
            CGFloat offsetX = (smallScrollview.bounds.size.width > smallScrollview.contentSize.width)?(smallScrollview.bounds.size.width - smallScrollview.contentSize.width)/2 : 0.0;
            CGFloat offsetY = (smallScrollview.bounds.size.height > smallScrollview.contentSize.height)?(smallScrollview.bounds.size.height - smallScrollview.contentSize.height)/2 : 0.0;
            smView.center = CGPointMake(smallScrollview.contentSize.width/2 + offsetX,smallScrollview.contentSize.height/2 + offsetY);
        }];
        
        CGFloat offsetX = (smallScrollview.bounds.size.width > smallScrollview.contentSize.width)?(smallScrollview.bounds.size.width - smallScrollview.contentSize.width)/2 : 0.0;
        CGFloat offsetY = (smallScrollview.bounds.size.height > smallScrollview.contentSize.height)?(smallScrollview.bounds.size.height - smallScrollview.contentSize.height)/2 : 0.0;
        smView.center = CGPointMake(smallScrollview.contentSize.width/2 + offsetX,smallScrollview.contentSize.height/2 + offsetY);
        smView.contentMode =  UIViewContentModeScaleAspectFit;
        
        [smallScrollview addSubview:smView];
        [_scrollView addSubview:smallScrollview];
        smallScrollview.minimumZoomScale = 1;
        smallScrollview.maximumZoomScale = 2;
        smallScrollview.delegate = self;
        smView.userInteractionEnabled = YES;
        smView.tag = i+11;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 200) {//如果是小scrollview
        return;
    }
    NSInteger currentindex = scrollView.contentOffset.x/scrollView.frame.size.width ;//获取当前位置
    if (_lastIndex != currentindex) {//如果上次的位置与本次的位置不同
        
        UIScrollView * smallView =  (UIScrollView *)scrollView.subviews[_lastIndex];
        smallView.zoomScale = 1;//放大倍数改为1
        
        _lastIndex =  currentindex;//记录上次的位置
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView = _scrollView;
    _svIndex = scrollView.contentOffset.x /scrollView.frame.size.width;
    self.title = [NSString stringWithFormat:@"第%.0f/%lu张", scrollView.contentOffset.x /scrollView.frame.size.width+ 1, (unsigned long)self.selectImages.count];
    
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == 200) {
        //小scrollview
        return scrollView.subviews[0];
        
    }else{
        return nil;
    }
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.tag == 200) {
        
        
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
        
        for (UIView *v in scrollView.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                v.center = CGPointMake(scrollView.contentSize.width/2 + offsetX, scrollView.contentSize.height/2 + offsetY);
            }
        }
    }
}


@end
