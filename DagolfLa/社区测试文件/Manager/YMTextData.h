//
//  YMTextData.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFMessageBody.h"



typedef enum : NSUInteger {
    TypeShuoshuo,
    TypeFavour,
    TypeReply,
    TypeShare,
} TypeView;

@interface YMTextData : NSObject


//动态类型 社区：0  足迹：1
@property (copy, nonatomic) NSNumber* moodType;




@property (nonatomic,strong) WFMessageBody  *messageBody;
@property (nonatomic,strong) NSMutableArray *replyDataSource;//回复内容数据源（未处理）

#pragma mark - 高度部分
@property (nonatomic,assign) float           replyHeight;//回复高度
@property (nonatomic,assign) float           shuoshuoHeight;//折叠说说高度
@property (nonatomic,assign) float           unFoldShuoHeight;//展开说说高度
@property (nonatomic,assign) float           favourHeight;//点赞的高度
@property (nonatomic,assign) float           shareHeight;//分享的高度
@property (nonatomic,assign) float           showImageHeight;//展示图片的高度
@property (nonatomic, assign) NSInteger userId; // uId 判断这条状态是否是自己的

@property (nonatomic, assign) BOOL isHaveDistance; // 是否有球场和距离

//点赞数量
@property (copy, nonatomic) NSNumber* assistCount;
//评论数量
@property (copy, nonatomic) NSNumber* commentCount;
//转发数量
@property (copy, nonatomic) NSNumber* forwardNum;
//球场名称
@property (copy, nonatomic) NSString* golfName;


//////////////////////


////动态id
@property (copy, nonatomic) NSNumber* userMoodId;

////评论id
@property (copy, nonatomic) NSNumber* userCommentId;


//心情内容
@property (copy, nonatomic) NSString* moodContent;
////用户id
@property (copy, nonatomic) NSNumber* uId;
////图片
//@property (copy, nonatomic) NSString* pic;
////发布时间
//@property (copy, nonatomic) NSDate* createTime;
////经纬度坐标
//@property (copy, nonatomic) NSNumber* xIndex, *yIndex;
////位置id
//@property (copy, nonatomic) NSNumber* placeId;
////动态类型 社区：0  足迹：1
//@property (copy, nonatomic) NSNumber* moodType;
//杆数
@property (copy, nonatomic) NSNumber* poleNum;
//打球日期
@property (copy, nonatomic) NSDate* playTime;
////打球日期
//@property (copy, nonatomic) NSString* playTimes;
////是否同步 否：0 是：1
//@property (copy, nonatomic) NSNumber* isSync;
////查询状态： 全部：无  关注：0 附近：1
//@property (copy, nonatomic) NSNumber* searchState;
//用户头衔
@property (copy, nonatomic) NSString* uPic;
//用户名称
@property (copy, nonatomic) NSString* userName;
//公里数
@property (copy, nonatomic) NSNumber* distance;
////球场名称
//@property (copy, nonatomic) NSString* golfName;
////点赞数量
//@property (copy, nonatomic) NSNumber* assistCount;

////评论数量
//@property (copy, nonatomic) NSNumber* commentCount;
////是否收藏： 否：0 是：1
//@property (copy, nonatomic) NSNumber* collectionState;
//是否点赞： 否：0 是：1
@property (copy, nonatomic) NSNumber* assistState;
//
//
//@property (strong, nonatomic) NSNumber* almost;
//@property (strong, nonatomic) NSNumber* sex;
//@property (strong, nonatomic) NSNumber* age;
//
//附件动态图片列表
@property (copy, nonatomic) NSArray* pics;
////点赞列表
@property (copy, nonatomic) NSMutableArray* tUserAssists;
////分享列表
@property (copy, nonatomic) NSMutableArray* userForwards;
//
////用户背景图片
//@property (copy, nonatomic) NSArray* backPic;
//
@property (copy, nonatomic) NSNumber* followState;

// 判断高和宽谁长    高长：1   宽长： 2  一样长： 3
@property (assign, nonatomic) NSInteger JavaRubbish;

/////////////////////

@property (nonatomic,strong) NSMutableArray *completionReplySource;//回复内容数据源（处理）
@property (nonatomic,strong) NSMutableArray *attributedDataReply;//回复部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataShuoshuo;//说说部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataFavour;//点赞部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataShare;//分享部分附带的点击

@property (nonatomic,strong) NSArray        *showImageArray;//图片数组
@property (nonatomic,strong) NSMutableArray *favourArray;//点赞昵称数组
@property (nonatomic,strong) NSMutableArray *shareArray;//分享昵称数组
@property (nonatomic,strong) NSMutableArray *defineAttrData;//自行添加 元素为每条回复中的自行添加的range组成的数组 如：第一条回复有（0，2）和（5，2） 第二条为（0，2）。。。。

@property (nonatomic,assign) BOOL            hasFavour;//是否赞过
@property (nonatomic,assign) BOOL            foldOrNot;//是否折叠
@property (nonatomic,copy) NSString       *showShuoShuo;//说说部分
@property (nonatomic,copy) NSString       *completionShuoshuo;//说说部分（处理后）
@property (nonatomic,copy) NSString       *showFavour;//点赞部分
@property (nonatomic,copy) NSString       *completionFavour;//点赞部分(处理后)
@property (nonatomic,copy) NSString       *showShare; //分享部分
@property (nonatomic,copy) NSString       *completionShare;//分享部分(处理后)
@property (nonatomic,assign) BOOL            islessLimit;//是否小于最低限制 宏定义最低限制是 limitline

//视频URL -- 2016-05-03
@property (nonatomic, strong)NSString *videoPath;

/**
 *  计算高度
 *
 *  @param sizeWidth view 宽度
 *
 *  @return 返回高度
 */
- (float) calculateReplyHeightWithWidth:(float)sizeWidth;

/**
 *  计算折叠还是展开的说说的高度
 *
 *  @param sizeWidth 宽度
 *  @param isUnfold  展开与否
 *
 *  @return 高度
 */
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold;

/**
 *  点赞区域高度
 *
 *  @param sizeWidth 宽度
 *
 *  @return 高度
 */
- (float)calculateFavourHeightWithWidth:(float)sizeWidth;
- (float)calculateShareHeightWithWidth:(float)sizeWidth;

- (id)initWithMessage:(WFMessageBody *)messageBody;
@end
