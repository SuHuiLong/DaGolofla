//
//  JGHScoreAF.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGHScoreListModel;

typedef void (^GBHEFailedBlock)(id errType);
typedef void (^GBHECompletionBlock)(id data);

@interface JGHScoreAF : NSObject

+ (JGHScoreAF *)shareScoreAF;

- (void)submitLocalScoreData;

- (void)httpScoreKey:(NSString *)scoreKey failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock;

- (void)httpFinishScoreKey:(NSString *)scoreKey failedBlock:(GBHEFailedBlock)failedBlock completionBlock:(GBHECompletionBlock)completionBlock;


@end
