//
//  SearchWithMapAnnotationView.m
//  DagolfLa
//
//  Created by SHL on 2017/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWithMapAnnotationView.h"

@implementation SearchWithMapAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    
    //设置大头针下部图片
    _backgroundImageView = [Factory createImageViewWithFrame: CGRectMake(-kWvertical(50) + self.frame.size.width/2, self.frame.size.height + kHvertical(5), kWvertical(100), kHvertical(45)) Image:[UIImage imageNamed:@"mapsearch_backview"]];
    
    //自定义显示的内容
    _descripLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(20), kHvertical(10), 0, kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(12) Title:@"nil"];
    [_backgroundImageView addSubview:_descripLabel];
    [self addSubview:_backgroundImageView];
    
    //设置气泡
    UIView *paoView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, 0, 0)];
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:paoView];
    pView.frame = CGRectMake(0, 0, 0, 0);
    self.paopaoView = pView;

}


//配置数据
-(void)configModel:(SearchWithMapModel *)model{
    _dataModel = model;
//    NSString *parkName = model.parkName;
    NSString *parkName = [NSString stringWithFormat:@"%ld%@",(long)model.orderNum,model.parkName];
    NSString *orderPrice = model.orderPrice;
    NSString *descripStr = [NSString stringWithFormat:@"%@ ¥%@",parkName,orderPrice];
    _descripLabel.text = descripStr;
    UIColor *changeColor = RGBA(61,161,255,1);
    if (model.isLeague==1) {
        changeColor = RGBA(236,45,51,1);
    }
    _descripLabel = [self AttributedStringLabel:_descripLabel rang:NSMakeRange(parkName.length+1, orderPrice.length+1) changeColor:changeColor];
    [_descripLabel sizeToFitSelf];
    _descripLabel.x = kWvertical(25);
    _backgroundImageView.width = _descripLabel.width+kWvertical(50);
    _backgroundImageView.x =  (self.frame.size.width - _backgroundImageView.width)/2 ;

}

//富文本
-(UILabel *)AttributedStringLabel:(UILabel *)putLabel rang:(NSRange )changeRang changeColor:(UIColor *)changeColor {
    UILabel *testLabel = putLabel;
    if (!putLabel) {
        return testLabel;
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:testLabel.text];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:changeColor range:changeRang];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:changeRang];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(10)] range:NSMakeRange(changeRang.location, 1)];
    
    
    testLabel.attributedText = AttributedStr;
    return testLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
