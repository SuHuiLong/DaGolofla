//
//  JGMemManageController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMemManageController.h"

#import "JGMemTitleTableViewCell.h"
#import "JGMemHalfTableViewCell.h"

#import "JGMemAuthorityViewController.h"
#import "JGHTeamPalerBaseCell.h"

@interface JGMemManageController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    /**
     *  标题数组和用户信息标题数组
     */
    NSArray* _arrayTitle;
    NSArray* _arrayInformation;
    /**
     *  存放用户的数据
     */
    NSMutableArray* _keyArray;
    
}
@end

@implementation JGMemManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"球队成员管理";
    
    _arrayTitle = [NSArray arrayWithObjects:@"基本信息",@"权限设置", nil];
    _arrayInformation = [NSArray arrayWithObjects:@"姓名",@"性别",@"差点",@"球龄", nil];
    
    [self uiConfig];
    
    
    
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 280*ScreenWidth/375 + 110*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGMemTitleTableViewCell class] forCellReuseIdentifier:@"JGMemTitleTableViewCell"];
    [_tableView registerClass:[JGMemHalfTableViewCell class] forCellReuseIdentifier:@"JGMemHalfTableViewCell"];
    [_tableView registerClass:[JGHTeamPalerBaseCell class] forCellReuseIdentifier:@"JGHTeamPalerBaseCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
    
    [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([_power rangeOfString:@"1002"].location != NSNotFound) {
        [btnDelete setTitle:@"剔除出队" forState:UIControlStateNormal];
        btnDelete.backgroundColor = [UIColor colorWithHexString:@"#F29825"];
        [btnDelete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [btnDelete setTitle:@"您没有权限删除队员" forState:UIControlStateNormal];
        btnDelete.backgroundColor = [UIColor darkGrayColor];
    }
   
    btnDelete.layer.cornerRadius = 8 *screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    btnDelete.frame = CGRectMake(10*screenWidth/375, 280*ScreenWidth/375 + 130*ScreenWidth/375, screenWidth-20*screenWidth/375, 44*screenWidth/375);
    
    [self.view addSubview:btnDelete];
    
}

-(void)deleteClick
{
    [Helper alertViewWithTitle:@"您是否确定要删除该队员" withBlockCancle:^{
        
    } withBlockSure:^{
        MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
        progress.mode = MBProgressHUDModeIndeterminate;
        progress.labelText = @"正在上传...";
        [self.view addSubview:progress];
        [progress show:YES];
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
        [dic setObject:_teamKey forKey:@"teamKey"];//球队的timekey
        [dic setObject:_model.timeKey forKey:@"memberKey"];//球队的member的timekey
        [[JsonHttp jsonHttp] httpRequest:@"team/deleteTeamMember" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            [[ShowHUD showHUD]showToastWithText:@"删除失败" FromView:self.view];
        } completionBlock:^(id data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                _deleteBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
            
        }];
        
    } withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
    
   
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*ScreenWidth/375;
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 280*ScreenWidth/375;
    }else{
        return 45*ScreenWidth/375;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JGMemTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMemTitleTableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = _arrayTitle[indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            return cell;
        }else{
            JGHTeamPalerBaseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGHTeamPalerBaseCell" forIndexPath:indexPath];
            [cell configJGLTeamMemberModel:_model];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        JGMemTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMemTitleTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayTitle[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        //权限设置的点击事件
        JGMemAuthorityViewController* autVc = [[JGMemAuthorityViewController alloc]init];
        autVc.teamKey = _model.teamKey;
        autVc.memberKey = _model.timeKey;
        autVc.model = _model;
        //判断有没有设定资金管理者
        autVc.dictAccount = _dictAccount;
        [self.navigationController pushViewController:autVc animated:YES];
    }
    else
    {
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 64*screenWidth/375;
    }
    else
    {
        return 0;
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
