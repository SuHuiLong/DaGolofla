//
//  CityCollectionViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/10/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CityModel.h"
@interface CityCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


-(void)showData:(CityModel *)model;

@end
