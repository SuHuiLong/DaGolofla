//
//  VipCardOrderDetailViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardOrderDetailViewController.h"
#import "VipCardOrderDetailTableViewCell.h"
#import "VipCardOrderDetailModel.h"
#import "VipCardOrderDetailFormatData.h"

#import "VipCardAgreementViewController.h"
#import "JGDConfirmPayViewController.h"
#import "VipCardAgreementViewController.h"

#import "VipCardOrderListViewController.h"
#import "VipCardGoodDetailViewController.h"
@interface VipCardOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 主列表视图
 */
@property(nonatomic, strong)UITableView *mainTableView;
/**
 数据源
 */
@property(nonatomic, strong)NSMutableArray *dataArray;

/**
 订单实际状态 只有未付款显示支付按钮
 */
@property(nonatomic, copy)NSString *stateButtonString;

/**
 立即支付按钮
 */
@property(nonatomic, strong)UIButton *paymentBtn;
@end

@implementation VipCardOrderDetailViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavagationBar];
    [self createTableView];
    [self createPaymentBtn];
}
/**
 上导航
 */
-(void)createNavagationBar{
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    self.title = @"订单详情";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_serve_phone"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kWvertical(15)], NSFontAttributeName, nil] forState:UIControlStateNormal];

    [rightBtn setTintColor:WhiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

/**
 主视图
 */
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.backgroundColor = RGB(238,238,238);
    [mainTableView registerClass:[VipCardOrderDetailTableViewCell class] forCellReuseIdentifier:@"VipCardOrderDetailTableViewCellId" ];
    [mainTableView setExtraCellLineHidden];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}
/**
 立即支付
 */
-(void)createPaymentBtn{
    _paymentBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(8), screenHeight - kHvertical(73)-64, screenWidth-kWvertical(16), kHvertical(46)) titleFont:kHorizontal(19) textColor:RGB(255,255,255) backgroundColor:RGB(252,90,1) target:self selector:@selector(paymentBtnClick) Title:@"立即支付"];
    _paymentBtn.layer.cornerRadius = kWvertical(5);
    [self.view addSubview:_paymentBtn];
    _paymentBtn.hidden = true;
}

#pragma mark - initData
-(void)initViewData{
    [self initDetailData];
}
/**
 获取订单详情数据
 */
-(void)initDetailData{
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"orderKey=%@dagolfla.com",_orderKey]];
    NSDictionary *dict = @{
                           @"orderKey":_orderKey,
                           @"md5":md5Value,
                           };
    [[JsonHttp jsonHttp] httpRequest:@"league/getSystemCardOrderInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        BOOL Success = [[data objectForKey:@"packSuccess"] boolValue];
        if (Success) {
            self.dataArray = [NSMutableArray array];
            VipCardOrderDetailFormatData *formatData = [[VipCardOrderDetailFormatData alloc] init];
            self.dataArray = [formatData formatData:data];
            self.stateButtonString =  formatData.stateButtonString;
            if ([self.stateButtonString isEqualToString:@"未付款"]) {
                _paymentBtn.hidden = false;
            }
            [_mainTableView reloadData];
        }
    }];

}

#pragma mark - Action
/**
 返回
 */
-(void)popBack{

    if (!_ispopAssign) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIViewController *popVC = [[UIViewController alloc] init];
        
        NSArray *temArray = self.navigationController.viewControllers;
        for(UIViewController *temVC in temArray){
            if ([temVC isKindOfClass:[VipCardGoodDetailViewController class]]){
                popVC = temVC;
            }
            if ([temVC isKindOfClass:[VipCardOrderListViewController class]]){
                popVC = temVC;
            }
        }
        [self.navigationController popToViewController:popVC animated:YES];
    }
}
/**
 咨询
 */
-(void)rightBtnClick{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
/**
 立即支付
 */
-(void)paymentBtnClick{
    VipCardOrderDetailModel *model = self.dataArray[0][3];
    NSString *price = model.content;
    price = [price stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    NSLog(@"%@",price);
    
    JGDConfirmPayViewController *confirPayVC = [[JGDConfirmPayViewController alloc] init];
    confirPayVC.orderKey = [Helper returnNumberForString:_orderKey];
    confirPayVC.payMoney = [price floatValue];
    confirPayVC.fromWitchVC = 1;
    [self.navigationController pushViewController:confirPayVC animated:YES];
    
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *indexSectionArray = self.dataArray[section];
    return indexSectionArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(66);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kHvertical(5);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *indexSectionArray = self.dataArray[indexPath.section];
    VipCardOrderDetailModel *model = indexSectionArray[indexPath.row];
    //内容
    NSString *contentStr = model.content;
    //字号
    NSInteger textFont = 15;
    if (model.status==2) {
        textFont = 14;
    }
    CGSize contentSize= [contentStr boundingRectWithSize:CGSizeMake(screenWidth - kWvertical(100), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:kHorizontal(textFont)]} context:nil].size;

    return contentSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    VipCardOrderDetailTableViewCell *cell = [[VipCardOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VipCardOrderDetailTableViewCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *indexSectionArray = self.dataArray[indexPath.section];
    VipCardOrderDetailModel *model = indexSectionArray[indexPath.row];
    [cell configModel:model];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titleArray = @[@"订单信息",@"联盟会籍",@"会员信息"];
    
    UIView *headerView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(66))];
    //灰色背景
    UIView *grayBackView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, 0, screenWidth, kHvertical(10))];
    [headerView addSubview:grayBackView];
    //标题
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(10), screenWidth-kWvertical(10), kHvertical(51)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:titleArray[section]];
    [headerView addSubview:titleLabel];
    //分割线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, kHvertical(60), screenWidth, 1)];
    [headerView addSubview:line];
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(5))];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1&&indexPath.row == 2) {
        VipCardAgreementViewController *vc = [[VipCardAgreementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
