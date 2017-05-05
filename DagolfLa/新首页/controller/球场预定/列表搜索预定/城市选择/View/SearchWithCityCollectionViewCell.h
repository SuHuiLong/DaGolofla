//
//  SearchWithCityCollectionViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchWithCityDetailModel.h"
@interface SearchWithCityCollectionViewCell : UICollectionViewCell

/**
 城市label
 */
@property (nonatomic,strong) UILabel *cityLabel;

-(void)configModel:(SearchWithCityDetailModel *)model;
@end
