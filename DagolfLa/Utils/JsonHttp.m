//
//  JsonHttp.m
//  TestUUID
//
//  Created by 黄安 on 16/5/17.
//  Copyright © 2016年 com.huangDM. All rights reserved.
//

#import "JsonHttp.h"
#import "AFNetworking.h"

@implementation JsonHttp

static JsonHttp *jsonHttp = nil;
// 网络单例对象的实现
+(instancetype)jsonHttp
{
    @synchronized(self){
        
        if (jsonHttp == nil) {
            jsonHttp = [[self alloc]init];
        }
    }
    
    return jsonHttp;
}

#pragma mark ----- MD5 POST
- (void)httpRequestHaveSpaceWithMD5:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
    
    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];
    
    NSString *paraStr = [Helper dictionaryHaveSpaceToJson:postData];
    
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *str = [Helper md5HexDigest:[NSString stringWithFormat:@"%@dagolfla.com", paraStr]];
    
    // 1.创建请求
    NSURL *urls = [NSURL URLWithString:[NSString stringWithFormat:@"%@?md5=%@",url ,str]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urls];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [request setValue:app_Version forHTTPHeaderField:@"AppVersion"];

    [request setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];
    
    NSData *data2 =[paraStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data2;
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            [Helper netWorkError];
            failedBlock(connectionError);
        }else{
            NSHTTPURLResponse *httpResonse=(NSHTTPURLResponse *)response;
            
            if( httpResonse.statusCode != 200 ){
                [Helper netWorkError];
                failedBlock(NSURLErrorDomain);
                return;
            }
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            completionBlock(dic);
        }
    }];
    
}


- (void)httpRequestWithMD5:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
   
    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];

     NSString *paraStr = [Helper dictionaryToJson:postData];
    
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    paraStr = [paraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *str = [Helper md5HexDigest:[NSString stringWithFormat:@"%@dagolfla.com", paraStr]];
    
    // 1.创建请求
    NSURL *urls = [NSURL URLWithString:[NSString stringWithFormat:@"%@?md5=%@",url ,str]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urls cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    [request setValue:app_Version forHTTPHeaderField:@"AppVersion"];
    [request setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];

    
    NSData *data2 =[paraStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data2;
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            [Helper netWorkError];
            failedBlock(connectionError);
        }else{
            
            NSHTTPURLResponse *httpResonse=(NSHTTPURLResponse *)response;
            
            if( httpResonse.statusCode != 200 ){
                [Helper netWorkError];
                failedBlock(NSURLErrorDomain);
                return;
            }
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            completionBlock(dic);
        }
        
        /*
         else if (connectionError == nil){
         //response == nil
         [Helper downLoadDataOverrun];
         failedBlock(connectionError);
         }
         */
    }];
    
}


#pragma mark ----- MD5 GET

- (void)httpRequestWithMD5GET:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)getData failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
    
    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];
    
    NSString *paraStr = [Helper dictionaryToJson:getData];
    
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *str = [Helper md5HexDigest:[NSString stringWithFormat:@"%@dagolfla.com", paraStr]];
    
    // 1.创建请求
    NSURL *urls = [NSURL URLWithString:[NSString stringWithFormat:@"%@?md5=%@",url ,str]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urls];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urls cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    request.HTTPMethod = @"GET";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [request setValue:app_Version forHTTPHeaderField:@"AppVersion"];
    [request setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];

    NSData *data2 =[paraStr dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data2;
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            [Helper netWorkError];
            failedBlock(connectionError);
        }else{
            NSHTTPURLResponse *httpResonse=(NSHTTPURLResponse *)response;
            
            if( httpResonse.statusCode != 200 ){
                [Helper netWorkError];
                failedBlock(NSURLErrorDomain);
                return;
            }
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            completionBlock(dic);
        }
    }];
    
}

- (void)httpRequest:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData requestMethod:(NSString *)httpMethod failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{

    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];
    NSLog(@"%@",url);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    if (jsonKey == nil) {
        postDict = [NSMutableDictionary dictionaryWithDictionary:postData];
    }else{
        [postDict setObject:postData forKey:jsonKey];
    }
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //返回数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"AppVersion"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];
    
//    [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //https安全策略
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    
    NSComparisonResult comparison1 = [httpMethod caseInsensitiveCompare:@"GET"];
    NSComparisonResult comparisonResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparison1 == NSOrderedSame)//get
    {
        [manager GET:url parameters:postDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completionBlock) {
                completionBlock(responseObject);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [Helper netWorkError];
            
            if (failedBlock) {
                failedBlock(error);
            }

        }];
    }
        
    if (comparisonResult2 == NSOrderedSame)//post
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
            [manager POST:url parameters:postDict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (completionBlock) {
                    completionBlock(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [Helper netWorkError];
                if (failedBlock) {
                    failedBlock(error);
                }
            }];
            
            
            
        }else{
            [manager POST:url parameters:postDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                //取出需要上传的图片数据
                for (NSString *key in postData) {
                    
                    id value = postData[key];
                    
                    if ([value isKindOfClass:[NSData class]]) {
                        
                        [formData appendPartWithFileData:value
                         
                                                    name:key
                         
                                                fileName:key
                         
                                                mimeType:@"image/png"];
                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (completionBlock) {
                    completionBlock(responseObject);
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [Helper netWorkError];
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

- (void)httpRequestImageOrVedio:(NSString *)url withData:(NSDictionary *)postData andDataArray:(NSArray *)arrayPic failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock{
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://webfile.dagolfla.com/upload.do"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"option\"\r\n\r\n"];
//    NSDictionary *dictJson = [NSDictionary dictionaryWithDictionary:postData];
//  @{@"nType":@"1", @"tag":@"dagolfla", @"data":@"test"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:nil];
    //添加字段的值
    [body appendFormat:@"%@\r\n",  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:arrayPic[0]];
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [request setValue:app_Version forHTTPHeaderField:@"AppVersion"];
    [request setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];

    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    NSData *da = [NSData dataWithData:myRequestData];
    NSString *myRequestString = nil;
    myRequestString = [[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", myRequestString);
    
    //http method
    [request setHTTPMethod:@"POST"];
    
    //错误信息
//    NSError *error = nil;
    //返回数据
//    NSURLResponse *response = nil;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //发送请求
   [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       NSDictionary *dataDict = nil;
       //[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]
       if (data) {
           dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       }else{
           return ;
       }
       
       if ([[NSString stringWithFormat:@"%@", [dataDict objectForKey:@"code"]] isEqualToString:@"1"]) {
           completionBlock(dataDict);
       }else{
           
//           if (connectionError != nil) {
               [Helper netWorkError];
//           }else {
//               [Helper downLoadDataOverrun];
//           }
           
           failedBlock(connectionError);
       }
    }];
}


#pragma mark --多张上传照片
- (void)httpRequestImage:(NSString *)url withData:(NSDictionary *)postData andDataArray:(NSData *)dataPic failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock{
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://webfile.dagolfla.com/upload.do"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"option\"\r\n\r\n"];
    //    NSDictionary *dictJson = [NSDictionary dictionaryWithDictionary:postData];
    //  @{@"nType":@"1", @"tag":@"dagolfla", @"data":@"test"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:nil];
    //添加字段的值
    [body appendFormat:@"%@\r\n",  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:dataPic];
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [request setValue:app_Version forHTTPHeaderField:@"AppVersion"];
    [request setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];

    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    NSData *da = [NSData dataWithData:myRequestData];
    NSString *myRequestString = nil;
    myRequestString = [[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", myRequestString);
    
    //http method
    [request setHTTPMethod:@"POST"];
    
    //错误信息
    //    NSError *error = nil;
    //返回数据
    //    NSURLResponse *response = nil;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dataDict = nil;
        if ([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]) {
            dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }else{
            return ;
        }
        
        if ([[NSString stringWithFormat:@"%@", [dataDict objectForKey:@"code"]] isEqualToString:@"1"]) {
            completionBlock(dataDict);
        }else{
//            if (connectionError != nil) {
                [Helper netWorkError];
//            }else {
//                [Helper downLoadDataOverrun];
//            }

            failedBlock(connectionError);
        }
    }];
}

- (void)httpRequest:(NSString *)url failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
    url = [NSString stringWithFormat:@"%@", url];
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //返回数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //https安全策略
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //当前版本号
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"AppVersion"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"AppSystem"];

    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型

    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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


@end
