//
//  JGDTextTipView.h
//  DagolfLa
//
//  Created by 東 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDTextTipView : UIView

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *detailLB;

@property (nonatomic, strong) UIButton *systemBtn; // 系统设置🐍
@property (nonatomic, strong) UIButton *ManualBtn; // 手动设置

@property (copy, nonatomic) void (^blockManual)();
@property (copy, nonatomic) void (^blocksys)();

@property (nonatomic, assign) BOOL isUseJG;     // almost_system_setting  1 是启用君高  不能改修改

@property (nonatomic, strong) UIView *backDView;
@end
