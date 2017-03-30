//
//  PostDataRequest.m
//  CharmRiuJin
//
//  Created by bhxx on 15/6/16.
//  Copyright (c) 2015年 bhxx. All rights reserved.

#define urlStr [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/%@",port]
//#define urlStr [NSString stringWithFormat:@"http://192.168.2.38:8088/dagaoerfu/%@",port]
//#define urlStr [NSString stringWithFormat:@"http://xiaoar.oicp.net:16681/dagaoerfu/%@",port]
//#define urlStr [NSString stringWithFormat:@"http://192.168.2.38:8088/dagaoerfu/%@",port]
//#define urlStr [NSString stringWithFormat:@"http://139.196.58.35:8080/dagaoerfu/%@",port]

#define TEST  YES   //可自由切-换生产和测试环境
#define BaseUrl TEST?@"http://www.dagolfla.com:8081/dagaoerfu/":@"http://www.dagolfla.com:8081/dagaoerfu/"


#import "PostDataRequest.h"
#import "Helper.h"

@implementation PostDataRequest
{
    AFHTTPSessionManager *_httpManager;
}

+ (instancetype)sharedInstance {
    static PostDataRequest *s_engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_engine = [[PostDataRequest alloc] init];
    });
    return s_engine;
}

- (id)init {
    if (self = [super init]) {
        _httpManager = [[AFHTTPSessionManager alloc] init];
        //返回二进制
        _httpManager.requestSerializer.timeoutInterval = 20.f;
        _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //当前版本号
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [_httpManager.requestSerializer setValue:app_Version forHTTPHeaderField:@"AppVersion"];
        [_httpManager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];
        
        
    }
    return self;
}

- (void)postDataRequest:(NSString *)port parameter:(NSDictionary *)dit success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock{
    
    //设置请求超时
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [_httpManager POST:urlStr parameters:dit progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
            [Helper downLoadDataOverrun];
        }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 61) {
            [Helper netWorkError];
        }
        if (faliedBlock) {
            faliedBlock(error);
        }
    }];
    
}

- (void)postDataAndImageRequest:(NSString *)port parameter:(NSDictionary *)dit imageDataArr:(NSArray *)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock {
    
    //设置请求超时
    
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [_httpManager POST:urlStr parameters:dit constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <imageDataArr.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置日期格式
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            NSString *nameStr = @"myPic";
            [formData appendPartWithFileData:imageDataArr[i] name:nameStr fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
            [Helper downLoadDataOverrun];
        }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
            [Helper netWorkError];
        }
        if (faliedBlock) {
            faliedBlock(error);
        }
    }];
    
    
}
- (void)postDataAndVideoDataRequest:(NSString*)port parameter:(NSDictionary*)dit videoData:(NSData *)videoData imageDataArr:(NSArray*)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock;
{
    //设置请求超时
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //上传视频
    [_httpManager POST:urlStr parameters:dit constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <imageDataArr.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置日期格式
            formatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            NSString *nameStr = @"videosmall_img_file";
            [formData appendPartWithFileData:imageDataArr[i] name:nameStr fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png"];
        }
        
        NSDateFormatter *videoFormatter = [[NSDateFormatter alloc] init];
        videoFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *videoFileName = [videoFormatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"video";
        //        [formData appendPartWithFormData:videoData name:nameStr];
        [formData appendPartWithFileData:videoData name:nameStr fileName:[NSString stringWithFormat:@"%@.mp4", videoFileName] mimeType:@"video/mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
            [Helper downLoadDataOverrun];
        }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
            [Helper netWorkError];
        }
        if (faliedBlock) {
            faliedBlock(error);
        }
    }];
}

- (void)postOpenBusinessData:(NSString *)port parameter:(NSDictionary *)dit imageDataArr:(NSArray *)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock {
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [_httpManager POST:urlStr parameters:dit constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <imageDataArr.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置日期格式
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            [formData appendPartWithFileData:imageDataArr[i] name:@"myPic" fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
            [Helper downLoadDataOverrun];
        }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
            [Helper netWorkError];
        }
        if (faliedBlock) {
            faliedBlock(error);
        }
    }];

}
- (void)getDataRequest:(NSString *)port success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock{
    
    _httpManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [_httpManager GET:port parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
            [Helper downLoadDataOverrun];
        }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 61) {
            [Helper netWorkError];
        }
        if (faliedBlock) {
            faliedBlock(error);
        }
    }];
    
    
}

- (void)postDataAndImageRequestBackPic:(NSString *)port parameter:(NSDictionary *)dit imageDataArr:(NSArray *)imageDataArr success:(SuccessBlockType)successBlock failed:(FailedBlockType)faliedBlock {
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [_httpManager POST:urlStr parameters:dit constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <imageDataArr.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置日期格式
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            NSString *nameStr = @"backPic";
            
            [formData appendPartWithFileData:imageDataArr[i] name:nameStr fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
            [Helper downLoadDataOverrun];
        }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
            [Helper netWorkError];
        }
        if (faliedBlock) {
            faliedBlock(error);
        }
    }];
}



+ (BOOL)isNetWorkReachable{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    NSUserDefaults *netUser = [NSUserDefaults standardUserDefaults];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不给力");//11
                [netUser setObject:@"11" forKey:NETWORKSTATS];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接");//-1
                [netUser setObject:@"-1" forKey:NETWORKSTATS];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AFNetworkReachabilityStatusReachableViaWWAN" object:nil];
                [netUser setObject:@"0" forKey:NETWORKSTATS];
                NSLog(@"网络通过流量连接");//0
                break;
            }
            default:
                break;
        }
    }];
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}


+(NSString *)getNetWorkState{
    UIApplication *app =[UIApplication sharedApplication];
    NSArray *array =[[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0 ;
    for (id child in array) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (netType) {
                case 0:
                    //                  无网络
                    state = @"无网络";
                    break;
                case 1:
                    //                    state = @"2G" ;
                    state = @"4";
                    break ;
                case 2:
                    //                    state = @"3G" ;
                    state = @"3" ;
                    break ;
                case 4:
                    //                    state = @"4G" ;
                    state = @"2" ;
                    break ;
                case 5:
                    //                    state = @"WiFi" ;
                    state = @"1";
                    break ;
                default:
                    break;
            }
        }
    }
    return state ;
}

- (void)downloadFileWithURL:(NSString*)requestURLString
                 parameters:(NSDictionary *)parameters
                  savedPath:(NSString*)savedPath
            downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath))success
            downloadFailure:(void (^)(NSError *error))failure
           downloadProgress:(void (^)(NSProgress *downloadProgress))progress

{
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURLString parameters:parameters error:nil];
    NSURLSessionDownloadTask *task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savedPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error){
            failure(error);
        }else{
            success(response,filePath);
        }
    }];
    [task resume];
    
}

    
    
    
    
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
//    AFHTTPRequestSerializer *operation = [[AFHTTPRequestSerializer alloc] initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        success(operation,error);
//        
//        NSLog(@"下载失败");
//        UIAlertView *dowloadFailView = [[UIAlertView alloc]initWithTitle:nil message:@"下载失败！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [dowloadFailView show];
//        [self performSelector:@selector(hidenDownloadFailView:) withObject:dowloadFailView afterDelay:0.8f];
//    }];
    
//    [operation start];
//}

- (void)hidenDownloadFailView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) httpRequest:(NSString *)url
            withData:(NSDictionary *)postData
       requestMethod:(NSString*)httpMethod
         failedBlock:(GBHEFailedBlock)failedBlock
     completionBlock:(GBHECompletionBlock)completionBlock
{
    url = [NSString stringWithFormat:@"%@%@", BaseUrl, url];
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //返回数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //https安全策略
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    NSComparisonResult comparison1 = [httpMethod caseInsensitiveCompare:@"GET"];
    NSComparisonResult comparisonResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparison1 == NSOrderedSame)
    {
        [manager GET:url parameters:postData progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completionBlock) {
                completionBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failedBlock) {
                failedBlock(error);
            }
        }];
    }
    if (comparisonResult2 == NSOrderedSame)
    {
        BOOL isFile = NO;
        for (NSString *key in postData.allKeys) {
            id value = postData[key];
            if ([value isKindOfClass:[NSData class]]) {
                
                isFile = YES;
                break;
            }
        }
        
        if (!isFile) {//判断是上传数据还是下请求数据
            [manager POST:url parameters:postData progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }else
        {
            [manager POST:url parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString *key in postData) {
                    
                    id value = postData[key];
                    
                    if ([value isKindOfClass:[NSData class]]) {
                        
                        [formData appendPartWithFileData:value
                         
                                                    name:key
                         
                                                fileName:key
                         
                                                mimeType:@"image/jpg"];
                    }
                }

            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (completionBlock) {
                    completionBlock(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
                    [Helper downLoadDataOverrun];
                }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
                    [Helper netWorkError];
                }
                if (failedBlock) {
                    failedBlock(error);
                }

            }];

        }
    }
}

- (void)cancelRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}



@end
