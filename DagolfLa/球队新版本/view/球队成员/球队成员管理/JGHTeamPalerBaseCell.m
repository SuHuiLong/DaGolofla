//
//  JGHTeamPalerBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHTeamPalerBaseCell.h"
#import "JGLTeamMemberModel.h"

@implementation JGHTeamPalerBaseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40*ProportionAdapter, 10 *ProportionAdapter, 40 *ProportionAdapter, 20 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _name.textColor = [UIColor colorWithHexString:B31_Color];
        _name.text = @"姓名";
        [self addSubview:_name];
        
        _nameValue = [[UILabel alloc]initWithFrame:CGRectMake(80 *ProportionAdapter, 10 *ProportionAdapter, screenWidth/2 -80 *ProportionAdapter, 20 *ProportionAdapter)];
        _nameValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_nameValue];
        
        _age = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 10 *ProportionAdapter, 40 *ProportionAdapter, 20 *ProportionAdapter)];
        _age.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _age.textColor = [UIColor colorWithHexString:B31_Color];
        _age.text = @"球龄";
        [self addSubview:_age];
        
        _ageValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 +40 *ProportionAdapter, 10 *ProportionAdapter, screenWidth/2 -80 *ProportionAdapter, 20 *ProportionAdapter)];
        _ageValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_ageValue];
        
        _sex = [[UILabel alloc]initWithFrame:CGRectMake(40*ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 20 *ProportionAdapter)];
        _sex.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _sex.textColor = [UIColor colorWithHexString:B31_Color];
        _sex.text = @"性别";
        [self addSubview:_sex];
        
        _sexValue = [[UILabel alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 40 *ProportionAdapter, screenWidth/2 -80 *ProportionAdapter, 20 *ProportionAdapter)];
        _sexValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_sexValue];
        
        _almost = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 40 *ProportionAdapter, 40 *ProportionAdapter, 20 *ProportionAdapter)];
        _almost.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _almost.textColor = [UIColor colorWithHexString:B31_Color];
        _almost.text = @"差点";
        [self addSubview:_almost];
        
        _almostValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 +40 *ProportionAdapter, 40 *ProportionAdapter, screenWidth/2 -80 *ProportionAdapter, 20 *ProportionAdapter)];
        _almostValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_almostValue];
        
        _mobile = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 70 *ProportionAdapter, 60 *ProportionAdapter, 20 *ProportionAdapter)];
        _mobile.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _mobile.textColor = [UIColor colorWithHexString:B31_Color];
        _mobile.text = @"手机号";
        [self addSubview:_mobile];
        
        _mobileValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 70 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _mobileValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_mobileValue];
        
        _veteran = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 100 *ProportionAdapter, 60 *ProportionAdapter, 20 *ProportionAdapter)];
        _veteran.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _veteran.textColor = [UIColor colorWithHexString:B31_Color];
        _veteran.text = @"行业";
        [self addSubview:_veteran];
        
        _veteranValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 100 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _veteranValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_veteranValue];
        
        _company = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 130 *ProportionAdapter, 60 *ProportionAdapter, 20 *ProportionAdapter)];
        _company.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _company.textColor = [UIColor colorWithHexString:B31_Color];
        _company.text = @"公司";
        [self addSubview:_company];
        
        _companyValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 130 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _companyValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_companyValue];
        
        _position = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 160 *ProportionAdapter, 60 *ProportionAdapter, 20 *ProportionAdapter)];
        _position.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _position.textColor = [UIColor colorWithHexString:B31_Color];
        _position.text = @"职位";
        [self addSubview:_position];
        
        _positionValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 160 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _positionValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_positionValue];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 190 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
        _address.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _address.textColor = [UIColor colorWithHexString:B31_Color];
        _address.text = @"常住地址";
        [self addSubview:_address];
        
        _addressValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 190 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _addressValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_addressValue];
        
        _dressSize = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 220 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
        _dressSize.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _dressSize.textColor = [UIColor colorWithHexString:B31_Color];
        _dressSize.text = @"衣服尺码";
        [self addSubview:_dressSize];
        
        _dressSizeValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 220 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _dressSizeValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_dressSizeValue];
        
        _useHand = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 250 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
        _useHand.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _useHand.textColor = [UIColor colorWithHexString:B31_Color];
        _useHand.text = @"惯用手";
        [self addSubview:_useHand];
        
        _useHandValue = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 250 *ProportionAdapter, screenWidth/2, 20 *ProportionAdapter)];
        _useHandValue.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_useHandValue];
    }
    return self;
}

- (void)configJGLTeamMemberModel:(JGLTeamMemberModel *)model{
    
    _nameValue.text = model.userName;
    
    if (model.ballage) {
        _ageValue.text = [NSString stringWithFormat:@"%@", model.ballage];
    }else{
        _ageValue.text = @"";
    }
    
    if ([model.sex integerValue] == 0) {
        _sexValue.text = @"女";
    }else if ([model.sex integerValue] == 1){
        _sexValue.text = @"男";
    }else{
        _sexValue.text = @"未知";
    }
    
    if (model.almost) {
        _almostValue.text = [NSString stringWithFormat:@"%@", model.almost];
    }
    
    if (model.industry) {
        _veteranValue.text = model.industry;
    }
    
    if (model.mobile) {
        _mobileValue.text = model.mobile;
    }
    
    if (model.company) {
        _companyValue.text = model.company;
    }
    
    if (model.occupation) {
        _positionValue.text = model.occupation;
    }
    
    if (model.address) {
        _addressValue.text = model.address;
    }
    
    if (model.size) {
        _dressSizeValue.text = model.size;
    }

    if ([model.hand integerValue] == 0) {
        _useHandValue.text = @"左手";
    }else{
        _useHandValue.text = @"右手";
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
