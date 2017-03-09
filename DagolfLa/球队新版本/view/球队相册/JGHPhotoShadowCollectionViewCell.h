//
//  JGHPhotoShadowCollectionViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLPhotoAlbumModel;

@interface JGHPhotoShadowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *shadowImageView;

@property (nonatomic, strong)UILabel *title;

-(void)configData:(JGLPhotoAlbumModel *)model;


@end
