//
//  YMTableViewCell.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"


typedef NS_ENUM(NSInteger, WFOperationType) {
    WFOperationTypeReply = 0,
    WFOperationTypeLike = 1,
    WFOperationTypeShare = 2
};

typedef void(^DidSelectedOperationBlock)(WFOperationType operationType);




@protocol cellDelegate <NSObject>

- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag withLittleArray:(NSMutableArray*)littleArray;
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
//播放视频
- (void)playWithStopVideoURL:(NSString *)videoURL;

@end

@interface YMTableViewCell : UITableViewCell<WFCoretextDelegate>

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * ymTextArray;
@property (nonatomic,strong) NSMutableArray * ymFavourArray;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,assign) id<cellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) YMButton *replyBtn;


@property (nonatomic,strong) UIView * distance;//距离View
@property (strong, nonatomic) UIImageView* locationImg;//定位图标
@property (strong, nonatomic) UILabel* labelDistance, *labelCities;//定位


@property (nonatomic,strong) UIView * footView;//足迹View
@property (strong, nonatomic) UILabel *labelFoot, *footTime, *footNum;//足迹


@property (nonatomic,strong) UIView * zpfView;//赞、评论、分享View
@property (strong, nonatomic) UIButton* zanBtn,*disCussBtn,*shareBtn;
@property (nonatomic,strong) UIImageView *favourImage;//点赞的图

@property (nonatomic,strong) UIImageView *shareImage;//点赞的图

@property (nonatomic,assign) float           totalCellHeight;


/**
 *  用户头像imageview
 */
@property (nonatomic,strong) UIImageView *userHeaderImage;

/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *userNameLbl;

/**
 *  用户简介label
 */
@property (nonatomic,strong) UILabel *userIntroLbl;

/**
 *  关注Button
 */
@property (nonatomic,strong) UIButton *attentionBtn;



@property (nonatomic, strong) UIButton *moreLikeBtn;
@property (nonatomic, strong) UIButton *moreShareBtn;
/////

@property (nonatomic, assign) BOOL shouldShowed;

@property (nonatomic, copy) DidSelectedOperationBlock didSelectedOperationCompletion;


- (void)showAtView:(UIView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour;

- (void)dismiss;

@property (nonatomic,copy) void(^blockSelf)(NSInteger);


////
- (void)setYMViewWith:(YMTextData *)ymData;

@property (nonatomic, strong)NSMutableArray *littleArray;


@end
