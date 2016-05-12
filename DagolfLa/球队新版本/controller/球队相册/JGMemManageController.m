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
    NSMutableArray* _dataArray;
    
}
@end

@implementation JGMemManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.title = @"球队成员管理";
    _arrayTitle = [NSArray arrayWithObjects:@"基本信息",@"入会时间",@"权限设置", nil];
    _arrayInformation = [NSArray arrayWithObjects:@"姓名",@"性别",@"差点",@"球龄", nil];
    
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:@[@"罗开叉",@"男",@"39",@"1年"]];
    
    [self uiConfig];
    
    
    
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45*7*ScreenWidth/375 + 30*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGMemTitleTableViewCell class] forCellReuseIdentifier:@"JGMemTitleTableViewCell"];
    [_tableView registerClass:[JGMemHalfTableViewCell class] forCellReuseIdentifier:@"JGMemHalfTableViewCell"];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*ScreenWidth/375;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JGMemTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMemTitleTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayTitle[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            cell.detailLabel.text = @"2015年6月15号";
        }
        
        return cell;
    }
    else
    {
        JGMemHalfTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMemHalfTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayInformation[indexPath.row-1];
        cell.detailLabel.text = _dataArray[0][indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //跳转到日期选择的点击事件
    }
    else if (indexPath.section == 2)
    {
        //权限设置的点击事件
        JGMemAuthorityViewController* autVc = [[JGMemAuthorityViewController alloc]init];
        [self.navigationController pushViewController:autVc animated:YES];
    }
    else
    {
        
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
