//
//  JGHRepeatApplyView.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRepeatApplyView.h"
#import "JGHHeaderLabelCell.h"
#import "JGApplyPepoleCell.h"
#import "JGHApplyListCell.h"
#import "JGSignUoPromptCell.h"

static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";

@interface JGHRepeatApplyView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *repeatApplyTableView;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, strong)UIButton *submitBtn;

@property (nonatomic, assign)float amountPayable;//应付金额
@property (nonatomic, assign)float realPayPrice;//实付金额
@property (nonatomic, assign)float realSubPrice;//补贴金额

@end

@implementation JGHRepeatApplyView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.repeatAppArray = [NSMutableArray array];
        _realPayPrice = 0;
        _amountPayable = 0;
        _realSubPrice = 0;
        [self createTeamActivityTabelView];//tableView
        [self createCancelAndSubmitBtn];
    }
    return self;
}

#pragma mark -- 创建TableView
- (void)createTeamActivityTabelView{
    self.repeatApplyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 196) style:UITableViewStyleGrouped];
    self.repeatApplyTableView.delegate = self;
    self.repeatApplyTableView.dataSource = self;
    self.repeatApplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.repeatApplyTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    UINib *signUoPromptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.repeatApplyTableView registerNib:signUoPromptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyListCell" bundle: [NSBundle mainBundle]];
    [self.repeatApplyTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyListCellIdentifier];
    UINib *headerLabelNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.repeatApplyTableView registerNib:headerLabelNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    [self addSubview:self.repeatApplyTableView];
}

#pragma mark -- 创建取消－支付按钮
- (void)createCancelAndSubmitBtn{
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 152, screenWidth/2, 44)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#F19725"]];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2, 152, screenWidth/2, 44)];
    [self.submitBtn setTitle:@"报名并支付" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8611D"]];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}

#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        //人员个数
        if (self.repeatAppArray.count > 0) {
            return self.repeatAppArray.count + 1;
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
    if (self.repeatAppArray.count > 0) {
        if (indexPath.row == self.repeatAppArray.count){
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
    if (self.repeatAppArray.count > 0) {
        if (indexPath.row == _repeatAppArray.count){
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
            signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [signUoPromptCell configPromptString:@"提示：未勾选系统默认为现场支付\n           仅当前报名人[在线支付]享受平台补贴。"];
            return signUoPromptCell;
        }else{
            JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
            applyListCel.chooseBtn.tag = indexPath.row;
            applyListCel.deleteBtn.tag = indexPath.row + 100;
//            applyListCel.delegate = self;
            applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
            applyListCel.deleteBtn.hidden = YES;
            [applyListCel configDict:_repeatAppArray[indexPath.row]];
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
        return (UIView *)applyPepoleCell;
    }else {
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [activityNameCell congiftitles:@"实付金额"];
        [activityNameCell congifContact:[NSString stringWithFormat:@"%.2f", _realPayPrice] andNote:[NSString stringWithFormat:@"%.2f", _realSubPrice]];
        return (UIView *)activityNameCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}

#pragma mark -- 刷新页面数据
- (void)configViewData:(NSMutableArray *)array{
    self.repeatAppArray = array;
    [self.repeatApplyTableView reloadData];
//    [self countAmountPayable];
    [self updateView];
}

#pragma mark -- 更新页面
- (void)updateView{
    if (screenHeight < ((_repeatAppArray.count * 30) + 108)) {
        self.repeatApplyTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 - 44);
        self.cancelBtn.frame = CGRectMake(0, screenHeight - 64, screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, screenHeight - 64, screenWidth/2, 44);
    }else{
        self.repeatApplyTableView.frame = CGRectMake(0, 0, screenWidth, 196 + _repeatAppArray.count * 30);
        self.cancelBtn.frame = CGRectMake(0, 152 + (_repeatAppArray.count * 30), screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, 152 + (_repeatAppArray.count * 30), screenWidth/2, 44);
    }
}
#pragma mark -- 计算应付价格
- (void)countAmountPayable{
    _amountPayable = 0.0;
    _realPayPrice = 0.0;
    _realSubPrice = 0.0;
    //判断成员中是否包含自己
    NSInteger isMember = 0;
    for (int i=0; i<_repeatAppArray.count; i++) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = _repeatAppArray[i];
        if ([[dict objectForKey:@"select"]integerValue] == 1) {
            NSLog(@"%@", [dict objectForKey:@"payMoney"]);
            float value = [[dict objectForKey:@"payMoney"] floatValue];
            _amountPayable += value;
            
            if ([[dict objectForKey:@"userKey"] integerValue] != 0) {
                isMember = 1;
            }
        }
    }
    
    //仅当前报名人[在线支付]享受平台补贴
    if (isMember == 1) {
        _realSubPrice = _subsidiesPrice;
        _realPayPrice = _amountPayable - _realSubPrice;
    }else{
        _realPayPrice = _amountPayable;
    }
    
    [self.repeatApplyTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
