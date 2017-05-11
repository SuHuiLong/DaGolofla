//
//  InitAdvertiseView.m
//  DagolfLa
//
//  Created by SHL on 2017/5/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "InitAdvertiseView.h"
#import "AdvertiseView.h"
#import "JGLAnimationViewController.h"
#import "TabBarController.h"
@implementation InitAdvertiseView

-(instancetype)init{
    self = [super init];
    if (self) {
        // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
        [self getAdvertisingImageWithUrl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAdView) name:@"pushtoad" object:nil];
    }
    return self;
}

//初始化广告页面
- (void)getAdvertisingImage
{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示]
    NSArray *dataArray = [UserDefaults objectForKey:@"adData"];
    BOOL isExistPic = false;
    for (NSDictionary *imageDict in dataArray) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
        NSString *imageName = [imageDict objectForKey:@"imageName"];
        int A = [self compareDate:currentDateStr withDate:imageName];
        switch (A) {
            case -1:{
                [self deleteOldImage:imageName];
            }break;
            case 0:{
                NSString *filePath = [self getFilePathWithImageName:imageName];
                BOOL isExist = [self isFileExistWithFilePath:filePath];
                if (isExist&&DEFAULF_USERID) {// 图片存在
                    isExistPic = true;
                    AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    advertiseView.filePath = filePath;
                    [advertiseView setCallBack:^{
                        [self startApp];
                    }];
                    if (filePath.length>0) {
                        [advertiseView show];
                    }
                    break;
                }
            }break;
            default:
                break;
        }
    }
    if (!isExistPic||!DEFAULF_USERID) {
        JGLAnimationViewController* aniVc = [[JGLAnimationViewController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = aniVc;
        [aniVc setCallBack:^{
            [self startApp];
        }];
    }
}
//判断文件是否存在
- (BOOL)isFileExistWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

//初始化广告页面
- (void)getAdvertisingImageWithUrl{
    // TODO 请求广告接口
    NSDictionary *dict = [NSDictionary dictionary];
    if (DEFAULF_USERID) {
        dict = @{
                 @"userKey":DEFAULF_USERID
                 };
    }
    [[JsonHttp jsonHttp] httpRequest:@"index/getStartPageList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSArray *listArray = [data objectForKey:@"list"];
        NSMutableArray *mDataArray = [NSMutableArray arrayWithArray:[UserDefaults objectForKey:@"adData"]];
        for (int i = 0; i<listArray.count; i++) {
            
            NSDictionary *imageDict = listArray[i];
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            NSMutableString *mImageName = [NSMutableString stringWithFormat:@"%@",[imageDict objectForKey:@"startTime"]];
            NSString * imageName =  [mImageName substringToIndex:10];
            NSString * picURL = [imageDict objectForKey:@"picURL"];
            NSString * webLinkURL = [imageDict objectForKey:@"webLinkURL"];
            [mDict setValue:imageName forKey:@"imageName"];
            [mDict setValue:picURL forKey:@"picURL"];
            [mDict setValue:webLinkURL forKey:@"webLinkURL"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
            int A = [self compareDate:currentDateStr withDate:imageName];
            if (A>-1) {
                BOOL isExist = false;
                for (int j = 0; j<mDataArray.count; j++) {
                    NSDictionary *isExistDict = mDataArray[j];
                    NSString *isExistPicURL = [isExistDict objectForKey:@"picURL"];
                    NSString *isExistImageName = [isExistDict objectForKey:@"imageName"];
                    NSString *isExistWebLInkURL = [isExistDict objectForKey:@"webLinkURL"];
                    
                    BOOL picURLEquel = [isExistPicURL isEqualToString:picURL];
                    BOOL nameEquel  = [isExistImageName isEqualToString:imageName];
                    BOOL webLinkEquel = [isExistWebLInkURL isEqualToString:webLinkURL];
                    
                    if (picURLEquel&&nameEquel&&webLinkEquel) {
                        isExist = true;
                    }
                    if (!(picURLEquel&&webLinkEquel)&&nameEquel) {
                        [mDataArray removeObject:mDict];
                        [self deleteOldImage:imageName];
                        for (int i = 0; i<mDataArray.count; i++) {
                            NSDictionary *imageDict = mDataArray[i];
                            NSString *ImageName = [imageDict objectForKey:@"imageName"];
                            if ([ImageName isEqualToString:imageName]) {
                                [mDataArray removeObjectAtIndex:i];
                            }
                        }
                    }
                }
                if (!isExist) {
                    [mDataArray addObject:mDict];
                }
            }
        }
        [UserDefaults setValue:mDataArray forKey:@"adData"];
    }];
    
    NSArray *listArray = [UserDefaults objectForKey:@"adData"];
    for (NSDictionary *imageDict in listArray) {
        // 获取图片名
        NSString * imageName =  [imageDict objectForKey:@"imageName"];
        // 拼接沙盒路径
        NSString *filePath = [self getFilePathWithImageName:imageName];
        BOOL isExist = [self isFileExistWithFilePath:filePath];
        NSString *imageUrl = [imageDict objectForKey:@"picURL"];
        if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
            [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        }
    }
}
//下载新图片
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            // 保存成功
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
    });
}

//删除旧图片
- (void)deleteOldImage:(NSString *)imageName
{
    NSString *filePath = [self getFilePathWithImageName:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[UserDefaults objectForKey:@"adData"]];
    
    for (int i = 0; i<dataArray.count; i++) {
        NSDictionary *imageDict = dataArray[i];
        NSString *ImageName = [imageDict objectForKey:@"imageName"];
        if ([ImageName isEqualToString:imageName]) {
            [dataArray removeObjectAtIndex:i];
        }
    }
    [UserDefaults setValue:dataArray forKey:@"adData"];
}

//根据图片名拼接文件路径
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    
    return nil;
}
//照片时间比较
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result){
            //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci=-1;
            break;
            //date02=date01
        case NSOrderedSame:
            ci=0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}



//点击跳转
-(void)pushAdView{
    NSArray *dataArray = [UserDefaults objectForKey:@"adData"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    NSDictionary *imageDict = [NSDictionary dictionary];
    
    for (NSDictionary *indexDict in dataArray) {
        NSString *imageName = [indexDict objectForKey:@"imageName"];
        if ([imageName isEqualToString:currentDateStr]) {
            imageDict = indexDict;
            break;
        }
    }
    NSString *urlString = [imageDict objectForKey:@"webLinkURL"];
    if ([urlString containsString:@"dagolfla://"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITabBarController *tabVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            [[JGHPushClass pushClass] URLString:urlString pushVC:^(UIViewController *vc) {
                vc.hidesBottomBarWhenPushed = YES;
                [pushClassStance pushViewController:vc animated:YES];
            }];
        });
    }
}


#pragma mark - 软件开始运行
-(void)startApp{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarController alloc]init];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}



@end
