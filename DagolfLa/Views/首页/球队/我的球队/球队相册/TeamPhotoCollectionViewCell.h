//
//  TeamPhotoCollectionViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/11/27.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamPhotoDeModel.h"
@interface TeamPhotoCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

-(void)showData:(TeamPhotoDeModel *)model;

@end
