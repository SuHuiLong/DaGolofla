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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError *error;
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:postData forKey:@"teamActivity"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
//    NSString *str1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSString *jsonString=[str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //设置请求格式Json
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
//    NSDictionary *parameters = @{@"1":@"XXXX",@"2":@"XXXX",@"3":@"XXXXX"};
    //你的接口地址
//    NSString *url=@"http://xxxxx";
//    //发送请求
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    NSString *accept = [NSString stringWithFormat:@"application/json"];
//    [manager setValue:accept forHTTPHeaderField: @"Accept"];
//    [manager setValue:accept forKey:@"Accept"];
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
