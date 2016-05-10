//
//  ALBBQuPaiPluginPluginServiceProtocol.h
//  ALBBQuPaiPluginPluginAdapter
//
//  Created by 友和(lai.zhoul@alibaba-inc.com) on 14/11/26.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QupaiSDKWatermarkPosition){
    QupaiSDKWatermarkPositionTopRight,
    QupaiSDKWatermarkPositionBottomRight,
};

@protocol QupaiSDKDelegate;

@protocol ALBBQuPaiPluginPluginServiceProtocol <NSObject>


@property (nonatomic, weak) id<QupaiSDKDelegate> delegte;

/* 可选配置 */
@property (nonatomic, assign) BOOL      enableBeauty;                       /* 是否开启美颜切换,默认YES */
@property (nonatomic, assign) BOOL      enableImport;                       /* 是否开启导入,默认YES  */
@property (nonatomic, assign) BOOL      enableMoreMusic;                    /* 是否添加更多音乐按钮,默认YES  */
@property (nonatomic, assign) BOOL      enableVideoEffect;                  /* 是否开启视频编辑页面,默认YES  */
@property (nonatomic, assign) BOOL      enableWatermark;                    /* 是否开启水印图片,默认NO */
@property (nonatomic, assign) CGFloat   thumbnailCompressionQuality;        /* 首帧图图片质量:压缩质量 0-1,默认0.8 */
@property (nonatomic, strong) UIColor   *tintColor;                         /* 颜色 */
@property (nonatomic, strong) UIImage   *watermarkImage;                    /* 水印图片 */
@property (nonatomic, assign) QupaiSDKWatermarkPosition watermarkPosition;  /* 水印图片位置 */

/**
 *创建录制页面，需要以 UINavigationController 为父容器
 * @param minDuration 允许拍摄的最小时长
 * @param maxDuration 允许拍摄的最大时长
 * @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
 */
- (UIViewController *)createRecordViewControllerWithMinDuration:(CGFloat)minDuration
                                                    maxDuration:(CGFloat)maxDuration
                                                        bitRate:(CGFloat)bitRate;

//创建录制页面，需要以 UINavigationController 为父容器
//参数使用默认值
- (UIViewController *)createRecordViewController;

/**
 *创建录制页面，需要以 UINavigationController 为父容器
 * @param maxDuration 允许拍摄的最大时长，最短8秒，最大60秒，时长越大，产生的视频文件越大
 * @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
 * @param thumbnailCompressionQuality 图片质量，0-1.0
 * @param watermarkImage 视频水印图片,传nil为不加水印
 * @param watermarkPosition QupaiSDKWatermarkPositionTopRight为加在右上角，QupaiSDKWatermarkPositionBottomRight为加在右下角
 * @param enableMoreMusic 是否需要更多音乐
 * @param enableImport 是否开启本地视频导入。不开启只能用该SDK拍摄视频，开启可以导入手机中用系统相机拍摄的视频或者外部导入手机中的视频
 */
- (UIViewController *)createRecordViewControllerWithMaxDuration:(CGFloat)maxDuration
                                                        bitRate:(CGFloat)bitRate
                                    thumbnailCompressionQuality:(CGFloat)thumbnailCompressionQuality
                                                 watermarkImage:(UIImage *)watermarkImage
                                              watermarkPosition:(QupaiSDKWatermarkPosition)watermarkPosition
                                                enableMoreMusic:(BOOL)enableMoreMusic
                                                   enableImport:(BOOL)enableImport NS_DEPRECATED_IOS(1_0, 2_0);

/**
 * Depricated
 *创建录制页面，需要以 UINavigationController 为父容器
 * @param maxDuration 允许拍摄的最大时长，最短8秒，最大60秒，时长越大，产生的视频文件越大
 * @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
 * @param thumbnailCompressionQuality 图片质量，0-1.0
 * @param watermarkImage 视频水印图片,传nil为不加水印
 * @param watermarkPosition QupaiSDKWatermarkPositionTopRight为加在右上角，QupaiSDKWatermarkPositionBottomRight为加在右下角
 * @param enableMoreMusic 是否需要更多音乐
 * @param enableImport 是否开启本地视频导入。不开启只能用该SDK拍摄视频，开启可以导入手机中用系统相机拍摄的视频或者外部导入手机中的视频
 * @param enableVideoEffect 是否开启视频编辑页面
 */
- (UIViewController *)createRecordViewControllerWithMaxDuration:(CGFloat)maxDuration
                                                        bitRate:(CGFloat)bitRate
                                    thumbnailCompressionQuality:(CGFloat)thumbnailCompressionQuality
                                                 watermarkImage:(UIImage *)watermarkImage
                                              watermarkPosition:(QupaiSDKWatermarkPosition)watermarkPosition
                                                enableMoreMusic:(BOOL)enableMoreMusic
                                                   enableImport:(BOOL)enableImport
                                              enableVideoEffect:(BOOL)videoEffect NS_DEPRECATED_IOS(1_0, 2_0);

/**
 *创建录制页面，需要以 UINavigationController 为父容器
 * @param maxDuration 允许拍摄的最大时长，最短8秒，最大60秒，时长越大，产生的视频文件越大
 * @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
 * @param thumbnailCompressionQuality 图片质量，0-1.0
 * @param watermarkImage 视频水印图片,传nil为不加水印
 * @param watermarkPosition QupaiSDKWatermarkPositionTopRight为加在右上角，QupaiSDKWatermarkPositionBottomRight为加在右下角
 * @param tintColor 界面主题颜色
 * @param enableMoreMusic 是否需要更多音乐
 * @param enableImport 是否开启本地视频导入。不开启只能用该SDK拍摄视频，开启可以导入手机中用系统相机拍摄的视频或者外部导入手机中的视频
 * @param enableVideoEffect 是否开启视频编辑页面
 */
- (UIViewController *)createRecordViewControllerWithMaxDuration:(CGFloat)maxDuration
                                                        bitRate:(CGFloat)bitRate
                                    thumbnailCompressionQuality:(CGFloat)thumbnailCompressionQuality
                                                 watermarkImage:(UIImage *)watermarkImage
                                              watermarkPosition:(QupaiSDKWatermarkPosition)watermarkPosition
                                                      tintColor:(UIColor *)tintColor
                                                enableMoreMusic:(BOOL)enableMoreMusic
                                                   enableImport:(BOOL)enableImport
                                              enableVideoEffect:(BOOL)videoEffect NS_DEPRECATED_IOS(1_0, 2_0);


/**
 * 更多音乐有了更新,比如新下载了音乐
 */
- (void)updateMoreMusic;

@end

@protocol QupaiSDKDelegate <NSObject>

/**
 * @param videoPath      保存拍摄好视频的存储路径
 * @param thumbnailPath  保存拍摄好视频首侦图的存储路径
 */
- (void)qupaiSDK:(id<ALBBQuPaiPluginPluginServiceProtocol>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath; 

@optional
- (NSArray *)qupaiSDKMusics:(id<ALBBQuPaiPluginPluginServiceProtocol>)sdk;
- (void)qupaiSDKShowMoreMusicView:(id<ALBBQuPaiPluginPluginServiceProtocol>)sdk viewController:(UIViewController *)viewController;

@end