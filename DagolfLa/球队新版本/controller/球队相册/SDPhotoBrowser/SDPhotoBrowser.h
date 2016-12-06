//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGPhotoListModel.h"

@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

//移除图片
- (void)removePhotoBrowser;

@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSMutableArray* arrayData;//接受数据模型
@property (strong, nonatomic) NSString* power;//权限管控
@property (strong, nonatomic) NSNumber* state;//球队状态
@property (strong, nonatomic) NSString* teamName;//球队名
@property (strong, nonatomic) NSNumber* teamTimeKey;//球队的timekey
@property (strong, nonatomic) NSString* strTitle;
@property (strong, nonatomic) NSNumber* userKey;//发布人的key
@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

@property (copy, nonatomic) void (^blockRef)();

@property (retain, nonatomic)UIScrollView *scrollView;

@property (retain, nonatomic)UILabel *indexLabel;

- (void)show;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
