//
//  JsonHttp.h
//  TestUUID
//
//  Created by 黄安 on 16/5/17.
//  Copyright © 2016年 com.huangDM. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define PORTOCOL_APP_ROOT_URL   @"http://192.168.1.104:8888/"
#define PORTOCOL_APP_ROOT_URL   @"http://mobile.dagolfla.com/"

@interface JsonHttp : NSObject

typedef void (^GBHEStartBlock)(void);
typedef void (^GBHEFailedBlock)(id errType);
typedef void (^GBHECompletionBlock)(id data);
typedef void (^GBHEBytesRecvBlock)(unsigned long long length, unsigned long long total);


+ (instancetype)jsonHttp;
- (void) httpRequest:(NSString *)url JsonKey:(NSString *)jsonKey
            withData:(NSDictionary *)postData
       requestMethod:(NSString*)httpMethod
         failedBlock:(GBHEFailedBlock)failedBlock
     completionBlock:(GBHECompletionBlock)completionBlock;

- (void)httpRequest:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData andArray:(NSArray *)arrayPic requestMethod:(NSString *)httpMethod failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock;

//取消网络请求
- (void)cancelRequest;

- (void)httpRequestImageOrVedio:(NSString *)url withData:(NSDictionary *)postData andDataArray:(NSArray *)arrayPic failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock;

- (void)httpRequestWithMD5:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock;
@end
