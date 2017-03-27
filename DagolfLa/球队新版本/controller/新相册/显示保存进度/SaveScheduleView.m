//
//  SaveScheduleView.m
//  DagolfLa
//
//  Created by SHL on 2017/3/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SaveScheduleView.h"
#import "JGPhotoListModel.h"
#import <Photos/Photos.h>
@interface SaveScheduleView()<NSURLSessionDelegate>

//进度提示
@property(nonatomic, copy)UILabel *scheduleLabel;
//已请求的总的请求数
@property(nonatomic, assign)NSInteger responseNum;
//总数据
@property(nonatomic, copy)NSArray *imageUrlArray;
//请求的总长度
@property(nonatomic, assign)long long totalLength;
//已经保存过的数据长度
@property(nonatomic, assign)long long saveLength;
//已下载的数组
@property(nonatomic, strong)NSMutableArray *downloadArray;

@end
@implementation SaveScheduleView


-(instancetype)initWithImageArray:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        _imageUrlArray = [NSArray array];
        _imageUrlArray = imageArray;
        [self createView];
    }
    return self;
}

#pragma mark - CreateView;
-(void)createView{
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.userInteractionEnabled = true;
    self.backgroundColor = ClearColor;
    //背景
    UIView *backGroundView = [Factory createViewWithBackgroundColor:BlackColor frame:self.bounds];
    backGroundView.alpha = 0.8;
    [self addSubview:backGroundView];
    //旋转view
    UIImageView *circleView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-kWvertical(55))/2, kHvertical(267) - 64, kWvertical(55), kWvertical(55))];
    [self addSubview:circleView];
    //进度
    _scheduleLabel = [Factory createLabelWithFrame:circleView.frame textColor:WhiteColor fontSize:kHorizontal(16) Title:@"0%"];
    _scheduleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_scheduleLabel];
    //loading
    UILabel *loadingLabel = [Factory createLabelWithFrame:CGRectMake(0, _scheduleLabel.y_height + kHvertical(8), screenWidth, kHvertical(20)) textColor:RGB(192,192,192) fontSize:kHorizontal(15) Title:@"loading"];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:loadingLabel];
    //取消下载
    UIButton *cancelBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth/2 - kWvertical(55),screenHeight - kHvertical(126),kWvertical(110),kHvertical(36))  titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:ClearColor target:self selector:@selector(cancelClick) Title:@"取消下载"];
    cancelBtn.layer.cornerRadius = kWvertical(8);
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = WhiteColor.CGColor;
    [self addSubview:cancelBtn];
    circleView.image = [UIImage imageNamed:@"teamPhotoSaveCircle"];
    circleView.userInteractionEnabled = YES;
    //旋转
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *rotationAnim = [CABasicAnimation animation];
        rotationAnim.keyPath = @"transform.rotation.z";
        rotationAnim.toValue = @(2 * M_PI);
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 5;
        rotationAnim.cumulative = NO;
        rotationAnim.autoreverses = NO;
        [circleView.layer addAnimation:rotationAnim forKey:nil];
    });
    [self sendRequest];
}

#pragma mark - Action
//取消下载
-(void)cancelClick{
    
    
    [self removeFromSuperview];
}

//更新进度
- (void)updateProgress {
    CGFloat downloadLenth = 0;
    NSArray *downLoadArray = [NSArray arrayWithArray:_downloadArray];
    
    for (NSString *length in downLoadArray) {
        downloadLenth = downloadLenth + [length floatValue];
    }
    //获取总下载
    float a = (float)downloadLenth/_totalLength;
    _scheduleLabel.text = [NSString stringWithFormat:@"%.0f%\%",a*100];
    if (a==1) {
        [self removeFromSuperview];
    }
}

#pragma mark 发送数据请求
-(void)sendRequest{
    //初始化
    _downloadArray = [NSMutableArray array];
    for (int i = 0; i<_imageUrlArray.count; i++) {
        [_downloadArray addObject:@""];

        JGPhotoListModel *model = _imageUrlArray[i];
        NSURL *url = [Helper setImageIconUrl:@"album/media" andTeamKey:[model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:NO];// 加载网络图片大图地址
        //创建请求
        NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
        //初始化请求
        NSURLSessionConfiguration *sessionConfig =[NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *newQueue = [NSOperationQueue new];
        newQueue.name = [NSString stringWithFormat:@"%d",i];
        //创建网络会话
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:newQueue];
        //创建下载任务
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
        //启动下载任务  
        [task resume];
    }
}


#pragma mark - 连接代理方法
// 每次写入调用(会调用多次)
/*
 
 totalBytesWritten 已下载的内容
 totalBytesExpectedToWrite 总需要下载内容
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
        NSOperationQueue *queue = [NSOperationQueue currentQueue];
    NSString *queueName = queue.name;
    // 可在这里通过已写入的长度和总长度算出下载进度
    NSInteger index = [queueName integerValue];
    NSString *nameStr  = _downloadArray[index];
    if ([nameStr isEqualToString:@""]) {
        _totalLength = _totalLength + totalBytesExpectedToWrite;
    }
    NSString *totalBytesWrittenStr = [NSString stringWithFormat:@"%lld",totalBytesWritten];
    [_downloadArray replaceObjectAtIndex:index withObject:totalBytesWrittenStr];
    //所有连接已响应更新进度
    if (![_downloadArray containsObject:@""]) {
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress];
        });
    }
}
//  下载成功 获取下载内容
-(void)URLSession:(NSURLSession *)session   downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath]; // 取得图片
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册 PHAssetChangeRequest *req =
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
    }];
    

}




@end
