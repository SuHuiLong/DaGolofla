//
//  MSSCollectionViewCell.h
//  MSSBrowse
//
//  Created by 于威 on 15/12/6.
//  Copyright © 2015年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGPhotoListModel.h"
@interface MSSCollectionViewCell : UICollectionViewCell
//照片
@property (nonatomic,strong)UIImageView *imageView;
//选中蒙版
@property (nonatomic,strong)UIView *coverView;
//配置数据
-(void)configModel:(JGPhotoListModel *)model;

//配置选择照片界面的数据
-(void)configSelectModel:(JGPhotoListModel *)model;

@end
