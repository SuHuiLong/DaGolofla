//
//  JGHNewActivityExplainCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityExplainCell.h"

@implementation JGHNewActivityExplainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _contentLable = [[UILabel alloc]initWithFrame:CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 44*ProportionAdapter)];
        _contentLable.text = @"";
        _contentLable.numberOfLines = 0;
        _contentLable.textAlignment = NSTextAlignmentLeft;
        _contentLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        [self addSubview:_contentLable];
        
        //_line = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*ProportionAdapter -0.5, screenWidth, 0.5)];
        //_line.backgroundColor = [UIColor colorWithHexString:BG_color];
        //[self addSubview:_line];
    }
    
    return self;
}

- (void)configJGHNewActivityExplainCellContent:(NSString *)content{
    _contentLable.text = content;
    _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, [Helper textHeightFromTextString:content width:screenWidth -50*ProportionAdapter fontSize:15*ProportionAdapter]);
    
    if (content.length >0) {
        CGFloat height;
        height = [Helper textHeightFromTextString:content width:screenWidth -50*ProportionAdapter fontSize:15*ProportionAdapter];
        if (0< height && height < 20*ProportionAdapter) {
            _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 25*ProportionAdapter);
        }else{
            _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 40*ProportionAdapter);
        }
    }else{
        _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 0);
    }
}

- (void)configActivityContent:(NSString *)content{
    _contentLable.text = content;
    _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, [Helper textHeightFromTextString:content width:screenWidth -50*ProportionAdapter fontSize:15*ProportionAdapter]);
    
    if (content.length >0) {
        CGFloat height;
        height = [Helper textHeightFromTextString:content width:screenWidth -50*ProportionAdapter fontSize:15*ProportionAdapter];
        if (0< height && height < 20*ProportionAdapter) {
            _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 25*ProportionAdapter);
        }else{
            _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, height);
        }
    }else{
        _contentLable.frame = CGRectMake(40*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 0);
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
