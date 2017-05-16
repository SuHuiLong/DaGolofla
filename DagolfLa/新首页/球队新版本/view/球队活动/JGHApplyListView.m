//
//  JGHApplyListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyListView.h"
#import "JGHHeaderLabelCell.h"
#import "JGApplyPepoleCell.h"
#import "JGHApplyListCell.h"
#import "JGSignUoPromptCell.h"

static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";

@interface JGHApplyListView ()<UITableViewDelegate, UITableViewDataSource, JGHApplyListCellDelegate>

@property (nonatomic, strong)UITableView *applistTableView;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, strong)UIButton *submitBtn;

@property (nonatomic, assign)float amountPayable;//应付金额
@property (nonatomic, assign)float realPayPrice;//实付金额
@property (nonatomic, assign)float realSubPrice;//补贴金额

@property (nonatomic, assign)NSInteger isSub;//是否显示补贴价 -1

@end

@implementation JGHApplyListView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.applistArray = [NSMutableArray array];
        _realPayPrice = 0;
        _amountPayable = 0;
        _realSubPrice = 0;
        _isSub = 0;
        [self createTeamActivityTabelView];//tableView
        [self createCancelAndSubmitBtn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#pragma mark -- 创建取消－支付按钮
- (void)createCancelAndSubmitBtn{
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 152, screenWidth/2, 44)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#F19725"]];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2, 152, screenWidth/2, 44)];
    [self.submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8611D"]];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}
#pragma mark -- 取消
- (void)cancelBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate didSelectCancelBtn:btn];
    }
}
#pragma mark -- 立即支付
- (void)submitBtnClick:(UIButton *)btn{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in _applistArray) {
        if ([[dict objectForKey:@"select"] integerValue] ==1) {
            [array addObject:dict];
        }
    }
    
    if ([array count] == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请勾选付款人！" FromView:self];
        return;
    }
    
    if (self.delegate) {
        [self.delegate didSelectPayBtn:btn andApplyListArray:array];
    }
}
#pragma mark -- 创建TableView
- (void)createTeamActivityTabelView{
    self.applistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 196) style:UITableViewStyleGrouped];
    self.applistTableView.delegate = self;
    self.applistTableView.dataSource = self;
    self.applistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.applistTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    UINib *signUoPromptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.applistTableView registerNib:signUoPromptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyListCell" bundle: [NSBundle mainBundle]];
    [self.applistTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyListCellIdentifier];
    UINib *headerLabelNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.applistTableView registerNib:headerLabelNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
//    self.applistTableView.bounces = NO;
    //[applyDict setObject:@"1" forKey:@"isOnlinePay"];//是否线上付款 1-线上
    [self addSubview:self.applistTableView];
}

#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        //人员个数
        if (self.applistArray.count > 0) {
            return self.applistArray.count + 1;
        }
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.applistArray.count > 0) {
        if (indexPath.row == self.applistArray.count){
            return 44;
        }else{
            return 30;
        }
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.applistArray.count > 0) {
        if (indexPath.row == _applistArray.count){
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
            signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [signUoPromptCell configPromptString:@"提示：未勾选系统默认为现场支付\n           仅当前报名人[在线支付]享受平台补贴。"];
            return signUoPromptCell;
        }else{
            JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
            applyListCel.chooseBtn.tag = indexPath.row;
            applyListCel.deleteBtn.tag = indexPath.row + 100;
            applyListCel.delegate = self;
            applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
            applyListCel.deleteBtn.hidden = YES;
            [applyListCel configDict:_applistArray[indexPath.row]];
            return applyListCel;
        }
    }else{
        
        JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
        signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [signUoPromptCell configPromptString:@"提示：未勾选系统默认为现场支付\n           仅当前报名人[在线支付]享受平台补贴。"];
        return signUoPromptCell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        applyPepoleCell.addApplyBtn.hidden = YES;
        applyPepoleCell.directionImageView.hidden = YES;
        applyPepoleCell.twoDirectionImageView.hidden = YES;
        return (UIView *)applyPepoleCell;
    }else {
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [activityNameCell congiftitles:@"实付金额"];
        
        if (_canSubsidy == 1) {
            [activityNameCell congifContact:[NSString stringWithFormat:@"%.2f", _realPayPrice] andNote:[NSString stringWithFormat:@"%.2f", _subsidiesPrice]];
        }else{
            [activityNameCell congifContact:[NSString stringWithFormat:@"%.2f", _realPayPrice] andNote:@"0.00"];
        }
        
        return (UIView *)activityNameCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 判断是否勾选自己
- (void)returnSelf{
    for (NSDictionary *dict in self.applistArray) {
        if ([[dict objectForKey:@"userKey"] integerValue] == [DEFAULF_USERID integerValue]) {
            if ([[dict objectForKey:@"select"] integerValue] == 1) {
                _isSub = 1;
            }
        }
    }
}
#pragma mark -- 刷新页面数据
- (void)configViewData:(NSMutableArray *)array andCanSubsidy:(NSInteger)canSubsidy{
    _canSubsidy = canSubsidy;
    self.applistArray = array;
    [self.applistTableView reloadData];
    [self countAmountPayable];
    [self updateView];
}

#pragma mark -- 更新页面
- (void)updateView{
    if (screenHeight < ((_applistArray.count * 30) + 108)) {
        self.applistTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 - 44);
        self.cancelBtn.frame = CGRectMake(0, screenHeight - 64 -44, screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, screenHeight - 64 -44, screenWidth/2, 44);
    }else{
        self.applistTableView.frame = CGRectMake(0, 0, screenWidth, 196 + _applistArray.count * 30);
        self.cancelBtn.frame = CGRectMake(0, 152 + (_applistArray.count * 30), screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, 152 + (_applistArray.count * 30), screenWidth/2, 44);
    }
}

#pragma mark --  选择嘉宾
- (void)didChooseBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [self.applistArray objectAtIndex:btn.tag];
    if ([[dict objectForKey:@"select"] integerValue] == 0) {
        [btn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
        [dict setObject:@"1" forKey:@"isOnlinePay"];
        [dict setObject:@"1" forKey:@"select"];
        [self.applistArray replaceObjectAtIndex:btn.tag withObject:dict];
    }else{
        [btn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        [dict setObject:@"0" forKey:@"isOnlinePay"];
        [dict setObject:@"0" forKey:@"select"];
        [self.applistArray replaceObjectAtIndex:btn.tag withObject:dict];
    }
    
    //计算价格
    [self countAmountPayable];
}
#pragma mark -- 计算应付价格
- (void)countAmountPayable{
    _amountPayable = 0.0;
    _realPayPrice = 0.0;
    _realSubPrice = 0.0;
    //判断成员中是否包含自己
    NSInteger isMember = 0;
    for (int i=0; i<_applistArray.count; i++) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = _applistArray[i];
        if ([[dict objectForKey:@"select"]integerValue] == 1) {
            NSLog(@"%@", [dict objectForKey:@"money"]);
            float value = [[dict objectForKey:@"money"] floatValue];
            _amountPayable += value;
            
            if ([[dict objectForKey:@"userKey"] integerValue] == [DEFAULF_USERID integerValue]) {
                isMember = 1;
                _subsidiesPrice = [[dict objectForKey:@"subsidyPrice"] floatValue];
            }
        }
    }
    
    //仅当前报名人[在线支付]享受平台补贴
    if (isMember == 1) {
//        _realSubPrice = _subsidiesPrice;
        if (_canSubsidy == 1) {
            _realPayPrice = _amountPayable - _subsidiesPrice;
        }else{
            _realPayPrice = _amountPayable;
        }
        
    }else{
        _realPayPrice = _amountPayable;
        _subsidiesPrice = 0.0;
    }
    
    [self.applistTableView reloadData];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end
