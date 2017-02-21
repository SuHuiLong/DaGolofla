//
//  AdvertiseView.m
//  zhibo
//
//  Created by 周焕强 on 16/5/17.
//  Copyright © 2016年 zhq. All rights reserved.
//

#import "AdvertiseView.h"

@interface AdvertiseView()
//图片
@property (nonatomic, strong) UIImageView *adView;
//跳过按钮
@property (nonatomic, strong) UIButton *countBtn;
//定时器
@property (nonatomic, strong) NSTimer *countTimer;
//剩余显示时间
@property (nonatomic, assign) int count;
//界面已经消失
@property (nonatomic, assign) BOOL isDissmiss;
//倒计时label
@property (nonatomic, strong) UILabel *timeLable;
@end

// 广告显示的时间
static int const showtime = 3;

@implementation AdvertiseView
//初始化定时器
- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 1.广告图片
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];

        // 2.跳过按钮
        CGFloat btnW = kWvertical(50);
        CGFloat btnH = btnW;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kscreenWidth - btnW - kWvertical(20), kHvertical(25), btnW, btnH)];
        [_countBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
//         [UIColor colorWithHexString:[UIColor blackColor] alpha:0.5]];
        
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _timeLable = [Factory createLabelWithFrame:CGRectMake( 0, kWvertical(10), _countBtn.width, btnW/2-kWvertical(10)) textColor:WhiteColor fontSize:kHorizontal(14) Title:[NSString stringWithFormat:@"%ds", showtime]];
        _timeLable.backgroundColor = ClearColor;
        [_timeLable setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *skipLabel = [Factory createLabelWithFrame:CGRectMake( 0, btnW/2, _countBtn.width, btnW/2-kWvertical(10)) textColor:WhiteColor fontSize:kHorizontal(15) Title:@"跳过"];
        skipLabel.backgroundColor = ClearColor;
        [skipLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_countBtn addSubview:_timeLable];
        [_countBtn addSubview:skipLabel];
        
        
        _countBtn.layer.cornerRadius = btnW/2;
        _countBtn.layer.borderWidth = kWvertical(1);
        _countBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        
    }
    return self;
}
//加载本地照片
- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];

    if (image) {
        if (image.size.width>0) {
            _adView.image = image;
        }else{
            [self dismiss];
        }
    }else{
        [self dismiss];
    }
    
    
}

- (void)pushToAd{
    
    [self dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}

- (void)countDown
{
    _count --;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timeLable setText:[NSString stringWithFormat:@"%ds",_count]];
    });


    if (_count == 0) {

        [self dismiss];
    }
}
//开始计时
- (void)show
{
    // 倒计时方法1：GCD
//    [self startCoundown];
    
    // 倒计时方法2：定时器
    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

// 定时器倒计时
- (void)startTimer
{
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

// GCD倒计时
- (void)startCoundown
{
    __block int timeout = showtime + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismiss];
            });
        }else{

            dispatch_async(dispatch_get_main_queue(), ^{
                [_timeLable setText:[NSString stringWithFormat:@"%ds",timeout]];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 移除广告页面
- (void)dismiss
{
    if (_isDissmiss) {
        return;
    }
    _isDissmiss = true;
    [self.countTimer invalidate];
    self.countTimer = nil;
    _callBack();
//    [UIView animateWithDuration:1.0f animations:^{
//        self.alpha = 0.f;
//        
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//    }];

}


@end
