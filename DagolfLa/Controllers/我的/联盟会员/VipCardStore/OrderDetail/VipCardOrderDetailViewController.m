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

@interface VipCardOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 主列表视图
 */
@property(nonatomic, strong)UITableView *mainTableView;
/**
 数据源
 */
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation VipCardOrderDetailViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray *titleArray = @[@[@"订单号",@"下单时间",@"销售人员",@"支付费用",@"订单状态"],@[@"会籍名称",@"会籍权益",@""],@[@"用户名",@"性别",@"证件号",@"预留号码"]];
        NSArray *contentArray = @[@[@"201612121565984",@"2016.12.20 16:15",@"周周",@"￥2400",@"未付款"],@[@"君高高尔夫",@"服务年限1年，28次联盟价击球权益，免费使用果岭、球童、球车、衣柜。",@"权益细则请查阅《君高高尔夫联盟会籍服务协议》"],@[@"李晓晓",@"女",@"325689856256235874",@"13654897265"]];
        for (int i = 0; i<titleArray.count; i++) {
            NSMutableArray *mArray = [NSMutableArray array];
            NSArray *titleIndexArray = titleArray[i];
            NSArray *contentIndexArray = contentArray[i];
            for (int j = 0; j < titleIndexArray.count; j++) {
                VipCardOrderDetailModel *model = [[VipCardOrderDetailModel alloc] init];
                model.title = titleIndexArray[j];
                model.content = contentIndexArray[j];
                model.status = 0;
                if (i==1&&j==0) {
                    model.status = 1;
                }else if (i==1&&j==2){
                    model.status = 2;
                }
                [mArray addObject:model];
            }
            [_dataArray addObject:mArray];
        }
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
}
-(void)createNavagationBar{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.title = @"订单详情";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_serve_phone"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
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
    [mainTableView dequeueReusableCellWithIdentifier:@"VipCardOrderDetailTableViewCellId"];
    [mainTableView setExtraCellLineHidden];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}
#pragma mark - Action
/**
 咨询
 */
-(void)rightBtnClick{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
