//
//  JGMemAuthorityViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMemAuthorityViewController.h"

#import "JGLSelfSetViewController.h"
#import "JGLAuthorityTableViewCell.h"
@interface JGMemAuthorityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    
    NSArray* _arrayTitle;
    NSArray* _arraySection;
    NSArray* _arrayDetail;
}

@end

@implementation JGMemAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.tintColor = [UIColor whiteColor];
    
    self.title = @"权限设置";
    
    _arrayTitle = @[@[@"队长",@"会长",@"副会长",@"队长秘书长",@"球队秘书",@"干事"],@[@"活动管理",@"权限管理",@"账户管理"]];
    _arraySection = @[@"身份设置",@"职责设置"];
    _arrayDetail = @[@"活动发布和对活动成员的管理",@"设置队员身份和职责",@"对内收支情况的管理"];
    [self uiConfig];
 
}

-(void)saveSetClick
{
//    JGLSelfSetViewController* selfVc = [[JGLSelfSetViewController alloc]init];
//    [self.navigationController pushViewController:selfVc animated:YES];
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@181 forKey:@"teamKey"];
    [dict setObject:@83 forKey:@"userKey"];
    [dict setObject:@"1001,1002" forKey:@"power"];
    [dict setObject:@196 forKey:@"memberKey"];
    [dict setObject:@5 forKey:@"identity"];
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamMemberPower" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        
    }];
    
    
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45*11*ScreenWidth/375 + 20*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [_tableView registerNib:[UINib nibWithNibName:@"JGLAuthorityTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLAuthorityTableViewCell"];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    else
    {
        return 4;
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
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.textLabel.text = _arraySection[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        JGLAuthorityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLAuthorityTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayTitle[indexPath.section][indexPath.row - 1];
        cell.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        cell.detailLabel.text = _arrayDetail[indexPath.row - 1];
        cell.detailLabel.textColor = [UIColor lightGrayColor];
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
