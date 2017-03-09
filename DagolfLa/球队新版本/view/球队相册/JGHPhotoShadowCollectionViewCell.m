//
//  JGHPhotoShadowCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHPhotoShadowCollectionViewCell.h"

@implementation JGHPhotoShadowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height -40*ProportionAdapter)];
        _shadowImageView.image = [UIImage imageNamed:@"xcback"];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImageView.clipsToBounds = YES;
        [self addSubview:_shadowImageView];
        
        //_title = [UILabel alloc]initWithFrame:CGRectMake(_shadowImageView.bounds.size, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    return self;
}

@end
