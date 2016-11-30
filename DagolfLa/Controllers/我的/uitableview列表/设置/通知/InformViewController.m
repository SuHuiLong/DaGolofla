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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20*ScreenWidth/375 + 44*ScreenWidth/375 * 2) style:(UITableViewStylePlain)];
    [self.view addSubview: self.tableView];
    self.title = @"推送设置";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44*ScreenWidth/375;
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//    self.array = [NSArray arrayWithObjects:@"约球消息", @"球队消息", @"悬赏消息", @"赛事消息",  nil];
    // Do any additional setup after loading the view.
}


// tableView 数据源
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else{
//        return [self.array count];
//    }
    return 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    static NSString *identifier = @"identifier";
    ScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ScreenTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    [cell.mySwitch addTarget:self action:@selector(mySwitchAc:) forControlEvents:(UIControlEventValueChanged)];
    if (indexPath.row == 0) {
        cell.mySwitch.tag = indexPath.row + 300;
        cell.myLabel.text = @"系统通知";
        if ([[user objectForKey:@"msg_system_setting"] integerValue] == 1) {
            cell.mySwitch.on = NO;
        }else{
            cell.mySwitch.on = YES;
        }
        
//        cell.informSetmodel = self.informSetM;
        return cell;
    }else{
        cell.myLabel.text = @"球队通知";
        cell.mySwitch.tag = indexPath.row + 300;
        if ([[user objectForKey:@"msg_team_setting"] integerValue] == 1) {
            cell.mySwitch.on = NO;
        }else{
            cell.mySwitch.on = YES;
        }

        //        cell.informSetmodel = self.informSetM;
        return cell;
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
        
    }else{
        
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

        
    }
    
//    _isAll = YES;
    
//    switch (mySwitch.tag) {
//        case 300:
//            
//            for (int i = 300; i < 305; i ++) {
//                UISwitch *newSwitch = [self.tableView viewWithTag:i];
//                if (self.informSetM.sysMessAll == 1) {
//                    newSwitch.on = NO;
//                }else{
//                    newSwitch.on = YES;
//                }
//            }
//            
//            if (self.informSetM.sysMessAll == 1) {
//                
//                for (NSString *str in [self.newDic allKeys]) {
//                    if (![str isEqualToString:@"userId"]) {
//                        self.newDic[str] = @2;
//                    }
//                }
//                
//                for (NSString *key in [self.informSetM allPropertyNames]) {
//                    [self.informSetM setValue:@2 forKey:key];
//                }
//                
//            }else{
//                
//                for (NSString *str in [self.newDic allKeys]) {
//                    if (![str isEqualToString:@"userId"]) {
//                        self.newDic[str] = @1;
//                    }
//                }
//                for (NSString *key in [self.informSetM allPropertyNames]) {
//                    [self.informSetM setValue:@1 forKey:key];
//                }
//            }
//            
//            break;
//            
//        case 301:
//            if (self.informSetM.sysMessaboutball == 1) {
//                mySwitch.on = NO;
//                [self.newDic setValue:@2 forKey:@"sysMessaboutball"];
//                self.informSetM.sysMessaboutball = 2;
//                
//                [self setAllWithStr:2];
//                
//            }else{
//                mySwitch.on = YES;
//                [self.newDic setValue:@1 forKey:@"sysMessaboutball"];
//                self.informSetM.sysMessaboutball = 1;
//                
//                [self setAllWithStr:1];
//                
//            }
//            break;
//            
//        case 302:
//            if (self.informSetM.sysMessball == 1) {
//                mySwitch.on = NO;
//                [self.newDic setValue:@2 forKey:@"sysMessball"];
//                self.informSetM.sysMessball = 2;
//                
//                [self setAllWithStr:2];
//                
//            }else{
//                mySwitch.on = YES;
//                [self.newDic setValue:@1 forKey:@"sysMessball"];
//                self.informSetM.sysMessball = 1;
//                
//                [self setAllWithStr:1];
//            }
//            break;
//            
//        case 303:
//            if (self.informSetM.sysMessaboutballre == 1) {
//                mySwitch.on = NO;
//                [self.newDic setValue:@2 forKey:@"sysMessaboutballre"];
//                self.informSetM.sysMessaboutballre = 2;
//                
//                [self setAllWithStr:2];
//                
//            }else{
//                mySwitch.on = YES;
//                [self.newDic setValue:@1 forKey:@"sysMessaboutballre"];
//                self.informSetM.sysMessaboutballre = 1;
//                
//                [self setAllWithStr:1];
//            }
//            break;
//            
//        case 304:
//            if (self.informSetM.sysMessevent == 1) {
//                mySwitch.on = NO;
//                [self.newDic setValue:@2 forKey:@"sysMessevent"];
//                self.informSetM.sysMessevent = 2;
//                
//                [self setAllWithStr:2];
//            }else{
//                mySwitch.on = YES;
//                [self.newDic setValue:@1 forKey:@"sysMessevent"];
//                self.informSetM.sysMessevent = 1;
//                
//                [self setAllWithStr:1];
//            }
//            break;
//            
//        default:
//            break;
//    }
    
    
    
}

//- (void)setAllWithStr:(int)number{
//    
//    NSString *key = [NSString stringWithFormat:@"%d", number];
//    
//    for (NSString *str in self.newDic.allKeys) {
//        if ([self.newDic[str] intValue] == number) {
//            
//        }else{
//            if ([str isEqualToString:@"sysMessAll"] || [str isEqualToString: @"userId"]) {
//                
//            }else{
//                _isAll = NO;
//            }
//        }
//    }
//    if (_isAll == YES) {
//        UISwitch *newSwitch = [self.tableView viewWithTag:300];
//        newSwitch.on = NO;
//        [self.newDic setValue:key forKey:@"sysMessAll"];
//        self.informSetM.sysMessAll = number;
//        [self.tableView reloadData];
//    }
//    
//}

//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20*ScreenWidth/375;
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


//InformSetmodel *beautifulGirl = [InformSetmodel modelWithDictionary:data];
//
//[beautifulGirl displayCurrentModleProperty];


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
