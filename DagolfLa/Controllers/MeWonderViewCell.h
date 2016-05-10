//
//  MeWonderViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeWonderViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;



-(void)height;
@end
