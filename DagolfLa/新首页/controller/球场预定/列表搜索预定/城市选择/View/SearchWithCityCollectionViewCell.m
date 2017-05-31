//
//  SearchWithCityCollectionViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWithCityCollectionViewCell.h"

@implementation SearchWithCityCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - CreateView
-(void)createView{
    self.cityLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(12.5), kHvertical(15), (screenWidth - kWvertical(134))/3, kHvertical(26)) textColor:RGB(0,134,73) fontSize:kHorizontal(14) Title:nil];
    self.cityLabel.layer.cornerRadius = kWvertical(4);
    self.cityLabel.layer.borderColor = RGB(0,134,73).CGColor;
    self.cityLabel.layer.borderWidth = 1;
    [self.cityLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_cityLabel];
    
}

#pragma mark - 配置数据
-(void)configModel:(SearchWithCityDetailModel *)model{
    
    NSString *provinceStr = model.provinceName;
    NSString *parkCount = model.ballCount;
    NSString *labelStr = [NSString stringWithFormat:@"%@ (%@)",provinceStr,parkCount];

    if ([parkCount isEqualToString:@"0"]) {
        labelStr = provinceStr;
        self.cityLabel.textColor = RGB(160,160,160);
        self.cityLabel.text = labelStr;
        self.cityLabel.backgroundColor = RGB(245,245,245);
        self.cityLabel.layer.borderColor = ClearColor.CGColor;

    }else{
        self.cityLabel.textColor = RGB(0,134,73);
        self.cityLabel.backgroundColor = WhiteColor;
        self.cityLabel.layer.borderColor = RGB(0,134,73).CGColor;

        NSMutableAttributedString *attributerStr = [[NSMutableAttributedString alloc] initWithString:labelStr];
        [attributerStr addAttribute:NSForegroundColorAttributeName value:RGB(160,160,160) range:NSMakeRange(provinceStr.length, parkCount.length+3)];
        [attributerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(provinceStr.length, parkCount.length+3)];
        self.cityLabel.attributedText = attributerStr;
        
    }
}
















@end
