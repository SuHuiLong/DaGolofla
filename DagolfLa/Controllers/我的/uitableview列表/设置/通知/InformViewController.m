//
//  ScreenViewController.m
//  DagolfLa
//
//  Created by 東 on 16/3/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "InformViewController.h"
#import "ScreenTableViewCell.h"
#import "PostDataRequest.h"
#import "InformSetmodel.h"



@interface InformViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *array;
@property (strong, nonatomic)InformSetmodel *informSetM;
@property (strong, nonatomic)NSMutableDictionary *newDic;
@property (assign, nonatomic)BOOL isAll;

@end

@implementation InformViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    [self.informSetM setValuesForKeysWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"informMessege"]];
//    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    /*
    [[PostDataRequest sharedInstance] postDataRequest:@"user/updateUserSys.do" parameter:self.newDic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[self.newDic copy] forKey:@"informMessege"];
            
            //            [self.tableView reloadData];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改接收消息设置失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failed:^(NSError *error) {
        
        
    }];
    */
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90*ScreenWidth/375 + 44*ScreenWidth/375 * 3) style:(UITableViewStylePlain)];
    [self.view addSubview: self.tableView];
    self.title = @"系统设置";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44*ScreenWidth/375;
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, section == 1 ?  70 * ProportionAdapter : 20 * ProportionAdapter)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    NSString *text = @"启用君高差点管理系统后，系统会根据每场完整几分成绩，计算出当此球场差点值，然后将该值与个人历史差点进行计算，实时算出您的新差点并自动更新。";
    UILabel *lalel = [Helper lableRect:CGRectMake(15 * ProportionAdapter, 0, screenWidth - 30 * ProportionAdapter, 60 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:12 * ProportionAdapter text:section == 1 ? text : @"" textAlignment:(NSTextAlignmentLeft)];
    lalel.numberOfLines = 0;
    if (section == 1) {
        [backView addSubview:lalel];
    }
    return backView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    static NSString *identifier = @"identifier";
    ScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ScreenTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    [cell.mySwitch addTarget:self action:@selector(mySwitchAc:) forControlEvents:(UIControlEventValueChanged)];

    if (indexPath.section == 0) {
        cell.mySwitch.tag = indexPath.row + 200;
        cell.myLabel.text = @"君高差点管理系统";
        if ([[user objectForKey:@"almost_system_setting"] integerValue] == 1) {
            cell.mySwitch.on = YES;
        }else{
            cell.mySwitch.on = NO;
        }
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            cell.mySwitch.tag = indexPath.row + 300;
            cell.myLabel.text = @"系统通知";
            if ([[user objectForKey:@"msg_system_setting"] integerValue] == 1) {
                cell.mySwitch.on = NO;
            }else{
                cell.mySwitch.on = YES;
            }
            
            return cell;
        }else{
            cell.myLabel.text = @"球队通知";
            cell.mySwitch.tag = indexPath.row + 300;
            if ([[user objectForKey:@"msg_team_setting"] integerValue] == 1) {
                cell.mySwitch.on = NO;
            }else{
                cell.mySwitch.on = YES;
            }
            return cell;
        }

    }
    
}


#pragma mark ------ switch 点击事件

- (void)mySwitchAc: (UISwitch *)mySwitch{

    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];

    if (mySwitch.tag == 300) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:DEFAULF_USERID forKey:@"userId"];
        if (mySwitch.isOn) {
            [dic setObject:@0 forKey:@"msg_system_setting"];
        }else{
            [dic setObject:@1 forKey:@"msg_system_setting"];
        }
        [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
        // msg_system_setting  // 1 是  close
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:dic failedBlock:^(id errType) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];

        } completionBlock:^(id data) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];

            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [user setObject:[dic objectForKey:@"msg_system_setting"] forKey:@"msg_system_setting"];
                [user synchronize];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                }
                
            }
        }];
        
    }else if (mySwitch.tag == 301){
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:DEFAULF_USERID forKey:@"userId"];
        if (mySwitch.isOn) {
            [dic setObject:@0 forKey:@"msg_team_setting"];
        }else{
            [dic setObject:@1 forKey:@"msg_team_setting"];
        }
        [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
        // msg_team_setting
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:dic failedBlock:^(id errType) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];
            
        } completionBlock:^(id data) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [user setObject:[dic objectForKey:@"msg_team_setting"] forKey:@"msg_team_setting"];
                [user synchronize];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                }
                
            }
        }];

        
    }else if (mySwitch.tag == 200) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:DEFAULF_USERID forKey:@"userId"];
        if (mySwitch.isOn) {
            [dic setObject:@1 forKey:@"almost_system_setting"];
        }else{
            [dic setObject:@0 forKey:@"almost_system_setting"];
        }
        [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
        // msg_team_setting
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:dic failedBlock:^(id errType) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];
            
        } completionBlock:^(id data) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [user setObject:[dic objectForKey:@"almost_system_setting"] forKey:@"almost_system_setting"];
                [user synchronize];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                }
                
            }
        }];
    }
  
    
}


//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 20*ScreenWidth/375 : 70*ScreenWidth/375;
}

- (NSMutableDictionary *)newDic{
    if (!_newDic) {
        _newDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"informMessege"] mutableCopy];
    }
    return _newDic;
}


- (InformSetmodel *)informSetM{
    if (!_informSetM) {
        _informSetM = [[InformSetmodel alloc] init];
    }
    return _informSetM;
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
