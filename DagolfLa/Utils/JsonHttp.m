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
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
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
                if ([[error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 61) {
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

- (void)cancelRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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
       NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       if ([[NSString stringWithFormat:@"%@", [dataDict objectForKey:@"code"]] isEqualToString:@"1"]) {
           completionBlock(dataDict);
       }else{
           if ([[connectionError.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 61) {
               [Helper downLoadDataOverrun];
           }else if ([[connectionError.userInfo objectForKey:@"_kCFStreamErrorCodeKey"] integerValue] == 51) {
               [Helper netWorkError];
           }else{
               //参数错误
           }
           failedBlock(connectionError);
       }
    }];
}

@end
