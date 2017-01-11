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
#define Mobile @"mobile"
#define PHPState @"phpstate"
#define UserName @"userName"
#define UserKey @"userKey"

#define IconCount @"iconCount"
#define DEFAULF_IconCount [[NSUserDefaults standardUserDefaults] objectForKey:IconCount]

// 系统ID
#define SYSTEM_ID @"-1"
// 球队ID
#define TEAM_ID @"-2"
// 新朋友ID
#define NEW_FRIEND_ID @"-3"

#define APPDATA @"appData"

#define DEFAULF_UserName [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]
#define DEFAULF_USERID [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
//提示框时间
#define TIMESlEEP 1.5
#define BACKImage @"backL"//返回按钮

#define TeamBGImage @"teamBGImage"// 球队背景图片
#define TeamLogoImage @"teamLogo"//logo白色图片
#define IconLogo @"iconlogo"//绿色app logo
#define ActivityBGImage @"teamBGImage"

// 4008605308 公司400电话
#define Company400 @"4008605308"

#define BDMAPLAT @"lat"
#define BDMAPLNG @"lng"
#define CITYNAME @"cityName"

#define loadingString @"加载中..."

#define kDistance 10*screenWidth/375 //说说和图片的间隔
#define kReplyBtnDistance 30*screenWidth/375 //回复按钮距离
#define kReply_FavourDistance 8*screenWidth/375 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height


#ifdef DEBUG
#define RongYunAPPKEY @"pgyu6atqylmiu"//pgyu6atqylmiu
#else
#define RongYunAPPKEY @"pgyu6atqylmiu"//0vnjpoadnkihz
#endif
//#define TESTRongYunAPPKEY @"pgyu6atqylmiu"//pgyu6atqylmiu
//#define RongYunAPPKEY @"0vnjpoadnkihz"//0vnjpoadnkihz

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

// 判断是否为空
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

#define SY_PriceColor @"#ef491c"
#define BG_color @"#EEEEEE"
#define Prompt_Color @"#F39800"
#define Nav_Color @"#F59826"
#define Cancel_Color @"#E5621E"
#define NoClick_Color @"#DDDDDD"
#define Click_Color @"#F08900"
#define Bar_Color @"#32B14D"
#define Line_Color @"#d2d2d2"

#define Par_jian @"#3586d8"
#define Par_jia @"#e8625a"
#define Par_b @"#b4b3b3"
#define Par_Eagle @"#7fffff"
#define Par_Birdie @"#7fbfff"
#define Par_Par @"#ffd2a6"
#define Par_Bogey @"#ffaaa5"

#define Bar_Segment @"#32b14b"

#define B31_Color @"#313131"
#define Ba0_Color @"#a0a0a0"

#define ProportionAdapter screenWidth/375

#define NUMBERS @"0123456789\n"

//#define SwitchMode @"switchMode"

//正式环境图片基础地址
#define imageBaseUrl @"http://www.dagolfla.com:8081/"
//测试环境图片基础地址//#define IMAGE_VEDIO_BASEURL @""
//#define imageBaseUrl @"http://192.168.2.38:8088/"

#define CornerRadiu 8.0 //圆角值

//上传图片的打高尔夫啦tag
#define PHOTO_DAGOLFLA @"dagolfla"

//默认头像
#define DefaultHeaderImage @"moren.jpg"

#define TYPE_TEAM_HEAD       @1   // 球队头像类型
#define TYPE_TEAM_BACKGROUND @2   // 球队背景类型
#define TYPE_MEDIA_IMAGE     @3   // 相册的媒介图像
#define TYPE_MEDIA_VIDEO     @4   // 相册的媒介视频
#define TYPE_USER_HEAD       @5   // 用户头像
#define TYPE_USER_CERTIFICATION       @9   // 实名认证
#define TYPE_FEEDBACK_HEAD       @12   // 用户头像
#define TYPE_MATCH_HEAD       @15   // 赛事头像

#import "UIColor+ColorTransfer.h"
#import "JsonHttp.h"
#import "Helper.h"
#import "JGReturnMD5Str.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShowHUD.h"

//share
#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "FCUUID.h"
#import "JGHLoginViewController.h"
#import "UITool.h"
#import "UMMobClick/MobClick.h"
#import "JGHPersonalInfoViewController.h"
#import "JGHDatePicksViewController.h"

#endif
