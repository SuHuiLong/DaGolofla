//
//  JKSlideViewController.m
//  sliderSegment
//
//  Created by shixiangyu on 15/10/11.
//

#import "JKSlideViewController.h"

#import "WXViewController.h"
#import "PublishViewController.h"
#import "Helper.h"
#import "ContactViewController.h"
#import "MyNewsBoxViewController.h"

#import "DetailViewController.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)

@interface JKSlideViewController ()
@property (nonatomic, strong) NSMutableArray *muArray; // 页面的数组
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation JKSlideViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.slideSwitchView.hidden = NO;
    self.tabBarController.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.slideSwitchView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setFrame:CGRectMake(0, 20*SCREEN_WIDTH/375, SCREEN_WIDTH/6*1, 40*SCREEN_WIDTH/375)];
    [self.leftBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundColor:[UIColor clearColor]];
    [self.leftBtn addTarget:self action:@selector(moreLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setFrame:CGRectMake(SCREEN_WIDTH/6*5, 20*SCREEN_WIDTH/375,SCREEN_WIDTH/6*1, 40*SCREEN_WIDTH/375)];
    [self.rightBtn setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundColor:[UIColor clearColor]];
    [self.rightBtn addTarget:self action:@selector(moreRightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBtn];

    
    
    
    _muArray = [[NSMutableArray alloc] init];
//    self.title = @"滑动切换视图";
    self.slideSwitchView.tabItemNormalColor = [JKSlideSwitchView colorFromHexRGB:@"DCDCDC"];
    self.slideSwitchView.tabItemSelectedColor = [JKSlideSwitchView colorFromHexRGB:@"FFFFFF"];
    self.slideSwitchView.bottomLineColor = [UIColor whiteColor];
    
    _titleArray = @[@"最新",@"热门",@"球友",@"附近"];
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        self.vc = [[WXViewController alloc] init];
        _vc.title = _titleArray[i];
        _vc.state = i - 1;
        _vc.navc = self.navigationController;
        [_muArray addObject:self.vc];
    }
    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(JKSlideSwitchView *)view
{
    return _muArray.count;
}

- (UIViewController *)slideSwitchView:(JKSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return _muArray[number];
}

- (void)slideSwitchView:(JKSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    WXViewController *vc = _muArray[number];
    [vc viewDidCurrentView];
    // 请求数据 用了显示的是哪一个
}

//发布话题
-(void)moreRightClick{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
        PublishViewController* pubVc = [[PublishViewController alloc]init];
        
        [self.navigationController pushViewController:pubVc animated:YES];
        //       //发布完成回调刷新
        pubVc.blockRereshing = ^(){
            self.vc = _muArray[0];
            [self.slideSwitchView selectFirst];
            [_muArray[0] returnFirRef];
            
        };

    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


//系统消息
-(void)moreLeftClick{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
        MyNewsBoxViewController * tVc = [[MyNewsBoxViewController alloc]init];
       
        WXViewController *vc = _muArray[0];
        tVc.nnewDataArray = vc.tableDataSource;
        
        [self.navigationController pushViewController:tVc animated:YES];
        
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}

@end
