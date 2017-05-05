//
//  SearchWithCityTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchWIthCityModel.h"
@interface SearchWithCityTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 区域
 */
@property(nonatomic, strong)UILabel *areaLabel;
/**
 城市和球场数量列表
 */
@property(nonatomic, strong)UICollectionView *cityView;

/**
 数据源
 */
@property(nonatomic, strong)NSMutableArray *dataArray;

//城市选择block
@property (copy, nonatomic) void (^blockAddress)(NSString* city);


-(void)configModel:(SearchWIthCityModel *)model;
@end


