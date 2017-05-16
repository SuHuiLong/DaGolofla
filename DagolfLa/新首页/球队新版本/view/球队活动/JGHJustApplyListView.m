//
//  JGHJustApplyListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHJustApplyListView.h"
#import "JGHHeaderLabelCell.h"
#import "JGApplyPepoleCell.h"
#import "JGHApplyListCell.h"
#import "JGSignUoPromptCell.h"

static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";

@interface JGHJustApplyListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *justApplistTableView;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, strong)UIButton *submitBtn;

@property (nonatomic, assign)float amountPayable;//应付金额
@property (nonatomic, assign)float realPayPrice;//实付金额
@property (nonatomic, assign)float realSubPrice;//补贴金额

@end

@implementation JGHJustApplyListView


- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.justApplistArray = [NSMutableArray array];
        _realPayPrice = 0;
        _amountPayable = 0;
        _realSubPrice = 0;
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
    [self.submitBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8611D"]];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}
#pragma mark -- 取消
- (void)cancelBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate didJustApplyListCancelBtn:btn];
    }
}
#pragma mark -- 立即报名
- (void)submitBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate didJustApplyListApplyBtn:btn];
    }
}
#pragma mark -- 创建TableView
- (void)createTeamActivityTabelView{
    self.justApplistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 196) style:UITableViewStyleGrouped];
    self.justApplistTableView.delegate = self;
    self.justApplistTableView.dataSource = self;
    self.justApplistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.justApplistTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    UINib *signUoPromptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.justApplistTableView registerNib:signUoPromptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyListCell" bundle: [NSBundle mainBundle]];
    [self.justApplistTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyListCellIdentifier];
    UINib *headerLabelNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.justApplistTableView registerNib:headerLabelNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    //    self.applistTableView.bounces = NO;
    [self addSubview:self.justApplistTableView];
}

#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        //人员个数
        if (self.justApplistArray.count > 0) {
            return self.justApplistArray.count + 1;
        }
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.justApplistArray.count > 0) {
        if (indexPath.row == _justApplistArray.count){
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
            signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [signUoPromptCell configPromptString:@"提示：用户报名不支付，将不能享受平台补贴。"];
            return signUoPromptCell;
        }else{
            JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
            applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
            applyListCel.deleteBtn.hidden = YES;
            applyListCel.chooseBtn.hidden = YES;
            
            [applyListCel configDict:_justApplistArray[indexPath.row]];
            applyListCel.subsidiesImageView.hidden = YES;
            return applyListCel;
        }
    }else{
        JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
        signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [signUoPromptCell configPromptString:@"提示：用户报名不支付，将不能享受平台补贴。"];
        return signUoPromptCell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
    applyPepoleCell.addApplyBtn.hidden = YES;
    applyPepoleCell.directionImageView.hidden = YES;
    applyPepoleCell.twoDirectionImageView.hidden = YES;
    return (UIView *)applyPepoleCell;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}

#pragma mark -- 刷新页面数据
- (void)configjustApplyViewData:(NSMutableArray *)array{
    self.justApplistArray = array;
    [self.justApplistTableView reloadData];
    [self updateView];
}

#pragma mark -- 更新页面
- (void)updateView{
    if (screenHeight < ((_justApplistArray.count * 30) + 108)) {
        self.justApplistTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 - 44);
        self.cancelBtn.frame = CGRectMake(0, screenHeight - 64 -44, screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, screenHeight - 64 -44, screenWidth/2, 44);
    }else{
        self.justApplistTableView.frame = CGRectMake(0, 0, screenWidth, 132 + _justApplistArray.count * 30);
        self.cancelBtn.frame = CGRectMake(0, 88 + (_justApplistArray.count * 30), screenWidth/2, 44);
        self.submitBtn.frame = CGRectMake(screenWidth/2, 88 + (_justApplistArray.count * 30), screenWidth/2, 44);
    }
}


@end
