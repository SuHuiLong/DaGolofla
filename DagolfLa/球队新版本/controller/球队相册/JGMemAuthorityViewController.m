//
//  JGMemAuthorityViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMemAuthorityViewController.h"

@interface JGMemAuthorityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    
    NSArray* _arrayTitle;
}

@end

@implementation JGMemAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.title = @"权限设置";
    _arrayTitle = [NSArray arrayWithObjects:@"队长",@"会长/副会长",@"队长秘书长",@"队长秘书/干事",@"剔除出队", nil];

    [self uiConfig];
 
}

-(void)saveSetClick
{
    //保存权限设置
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45*5*ScreenWidth/375 + 20*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
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
    return 45*ScreenWidth/375;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.textLabel.text = _arrayTitle[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.textLabel.text = _arrayTitle[4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
