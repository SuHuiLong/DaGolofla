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
#import "JGImageAndLabelAndLabelTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "JGLTeamEditViewController.h"
#import "JGHManagerViewController.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "JGTeamPhotoViewController.h"

@interface JGTeamManageViewController ()<UITableViewDelegate, UITableViewDataSource, JGHConcentTextViewControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *array;
@property (nonatomic, strong)NSArray *imageArray;
@end

@implementation JGTeamManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"球队管理";

    [self creatTableView];
    // Do any additional setup after loading the view.
}

- (void)creatTableView{
      self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerClass:[JGImageAndLabelAndLabelTableViewCell class] forCellReuseIdentifier:@"imageVSlabel"];
    self.array = [NSArray arrayWithObjects:@"发布公告",@[@"球队资料编辑",@"入队审核"],@[@"队员管理",@"活动管理", @"相册管理"],@"账户管理", nil];
    
    self.imageArray = [NSArray arrayWithObjects:@"fbgg", @[@"qdzl", @"rd"], @[@"dy", @"hd-2", @"xcgl"],@"zhgl", nil];
    [self.view addSubview: self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JGImageAndLabelAndLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageVSlabel"];
   
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        cell.imageV.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
        cell.promptLB.text = self.array[indexPath.section][indexPath.row];
    }else{
        cell.imageV.image = [UIImage imageNamed:self.imageArray[indexPath.section]];
        cell.promptLB.text = self.array[indexPath.section];
     }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        JGHConcentTextViewController *contVC = [[JGHConcentTextViewController alloc] init];
        contVC.delegate = self;
        [self.navigationController pushViewController:contVC animated:YES];
        
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            JGLTeamEditViewController* teVc = [[JGLTeamEditViewController alloc]init];
            teVc.detailDic = self.detailDic;
            [self.navigationController pushViewController:teVc animated:YES];
        }else{
            JGLJoinManageViewController* joinVc = [[JGLJoinManageViewController alloc]init];
            joinVc.teamKey = [NSNumber numberWithInteger:_teamKey];
            [self.navigationController pushViewController:joinVc animated:YES];
        }
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            //成员管理
            JGTeamMemberController* menVc = [[JGTeamMemberController alloc]init];
            menVc.title = @"队员管理";
            menVc.power =self.power;
            menVc.teamManagement = 1;
            menVc.teamKey = [NSNumber numberWithInteger:self.teamKey];
            [self.navigationController pushViewController:menVc animated:YES];
        }else if (indexPath.row == 1) {
            JGHManagerViewController *mangerCtrl = [[JGHManagerViewController alloc]init];
            mangerCtrl.timeKey = self.teamKey;
            mangerCtrl.power = _power;
            if ([_detailDic objectForKey:@"name"]) {
                mangerCtrl.teamName = [_detailDic objectForKey:@"name"];
            }
            
            [self.navigationController pushViewController:mangerCtrl animated:YES];
        }else{
            JGTeamPhotoViewController* phoVc = [[JGTeamPhotoViewController alloc]init];
            phoVc.teamKey = [self.detailDic objectForKey:@"timeKey"];
            phoVc.powerPho = self.power;
            phoVc.dictMember = _memberDic;
            phoVc.titleStr = [self.detailDic objectForKey:@"name"];
            [self.navigationController pushViewController:phoVc animated:YES];
        }
        
    }else if (indexPath.section == 3) {
        JGTeamDeatilWKwebViewController *teamDetailCtrl = [[JGTeamDeatilWKwebViewController alloc]init];
        teamDetailCtrl.teamName = @"账户详情";
        teamDetailCtrl.detailString = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/share/team/accountManage.html?teamKey=%td&userKey=%@", self.teamKey, [[NSUserDefaults standardUserDefaults] objectForKey:userID]];
        teamDetailCtrl.teamKey = self.teamKey;
        teamDetailCtrl.isManage = YES;
        [self.navigationController pushViewController:teamDetailCtrl animated:YES];
    }
        
    
    
    
    
    
    
    
    
    
//    //入队审核
//    if (indexPath.section == 0) {
//        JGLJoinManageViewController* joinVc = [[JGLJoinManageViewController alloc]init];
//        joinVc.teamKey = [NSNumber numberWithInteger:_teamKey];
//        [self.navigationController pushViewController:joinVc animated:YES];
//    }
//    else if (indexPath.section == 1)
//    {
//        switch (indexPath.row) {
//            case 0:
//            {
//                //成员管理
//                JGTeamMemberController* menVc = [[JGTeamMemberController alloc]init];
//                menVc.title = @"队员管理";
//                menVc.power =self.power;
//                menVc.teamManagement = 1;
//                menVc.teamKey = [NSNumber numberWithInteger:self.teamKey];
//                [self.navigationController pushViewController:menVc animated:YES];
//            }
//                break;
//            case 1:
//            {
//                //活动管理
//                JGTeamActivityViewController *activityCtrl = [[JGTeamActivityViewController alloc]init];
//                activityCtrl.timeKey = self.teamKey;
//                activityCtrl.myActivityList = 1;
//                [self.navigationController pushViewController:activityCtrl animated:YES];
////                JGTeamActivityViewController* acVc = [[JGTeamActivityViewController alloc]init];
////                [self.navigationController pushViewController:acVc animated:YES];
//            }
//                break;
//            case 2:
//            {
//                JGTeamPhotoViewController* phoVc = [[JGTeamPhotoViewController alloc]init];
//                [self.navigationController pushViewController:phoVc animated:YES];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    else if (indexPath.section == 2)
//    {
//        JGHConcentTextViewController *contVC = [[JGHConcentTextViewController alloc] init];
//        contVC.delegate = self;
//        [self.navigationController pushViewController:contVC animated:YES];
//    }
//    else{
//        JGLTeamEditViewController* teVc = [[JGLTeamEditViewController alloc]init];
//        teVc.detailDic = self.detailDic;
//        [self.navigationController pushViewController:teVc animated:YES];
//    }
}

- (void)didSelectSaveBtnClick:(NSString *)text{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
        [dic setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"teamKey"];
        [dic setObject:text forKey:@"notice"];
        [[JsonHttp jsonHttp] httpRequest:@"team/updateTeam" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
           } completionBlock:^(id data) {
               
//                [Helper alertViewNoHaveCancleWithTitle:@"保存成功" withBlock:^(UIAlertController *alertView) {
//                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
//                }];
           }];
    
    
    }];
 
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
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
