//
//  PicArrShowViewControllerViewController.m
//  DagolfLa
//
//  Created by 张天宇 on 15/10/23.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "PicArrShowViewControllerViewController.h"
@interface PicArrShowViewControllerViewController ()<UIScrollViewDelegate>
@property (assign, nonatomic) NSInteger lastIndex;


@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) CGPoint offset;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger svIndex;


@property (strong, nonatomic) UIImageView *imageView;



@end

@implementation PicArrShowViewControllerViewController

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
    self.title = [NSString stringWithFormat:@"第%ld/%lu张", self.index + 1, (unsigned long)self.selectImages.count];
    [self savePicButton];
    [self initializeUserInterface];
}

-(void)savePicButton {
    UIButton *savePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [savePicBtn setImage:[UIImage imageNamed:@"xiaoxidian3"] forState:UIControlStateNormal];
    [savePicBtn setTitle:@"保存" forState:UIControlStateNormal];
    savePicBtn.titleLabel.textColor = [UIColor whiteColor];
    [savePicBtn setFrame:CGRectMake(0, 0, 40, 44)];
    [savePicBtn addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:savePicBtn];
    
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)saveImg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要保存此张照片到相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    if(!error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片保存成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        ////NSLog(@"savesuccess");
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片保存失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        ////NSLog(@"savefailed");
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
        
        [smView sd_setImageWithURL:[Helper imageUrl:[self.selectImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"xiangcemoren"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        if (_svIndex < 3) {
            _svIndex = self.index;
        }
        UIImageView *svView = [self.view viewWithTag:_svIndex+11];
        UIImageWriteToSavedPhotosAlbum(svView.image ,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    }
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
