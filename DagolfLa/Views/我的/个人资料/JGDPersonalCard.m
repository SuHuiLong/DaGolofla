//
//  JGDPersonalCard.m
//  DagolfLa
//
//  Created by 東 on 17/2/22.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPersonalCard.h"

@interface JGDPersonalCard () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;  
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *pointTF; // 差点
@property (nonatomic, strong) UIButton *industryBtn; // 行业
@property (nonatomic, strong) UITextField *industryTF; // 行业
@property (nonatomic, strong) UIButton *isUseJGBtn;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UITableView *industryTable;


@property (nonatomic, assign) BOOL isUerJG;
@end

@implementation JGDPersonalCard

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        
        self.isUerJG = YES;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(13 * ProportionAdapter,50 * ProportionAdapter, screenWidth - 26 * ProportionAdapter, 477 * ProportionAdapter)];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 8 * ProportionAdapter;
        self.backView.clipsToBounds = YES;
        [self addSubview:self.backView];
        

        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 26 * ProportionAdapter, 133 * ProportionAdapter)];
        imageView.image = [UIImage imageNamed:@"personalCardBG"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.backView addSubview:imageView];
        
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - 26 * ProportionAdapter)/2 - 66 * ProportionAdapter / 2, 133 * ProportionAdapter - 66 * ProportionAdapter / 2, 66 * ProportionAdapter, 66 * ProportionAdapter)];
        [iconBtn setImage:[UIImage imageNamed:@"bg_photo"] forState:(UIControlStateNormal)];
        iconBtn.layer.cornerRadius = 66 * ProportionAdapter / 2;
        iconBtn.clipsToBounds = YES;
        iconBtn.layer.borderWidth = 1.5 * ProportionAdapter;
        iconBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.backView addSubview:iconBtn];
        iconBtn.contentMode = UIViewContentModeScaleAspectFill;
        
        UIButton *removeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        removeBtn.frame = CGRectMake(screenWidth - 66 * ProportionAdapter, 13 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter);
        [removeBtn setImage:[UIImage imageNamed:@"date_close"] forState:(UIControlStateNormal)];
        [removeBtn addTarget:self action:@selector(removeAct) forControlEvents:(UIControlEventTouchUpInside)];
        [removeBtn setTintColor:[UIColor whiteColor]];
        
        [self.backView addSubview:removeBtn];
        
        self.maleBtn = [[UIButton alloc] initWithFrame:CGRectMake(65.5 * ProportionAdapter, 175 * ProportionAdapter, 80 * ProportionAdapter, 37 * ProportionAdapter)];
        [self.maleBtn setImage:[UIImage imageNamed:@"icn_men_color"] forState:(UIControlStateNormal)];
        [self.maleBtn setTitle:@"男" forState:(UIControlStateNormal)];
        [self.maleBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [self.maleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15 * ProportionAdapter, 0, 0)];
        [self.maleBtn addTarget:self action:@selector(changeMaleAct:) forControlEvents:(UIControlEventTouchUpInside)];
        self.maleBtn.tag = 200;
        [self.backView addSubview:self.maleBtn];
        
        
        self.femaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(212.5 * ProportionAdapter, 175 * ProportionAdapter, 80 * ProportionAdapter, 37 * ProportionAdapter)];
        [self.femaleBtn setImage:[UIImage imageNamed:@"icn_women_nocolor"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitle:@"女" forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleColor:[UIColor colorWithHexString:@"#d2d2d2"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15 * ProportionAdapter, 0, 0)];
        [self.femaleBtn addTarget:self action:@selector(changeMaleAct:) forControlEvents:(UIControlEventTouchUpInside)];
        self.femaleBtn.tag = 201;
        [self.backView addSubview:self.femaleBtn];
        
        
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 227 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        self.nameTF.placeholder = @"请输入您的个性昵称";
        self.nameTF.borderStyle = UITextBorderStyleRoundedRect;
        self.nameTF.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [self.backView addSubview:self.nameTF];
        
        self.pointTF = [[UITextField alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 277 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        self.pointTF.placeholder = @"请输入您的差点";
        self.pointTF.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.pointTF.borderStyle = UITextBorderStyleRoundedRect;
        [self.backView addSubview:self.pointTF];
        
        
        
        self.industryTF = [[UITextField alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 326 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        self.industryTF.placeholder = @"请选择您的行业";
        self.industryTF.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.industryTF.borderStyle = UITextBorderStyleRoundedRect;
        [self.backView addSubview:self.industryTF];
        
        self.industryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.industryBtn setImage:[UIImage imageNamed:@"icn_show_arrowup"] forState:(UIControlStateNormal)];
        [self.industryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 250 * ProportionAdapter, 0, 0)];
        [self.industryBtn addTarget:self action:@selector(indstryAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.industryTF addSubview:self.industryBtn];
        
        
        self.isUseJGBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 370 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.isUseJGBtn setImage:[UIImage imageNamed:@"icn_register"] forState:(UIControlStateNormal)];
        [self.isUseJGBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 220 * ProportionAdapter)];
        self.isUseJGBtn.titleLabel.font = [UIFont systemFontOfSize:11 * ProportionAdapter];
        [self.isUseJGBtn setTitle:@"使用君高差点管理系统,根据您的记分自动更新差点" forState:(UIControlStateNormal)];
        [self.isUseJGBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        [self.isUseJGBtn addTarget:self action:@selector(isJGSystemAct:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.backView addSubview:self.isUseJGBtn];
        
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 420 * ProportionAdapter, screenWidth - 106 * ProportionAdapter, 33 * ProportionAdapter)];
        self.commitBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
        self.commitBtn.layer.cornerRadius = 6 * ProportionAdapter;
        self.commitBtn.clipsToBounds = YES;
        [self.commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        [self.commitBtn addTarget:self action:@selector(commitAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.backView addSubview:self.commitBtn];
        
    }
    return self;
}

- (void)changeMaleAct:(UIButton *)btn{
    
    if (btn.tag == 200) {
        
        [self.maleBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [self.maleBtn setImage:[UIImage imageNamed:@"icn_men_color"] forState:(UIControlStateNormal)];

        [self.femaleBtn setImage:[UIImage imageNamed:@"icn_women_nocolor"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleColor:[UIColor colorWithHexString:@"#d2d2d2"] forState:(UIControlStateNormal)];

    }else{
        
        [self.maleBtn setTitleColor:[UIColor colorWithHexString:@"#d2d2d2"] forState:(UIControlStateNormal)];
        [self.maleBtn setImage:[UIImage imageNamed:@"icn_men_nocolor"] forState:(UIControlStateNormal)];
        
        [self.femaleBtn setImage:[UIImage imageNamed:@"icn_women_color"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];

    }
}

- (void)commitAct{
    
}

- (void)isJGSystemAct:(UIButton *)btn{
    
    if (self.isUerJG) {
        self.isUerJG = NO;
        [btn setImage:[UIImage imageNamed:@"icn_registerlay"] forState:(UIControlStateNormal)];
    }else{
        self.isUerJG = YES;
        [self.isUseJGBtn setImage:[UIImage imageNamed:@"icn_register"] forState:(UIControlStateNormal)];
    }
    
}

- (void)removeAct{
    [self removeFromSuperview];
}

- (void)indstryAct{
    
    if ([self.backView.subviews containsObject:self.industryTable]) {
        [self.industryTable removeFromSuperview];

    }else{
        [self.backView addSubview:self.industryTable];

    }
    NSLog(@"......%f.-.-.-.-.-.-.-.-......",screenWidth - 86 * ProportionAdapter);
}

- (UITableView *)industryTable{
    if (!_industryTable) {
        _industryTable = [[UITableView alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 353 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 121 * ProportionAdapter)];
        _industryTable.delegate = self;
        _industryTable.dataSource = self;
        [_industryTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _industryTable.rowHeight = 30 * ProportionAdapter;
        _industryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _industryTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card"]];
    }
    return _industryTable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"其他行业";
    cell.textLabel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.industryTF.text = @"CCAAAA";
    [self.industryTable removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
