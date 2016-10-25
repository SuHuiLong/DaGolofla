//
//  ViewController.m
//  启动动画
//
//  Created by Madridlee on 16/9/28.
//  Copyright © 2016年 MadridLee. All rights reserved.
//

#import "JGLAnimationViewController.h"
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height
@interface JGLAnimationViewController()
{
    CALayer *_layer, *_layer1;
    NSTimer* _timer;
    UIImageView* _imgv;
    UIImageView* _imgvQi;
}
@property (nonatomic,strong)UIImageView * ballView;
@end

@implementation JGLAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景(注意这个图片其实在根图层)
    _imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:_imgv];
    _imgv.image = [UIImage imageNamed:@"bg_image"];
    
    UIImageView* imgvWord = [[UIImageView alloc]initWithFrame:CGRectMake(4*ProportionAdapter, screenHeight - 200*ProportionAdapter, screenWidth - 8*ProportionAdapter, 100*ProportionAdapter)];
    imgvWord.image = [UIImage imageNamed:@"word"];
    [_imgv addSubview:imgvWord];
    
    
    _imgvQi = [[UIImageView alloc]initWithFrame:CGRectMake(204*ProportionAdapter, 173*ProportionAdapter, 36*ProportionAdapter, 29*ProportionAdapter)];
    _imgvQi.image = [UIImage imageNamed:@"fllag_1"];
    [_imgv addSubview:_imgvQi];
    
    [UIView animateWithDuration:2 animations:^{
        imgvWord.frame = CGRectMake(106*ProportionAdapter, screenHeight-79*ProportionAdapter, screenWidth-212*ProportionAdapter, 59*ProportionAdapter);
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }];
    
    
    UIImage * ballImage = [UIImage imageNamed:@"ball.png"];
    self.ballView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 32*ProportionAdapter, 32*ProportionAdapter)];
    self.ballView.center =CGPointMake(150*ProportionAdapter,32*ProportionAdapter);
    self.ballView.image = ballImage;
    self.ballView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.ballView];
    
    //    //自定义一个图层
    
    
    //创建动画
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    });
    [self animationBallPull];//球下落，可以进行时间控制
    [self groupAnimation];//动画组控制球体移动拐弯,曲线设置4个关键帧节点，没找到时间设置的属性，有可能可以修改
    [self animationDown];//球旋转后的位置入洞，
    
//    在主线程中用uianimation进行影藏。。。
    //这个有点小问题，我刚开始写下落的时候就考虑了隐藏，所以写到了animationBallPull这个方法里面
    
    ///还有就是tabbar切换时候的淡出效果没有诶
    
}
static int timeNumber = 0;
-(void)autoMove
{
    if (timeNumber % 2 == 0) {
        _imgvQi.image = [UIImage imageNamed:@"fllag_1"];
    }
    else{
        _imgvQi.image = [UIImage imageNamed:@"fllag_2"];
    }
    timeNumber++;
}
-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

-(void)animationDown
{
    self.ballView.center =CGPointMake(277*ProportionAdapter,-40*ProportionAdapter);
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath =@"position";
    animation.duration = 0.4;
    animation.delegate =self;
    animation.values =@[[NSValue valueWithCGPoint:CGPointMake(240*ProportionAdapter,290*ProportionAdapter)],
                        [NSValue valueWithCGPoint:CGPointMake(240*ProportionAdapter,310*ProportionAdapter)]];
    
    animation.timingFunctions =@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    //  设置每个关键帧的时长
    animation.keyTimes =@[@0.0, @0.4];
    
    self.ballView.layer.position = CGPointMake(240*ProportionAdapter,310*ProportionAdapter);
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0];
    opacityAnim.removedOnCompletion = YES;
    
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations =@[animation,opacityAnim];
    group.duration = animation.duration;
    group.speed =0.5;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.beginTime=CACurrentMediaTime()+5.1;//设置延迟2秒执行
    [self.ballView.layer addAnimation:group forKey:nil];
    
}
-(void)animationBallPull
{
    self.ballView.center =CGPointMake(277*ProportionAdapter,-40*ProportionAdapter);
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath =@"position";
    animation.duration =1.0;
    animation.delegate =self;
    animation.values =@[[NSValue valueWithCGPoint:CGPointMake(277*ProportionAdapter,-40*ProportionAdapter)],
                        [NSValue valueWithCGPoint:CGPointMake(277*ProportionAdapter,468*ProportionAdapter)],
                        [NSValue valueWithCGPoint:CGPointMake(277*ProportionAdapter,360*ProportionAdapter)],
                        [NSValue valueWithCGPoint:CGPointMake(277*ProportionAdapter,468*ProportionAdapter)],
                        [NSValue valueWithCGPoint:CGPointMake(277*ProportionAdapter,450*ProportionAdapter)],
                        [NSValue valueWithCGPoint:CGPointMake(277*ProportionAdapter,468*ProportionAdapter)]];
    
    animation.timingFunctions =@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    //  设置每个关键帧的时长
    //@0.0第0s
    //@0.2从开始的第0s，过后的0.2s开始执行
    animation.keyTimes =@[@0.0, @0.2,@0.3, @0.4,@0.5, @0.6];
    
    self.ballView.layer.position = CGPointMake(277*ProportionAdapter,468*ProportionAdapter);
    
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations =@[animation];
    group.duration = animation.duration;
    group.speed =0.2;
    
    [self.ballView.layer addAnimation:group forKey:nil];
}





#pragma mark 创建动画组
-(void)groupAnimation{
    //    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2.设置路径
    //绘制贝塞尔曲线
    CGPathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.ballView.layer.position.x, self.ballView.layer.position.y);//移动到起始点
    CGPathAddCurveToPoint(path, NULL, 160*ProportionAdapter, 261*ProportionAdapter, 140*ProportionAdapter, 255*ProportionAdapter, 240*ProportionAdapter, 290*ProportionAdapter);//绘制二次贝塞尔曲线
    keyframeAnimation.path=path;//设置path属性
    CGPathRelease(path);//释放路径对象
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    //设置其他属性
    keyframeAnimation.duration=2.0;
    keyframeAnimation.beginTime=CACurrentMediaTime()+3.1;//设置延迟2秒执行
    //3.添加动画到图层，添加动画后就会执行动画
    [self.ballView.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2.0 animations:^{
            self.ballView.alpha = 0;
//            _callBack();
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        _callBack();
    });
}

#pragma mark - 代理方法
#pragma mark 动画完成
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
}

@end
