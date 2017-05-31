//
//  JGHSpectatorSportsView.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHSpectatorSportsViewDelegate <NSObject>

- (void)selectSpectatorSportsViewUrlString:(NSString *)urlStr index:(NSInteger)selectID;

@end

@interface JGHSpectatorSportsView : UIView

@property (nonatomic, weak)id<JGHSpectatorSportsViewDelegate> delegate;

- (void)configJGHSpectatorSportsViewData:(NSArray *)dataArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;

@end
