//
//  JGLCaddieScoreTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCaddieScoreTableViewCell.h"

@implementation JGLCaddieScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * ProportionAdapter, 0, 80 * ProportionAdapter, 50 * ProportionAdapter)];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        _timeLabel.textColor = [UIColor lightGrayColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 0, 210 * ProportionAdapter, 50 * ProportionAdapter)];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#313131"];
        self.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.contentView addSubview:self.titleLabel];
        
        self.checkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.checkBtn.frame = CGRectMake(300 * ProportionAdapter, 10 * ProportionAdapter, 70 * ProportionAdapter, 30 * ProportionAdapter);
        self.checkBtn.layer.borderWidth = 1.0 * ProportionAdapter;
        self.checkBtn.layer.masksToBounds = YES;
        self.checkBtn.layer.cornerRadius = 5 * ProportionAdapter;
        self.checkBtn.layer.borderColor = [UIColor colorWithHexString:@"#32b14d"].CGColor;
        [self.checkBtn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
        self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.checkBtn];
    }
    return self;
}


-(void)showData:(JGLCaddieModel *)model{
    if (![Helper isBlankString:model.createtime]) {
        NSLog(@"%@",model.createtime);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *destDate= [dateFormatter dateFromString:model.createtime];
        NSString* str = [NSString stringWithFormat:@"%@",destDate];
        
        NSArray* array = [str componentsSeparatedByString:@" "];
        NSArray* array1 = [array[0] componentsSeparatedByString:@"-"];
        NSArray* array2 = [array[1] componentsSeparatedByString:@":"];
        
        NSString* strTime = [NSString stringWithFormat:@"%@-%@ %@:%@",array1[1],array1[2],array2[0],array2[1]];
        _timeLabel.text = strTime;
        
    }
    else{
        _timeLabel.text = @"暂无时间";
    }
    
    
    if ([model.scoreFinish integerValue] == 0) {
        _titleLabel.text = [NSString stringWithFormat:@"正在给客户 %@ 记分",model.userName];
        [self.checkBtn setTitle:@"继续记分" forState:(UIControlStateNormal)];
    }
    else if([model.scoreFinish integerValue] == 1){
        _titleLabel.text = [NSString stringWithFormat:@"客户 %@ 的记分已经完成",model.userName];
        [self.checkBtn setTitle:@"查看记分" forState:(UIControlStateNormal)];
    }
    else{
        [self.checkBtn setTitle:@"查看记分" forState:(UIControlStateNormal)];
        _titleLabel.text = @"记分完成";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
