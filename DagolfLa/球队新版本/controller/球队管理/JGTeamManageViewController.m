//
//  JGTeamManageViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamManageViewController.h"
#import "JGLJoinManageViewController.h"
#import "JGTeamMemberController.h"
#import "JGTeamPhotoViewController.h"
#import "JGTeamActivityViewController.h"

@interface JGTeamManageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *array;

@end

@implementation JGTeamManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    // Do any additional setup after loading the view.
}

- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.array = [NSArray arrayWithObjects:@"入队审核",@[@"队员管理",@"活动管理", @"相册管理"],@"账户管理",@"球队资料编辑", nil];
    [self.view addSubview: self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    }else{
        cell.textLabel.text = self.array[indexPath.section];
     }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)
tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //入队审核
    if (indexPath.section == 0) {
        JGLJoinManageViewController* joinVc = [[JGLJoinManageViewController alloc]init];
        [self.navigationController pushViewController:joinVc animated:YES];
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                //成员管理
                JGTeamMemberController* menVc = [[JGTeamMemberController alloc]init];
                [self.navigationController pushViewController:menVc animated:YES];
            }
                break;
            case 1:
            {
                JGTeamActivityViewController* acVc = [[JGTeamActivityViewController alloc]init];
                [self.navigationController pushViewController:acVc animated:YES];
            }
                break;
            case 2:
            {
                JGTeamPhotoViewController* phoVc = [[JGTeamPhotoViewController alloc]init];
                [self.navigationController pushViewController:phoVc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        
    }
    else{
        
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
