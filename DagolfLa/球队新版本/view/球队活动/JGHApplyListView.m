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

@interface JGHApplyListView ()<UITableViewDelegate, UITableViewDataSource, JGHApplyListCellDelegate, JGApplyPepoleCellDelegate>

@property (nonatomic, strong)UITableView *applistTableView;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, strong)UIButton *submitBtn;

@end

@implementation JGHApplyListView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.applistArray = [NSMutableArray array];
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
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 196, screenWidth/2, 44)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#F19725"]];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2, 196, screenWidth/2, 44)];
    [self.submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8611D"]];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}
#pragma mark -- 取消
- (void)cancelBtnClick:(UIButton *)btn{
    
}
#pragma mark -- 立即支付
- (void)submitBtnClick:(UIButton *)btn{
    
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
            return signUoPromptCell;
        }else{
            JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
            applyListCel.chooseBtn.tag = indexPath.row;
            applyListCel.deleteBtn.tag = indexPath.row + 100;
            applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
            [applyListCel configDict:_applistArray[indexPath.row]];
            return applyListCel;
        }
    }else{
        
        JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
        signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
//        [activityNameCell congifContact:[NSString stringWithFormat:@"%.2f", _realPayPrice] andNote:[NSString stringWithFormat:@"%.2f", _subsidiesPrice]];
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
    self.applistArray = array;
    [self.applistTableView reloadData];
    
    [self updateView];
}

#pragma mark -- 更新页面
- (void)updateView{
    self.applistTableView.frame = CGRectMake(0, 0, screenWidth, 196 + _applistArray.count * 30);
    NSLog(@"%f", self.frame.size.height - 44);
    
    self.cancelBtn.frame = CGRectMake(0, 196 + _applistArray.count * 30, screenWidth/2, 44);
    self.submitBtn.frame = CGRectMake(screenWidth/2, 196 + _applistArray.count * 30, screenWidth/2, 44);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end
