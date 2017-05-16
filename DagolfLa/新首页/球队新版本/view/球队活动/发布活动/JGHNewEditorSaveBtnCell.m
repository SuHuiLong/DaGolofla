//
//  JGHNewEditorSaveBtnCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewEditorSaveBtnCell.h"

@implementation JGHNewEditorSaveBtnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth -20*ProportionAdapter, 45*ProportionAdapter)];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#F39800"]];
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.layer.cornerRadius = 6.0*ProportionAdapter;
        [_saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
    }
    return self;
}

- (void)saveBtn:(UIButton *)saveBtn{
    if ([self.delegate respondsToSelector:@selector(editonAttendBtnClick:)]) {
        [self.delegate editonAttendBtnClick:saveBtn];
    }
}

- (void)configJGHNewEditorSaveBtnCell:(BOOL)edtior{
    
    if (!edtior) {
        _saveBtn.userInteractionEnabled = NO;
        [_saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        _saveBtn.userInteractionEnabled = YES;
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#F39800"]];
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
