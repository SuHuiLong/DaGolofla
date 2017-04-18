//
//  VipCardGoodsListCollectionViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/4/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardGoodsListCollectionViewCell.h"

@implementation VipCardGoodsListCollectionViewCell
//初始化
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
//创建
-(void)createView{
    //白色背景
    UIView *backWhiteView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(302))];
    [self.contentView addSubview:backWhiteView];
    //卡片
    _cardImageView  = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-kWvertical(267))/2, 20,kWvertical(267), kHvertical(174))];
    //背景照片
    UIImageView *backImageView = [Factory createImageViewWithFrame:CGRectMake(_cardImageView.x-kWvertical(10), _cardImageView.y-kHvertical(10.5), _cardImageView.width+kWvertical(20), _cardImageView.height+kWvertical(21)) Image:[UIImage imageNamed:@"icn_allianceBackView"]];
    [backWhiteView addSubview:backImageView];
    [backWhiteView addSubview:_cardImageView];
    
    UIView *line = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(kWvertical(15), _cardImageView.y_height+kHvertical(26), screenWidth - kWvertical(30), 1)];
    [backWhiteView addSubview:line];
    
    _nameAndPrice = [Factory createLabelWithFrame:CGRectMake(kWvertical(20), line.y_height+kHvertical(20), screenWidth - kWvertical(40), kHvertical(17)) textColor:RGB(49,49,49) fontSize:kHorizontal(18) Title:@"君高联盟VIP卡 ￥4600"];
    [backWhiteView addSubview:_nameAndPrice];
    
    _equity = [Factory createLabelWithFrame:CGRectMake(_nameAndPrice.x, _nameAndPrice.y_height+kHvertical(12), screenWidth - kWvertical(40), kHvertical(15)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"1年会员权益 尊享会员击球优惠 28次/年"];
    [backWhiteView addSubview:_equity];
}
//配置数据
-(void)configModel:(VipCardGoodsListModel *)model{
    NSString *picUrl = model.bigPicURL;//卡片图片
    NSString *nameStr = model.name;//卡名
    NSString *price = model.price;//卡价格
    NSString *expiry = [NSString stringWithFormat:@"%ld",model.expiry];//有效年数
    NSString *schemeMaxCount =[NSString stringWithFormat:@"%ld",model.schemeMaxCount];//有效次数
    
    [_cardImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    //名字和金额文字
    NSString *nameAndPriceText = [NSString stringWithFormat:@"%@  ¥%@",nameStr,price];
    NSMutableAttributedString *nameAndPriceTextStr = [[NSMutableAttributedString alloc]initWithString:nameAndPriceText];
    //设置¥字号
    [nameAndPriceTextStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kHorizontal(15)] range:NSMakeRange(nameStr.length+2, 1)];
    //设置金额颜色
    [nameAndPriceTextStr addAttribute:NSForegroundColorAttributeName value:RGB(252,90,1) range:NSMakeRange(nameStr.length+2, price.length+1)];
    _nameAndPrice.attributedText = nameAndPriceTextStr;
    
    //权益文字
    NSString *equityText = [NSString stringWithFormat:@"%@年会员权益  尊贵会员击球优惠  %@次/年",expiry,schemeMaxCount];
    NSMutableAttributedString *equityTextStr = [[NSMutableAttributedString alloc]initWithString:equityText];
    //设置/字号
    [equityTextStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kHorizontal(17)] range:NSMakeRange(equityText.length-2, 1)];
    //设置/年颜色
    [equityTextStr addAttribute:NSForegroundColorAttributeName value:RGB(160,160,160) range:NSMakeRange(equityText.length-2, 2)];
    _equity.attributedText = equityTextStr;

}

@end
