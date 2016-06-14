//
//  JGInvoiceViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGInvoiceViewController.h"
#import "JGHInvoiceCell.h"
#import "InvoiceModel.h"
#import "JGHAddInvoiceViewController.h"

static NSString *const JGHInvoiceCellCellIdentifier = @"JGHInvoiceCell";
//static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";

@interface JGInvoiceViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (nonatomic, strong)UITableView *invoiceTableView;
@property (nonatomic, strong)UIView *invoiceTypeView;
@property (nonatomic, strong)NSArray *invoiceTypeArray;//发票类型

@property (nonatomic, strong)NSMutableArray *invoiceArray;//发票数组

@end
@implementation JGInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"发票信息";
    self.invoiceTypeArray = @[@"文具类", @"办公用品", @"餐饮"];
    self.invoiceArray = [NSMutableArray array];
    
    [self createInvoiceTableView];
    
    [self createAdminBtn];
    
    [self loadData];
}
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@244 forKey:@"userKey"];
    [dict setObject:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"invoice/getInvoiceList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errTpe ==%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data ==%@", data);
        [self.invoiceArray removeAllObjects];
        NSArray *array = [data objectForKey:@"invoiceList"];
        for (NSDictionary *dict in array) {
            InvoiceModel *model = [[InvoiceModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.invoiceArray addObject:model];
        }
        
        [self.invoiceTableView reloadData];
    }];
}

#pragma mark -- 创建新增按钮
- (void)createAdminBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RightNavItemFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(newInvoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -- 新增发票
- (void)newInvoiceBtnClick:(UIButton *)btn{
    JGHAddInvoiceViewController *addInvoice = [[JGHAddInvoiceViewController alloc]initWithNibName:@"JGHAddInvoiceViewController" bundle:nil];
    [self.navigationController pushViewController:addInvoice animated:YES];
}
- (UIView *)invoiceTypeView{
    if (_invoiceTypeView == nil) {
        _invoiceTypeView = [[UIView alloc]init];
        
    }
    return _invoiceTypeView;
}
#pragma mark --创建tableView
- (void)createInvoiceTableView{
    self.invoiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    UINib *tableViewNib = [UINib nibWithNibName:@"JGHInvoiceCell" bundle: [NSBundle mainBundle]];
    [self.invoiceTableView registerNib:tableViewNib forCellReuseIdentifier:JGHInvoiceCellCellIdentifier];
    
//    UINib *invoiceNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
//    [self.invoiceTableView registerNib:invoiceNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    self.invoiceTableView.delegate = self;
    self.invoiceTableView.dataSource = self;
    self.invoiceTableView.scrollEnabled = NO;
    self.invoiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.invoiceTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _invoiceArray.count;
//    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        JGInvoiceTypeTextCell *invoiceCell = [tableView dequeueReusableCellWithIdentifier:JGInvoiceTypeTextCellIdentifier forIndexPath:indexPath];
//        invoiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return invoiceCell;
//    }else{
//        JGActivityNameBaseCell *invoiceTypeCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
//        invoiceTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return invoiceTypeCell;
//    }
    JGHInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHInvoiceCellCellIdentifier];
    InvoiceModel *model = [[InvoiceModel alloc]init];
    model = _invoiceArray[indexPath.section];
    [cell configInvoiceModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGHInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:JGHInvoiceCellCellIdentifier forIndexPath:indexPath];
//    cell.selectBtn setImage:@"" forState:<#(UIControlState)#>
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        if (_invoiceTypeView == nil) {
//            self.invoiceTypeView.hidden = NO;
//            JGActivityNameBaseCell *activityNameBaseCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
//            self.invoiceTypeView.frame = CGRectMake(0, activityNameBaseCell.frame.origin.y + activityNameBaseCell.frame.size.height, screenWidth, 90);
//            for (int i = 0; i < self.invoiceTypeArray.count; i++) {
//                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, i*30, screenWidth, 30)];
//                [btn setTitle:self.invoiceTypeArray[i] forState:UIControlStateNormal];
//                btn.titleLabel.font = [UIFont systemFontOfSize:15];
//                btn.titleLabel.textColor = [UIColor blackColor];
//                btn.titleLabel.textColor = [UIColor blackColor];
//                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                btn.tag = 100 + i;
//                [btn addTarget:self action:@selector(didSelectInvoiceTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [self.invoiceTypeView addSubview:btn];
//            }
//            self.invoiceTypeView.backgroundColor = [UIColor redColor];
//            [self.invoiceTableView addSubview:self.invoiceTypeView];
//        }
//        self.invoiceTypeView.hidden = NO;
//    }
}
#pragma mark -- 发票类型选中事件
//- (void)didSelectInvoiceTypeBtnClick:(UIButton *)btn{
//    self.invoiceTypeView.hidden = YES;
//    NSString *currentBtnText = btn.currentTitle;
//    if (btn.tag == 101) {
//        
//    }else if (btn.tag == 102){
//        
//    }else{
//        
//    }
//}
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
