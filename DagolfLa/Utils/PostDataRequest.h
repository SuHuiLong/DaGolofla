//
//  PostDataRequest.h
//  CharmRiuJin
//
//  Created by bhxx on 15/6/16.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlockType) (id respondsData);
typedef void(^FailedBlockType) (NSError *error);

typedef void (^GBHEStartBlock)(void);
typedef void (^GBHEFailedBlock)(id errType);
typedef void (^GBHECompletionBlock)(id data);
typedef void (^GBHEBytesRecvBlock)(unsigned long long length, unsigned long long total);

@interface PostDataRequest : NSObject

+ (instancetype)sharedInstance;
//无图片
- (void)postDataRequest:(NSString*)port parameter:(NSDictionary*)dit success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock;
//有图片
- (void)postDataAndImageRequest:(NSString*)port parameter:(NSDictionary*)dit imageDataArr:(NSArray*)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock;

//视频+图片
- (void)postDataAndVideoDataRequest:(NSString*)port parameter:(NSDictionary*)dit videoData:(NSData *)videoData imageDataArr:(NSArray*)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock;

- (void)postDataAndImageRequestBackPic:(NSString*)port parameter:(NSDictionary*)dit imageDataArr:(NSArray*)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock;


//GET请求
- (void)getDataRequest:(NSString *)port success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock;

//判断网络状态类型
+ (BOOL)isNetWorkReachable;

+ (NSString *)getNetWorkState;

/**
 *  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
+ (void)downloadFileWithURL:(NSString*)requestURLString
                 parameters:(NSDictionary *)parameters
                  savedPath:(NSString*)savedPath
            downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath))success
            downloadFailure:(void (^)(NSError *error))failure
           downloadProgress:(void (^)(NSProgress *downloadProgress))progress;




//Json请求
- (void) httpRequest:(NSString *)url
            withData:(NSDictionary *)postData
       requestMethod:(NSString*)httpMethod
         failedBlock:(GBHEFailedBlock)failedBlock
     completionBlock:(GBHECompletionBlock)completionBlock;


//取消网络请求
- (void)cancelRequest;

@end
