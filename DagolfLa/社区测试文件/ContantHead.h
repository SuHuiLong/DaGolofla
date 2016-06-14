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


//userId
#define userID @"userId"
#define DEFAULF_USERID [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
//1001-活动，1003,1001,1004,1002,1005
//#define ActivityKey @"activityKey"
//#define HEADERRImage @"logo"//头像默认图片
#define BACKImage @"backL"//返回按钮
//#define BGImage @"selfBackPic.jpg"//背景图片

#define TeamBGImage @"teamBGImage"// 球队背景图片
#define TeamLogoImage @"teamLogo"//logo白色图片
#define IconLogo @"iconlogo"//绿色app logo
#define ActivityBGImage @"activityBGImage"

#define kDistance 10*screenWidth/375 //说说和图片的间隔
#define kReplyBtnDistance 30*screenWidth/375 //回复按钮距离
#define kReply_FavourDistance 8*screenWidth/375 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

//判断是否是Iphone型号
#define iPhone6Plus1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2001),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

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

#define BG_color @"#EEEEEF"
#define TB_BG_Color @"#CFCFCF"
#define Nav_Color @"#F59826"
//正式环境图片基础地址
#define imageBaseUrl @"http://139.196.9.49:8081/"
//测试环境图片基础地址//#define IMAGE_VEDIO_BASEURL @""
//#define imageBaseUrl @"http://192.168.2.38:8088/"

#define CornerRadiu 8.0 //圆角值

//上传图片的打高尔夫啦tag
#define PHOTO_DAGOLFLA @"dagolfla"

#define TYPE_TEAM_HEAD       @1   // 球队头像类型
#define TYPE_TEAM_BACKGROUND @2   // 球队背景类型
#define TYPE_MEDIA_IMAGE     @3   // 相册的媒介图像
#define TYPE_MEDIA_VIDEO     @4   // 相册的媒介视频
#define TYPE_USER_HEAD       @5   // 用户头像

#import "UIColor+ColorTransfer.h"
#import "JsonHttp.h"
#import "Helper.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShowHUD.h"

//share
#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#endif
