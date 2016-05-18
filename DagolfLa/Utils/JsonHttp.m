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

- (void) httpRequest:(NSString *)url
            withData:(NSDictionary *)postData
       requestMethod:(NSString*)httpMethod
         failedBlock:(GBHEFailedBlock)failedBlock
     completionBlock:(GBHECompletionBlock)completionBlock
{
    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];
    NSLog(@"%@",url);
    NSData *data=[NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableString *jsonString=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *str1=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求格式Json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //返回数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //https安全策略
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    
    NSComparisonResult comparison1 = [httpMethod caseInsensitiveCompare:@"GET"];
    NSComparisonResult comparisonResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparison1 == NSOrderedSame)
    {
        [manager GET:url parameters:@{@"json":jsonString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [manager POST:url parameters:@{@"json":jsonString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (completionBlock) {
                    completionBlock(responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failedBlock) {
                    failedBlock(error);
                }
            }];
        }else
        {
            [manager POST:url parameters:@{@"json":jsonString} constructingBodyWithBlock:^(id formData) {
                //取出需要上传的图片数据
                for (NSString *key in postData) {
                    
                    id value = postData[key];
                    
                    if ([value isKindOfClass:[NSData class]]) {
                        
                        [formData appendPartWithFileData:value
                         
                                                    name:key
                         
                                                fileName:key
                         
                                                mimeType:@"image/jpg"];
                        
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

- (void)cancelRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
}

@end
