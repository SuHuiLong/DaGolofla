//
//  VedioPlayViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/4/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VedioPlayViewControllerDelegate <NSObject>
//关闭视频的代理
- (void)closeVideo;

@end

@interface VedioPlayViewController : UIViewController
//@property (retain, nonatomic) UIView *playerView;

//播放视频的URL
@property (nonatomic, strong)NSString *vedioURL;

@property (weak, nonatomic) id <VedioPlayViewControllerDelegate> delegate;
@end
