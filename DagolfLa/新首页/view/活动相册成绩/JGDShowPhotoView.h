//
//  JGDShowPhotoView.h
//  DagolfLa
//
//  Created by 東 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDShowPhotoView : UIView

@property (nonatomic, strong) UIImageView *photoImageV;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLB;


- (void)configJGHShowPhotoView:(NSDictionary *)dic;

@end
