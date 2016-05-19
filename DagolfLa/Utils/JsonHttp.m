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

- (void)httpRequest:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData requestMethod:(NSString *)httpMethod failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];
    NSLog(@"%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    if (jsonKey == nil) {
        postDict = [NSMutableDictionary dictionaryWithDictionary:postData];
    }else{
        [postDict setObject:postData forKey:jsonKey];
    }
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //返回数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //https安全策略
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    
    NSComparisonResult comparison1 = [httpMethod caseInsensitiveCompare:@"GET"];
    NSComparisonResult comparisonResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparison1 == NSOrderedSame)
    {
        [manager GET:url parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (completionBlock) {
                completionBlock(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
            [manager POST:url parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (completionBlock) {
                    completionBlock(responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 60) {
                    [Helper downLoadDataOverrun];
                }else if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
                    [Helper netWorkError];
                }
                if (failedBlock) {
                    failedBlock(error);
                }
            }];
        }else
        {
            [manager POST:url parameters:postDict constructingBodyWithBlock:^(id formData) {
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
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (completionBlock) {
                    completionBlock(responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failedBlock) {
                    failedBlock(error);
                }
            }];
        }
    }
}




- (void)httpRequest:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData andArray:(NSArray *)arrayPic requestMethod:(NSString *)httpMethod failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    if (jsonKey == nil) {
        postDict = [NSMutableDictionary dictionaryWithDictionary:postData];
    }else{
        [postDict setObject:postData forKey:jsonKey];
    }
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    [manager POST:url parameters:postDict constructingBodyWithBlock:^(id formData) {
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
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionBlock) {
            completionBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}


- (void)cancelRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
}

@end
