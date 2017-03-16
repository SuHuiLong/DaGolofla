//
//  SearchWithMapAnnotationView.h
//  DagolfLa
//
//  Created by SHL on 2017/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

//#import <BaiduMapAPI/BaiduMapAPI.h>
#import <BaiduMapAPI/BMKPinAnnotationView.h>
#import "SearchWithMapModel.h"
@interface SearchWithMapAnnotationView : BMKPinAnnotationView
//大头针的id
@property(nonatomic, copy)NSString *pinId;
//文字介绍
@property(nonatomic, strong)UILabel *descripLabel;
//文字介绍背景view
@property(nonatomic, strong)UIImageView *backgroundImageView;
//配置数据
-(void)configModel:(SearchWithMapModel *)model;

@end
