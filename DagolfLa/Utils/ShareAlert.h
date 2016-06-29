//
//  PayPassWordAlert.h
//   DagolfLa
//
//  Created by BIHUA－PEI on 15/8/20.
//  Copyright (c) 2015年 BIHUA－PEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareAlert : UIView
//@property(nonatomic,strong) UINavigationController* myNav;
- (id)initMyAlert;
@property(strong,nonatomic)void(^callBackTitle)(NSInteger);
- (void)show;
@end
