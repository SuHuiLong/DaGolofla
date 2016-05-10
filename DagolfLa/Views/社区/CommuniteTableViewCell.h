//
//  CommuniteTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"


#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "ShareAlert.h"

@interface CommuniteTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *picImage1;
@property (strong, nonatomic) UIImageView *picImage2;
@property (strong, nonatomic) UIImageView *picImage3;


@property (strong, nonatomic) UIButton* zanPeopleIcon;


/**
 *  头像背景按钮
 */
@property (strong, nonatomic) UIButton* btn;
/**
 *  头像图片
 */
@property (strong, nonatomic) UIImageView* iconImgv;
//昵称
@property (strong, nonatomic) UILabel* labelTitle;
//时间
@property (strong, nonatomic) UILabel* labelTime;

//举报
@property (strong, nonatomic) UIButton* reportBtn;

//用户发布的信息
@property (strong, nonatomic) UILabel* labelContent;
//用户发布的图片
@property (strong, nonatomic) UIImageView* isUseImgv;

@property (strong, nonatomic) UILabel* labelImgvCount;
//定位图标
@property (strong, nonatomic) UIImageView* locationImg;
//定位
@property (strong, nonatomic) UILabel* labelDistance, *labelCities, *labelFoot, *footTime, *footNum;
//喜欢的按钮,赞按钮，评论按钮
@property (strong, nonatomic) UIButton* btnLike, *zanBaseBtn, *disCussBtnBase;

//分割线
@property (strong, nonatomic) UIView* viewLine1;
//赞按钮
@property (strong, nonatomic) UIButton* btnZan;
//赞的人数
@property (strong, nonatomic) UILabel* labelZan;
//评论图标
@property (strong, nonatomic) UIButton* btnDiscuss;
//评论人数
@property (strong, nonatomic) UILabel* labelDis;
//分享
@property (strong, nonatomic) UIButton* shareBtn;
//分割线
@property (strong, nonatomic) UIView* viewLine2;
//显示赞的头像图标
@property (strong, nonatomic) UIImageView* discussImg;

//共几张照片
@property (strong, nonatomic) UILabel* picCount;


//cell上面控件View
@property (strong, nonatomic) UIView* ClubView;
@property (strong, nonatomic) UIView* FootView;
@property (strong, nonatomic) UIView* ZPFView;
@property (strong, nonatomic) UIView* ZanView;


-(void)awakeFromNib;

-(void)setZanIcon:(NSArray *)iconArr;

// 记录有还是没有他们的高度
@property (assign, nonatomic) NSInteger viewHeight;
@property (assign, nonatomic) NSInteger newHeight;

@property (assign, nonatomic) NSInteger cellIndexPath;
@property (copy, nonatomic) NSMutableArray * cellDataArray;

// 记录传来的model数据
@property (strong, nonatomic) CommunityModel *communityModel;
//图片跳转Block
@property (copy, nonatomic) void(^blockPicPush)(NSInteger, NSMutableArray *);

//点击头像跳转block
@property (copy, nonatomic) void(^blockIconPush)(NSNumber *);
//点击评论跳转block
@property (copy, nonatomic) void(^blockPinglunPush)(NSInteger);
//点击关注调用Block
@property (copy, nonatomic) void(^blockIsLogin)();
//点击点赞跳转block
@property (copy, nonatomic) void(^blockAddZanIcon)(UIButton *);

//点击更多赞调用Block
@property (copy, nonatomic) void(^blockMoreZan)();

//点击点赞跳转block
@property (copy, nonatomic) void(^blockShare)();


//点举报调用Block
@property (copy, nonatomic) void(^blockReportBtn)();

@end
