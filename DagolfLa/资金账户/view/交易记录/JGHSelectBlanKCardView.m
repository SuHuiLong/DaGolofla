//
//  JGHSelectBlanKCardView.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSelectBlanKCardView.h"
#import "JGHSelectBlankCatoryCell.h"
#import "JGLBankModel.h"

static NSString *const JGHSelectBlankCatoryCellIdentifier = @"JGHSelectBlankCatoryCell";

@interface JGHSelectBlanKCardView ()<UITableViewDelegate, UITableViewDataSource>

{
    NSInteger _selectBlank;
}

@property (nonatomic, strong)UITableView *blankCatoryTableView;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, strong)UIButton *submitBtn;

@end

@implementation JGHSelectBlanKCardView

- (instancetype)init{
    if (self == [super init]) {
        self.userInteractionEnabled = YES;
        self.dataArray = [NSMutableArray array];
        self.blankCatoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, self.frame.size.height - 44 -30*ProportionAdapter) style:UITableViewStyleGrouped];
        self.blankCatoryTableView.delegate = self;
        self.blankCatoryTableView.dataSource = self;
        self.blankCatoryTableView.backgroundColor = [UIColor whiteColor];
        
        UINib *blankCatoryNib = [UINib nibWithNibName:@"JGHSelectBlankCatoryCell" bundle: [NSBundle mainBundle]];
        [self.blankCatoryTableView registerNib:blankCatoryNib forCellReuseIdentifier:JGHSelectBlankCatoryCellIdentifier];
        
        [self addSubview:self.blankCatoryTableView];
        
        self.backgroundColor = [UIColor redColor];
        
        _selectBlank = 0;
        [self createCancelAndSubmitBtn];
    }
    return self;
}
#pragma mark -- 创建取消－支付按钮
- (void)createCancelAndSubmitBtn{
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30*ProportionAdapter, screenWidth/2, 44)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#F19725"]];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2, 30*ProportionAdapter, screenWidth/2, 44)];
    [self.submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8611D"]];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}
#pragma mark -- cancelBtnClick
- (void)cancelBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate seleCancelBtn:btn];
    }
}
#pragma mark -- submitBtnClick
- (void)submitBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate selectSubmitBtn:btn];
    }
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count + 1;
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 * ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHSelectBlankCatoryCell *blankCatoryCell = [tableView dequeueReusableCellWithIdentifier:JGHSelectBlankCatoryCellIdentifier];
    blankCatoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count == 0) {
        [blankCatoryCell configAddBlankCatory];
    }else{
        if (_dataArray.count == indexPath.row) {
            [blankCatoryCell configAddBlankCatory];
        }else{
            [blankCatoryCell configJGLBankModel:_dataArray[indexPath.section] andSelectBlank:indexPath.row andCurrentSelect:_selectBlank];
        }
    }
    
    return blankCatoryCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30*ProportionAdapter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count != 0) {
        
        if (_dataArray.count != indexPath.row) {
            _selectBlank = indexPath.row;
            self.submitBtn.tag = _selectBlank;
            NSLog(@" _submitBtn.tag == %td", _submitBtn.tag);
            [self.blankCatoryTableView reloadData];
            NSLog(@"选中");
        }else{
            NSLog(@"添加银行卡");
            [self addBlankCardClick];
        }
    }else{
        NSLog(@"添加银行卡");
        [self addBlankCardClick];
    }
}
#pragma mark -- 添加银行卡
- (void)addBlankCardClick{
    if (self.delegate) {
        [self.delegate addBlankCard];
    }
}
#pragma mark -- 刷新页面数据
- (void)configViewData:(NSMutableArray *)array{
    self.dataArray = array;
    [self updateView];
}

#pragma mark -- 更新页面
- (void)updateView{
    if (screenHeight < ((_dataArray.count * 60) + 108 + 30*ProportionAdapter)) {
        self.blankCatoryTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 - 44);
        self.cancelBtn.frame = CGRectMake(0, screenHeight -64 -44, screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, screenHeight -44 -64, screenWidth/2, 44);
    }else{
        self.blankCatoryTableView.frame = CGRectMake(0, 0, screenWidth, ((_dataArray.count + 1) * 60)*ProportionAdapter + 30*ProportionAdapter);
        self.cancelBtn.frame = CGRectMake(0, (((_dataArray.count + 1) * 60))*ProportionAdapter+30*ProportionAdapter, screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, (((_dataArray.count + 1) * 60))*ProportionAdapter+30*ProportionAdapter, screenWidth/2, 44);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
