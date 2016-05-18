//
//  JGTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamApplyViewController.h"
#import "JGActivityNameBaseCell.h"
#import "JGTableViewCell.h"
#import "JGApplyPepoleCell.h"
#import "JGAddTeamGuestViewController.h"
#import "JGInvoiceViewController.h"
#import "JGTeamGroupViewController.h"

static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";

@interface JGTeamApplyViewController ()<JGApplyPepoleCellDelegate>
{
    UIAlertController *_actionView;
}

@end

@implementation JGTeamApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名缴费";
    //注册cell
    UINib *activityNameNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:activityNameNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
    
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        static JGApplyPepoleCell *cell;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        }
        
        cell.guestList.text = @"绝代风华\n哈哈哈\n嘿嘿嘿\n鸡尾酒\n贝多芬";
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tableCell;
    }else if (indexPath.section == 1){
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier forIndexPath:indexPath];
        applyPepoleCell.delegate = self;
        applyPepoleCell.guestList.text = @"绝代风华\n哈哈哈\n嘿嘿嘿\n鸡尾酒\n贝多芬";

        applyPepoleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return applyPepoleCell;
    }else{
        JGActivityNameBaseCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
            activityNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return activityNameCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        JGInvoiceViewController *invoiceCtrl = [[JGInvoiceViewController alloc]init];
        [self.navigationController pushViewController:invoiceCtrl animated:YES];
    }
}
#pragma mark -- 立即付款
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 分别3个创建操作
    UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信支付");
        JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }];
    UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消支付");
    }];
    [_actionView addAction:weiChatAction];
    [_actionView addAction:zhifubaoAction];
    [_actionView addAction:cancelAction];
    [self presentViewController:_actionView animated:YES completion:nil];
}
#pragma mark -- 现场付款
- (IBAction)scenePayBtnClick:(UIButton *)sender {
    
}
#pragma mark -- 添加嘉宾
- (void)addApplyPeopleClick{
    JGAddTeamGuestViewController *addTeamGuestCtrl = [[JGAddTeamGuestViewController alloc]initWithNibName:@"JGAddTeamGuestViewController" bundle:nil];
    [self.navigationController pushViewController:addTeamGuestCtrl animated:YES];
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
