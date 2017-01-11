//
//  JGHTimeListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHTimeListView : UIView

//@property (nonatomic, retain)NSNumber *ballKey;
//
//@property (nonatomic, retain)NSString *dateString;

@property (copy, nonatomic) void (^blockSelectTimeAndPrice)(NSString *, NSString *, NSString *, NSString *);

- (void)loadTimeListWithBallKey:(NSNumber *)ballKey andDateString:(NSString *)dateString;

@end
