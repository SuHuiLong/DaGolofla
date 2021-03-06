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
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"%f",scale_screen);
    if (scale_screen==3) {
        _backgroundImageView.y = self.frame.size.height + kHvertical(10);
    }
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
    if (model.name) {
        NSString *provinceName = model.name;
        NSString *parkCount = [NSString stringWithFormat:@"%ld",model.count];
        NSString *titleStr = [NSString stringWithFormat:@"%@ %@ 家",provinceName,parkCount];
        UIColor *changeColor = RedColor;
        if (model.dataType==1) {
            titleStr = [NSString stringWithFormat:@"%@ %@ 个",provinceName,parkCount];
            changeColor = RGB(0,134,73);
        }
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:changeColor range:NSMakeRange(provinceName.length+1, parkCount.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(160,160,160) range:NSMakeRange(AttributedStr.length-1, 1)];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(10)] range:NSMakeRange(AttributedStr.length-1, 1)];
        
        _descripLabel.attributedText = AttributedStr;
        
    }else{
        NSString *parkName = model.parkName;
        NSString *endStr = [NSString string];
        UIColor *changeColor = [[UIColor alloc] init];
        NSString *descripStr = [NSString string];
        if (model.dataType==1) {
            changeColor = RGB(236,45,51);
            endStr = [NSString stringWithFormat:@"%ld个",(long)model.count];
            descripStr = [NSString stringWithFormat:@"%@ %@",parkName,endStr];
        }else{
            endStr = [NSString stringWithFormat:@"¥%@",model.orderPrice];
            descripStr = [NSString stringWithFormat:@"%@ %@",parkName,endStr];
            changeColor = RGBA(61,161,255,1);
            if (model.isLeague==1) {
                changeColor = RGBA(236,45,51,1);
            }
        }
        _descripLabel.text = descripStr;
        _descripLabel = [self AttributedStringLabel:_descripLabel rang:NSMakeRange(parkName.length+1, endStr.length) changeColor:changeColor];
    }
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
