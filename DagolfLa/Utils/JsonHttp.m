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




- (void)httpRequest:(NSString *)url JsonKey:(NSString *)jsonKey withData:(NSDictionary *)postData andArray:(NSArray *)arrayPic requestMethod:(NSString *)httpMethod failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock
{
//    url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,url];
    url = @"http://192.168.1.101:8080/upload.do";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    if (jsonKey == nil) {
//        postDict = [NSMutableDictionary dictionaryWithDictionary:postData];
//    }else{
//        [postDict setObject:postData forKey:jsonKey];
//    }
    
//    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
//    [manager POST:url parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (completionBlock) {
//            completionBlock(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failedBlock) {
//            failedBlock(error);
//        }
//    }];
    
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id formData) {
        
//        for (int i = 0; i <imageDataArr.count; i++) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置日期格式
//            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            NSString *fileName = [formatter stringFromDate:[NSDate date]];
//            NSString *nameStr = @"backPic";
//            
//            [formData appendPartWithFileData:imageDataArr[i] name:nameStr fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png"];
//        }
        
        //取出需要上传的图片数据
        
        [formData appendPartWithHeaders:postData body:arrayPic[0]];
//        [formData appendPartWithFormData:arrayPic[0] name:@"/team/11010.png"];
//        [formData appendPartWithFileData:arrayPic[0] name:@"/team/11010.png" fileName:@"11010" mimeType:@"image.png"];

//        for (NSString *key in postData) {
//            
//            id value = postData[key];
//            
//            if ([value isKindOfClass:[NSData class]]) {
//                
//                
//            }
//        }
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

//- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
//    // 构造 NSURLRequest
//    NSError* error = NULL;
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[self uploadUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"someFileName" mimeType:@"multipart/form-data"];
//    } error:&error];
//    
//    // 可在此处配置验证信息
//    
//    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
//    } completionHandler:completionBlock];
//    
//    return uploadTask;
//}

////分界线的标识符
//NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
////根据url初始化request
//NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                   timeoutInterval:10];
////分界线 --AaB03x
//NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
////结束符 AaB03x--
//NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
////要上传的图片
//UIImage *image=[params objectForKey:@"pic"];
////得到图片的data
//NSData* data = UIImagePNGRepresentation(image);
////http body的字符串
//NSMutableString *body=[[NSMutableString alloc]init];
////参数的集合的所有key的集合
//NSArray *keys= [params allKeys];
//
////遍历keys
//for(int i=0;i<[keys count];i++)
//{
//    //得到当前key
//    NSString *key=[keys objectAtIndex:i];
//    //如果key不是pic，说明value是字符类型，比如name：Boris
//    if(![key isEqualToString:@"pic"])
//    {
//        //添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        //添加字段名称，换2行
//        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//        //添加字段的值
//        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
//    }
//}
//
//////添加分界线，换行
//[body appendFormat:@"%@\r\n",MPboundary];
////声明pic字段，文件名为boris.png
//[body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
////声明上传文件的格式
//[body appendFormat:@"Content-Type: image/png\r\n\r\n"];
//
////声明结束符：--AaB03x--
//NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
////声明myRequestData，用来放入http body
//NSMutableData *myRequestData=[NSMutableData data];
////将body字符串转化为UTF8格式的二进制
//[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
////将image的data加入
//[myRequestData appendData:data];
////加入结束符--AaB03x--
//[myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//
////设置HTTPHeader中Content-Type的值
//NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
////设置HTTPHeader
//[request setValue:content forHTTPHeaderField:@"Content-Type"];
////设置Content-Length
//[request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
////设置http body
//[request setHTTPBody:myRequestData];
////http method
//[request setHTTPMethod:@"POST"];
//
////建立连接，设置代理
//NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//
////设置接受response的data
//if (conn) {
//    mResponseData = [[NSMutableData data] retain];
//}

@end
