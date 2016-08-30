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
#import "JGLManageCancelViewController.h"

#import "JGLPowerSettTableViewCell.h"
@interface JGMemAuthorityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    
    NSArray* _arrayTitle;
    NSArray* _arraySection;
    NSArray* _arrayDetail;
    
    
    NSInteger _chooseID;
    
    BOOL _chooseJob[2];
    NSMutableArray* _arrayNum;//存储power的数据
    
    NSInteger _identity;
    NSString* _strPower;
    NSArray* _arrPower;
    //咨询回答1004，球队管理1005
    BOOL _isClick;
}

@property (nonatomic, strong)NSMutableArray *memberArray;

@end

@implementation JGMemAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isClick = NO;
    self.memberArray  =  [[NSMutableArray alloc] init];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.tintColor = [UIColor whiteColor];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_memberKey forKey:@"memberKey"];
    NSString *para = [JGReturnMD5Str getTeamMemberWithMemberKey:[_memberKey integerValue]];
    [dic setObject:para forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMember" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        NSString *str = [[data objectForKey:@"member"]objectForKey:@"power"];
        NSArray *array = [str componentsSeparatedByString:@","];
        
        if ([str containsString:@"1001"]) {
            [self.memberArray addObject:@"1"];
        }else{
            [self.memberArray addObject:@"0"];
        }
        
        if ([str containsString:@"1002"]){
            [self.memberArray addObject:@"1"];
        }else{
            [self.memberArray addObject:@"0"];
        }
        
//        if ([str containsString:@"1003"]){
//            [self.memberArray addObject:@"1"];
//        }else{
//            [self.memberArray addObject:@"0"];
//        }
        
        
        _identity = [[[data objectForKey:@"member"] objectForKey:@"identity"] integerValue];
        _strPower = [[data objectForKey:@"member"] objectForKey:@"power"];
        [_tableView reloadData];
        
    }];

    
    
    
    self.title = @"权限设置";
    
    _arrayTitle = @[@[@"队长",@"会长",@"副会长",@"队长秘书长",@"球队秘书",@"干事",@"普通成员"],@[@"活动管理",@"权限管理"]];
    _arraySection = @[@"身份设置",@"职责设置",@"资金管理"];
    _arrayDetail = @[@"活动发布和对活动成员的管理",@"设置队员身份和职责"];
    _chooseID = 666;
    _arrayNum = [[NSMutableArray alloc]init];
    [self uiConfig];
 
}

-(void)saveSetClick
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    
    
    if (_chooseJob[0] == 1) {
        [_arrayNum addObject:@1001];
    }
    if (_chooseJob[1] == 1) {
        [_arrayNum addObject:@1002];
    }
    //把数组转换成字符串
    if (_chooseID == 7) {
        [dict setObject:@"" forKey:@"power"];
    }else{
        NSString *strNum=[_arrayNum componentsJoinedByString:@","];
        NSString* strPower = [NSString stringWithFormat:@"%@,1004,1005",strNum];
        [dict setObject:strPower forKey:@"power"];
       
    }
    [dict setObject:_memberKey forKey:@"memberKey"];
    

    [dict setObject:[NSNumber numberWithInteger:_chooseID] forKey:@"identity"];

    
    if (_chooseID >= 0 && _chooseID <= 7) {
        [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamMemberPower" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                
                [[ShowHUD showHUD]showToastWithText:@"设置成功" FromView:self.view];
                [self performSelector:@selector(pop) withObject:self afterDelay:TIMESlEEP];

            }
            else
            {
                [Helper alertViewNoHaveCancleWithTitle:[data objectForKey:@"packResultMsg"] withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];

            }
        }];
    }
    else
    {
        [Helper alertViewWithTitle:@"请为他选择一个身份" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
    
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uiConfig
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, screenHeight-15*screenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [_tableView registerNib:[UINib nibWithNibName:@"JGLAuthorityTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLAuthorityTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JGLPowerSettTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLPowerSettTableViewCell"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    else if (section == 1)
    {
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*ScreenWidth/375;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        if (indexPath.section == 2) {
            if (![Helper isBlankString:[_dictAccount objectForKey:@"accountUserName"]]) {
                JGLPowerSettTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPowerSettTableViewCell" forIndexPath:indexPath];
                cell.labelTitle.text = _arraySection[indexPath.section];
                cell.labelName.text = [NSString stringWithFormat:@"%@",[_dictAccount objectForKey:@"accountUserName"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.btnChange addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else
            {
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
                cell.textLabel.text = _arraySection[indexPath.section];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        else
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
            cell.textLabel.text = _arraySection[indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
       
    }
    else
    {
        JGLAuthorityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLAuthorityTableViewCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.titleLabel.text = _arrayTitle[indexPath.section][indexPath.row - 1];
            cell.detailLabel.hidden = YES;
            if (_isClick == NO) {
                if (indexPath.row == _identity) {
                    cell.iconImgv.image = [UIImage imageNamed:@"duihao"];
                }
                else
                {
                    cell.iconImgv.image = [UIImage imageNamed:@""];
                }
            }
            else
            {
                if (indexPath.row != 0) {
                    if (_chooseID != 666) {
                        if (indexPath.row == _chooseID) {
                            cell.iconImgv.image = [UIImage imageNamed:@"duihao"];
                        }
                        else
                        {
                            cell.iconImgv.image = [UIImage imageNamed:@""];
                        }
                        
                    }
                    else
                    {
                        cell.iconImgv.image = [UIImage imageNamed:@""];
                    }
                }
                else
                {
                    cell.iconImgv.image = [UIImage imageNamed:@""];
                }
            }
        }
        else
        {
            
            cell.titleLabel.text = _arrayTitle[indexPath.section][indexPath.row - 1];
            cell.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
            cell.detailLabel.text = _arrayDetail[indexPath.row - 1];
            cell.detailLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_isClick == NO) {
                if (_identity == 7) {
                    cell.userInteractionEnabled = NO;
                    cell.iconImgv.hidden = YES;
                    return cell;
                }
                else{
                    cell.userInteractionEnabled = YES;
                    cell.iconImgv.hidden = NO;
                    
                }
                
                if (_memberArray.count != 0) {
                    if ([[_memberArray objectAtIndex:indexPath.row-1]integerValue] == 1) {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                    }else{
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                    }
                }
                else{

                }
            }
            else
            {
                if (_chooseID == 7) {
                    cell.userInteractionEnabled = NO;
                    cell.iconImgv.hidden = YES;
                    return cell;
                }
                else{
                    cell.userInteractionEnabled = YES;
                    cell.iconImgv.hidden = NO;
                    
                }
                if (_chooseJob[indexPath.row - 1] == 0) {
                    cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                }
                else
                {
                    cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                }
            }
            
            
        }

        return cell;
    }
    return nil;
    
}


-(void)changeClick
{
    [Helper alertViewWithTitle:[NSString stringWithFormat:@"球队只能设置一个资金管理人，如需更换请先取消%@的资金管理权限",[_dictAccount objectForKey:@"accountUserName"]] withBlockCancle:^{
        
    } withBlockSure:^{
        JGLManageCancelViewController*  manVc = [[JGLManageCancelViewController alloc]init];
        manVc.model = _model;
        manVc.teamKey = _teamKey;
        manVc.title = @"取消权限";
        manVc.isCancel = 1;
        manVc.blockCancel = ^(){
            [_dictAccount removeAllObjects];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:manVc animated:YES];
    } withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isClick = YES;
    if (indexPath.section == 0) {
        _chooseID = indexPath.row;
        NSLog(@"%td",_chooseID);
        [_tableView reloadData];
        
    }
    else if (indexPath.section == 1)
    {
        _chooseJob[indexPath.row - 1] = !_chooseJob[indexPath.row - 1];
        [_tableView reloadData];
    }
    else
    {
        if (![Helper isBlankString:[_dictAccount objectForKey:@"accountUserName"]]) {
            [self changeClick];
        }
        else
        {
            JGLManageCancelViewController*  manVc = [[JGLManageCancelViewController alloc]init];
            manVc.model = _model;
            manVc.teamKey = _teamKey;
            manVc.title = @"设置资金管理权限";
            manVc.isCancel = 0;
            manVc.blockSetting = ^(){
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                [dict setObject:_teamKey forKey:@"teamKey"];
                [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
                [dict setObject:@1 forKey:@"offset"];
                NSString *para = [JGReturnMD5Str getTeamMemberListWithTeamKey:[_teamKey integerValue] userKey:[DEFAULF_USERID integerValue]];
                [dict setObject:para forKey:@"md5"];
                [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMemberList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
                    
                } completionBlock:^(id data) {
                    
                    if (![Helper isBlankString:[data objectForKey:@"accountUserKey"]]) {
                        [_dictAccount setObject:[data objectForKey:@"accountUserKey"] forKey:@"accountUserKey"];
                    }
                    if (![Helper isBlankString:[data objectForKey:@"accountUserMobile"]]) {
                        [_dictAccount setObject:[data objectForKey:@"accountUserMobile"] forKey:@"accountUserMobile"];
                    }
                    if (![Helper isBlankString:[data objectForKey:@"accountUserName"]]) {
                        [_dictAccount setObject:[data objectForKey:@"accountUserName"] forKey:@"accountUserName"];
                    }
                    
//                    [_tableView reloadData];
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }];
            };
            [self.navigationController pushViewController:manVc animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
