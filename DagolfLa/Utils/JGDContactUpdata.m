//
//  JGDContactUpdata.m
//  DagolfLa
//
//  Created by 東 on 17/3/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDContactUpdata.h"
#import <AddressBook/AddressBook.h>

@implementation JGDContactUpdata

+ (void)contanctUpload:(blockContact)contact error:(blockError)error{
    NSMutableDictionary *DataDic = [NSMutableDictionary dictionary];
    [DataDic setObject:DEFAULF_USERID forKey:@"userKey"];
    [DataDic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp] httpRequest:@"mobileContact/getLastUploadTime" JsonKey:nil withData:DataDic requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            // 是否允许同步通讯录
            if ([[data objectForKey:@"upLoadEnable"] boolValue]) {
                
                NSMutableArray *commitContactArray = [NSMutableArray array];
                
                ABAddressBookRef addresBook = ABAddressBookCreateWithOptions(NULL, NULL);
                //获取通讯录中的所有人
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addresBook);
                //通讯录中人数
                CFIndex nPeople = ABAddressBookGetPersonCount(addresBook);
                
                for (NSInteger i = 0; i < nPeople; i++)
                {
                    //获取个人
                    ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                    
                    //电话
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    for (int k = 0; k<ABMultiValueGetCount(phone); k++)
                    {
                        
                        NSMutableDictionary *personDic = [NSMutableDictionary dictionary];
                        
                        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                        
                        if (personPhone) {
                            [personDic setObject:personPhone forKey:@"phone"];
                        }else{
                            continue;
                        }
                        
                        //名字
                        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
                        CFStringRef abFullName = ABRecordCopyCompositeName(person);
                        NSString *nameString = (__bridge NSString *)abName;
                        NSString *lastNameString = (__bridge NSString *)abLastName;
                        
                        if ((__bridge id)abFullName != nil) {
                            nameString = (__bridge NSString *)abFullName;
                        } else {
                            if ((__bridge id)abLastName != nil)
                            {
                                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                            }
                        }
                        
                        if (nameString) {
                            [personDic setObject:nameString forKey:@"cName"];
                        }
                        // 公司
                        NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
                        //      工作         NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
                        if (organization) {
                            [personDic setObject:organization forKey:@"workUnit"];
                        }
                        //第一次添加该条记录的时间
                        NSString *firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
                        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
                        //最后一次修改該条记录的时间
                        NSDate *lastknow = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
                        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
                        ;
                        // 最后一次上传的时间  如果第一次上传没有该参数
                        if ([data objectForKey:@"lastTime"]) {
                            // 最后一次修改的时间
                            CGFloat last = [[Helper getNowDateFromatAnDate:lastknow] timeIntervalSince1970];
                            // 最后一次上传的时间
                            NSString *current = [data objectForKey:@"lastTime"];
                            NSDateFormatter * dm = [[NSDateFormatter alloc]init];
                            [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSDate * newdate = [dm dateFromString:current];
                            NSDate *lastDate = [Helper getNowDateFromatAnDate:newdate];
                            CGFloat currentDate = [lastDate timeIntervalSince1970];
                            if (last > currentDate) {
                                [commitContactArray addObject:personDic];
                            }
                            
                        }else{
                            [commitContactArray addObject:personDic];
                            
                        }
                    }
                }
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:DEFAULF_USERID forKey:@"userKey"];
                [dic setObject:commitContactArray forKey:@"contactList"];
                if ([commitContactArray count] != 0) {
                    [[JsonHttp jsonHttp] httpRequestWithMD5:@"mobileContact/doUploadContacts" JsonKey:nil withData:dic failedBlock:^(id errType) {
                        error([NSString stringWithFormat:@"%@",errType]);

                    } completionBlock:^(id data) {
                        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                            
                            // * 获取用户的通讯录列表
                            NSDictionary *userDic = [NSMutableDictionary dictionary];
                            [userDic setValue:DEFAULF_USERID forKey:@"userKey"];
                            [userDic setValue: [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
                            [[JsonHttp jsonHttp] httpRequest:@"mobileContact/getUserMobileContactList" JsonKey:nil withData:userDic requestMethod:@"GET" failedBlock:^(id errType) {
                                
                            } completionBlock:^(id data) {
                                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                                    if ([data objectForKey:@"cList"]) {
                                        contact([data objectForKey:@"cList"]);
                                    }
                                }
                            }];
                            
                            
                        }else{
                            if ([data objectForKey:@"packResultMsg"]) {
                                error([data objectForKey:@"packResultMsg"]);
                            }
                        }
                    }];
                }else{
                    // * 获取用户的通讯录列表
                    
                    NSDictionary *userDic = [NSMutableDictionary dictionary];
                    [userDic setValue:DEFAULF_USERID forKey:@"userKey"];
                    [userDic setValue: [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
                    [[JsonHttp jsonHttp] httpRequest:@"mobileContact/getUserMobileContactList" JsonKey:nil withData:userDic requestMethod:@"GET" failedBlock:^(id errType) {
                        error([NSString stringWithFormat:@"%@",errType]);

                    } completionBlock:^(id data) {
                        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                            if ([data objectForKey:@"cList"]) {
                                contact([data objectForKey:@"cList"]);
                            }
                        }else{
                            if ([data objectForKey:@"packResultMsg"]) {
                                error([data objectForKey:@"packResultMsg"]);
                            }
                        }
                    }];
                    
                }
            }
        }
    }];
}



/**
 * 获取用户的通讯录列表
 * @Title: getUserMobileContactList
 * @param userKey
 * @param md5
 * @param response
 * @throws Throwable
 * @author lyh
 @HttpService(RequestURL = "/getUserMobileContactList" , method = "get")
 public void getUserMobileContactList(
 @Param(value="userKey",  require=true) Long   userKey,
 @Param(value = "md5"  ,  require=true) String md5,
 TcpResponse  response
 ) throws Throwable{
 */


@end
