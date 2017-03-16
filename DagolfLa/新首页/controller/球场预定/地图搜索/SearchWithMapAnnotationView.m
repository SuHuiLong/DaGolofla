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
    _backgroundImageView = [Factory createImageViewWithFrame: CGRectMake(-kWvertical(50) + self.frame.size.width/2, self.frame.size.height , kWvertical(100), kHvertical(45)) Image:[UIImage imageNamed:@"mapsearch_backview"]];
    
    //自定义显示的内容
    _descripLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(20), kHvertical(10), 0, kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(12) Title:@"nil"];
    [_backgroundImageView addSubview:_descripLabel];
    [self addSubview:_backgroundImageView];
    
    //设置气泡
    UIView *paoView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, 0, 0)];
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:paoView];
    pView.frame = CGRectMake(0, 0, 0, 0);
    self.paopaoView = pView;

    
    
    /*
     //大头针改变之前的frame1126.44 3500
     CGRect iconFrame = newAnnotation.frame;
     //大头针和popview的高只差
     CGFloat differ = popView.height-iconFrame.size.height+kHvertical(20);
     
     //重新设置大头针坐标
     CGFloat annotationHeight = (iconFrame.size.height + differ)*2 ;
     CGFloat annotationWidth = popView.width;
     newAnnotation.image = [UIImage imageNamed:@""];
     newAnnotation.width = annotationWidth;
     newAnnotation.height = annotationHeight;
     newAnnotation.x =  (iconFrame.size.width - popView.width)/2;
     newAnnotation.y = -iconFrame.origin.y + kHvertical(20);
     popView.x = 0;
     UIImageView *iconImageView = [Factory createImageViewWithFrame:CGRectMake((popView.width-iconFrame.size.width)/2, differ - iconFrame.origin.y - kHvertical(20), iconFrame.size.width, iconFrame.size.height) Image:[UIImage imageNamed:@"pin"]];
     [newAnnotation addSubview:iconImageView];
     //重置icon下view的坐标
     popView.y = iconImageView.y_height-kHvertical(5);
     */

}


//配置数据
-(void)configModel:(SearchWithMapModel *)model{
    _pinId = model.parkId;
    NSString *parkName = model.parkName;
    NSString *orderPrice = model.orderPrice;
    NSString *descripStr = [NSString stringWithFormat:@"%@ ¥%@",parkName,orderPrice];
    _descripLabel.text = descripStr;
    _descripLabel = [self AttributedStringLabel:_descripLabel rang:NSMakeRange(parkName.length+1, orderPrice.length+1) changeColor:RedColor];
    [_descripLabel sizeToFitSelf];
    _backgroundImageView.width = _descripLabel.width+kWvertical(40);
    


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
