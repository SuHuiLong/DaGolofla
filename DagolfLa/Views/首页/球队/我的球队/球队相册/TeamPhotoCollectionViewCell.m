//
//  TeamPhotoCollectionViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/27.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamPhotoCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "Helper.h"

@implementation TeamPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)showData:(TeamPhotoDeModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.photoPic] placeholderImage:[UIImage imageNamed:@"moren.jpg"]];
}



@end
