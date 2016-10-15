//
//  JGLGroupPeoTableViewCell.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGroupPeoTableViewCell.h"

@implementation JGLGroupPeoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView1 = [[UIView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 5*ProportionAdapter, 148*ProportionAdapter, 94*ProportionAdapter)];
        _backView1.backgroundColor = [UITool colorWithHexString:@"edf8fa" alpha:1];
        _backView1.layer.cornerRadius = 7*ProportionAdapter;
        _backView1.layer.masksToBounds = YES;
        [self.contentView addSubview:_backView1];
        
        [self createPeopleFirst];
        [self createPeopleSecond];
        
        _labelNum = [[UILabel alloc]initWithFrame:CGRectMake(160*ProportionAdapter, 30*ProportionAdapter, 60*ProportionAdapter, 20*ProportionAdapter)];
        _labelNum.textAlignment = NSTextAlignmentCenter;
        _labelNum.text = @"第12组";
        _labelNum.font = [UIFont systemFontOfSize:12*ProportionAdapter];
        _labelNum.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
        [self.contentView addSubview:_labelNum];
        
        _imgvJt = [[UIImageView alloc]initWithFrame:CGRectMake(163*ProportionAdapter, 50*ProportionAdapter, 50*ProportionAdapter, 14*ProportionAdapter)];
        _imgvJt.image = [UIImage imageNamed:@"arow"];
        [self.contentView addSubview:_imgvJt];
        
        _backView2 = [[UIView alloc]initWithFrame:CGRectMake(218*ProportionAdapter, 5*ProportionAdapter, 148*ProportionAdapter, 94*ProportionAdapter)];
        [self.contentView addSubview:_backView2];
        _backView2.backgroundColor = [UITool colorWithHexString:@"f9f4f3" alpha:1];
        _backView2.layer.cornerRadius = 7*ProportionAdapter;
        _backView2.layer.masksToBounds = YES;

        [self createPeopleThird];
        [self createPeopleFourth];
        
    }
    return self;
}

-(void)initUiConfig{
    _backView1 = [[UIView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 5*ProportionAdapter, 148*ProportionAdapter, 94*ProportionAdapter)];
    _backView1.backgroundColor = [UITool colorWithHexString:@"edf8fa" alpha:1];
    _backView1.layer.cornerRadius = 7*ProportionAdapter;
    _backView1.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView1];
    
    [self createPeopleFirst];
    [self createPeopleSecond];
    
    _labelNum = [[UILabel alloc]initWithFrame:CGRectMake(168*ProportionAdapter, 30*ProportionAdapter, 50*ProportionAdapter, 20*ProportionAdapter)];
    _labelNum.textAlignment = NSTextAlignmentCenter;
    _labelNum.text = @"第十二组";
    _labelNum.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    _labelNum.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    [self.contentView addSubview:_labelNum];
    
    _imgvJt = [[UIImageView alloc]initWithFrame:CGRectMake(168*ProportionAdapter, 50*ProportionAdapter, 50*ProportionAdapter, 14*ProportionAdapter)];
    _imgvJt.image = [UIImage imageNamed:@"arow"];
    [self.contentView addSubview:_imgvJt];
    
    _backView2 = [[UIView alloc]initWithFrame:CGRectMake(218*ProportionAdapter, 5*ProportionAdapter, 148*ProportionAdapter, 94*ProportionAdapter)];
    [self.contentView addSubview:_backView2];
    _backView2.backgroundColor = [UITool colorWithHexString:@"f9f4f3" alpha:1];
    _backView2.layer.cornerRadius = 7*ProportionAdapter;
    _backView2.layer.masksToBounds = YES;
    
    [self createPeopleThird];
    [self createPeopleFourth];
}

-(void)createPeopleFirst
{
    _btnHeader1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnHeader1.frame = CGRectMake(10*ProportionAdapter, 6*ProportionAdapter, 55*ProportionAdapter, 55*ProportionAdapter);
    [_btnHeader1 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
    _btnHeader1.layer.cornerRadius = _btnHeader1.frame.size.height/2;
    _btnHeader1.layer.masksToBounds = YES;
    [_backView1 addSubview:_btnHeader1];
    
    _labelName1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelName1.alpha = 0.5;
    _labelName1.font = [UIFont systemFontOfSize:10*ProportionAdapter];
    _labelName1.backgroundColor = [UIColor whiteColor];
    _labelName1.textAlignment = NSTextAlignmentCenter;
    _labelName1.text = @"郑小虎";
    [_btnHeader1 addSubview:_labelName1];
    
    _labelAlmast1 = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 60*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelAlmast1.text = @"06";
    _labelAlmast1.textAlignment = NSTextAlignmentCenter;
    _labelAlmast1.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    _labelAlmast1.textColor = [UITool colorWithHexString:@"60c8d4" alpha:1];
    [_backView1 addSubview:_labelAlmast1];
    
    _labelChadian1 = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 75*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelChadian1.text = @"差点";
    _labelChadian1.font = [UIFont systemFontOfSize:9*ProportionAdapter];
    _labelChadian1.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    _labelChadian1.textAlignment = NSTextAlignmentCenter;
    [_backView1 addSubview:_labelChadian1];
}

-(void)createPeopleSecond
{
    _btnHeader2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnHeader2.frame = CGRectMake(80*ProportionAdapter, 6*ProportionAdapter, 55*ProportionAdapter, 55*ProportionAdapter);
    [_btnHeader2 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
    _btnHeader2.layer.cornerRadius = _btnHeader2.frame.size.height/2;
    _btnHeader2.layer.masksToBounds = YES;
    [_backView1 addSubview:_btnHeader2];
    
    _labelName2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelName2.alpha = 0.5;
    _labelName2.font = [UIFont systemFontOfSize:10*ProportionAdapter];
    _labelName2.backgroundColor = [UIColor whiteColor];
    _labelName2.textAlignment = NSTextAlignmentCenter;
    _labelName2.text = @"郑小虎";
    [_btnHeader2 addSubview:_labelName2];
    
    _labelAlmast2 = [[UILabel alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 60*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelAlmast2.text = @"06";
    _labelAlmast2.textAlignment = NSTextAlignmentCenter;
    _labelAlmast2.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    _labelAlmast2.textColor = [UITool colorWithHexString:@"60c8d4" alpha:1];
    [_backView1 addSubview:_labelAlmast2];
    
    _labelChadian2 = [[UILabel alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 75*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelChadian2.text = @"差点";
    _labelChadian2.font = [UIFont systemFontOfSize:9*ProportionAdapter];
    _labelChadian2.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    _labelChadian2.textAlignment = NSTextAlignmentCenter;
    [_backView1 addSubview:_labelChadian2];
}

-(void)createPeopleThird
{
    _btnHeader3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnHeader3.frame = CGRectMake(10*ProportionAdapter, 6*ProportionAdapter, 55*ProportionAdapter, 55*ProportionAdapter);
    [_btnHeader3 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
    _btnHeader3.layer.cornerRadius = _btnHeader3.frame.size.height/2;
    _btnHeader3.layer.masksToBounds = YES;
    [_backView2 addSubview:_btnHeader3];
    
    _labelName3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelName3.alpha = 0.5;
    _labelName3.font = [UIFont systemFontOfSize:10*ProportionAdapter];
    _labelName3.backgroundColor = [UIColor whiteColor];
    _labelName3.textAlignment = NSTextAlignmentCenter;
    _labelName3.text = @"郑小虎";
    [_btnHeader3 addSubview:_labelName3];
    
    _labelAlmast3 = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 60*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelAlmast3.text = @"06";
    _labelAlmast3.textAlignment = NSTextAlignmentCenter;
    _labelAlmast3.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    _labelAlmast3.textColor = [UITool colorWithHexString:@"60c8d4" alpha:1];
    [_backView2 addSubview:_labelAlmast3];
    
    _labelChadian3 = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 75*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelChadian3.text = @"差点";
    _labelChadian3.font = [UIFont systemFontOfSize:9*ProportionAdapter];
    _labelChadian3.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    _labelChadian3.textAlignment = NSTextAlignmentCenter;
    [_backView2 addSubview:_labelChadian3];
}
-(void)createPeopleFourth
{
    _btnHeader4 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnHeader4.frame = CGRectMake(80*ProportionAdapter, 6*ProportionAdapter, 55*ProportionAdapter, 55*ProportionAdapter);
    [_btnHeader4 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
    _btnHeader4.layer.cornerRadius = _btnHeader4.frame.size.height/2;
    _btnHeader4.layer.masksToBounds = YES;
    [_backView2 addSubview:_btnHeader4];
    
    _labelName4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelName4.alpha = 0.5;
    _labelName4.font = [UIFont systemFontOfSize:10*ProportionAdapter];
    _labelName4.backgroundColor = [UIColor whiteColor];
    _labelName4.textAlignment = NSTextAlignmentCenter;
    _labelName4.text = @"郑小虎";
    [_btnHeader4 addSubview:_labelName4];
    
    _labelAlmast4 = [[UILabel alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 60*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelAlmast4.text = @"06";
    _labelAlmast4.textAlignment = NSTextAlignmentCenter;
    _labelAlmast4.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    _labelAlmast4.textColor = [UITool colorWithHexString:@"60c8d4" alpha:1];
    [_backView2 addSubview:_labelAlmast4];
    
    _labelChadian4 = [[UILabel alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 75*ProportionAdapter, 55*ProportionAdapter, 20*ProportionAdapter)];
    _labelChadian4.text = @"差点";
    _labelChadian4.font = [UIFont systemFontOfSize:9*ProportionAdapter];
    _labelChadian4.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    _labelChadian4.textAlignment = NSTextAlignmentCenter;
    [_backView2 addSubview:_labelChadian4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
