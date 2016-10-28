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
 
        self.photoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (screenWidth - 60 * ProportionAdapter) / 2 , 70 * ProportionAdapter)];
        self.photoImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageV.clipsToBounds = YES;
        self.photoImageV.userInteractionEnabled = YES;
        [self addSubview:self.photoImageV];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 55 * ProportionAdapter,  (screenWidth - 60 * ProportionAdapter) / 2, 15 * ProportionAdapter)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#313131"];
        self.backView.alpha = 0.8;
        [self addSubview:self.backView];
        
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 55 * ProportionAdapter,  (screenWidth - 60 * ProportionAdapter) / 2, 15 * ProportionAdapter)];
        self.titleLB.font = [UIFont systemFontOfSize:11 * ProportionAdapter];
        self.titleLB.textAlignment = NSTextAlignmentCenter;
        self.titleLB.textColor = [UIColor colorWithHexString:@"#eceaea"];
        [self addSubview:self.titleLB];
    }
    return self;
}

- (void)configJGHShowPhotoView:(NSDictionary *)dic{
    
    [self.photoImageV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"imgURL"]] placeholderImage:[UIImage imageNamed:@"xcback"]];
    self.titleLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
