//
//  JGInvoiceViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGInvoiceViewController.h"
#import "JGInvoiceTypeTextCell.h"
#import "JGActivityNameBaseCell.h"

static NSString *const JGInvoiceTypeTextCellIdentifier = @"JGInvoiceTypeTextCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";

@interface JGInvoiceViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (nonatomic, strong)UITableView *invoiceTableView;
@property (nonatomic, strong)UIView *invoiceTypeView;
@property (nonatomic, strong)NSArray *invoiceTypeArray;//发票类型
@end
@implementation JGInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发票信息";
    self.invoiceTypeArray = @[@"文具类", @"办公用品", @"餐具"];
    
    [self createInvoiceTableView];
    
    
}
- (void)createCommitBtn{
    
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
    UINib *tableViewNib = [UINib nibWithNibName:@"JGInvoiceTypeTextCell" bundle: [NSBundle mainBundle]];
    [self.invoiceTableView registerNib:tableViewNib forCellReuseIdentifier:JGInvoiceTypeTextCellIdentifier];
    
    UINib *invoiceNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
    [self.invoiceTableView registerNib:invoiceNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    self.invoiceTableView.delegate = self;
    self.invoiceTableView.dataSource = self;
    self.invoiceTableView.scrollEnabled = NO;
    self.invoiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.invoiceTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGInvoiceTypeTextCell *invoiceCell = [tableView dequeueReusableCellWithIdentifier:JGInvoiceTypeTextCellIdentifier forIndexPath:indexPath];
        invoiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return invoiceCell;
    }else{
        JGActivityNameBaseCell *invoiceTypeCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
        invoiceTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return invoiceTypeCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (_invoiceTypeView == nil) {
            self.invoiceTypeView.hidden = NO;
            JGActivityNameBaseCell *activityNameBaseCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
            self.invoiceTypeView.frame = CGRectMake(0, activityNameBaseCell.frame.origin.y + activityNameBaseCell.frame.size.height, screenWidth, 90);
            for (int i = 0; i < self.invoiceTypeArray.count; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, i*30, screenWidth, 30)];
                [btn setTitle:self.invoiceTypeArray[i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.titleLabel.textColor = [UIColor blackColor];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                btn.tag = 100 + i;
                [btn addTarget:self action:@selector(didSelectInvoiceTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.invoiceTypeView addSubview:btn];
            }
            self.invoiceTypeView.backgroundColor = [UIColor redColor];
            [self.invoiceTableView addSubview:self.invoiceTypeView];
        }
        self.invoiceTypeView.hidden = NO;
    }
}
#pragma mark -- 发票类型选中事件
- (void)didSelectInvoiceTypeBtnClick:(UIButton *)btn{
    self.invoiceTypeView.hidden = YES;
    NSString *currentBtnText = btn.currentTitle;
    if (btn.tag == 101) {
        
    }else if (btn.tag == 102){
        
    }else{
        
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
