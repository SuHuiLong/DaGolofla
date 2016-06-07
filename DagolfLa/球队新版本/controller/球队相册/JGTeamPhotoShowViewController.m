//
//  PicArrShowViewControllerViewController.m
//  DagolfLa
//
//  Created by 张天宇 on 15/10/23.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "JGTeamPhotoShowViewController.h"

@interface JGTeamPhotoShowViewController ()<UIScrollViewDelegate>
{
    BOOL _isDelete;
}
@property (assign, nonatomic) NSInteger lastIndex;


@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) CGPoint offset;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger svIndex;


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
    [self savePicButton];
    [self initializeUserInterface];
}

-(void)savePicButton {
    if ([_power containsString:@"1005"] == YES) {
        UIButton *savePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [savePicBtn setTitle:@"编辑" forState:UIControlStateNormal];
        savePicBtn.titleLabel.textColor = [UIColor whiteColor];
        [savePicBtn setFrame:CGRectMake(0, 0, 40, 44)];
        [savePicBtn addTarget:self action:@selector(editImageImg) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:savePicBtn];
        
        self.navigationItem.rightBarButtonItem = saveItem;
    }
    else
    {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
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
-(void)editImageImg {
    
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //保存
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"保存照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    //删除
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"删除照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Helper alertViewWithTitle:@"是否确定要删除照片" withBlockCancle:^{
            
        } withBlockSure:^{
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            [dict setObject:@[[self.selectImages objectAtIndex:self.index]] forKey:@"timeKeyList"];
            [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
            [[JsonHttp jsonHttp]httpRequest:@"team/batchDeleteTeamMedia" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
                NSLog(@"errType == %@", errType);
            } completionBlock:^(id data) {
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
                self.title = [NSString stringWithFormat:@"第%d/%lu张", (long)self.index + 1, (unsigned long)self.selectImages.count];
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
        [Helper alertViewWithTitle:@"照片保存成功!" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }else{
        [Helper alertViewWithTitle:@"照片保存失败!" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
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
        [smView sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[[self.selectImages objectAtIndex:i] integerValue] andIsSetWidth:NO andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xiangcemoren.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
