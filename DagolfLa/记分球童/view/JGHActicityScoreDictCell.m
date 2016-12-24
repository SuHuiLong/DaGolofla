//
//  JGHActicityScoreDictCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActicityScoreDictCell.h"
#import "JGLChooseScoreModel.h"

@implementation JGHActicityScoreDictCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12*ProportionAdapter, 12*ProportionAdapter, 66*ProportionAdapter, 66*ProportionAdapter)];
        _headerImageView.image = [UIImage imageNamed:DefaultHeaderImage];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 3.0 *ProportionAdapter;
        [self addSubview:_headerImageView];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 20 *ProportionAdapter, 170*ProportionAdapter, 20 *ProportionAdapter)];
        _title.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _title.textColor = [UIColor colorWithHexString:B31_Color];
        _title.text = @"1111";
        _title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_title];
        
        _startScore = [[UILabel alloc]initWithFrame:CGRectMake(265 *ProportionAdapter, 20*ProportionAdapter, 65 *ProportionAdapter, 20 *ProportionAdapter)];
        _startScore.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _startScore.textAlignment = NSTextAlignmentRight;
        _startScore.textColor = [UIColor colorWithHexString:@"#f39800"];
        _startScore.text = @"开始记分";
        [self addSubview:_startScore];
        
        _directionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(335 *ProportionAdapter, 23 *ProportionAdapter, 7*ProportionAdapter, 13*ProportionAdapter)];
        _directionImageView.image = [UIImage imageNamed:@")"];
        [self addSubview:_directionImageView];
        
        _addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 52 *ProportionAdapter, 11*ProportionAdapter, 15 *ProportionAdapter)];
        _addressImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:_addressImageView];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(105 *ProportionAdapter, 50 *ProportionAdapter, 160 *ProportionAdapter, 20 *ProportionAdapter)];
        _address.textColor = [UIColor colorWithHexString:Ba0_Color];
        _address.textAlignment = NSTextAlignmentLeft;
        _address.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        [self addSubview:_address];
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(265*ProportionAdapter, 50 *ProportionAdapter, 65 *ProportionAdapter, 20*ProportionAdapter)];
        _time.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _time.textColor = [UIColor colorWithHexString:Ba0_Color];
        _time.textAlignment = NSTextAlignmentRight;
        [self addSubview:_time];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(12 *ProportionAdapter, 89 *ProportionAdapter, screenWidth -48*ProportionAdapter, 1*ProportionAdapter)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
    }
    return self;
}

- (void)configJGLChooseScoreModel:(JGLChooseScoreModel *)model{
    [_headerImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[model.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    if (![Helper isBlankString:model.name]) {
        _title.text = model.name;
    }
    else{
        _title.text = [NSString stringWithFormat:@"暂无活动名"];
    }
    
    if (![Helper isBlankString:model.beginDate]) {
        NSLog(@"%@",model.beginDate);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *destDate= [dateFormatter dateFromString:model.beginDate];
        NSString* str = [NSString stringWithFormat:@"%@",destDate];
        
        NSArray* array = [str componentsSeparatedByString:@" "];
        NSArray* array1 = [array[0] componentsSeparatedByString:@"-"];
//        NSArray* array2 = [array[1] componentsSeparatedByString:@":"];
        
//        NSString* strTime = [NSString stringWithFormat:@"%@月%@日 %@:%@",array1[1],array1[2],array2[0],array2[1]];
        NSString* strTime = [NSString stringWithFormat:@"%@月%@日",array1[1],array1[2]];
        _time.text = strTime;
        
    }
    else{
        _time.text = @"暂无时间";
    }
    
    _address.text = model.ballName;
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
