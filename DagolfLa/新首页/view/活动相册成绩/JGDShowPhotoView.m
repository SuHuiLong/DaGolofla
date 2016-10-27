//
//  JGDShowPhotoView.m
//  DagolfLa
//
//  Created by 東 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDShowPhotoView.h"

@implementation JGDShowPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
 
        self.photoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, (screenWidth - 29 * ProportionAdapter) / 2 , 70 * ProportionAdapter)];
        self.photoImageV.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.photoImageV];
    }
    return self;
}

- (void)configJGHShowPhotoView:(NSDictionary *)dic{
    
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
