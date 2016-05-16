//
//  JGLSelfSetViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLSelfSetViewController.h"
#import "JGSelfSetTableViewCell.h"
@interface JGLSelfSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableview;
    
    NSArray* _arrayTitle;
    NSArray* _arrayDetail;
}
@end

@implementation JGLSelfSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arrayTitle = [NSArray arrayWithObjects:@[@"群名片"],@[@"性别",@"差点",@"手机号码"],@[@"常住地址",@"衣服尺码",@"惯用手"],nil];
    _arrayDetail = [NSArray arrayWithObjects:@[@"卡卡"],@[@"男",@"27",@"15872205752"],@[@"上海",@"l",@"左手"],nil];
    self.title = @"个人设置";
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.tintColor = [UIColor whiteColor];

    
    [self uiConfig];
    
    
    
}

-(void)saveSetClick
{
    
}

-(void)uiConfig
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [_tableview registerClass:[JGSelfSetTableViewCell class] forCellReuseIdentifier:@"JGSelfSetTableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 3;
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
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*ScreenWidth/375;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        JGSelfSetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGSelfSetTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayTitle[indexPath.section][indexPath.row];
        cell.detailLabel.text = _arrayDetail[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        if (indexPath.section == 3) {
            cell.textLabel.text = @"年费清单";
        }
        else
        {
            cell.textLabel.text = @"查看球队公共账务";
        }
        return cell;
    }
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //剔除出队的点击事件
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
