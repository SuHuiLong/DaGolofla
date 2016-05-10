//
//  ContantHead.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#ifndef WFCoretext_ContantHead_h
#define WFCoretext_ContantHead_h

typedef NS_ENUM(NSInteger, GestureType) {
    
    TapGesType = 1,
    LongGesType,
    
};

#define TableHeader 50*screenWidth/375
#define ShowImage_H 80*screenWidth/375
#define PlaceHolder @" "
#define offSet_X 70*screenWidth/375
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"

#define kDistance 10*screenWidth/375 //说说和图片的间隔
#define kReplyBtnDistance 30*screenWidth/375 //回复按钮距离
#define kReply_FavourDistance 8*screenWidth/375 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;


#define BackBtnFrame CGRectMake(0, 0, 44, 44)
#define RightNavItemFrame CGRectMake(0, 0, 84, 44)
#define FontSize_Normal 30.0/2
//系统导航
#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
//网络状态
#define NETWORKSTATS @"networkStats"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

//正式环境图片基础地址
#define imageBaseUrl @"http://139.196.9.49:8081/"
//测试环境图片基础地址//#define IMAGE_VEDIO_BASEURL @""
//#define imageBaseUrl @"http://192.168.2.38:8088/"

#endif
