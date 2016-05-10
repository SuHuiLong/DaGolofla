//
//  ALMoviePlayerControls.m
//  ALMoviePlayerController
//
//  Created by Anthony Lobianco on 10/8/13.
//  Copyright (c) 2013 Anthony Lobianco. All rights reserved.
//

#import "ALMoviePlayerControls.h"
#import "ALMoviePlayerController.h"
#import "ALAirplayView.h"
#import <tgmath.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIDevice (ALSystemVersion)

+ (float)iOSVersions {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

@end

@interface ALMoviePlayerControlsBar : UIView
@property (nonatomic, strong) UIColor *color;
@end

static const inline BOOL isIpad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
static const CGFloat activityIndicatorSize = 40.f;
static CGFloat iPhoneScreenPortraitWidth;
static CGFloat iPhoneScreenPortraitHeight;


@interface ALMoviePlayerControls () <ALAirplayViewDelegate, ALButtonDelegate> {
@private
    NSInteger windowSubviews;
}

@property (nonatomic, weak) ALMoviePlayerController *moviePlayer;
@property (nonatomic, assign) ALMoviePlayerControlsState state;
@property (nonatomic, getter = isShowing) BOOL showing;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, strong) UIView *activityBackgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) ALMoviePlayerControlsBar *topBar;
@property (nonatomic, strong) ALMoviePlayerControlsBar *bottomBar;
@property (nonatomic, strong) UISlider *durationSlider;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) ALButton *fullscreenButton;
@property (nonatomic, strong) ALButton *backforwardButton;//返回按钮

@property (nonatomic, strong) UILabel *timeRemainingLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ALMoviePlayerControls

# pragma mark - Construct/Destruct
- (id)initWithMoviePlayer:(ALMoviePlayerController *)moviePlayer style:(ALMoviePlayerControlsStyle)style {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _moviePlayer = moviePlayer;
        _style = style;
        _showing = NO;
        _fadeDelay = 5.0;
        _timeRemainingDecrements = NO;
//        _barColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        
        iPhoneScreenPortraitWidth = [UIScreen mainScreen].bounds.size.width;
        iPhoneScreenPortraitHeight = [UIScreen mainScreen].bounds.size.height;

        //in fullscreen mode, move controls away from top status bar and bottom screen bezel. I think the iOS7 control center gestures interfere with the uibutton touch events. this will alleviate that a little (correct me if I'm wrong and/or adjust if necessary).
        _barHeight = 40.f;
        
        _state = ALMoviePlayerControlsStateIdle;
        
        [self setup];
        [self addNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_durationTimer invalidate];
    [self nilDelegates];
}

# pragma mark - Construct/Destruct Helpers
- (void)setup {
    if (self.style == ALMoviePlayerControlsStyleNone){
        return;
    }
    //top bar
    _topBar = [[ALMoviePlayerControlsBar alloc] init];
    _topBar.color = _barColor;
    _topBar.alpha = 0.f;
    [self addSubview:_topBar];
    
    //bottom bar
    _bottomBar = [[ALMoviePlayerControlsBar alloc] init];
    _bottomBar.color = _barColor;
    _bottomBar.alpha = 0.f;
    [self addSubview:_bottomBar];
    
    //进度条
    _durationSlider = [[UISlider alloc] init];
    _durationSlider.value = 0.f;
    _durationSlider.continuous = YES;
    _durationSlider.thumbTintColor = [UIColor clearColor];
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"videobarProgressbarIcon"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:0.0];
    [_durationSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"vedioProgressbarDot"];
    [_durationSlider setThumbImage:image forState:UIControlStateNormal];
    [_durationSlider setThumbImage:image forState:UIControlStateHighlighted];
    [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];

    
    //时间
    _timeRemainingLabel = [[UILabel alloc] init];
    _timeRemainingLabel.backgroundColor = [UIColor clearColor];
    _timeRemainingLabel.font = [UIFont systemFontOfSize:12.f];
    _timeRemainingLabel.textColor = [UIColor lightTextColor];
    _timeRemainingLabel.textAlignment = NSTextAlignmentCenter;
    _timeRemainingLabel.text = @"0:00";
    _timeRemainingLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeRemainingLabel.layer.shadowRadius = 1.f;
    _timeRemainingLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeRemainingLabel.layer.shadowOpacity = 0.8f;
    _timeRemainingLabel.hidden = YES;
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"标题";
    _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _titleLabel.layer.shadowRadius = 1.f;
    _titleLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _titleLabel.layer.shadowOpacity = 0.8f;
    [_topBar addSubview:_titleLabel];
    
    
    if (_style == ALMoviePlayerControlsStyleFullscreen || (_style == ALMoviePlayerControlsStyleDefault && _moviePlayer.isFullscreen)) {
        [_bottomBar addSubview:_durationSlider];
        [_bottomBar addSubview:_timeRemainingLabel];
        
        
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.backgroundColor = [UIColor redColor];
        [_volumeView setShowsRouteButton:NO];
        [_volumeView setShowsVolumeSlider:YES];
        [_bottomBar addSubview:_volumeView];
        
    }else if (_style == ALMoviePlayerControlsStyleEmbedded || (_style == ALMoviePlayerControlsStyleDefault && !_moviePlayer.isFullscreen)) {
        [_bottomBar addSubview:_durationSlider];
        [_bottomBar addSubview:_timeRemainingLabel];
        
    }

    //static stuff
    _playPauseButton = [[ALButton alloc] init];
    [_playPauseButton setImage:[UIImage imageNamed:@"vedioStopBtn"] forState:UIControlStateNormal];
    [_playPauseButton setImage:[UIImage imageNamed:@"vedioPlayBtn"] forState:UIControlStateSelected];
    [_playPauseButton setSelected:_moviePlayer.playbackState == MPMoviePlaybackStatePlaying ? NO : YES];
    [_playPauseButton addTarget:self action:@selector(playPausePressed:) forControlEvents:UIControlEventTouchUpInside];
    _playPauseButton.delegate = self;
    [_bottomBar addSubview:_playPauseButton];
    
    
    _activityBackgroundView = [[UIView alloc] init];
    [_activityBackgroundView setBackgroundColor:[UIColor blackColor]];
    _activityBackgroundView.alpha = 0.f;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.alpha = 0.f;
    _activityIndicator.hidesWhenStopped = YES;
    
    //是否 全屏 按钮
    _fullscreenButton  = [[ALButton alloc] init];
    [_fullscreenButton setImage:[UIImage imageNamed:@"vedioFullscreenBtn"] forState:UIControlStateNormal];
    [_fullscreenButton setImage:[UIImage imageNamed:@"videoShrinkageBtnHl"] forState:UIControlStateSelected];
    [_fullscreenButton addTarget:self action:@selector(fullscreenPressed:) forControlEvents:UIControlEventTouchUpInside];
    _fullscreenButton.delegate = self;
    [_bottomBar addSubview:_fullscreenButton];
    
    //返回按钮
    _backforwardButton = [[ALButton alloc] init];
    _backforwardButton.hidden = YES;
    [_backforwardButton setImage:[UIImage imageNamed:@"backAppbarBtn"] forState:UIControlStateNormal];
    [_backforwardButton setImage:[UIImage imageNamed:@"backAppbarBtnHl"] forState:UIControlStateSelected];
    [_backforwardButton addTarget:self action:@selector(fullscreenPressed:) forControlEvents:UIControlEventTouchUpInside];
    _backforwardButton.delegate = self;
    [_topBar addSubview:_backforwardButton];
}

- (void)resetViews {
    [self stopDurationTimer];
    [self nilDelegates];
    [_topBar removeFromSuperview];
    [_bottomBar removeFromSuperview];
}

- (void)nilDelegates {
    _playPauseButton.delegate = nil;
    _fullscreenButton.delegate = nil;
}

# pragma mark - Setters
- (void)setStyle:(ALMoviePlayerControlsStyle)style {
    if (_style != style) {
        BOOL flag = _style == ALMoviePlayerControlsStyleDefault;
        [self hideControls:^{
            [self resetViews];
            _style = style;
            [self setup];
            if (_style != ALMoviePlayerControlsStyleNone) {
                double delayInSeconds = 0.2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self setDurationSliderMaxMinValues];
                    [self monitorMoviePlayback]; //resume values
                    [self startDurationTimer];
                    [self showControls:^{
                        if (flag) {
                            //put style back to default
                            _style = ALMoviePlayerControlsStyleDefault;
                        }
                    }];
                });
            } else {
                if (flag) {
                    //put style back to default
                    _style = ALMoviePlayerControlsStyleDefault;
                }
            }
        }];
    }
}

- (void)setState:(ALMoviePlayerControlsState)state {
    if (_state != state) {
        _state = state;
        
        switch (state) {
            case ALMoviePlayerControlsStateLoading:
                [self showLoadingIndicators];
                break;
            case ALMoviePlayerControlsStateReady:
                [self hideLoadingIndicators];
                break;
            case ALMoviePlayerControlsStateIdle:
            default:
                break;
        }
    }
}

- (void)setBarColor:(UIColor *)barColor {
    if (_barColor != barColor) {
        _barColor = barColor;
        [self.topBar setColor:barColor];
        [self.bottomBar setColor:barColor];
    }
}

-(void)setVideoTitles:(NSString *)videoTitles{
    if (_videoTitles != videoTitles) {
        _videoTitles = videoTitles;
        self.titleLabel.text = videoTitles;
    }
}

# pragma mark - UIControl/Touch Events
- (void)durationSliderTouchBegan:(UISlider *)slider {
    //关闭定时器，避免影响到UISlider滑动的过程中被影响到
    [self.durationTimer setFireDate:[NSDate distantFuture]];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    [self.moviePlayer pause];
}

- (void)durationSliderTouchEnded:(UISlider *)slider {
    [self.moviePlayer setCurrentPlaybackTime:floor(slider.value)];
    [self.moviePlayer play];
    
    //开启定时器，滑动UISlider结束后开启之前关闭的定时器
    [self.durationTimer setFireDate:[NSDate distantPast]];
    
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)durationSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)buttonTouchedDown:(UIButton *)button {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
}

- (void)buttonTouchedUpOutside:(UIButton *)button {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)buttonTouchCancelled:(UIButton *)button {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)airplayButtonTouchedDown {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
}

- (void)airplayButtonTouchedUpOutside {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)airplayButtonTouchFailed {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)airplayButtonTouchedUpInside {
    //TODO iphone
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    if (isIpad()) {
        windowSubviews = keyWindow.layer.sublayers.count;
        [keyWindow addObserver:self forKeyPath:@"layer.sublayers" options:NSKeyValueObservingOptionNew context:NULL];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:@"layer.sublayers"]) {
        return;
    }
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    if (keyWindow.layer.sublayers.count == windowSubviews) {
        [keyWindow removeObserver:self forKeyPath:@"layer.sublayers"];
        [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    }
}

- (void)windowDidResignKey:(NSNotification *)note {
    UIWindow *resignedWindow = (UIWindow *)[note object];
    if ([self isAirplayShowingInView:resignedWindow]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidResignKeyNotification object:nil];
        [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    }
}

- (void)windowDidBecomeKey:(NSNotification *)note {
    UIWindow *keyWindow = (UIWindow *)[note object];
    if ([self isAirplayShowingInView:keyWindow]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:UIWindowDidResignKeyNotification object:nil];
    }
}

- (BOOL)isAirplayShowingInView:(UIView *)view {
    BOOL actionSheet = NO;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIActionSheet class]]) {
            actionSheet = YES;
        } else {
            actionSheet = [self isAirplayShowingInView:subview];
        }
    }
    return actionSheet;
}

- (void)playPausePressed:(UIButton *)button {
    if (self.moviePlayer.contentURL == nil) {
        [self.moviePlayer setContentURL:self.moviePlayer.contentPlayersURL];
    }
    self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying ? [self.moviePlayer pause] : [self.moviePlayer play];
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)fullscreenPressed:(UIButton *)button {
    self.fullscreenButton.selected = !self.fullscreenButton.selected;
    if (self.fullscreenButton.selected) {

        [self.fullscreenButton setSelected:YES];
        self.backforwardButton.hidden = NO;
        self.timeRemainingLabel.hidden = NO;
        //全屏
        [self.AutorotateDelegate isFullScreen:YES];
    }else{

        [self.fullscreenButton setSelected:NO];
        self.backforwardButton.hidden = YES;
        self.timeRemainingLabel.hidden = YES;
        //默认
        [self.AutorotateDelegate isFullScreen:NO];
    }
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.style == ALMoviePlayerControlsStyleNone){
        return;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.style == ALMoviePlayerControlsStyleNone){
        return;
    }
    self.isShowing ? [self hideControls:nil] : [self showControls:nil];
}

# pragma mark - Notifications
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieContentURLDidChange:) name:ALMoviePlayerContentURLDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDurationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)movieFinished:(NSNotification *)note {
    self.playPauseButton.selected = YES;
    [self.durationTimer invalidate];
    [self.moviePlayer setCurrentPlaybackTime:0.0];
    [self monitorMoviePlayback]; //reset values
    [self hideControls:nil];
    self.state = ALMoviePlayerControlsStateIdle;
}

- (void)movieLoadStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.loadState) {
        case MPMovieLoadStatePlayable:
        case MPMovieLoadStatePlaythroughOK:
            [self showControls:nil];
            self.state = ALMoviePlayerControlsStateReady;
            break;
        case MPMovieLoadStateStalled:
        case MPMovieLoadStateUnknown:
            break;
        default:
            break;
    }
}

- (void)moviePlaybackStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            self.playPauseButton.selected = NO;
            [self startDurationTimer];
            
            //local file
            if ([self.moviePlayer.contentURL.scheme isEqualToString:@"file"]) {
                [self setDurationSliderMaxMinValues];
                [self showControls:nil];
            }
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
            self.state = ALMoviePlayerControlsStateReady;
            break;
        case MPMoviePlaybackStateInterrupted:
            self.state = ALMoviePlayerControlsStateLoading;
            break;
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
            self.state = ALMoviePlayerControlsStateIdle;
            self.playPauseButton.selected = YES;
            [self stopDurationTimer];
            break;
        default:
            break;
    }
}

- (void)movieDurationAvailable:(NSNotification *)note {
    [self setDurationSliderMaxMinValues];
}

- (void)movieContentURLDidChange:(NSNotification *)note {
    [self hideControls:^{
        //don't show loading indicator for local files
        self.state = [self.moviePlayer.contentURL.scheme isEqualToString:@"file"] ? ALMoviePlayerControlsStateReady : ALMoviePlayerControlsStateLoading;
    }];
}

# pragma mark - Internal Methods
- (void)startDurationTimer {
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorMoviePlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer {
    [self.durationTimer invalidate];
}

- (void)monitorMoviePlayback {
    double currentTime = floor(self.moviePlayer.currentPlaybackTime);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.durationSlider.value = ceil(currentTime);
}

- (void)showControls:(void(^)(void))completion {
    if (!self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        if (self.style == ALMoviePlayerControlsStyleFullscreen || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
            [self.topBar setNeedsDisplay];
        }
        [self.bottomBar setNeedsDisplay];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.topBar.alpha = 1.f;
            self.bottomBar.alpha = 1.f;
        } completion:^(BOOL finished) {
            _showing = YES;
            if (completion){
                completion();
            }
        }];
    } else {
        if (completion){
            completion();
        }
    }
}

- (void)hideControls:(void(^)(void))completion {
    if (self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.topBar.alpha = 0.f;
            self.bottomBar.alpha = 0.f;
        } completion:^(BOOL finished) {
            _showing = NO;
            if (completion)
                completion();
        }];
    } else {
        if (completion){
            completion();
        }
    }
}

- (void)showLoadingIndicators {
    [self addSubview:_activityBackgroundView];
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    [UIView animateWithDuration:0.2f animations:^{
        _activityBackgroundView.alpha = 1.f;
        _activityIndicator.alpha = 1.f;
    }];
}

- (void)hideLoadingIndicators {
    [UIView animateWithDuration:0.2f delay:0.0 options:0 animations:^{
        self.activityBackgroundView.alpha = 0.0f;
        self.activityIndicator.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.activityBackgroundView removeFromSuperview];
        [self.activityIndicator removeFromSuperview];
    }];
}

- (void)setDurationSliderMaxMinValues {
    CGFloat duration = self.moviePlayer.duration;
    self.durationSlider.minimumValue = 0.f;
    self.durationSlider.maximumValue = duration;
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining;
    double secondsRemaining;
//    if (self.timeRemainingDecrements) {
//        minutesRemaining = floor((totalTime - currentTime) / 60.0);
//        secondsRemaining = fmod((totalTime - currentTime), 60.0);
//    } else {
        minutesRemaining = floor(totalTime / 60.0);
        secondsRemaining = floor(fmod(totalTime, 60.0));
//    }
    self.timeRemainingLabel.text = self.timeRemainingDecrements ? [NSString stringWithFormat:@"%@ / %.0f:%02.0f",timeElapsedString, minutesRemaining, secondsRemaining] : [NSString stringWithFormat:@"%@ / %.0f:%02.0f",timeElapsedString, minutesRemaining, secondsRemaining];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.style == ALMoviePlayerControlsStyleNone){
        return;
    }
    
    //common sizes
    CGFloat paddingFromBezel = self.frame.size.width <= iPhoneScreenPortraitWidth ? 10.f : 20.f;
    CGFloat paddingBetweenButtons = self.frame.size.width <= iPhoneScreenPortraitWidth ? 10.f : 30.f;
    CGFloat paddingBetweenLabelsAndSlider = 10.f;
    CGFloat sliderHeight = 34.f; //default height
    CGFloat volumeHeight = 20.f;
    CGFloat volumeWidth = isIpad() ? 210.f : 120.f;
    CGFloat playWidth = 60.0f;
    CGFloat playHeight = 40.f;
    CGFloat labelWidth = 70.0f;
    
    CGFloat fullscreenWidth = 40.f;
    CGFloat fullscreenHeight = fullscreenWidth;
    
    
    if ( self.moviePlayer.isFullscreen) {
        //全屏模式

        self.fullscreenButton.frame = CGRectMake(iPhoneScreenPortraitWidth - 40, self.barHeight/2 - fullscreenHeight/2, fullscreenWidth, fullscreenHeight);
        self.timeRemainingLabel.frame = CGRectMake(self.fullscreenButton.frame.origin.x - paddingBetweenButtons - labelWidth, 0, labelWidth, self.barHeight);
        
        //bottom bar
        self.bottomBar.frame = CGRectMake(0, self.moviePlayer.view.bounds.size.width - self.barHeight, self.moviePlayer.view.bounds.size.height, self.barHeight);
        
        //top bar
        self.topBar.frame = CGRectMake(0, 0,self.moviePlayer.view.bounds.size.height, self.barHeight);
        
        //play button
        self.playPauseButton.frame = CGRectMake(0, 0, playWidth, playHeight);
        
        //返回按钮
        self.backforwardButton.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(40, 0, self.topBar.frame.size.width - 80, 40);
        
        //hide volume view in iPhone's portrait orientation
        if (self.frame.size.width <= iPhoneScreenPortraitWidth) {
            self.volumeView.alpha = 0.f;
        } else {
            self.volumeView.alpha = 1.f;
            self.volumeView.frame = CGRectMake(paddingFromBezel, self.barHeight/2 - volumeHeight/2, volumeWidth, volumeHeight);
        }
    }else if (!self.moviePlayer.isFullscreen) {
        self.topBar.frame = CGRectMake(0, 0,self.moviePlayer.view.bounds.size.width, self.barHeight);
        self.bottomBar.frame = CGRectMake(0, self.moviePlayer.view.bounds.size.height - self.barHeight, self.moviePlayer.view.bounds.size.width, self.barHeight);
        self.titleLabel.frame = CGRectMake(0, 0, self.topBar.frame.size.width, 40);
        self.backforwardButton.frame = CGRectMake(0, 0, 40, 40);

        //left side of bottom bar
        self.playPauseButton.frame = CGRectMake(0, self.barHeight/2 - playHeight/2, playWidth, playHeight);
        
        //right side of bottom bar
        self.fullscreenButton.frame = CGRectMake(self.moviePlayer.view.bounds.size.width - 40, self.barHeight/2 - fullscreenHeight/2, fullscreenWidth, fullscreenHeight);
        //时间
        if (self.fullscreenButton.selected) {
            self.timeRemainingLabel.frame = CGRectMake(self.fullscreenButton.frame.origin.x - paddingBetweenButtons - labelWidth, 0, labelWidth, self.barHeight);
        }else{
            self.timeRemainingLabel.frame = CGRectMake(self.fullscreenButton.frame.origin.x - paddingBetweenButtons, 0, 0, self.barHeight);
        }
    }
    
    //duration slider
    CGFloat timeRemainingX = self.timeRemainingLabel.frame.origin.x;
    CGFloat sliderWidth = ((timeRemainingX - paddingBetweenLabelsAndSlider) - (65 + paddingBetweenLabelsAndSlider));
    self.durationSlider.frame = CGRectMake(65 + paddingBetweenLabelsAndSlider, self.barHeight/2 - sliderHeight/2, sliderWidth, sliderHeight);
    
    if (self.state == ALMoviePlayerControlsStateLoading) {
        [_activityBackgroundView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_activityIndicator setFrame:CGRectMake((self.frame.size.width / 2) - (activityIndicatorSize / 2), (self.frame.size.height / 2) - (activityIndicatorSize / 2), activityIndicatorSize, activityIndicatorSize)];
    }
}
@end

# pragma mark - ALMoviePlayerControlsBar
@implementation ALMoviePlayerControlsBar

- (id)init {
    if ( self = [super init] ) {
        self.opaque = NO;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [_color CGColor]);
    CGContextFillRect(context, rect);
}
@end
