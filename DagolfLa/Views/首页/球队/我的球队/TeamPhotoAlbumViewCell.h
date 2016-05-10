//
//  TeamPhotoAlbumViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/11/26.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "TeamPhotoModel.h"
@interface TeamPhotoAlbumViewCell : UITableViewCell



@property (strong, nonatomic) UIImageView* iconImage;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* numLabel;
@property (strong, nonatomic) UIImageView* jtImage;


-(void)showData:(TeamPhotoModel *)model;

@end
