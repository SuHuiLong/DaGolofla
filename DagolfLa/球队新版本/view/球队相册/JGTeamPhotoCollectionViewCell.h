//
//  JGTeamPhotoCollectionViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLPhotoAlbumModel.h"

@interface JGTeamPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIngv;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *manageBtn;

@property (weak, nonatomic) IBOutlet UIImageView *suoImage;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

-(void)showData:(JGLPhotoAlbumModel *)model;



@end
