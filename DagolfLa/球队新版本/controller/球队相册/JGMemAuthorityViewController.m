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
    
    
    NSInteger _chooseID;
    
    BOOL _chooseJob[5];
    NSMutableArray* _arrayNum;//存储power的数据
    
    NSInteger _identity;
    NSString* _strPower;
    NSArray* _arrPower;
    //咨询回答1004，球队管理1005
    BOOL _isClick;
}

@end

@implementation JGMemAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isClick = NO;
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.tintColor = [UIColor whiteColor];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_memberKey forKey:@"memberKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMember" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        _identity = [[[data objectForKey:@"member"] objectForKey:@"identity"] integerValue];
        _strPower = [[data objectForKey:@"member"] objectForKey:@"power"];
        [_tableView reloadData];
        
    }];

    
    
    
    self.title = @"权限设置";
    
    _arrayTitle = @[@[@"队长",@"会长",@"副会长",@"队长秘书长",@"球队秘书",@"干事"],@[@"活动管理",@"权限管理",@"账户管理", @"咨询管理", @"球队管理"]];
    _arraySection = @[@"身份设置",@"职责设置"];
    _arrayDetail = @[@"活动发布和对活动成员的管理",@"设置队员身份和职责",@"对内收支情况的管理"];
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
    if (_chooseJob[2] == 1) {
        [_arrayNum addObject:@1003];
    }
    if (_chooseJob[3] == 1) {
        [_arrayNum addObject:@1004];
    }
    if (_chooseJob[4] == 1) {
        [_arrayNum addObject:@1005];
    }
    //把数组转换成字符串
    NSString *strNum=[_arrayNum componentsJoinedByString:@","];
    [dict setObject:strNum forKey:@"power"];
    [dict setObject:_memberKey forKey:@"memberKey"];
    [dict setObject:[NSNumber numberWithInteger:_chooseID] forKey:@"identity"];

    
    if (_chooseID >= 0 && _chooseID <= 6) {
        [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamMemberPower" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [Helper alertViewNoHaveCancleWithTitle:@"设置成功" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
                [self.navigationController popViewControllerAnimated:YES];

            }
            else
            {
                [Helper alertViewNoHaveCancleWithTitle:@"请检查勾选是否有误" withBlock:^(UIAlertController *alertView) {
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

-(void)uiConfig
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, screenHeight-15*screenWidth/375) style:UITableViewStylePlain];
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
        return 6;
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
            if (_isClick == NO) {
                if ([_strPower rangeOfString:@"1001"].location != NSNotFound) {
                    if (indexPath.row == 1) {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                    }
                    else
                    {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                    }
                }
                else if ([_strPower rangeOfString:@"1002"].location != NSNotFound)
                {
                    if (indexPath.row == 2) {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                    }
                    else
                    {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                    }
                }
                else if ([_strPower rangeOfString:@"1003"].location != NSNotFound)
                {
                    if (indexPath.row == 3) {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                    }
                    else
                    {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                    }
                }
                else if ([_strPower rangeOfString:@"1004"].location != NSNotFound)
                {
                    if (indexPath.row == 4) {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                    }
                    else
                    {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                    }
                }
                else if ([_strPower rangeOfString:@"1005"].location != NSNotFound)
                {
                    if (indexPath.row == 5) {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                    }
                    else
                    {
                        cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                    }
                }
                else{
                    
                }

            }
            else
            {
                if (_chooseJob[indexPath.row - 1] == 0) {
                    cell.iconImgv.image = [UIImage imageNamed:@"kuang"];
                }
                else
                {
                    cell.iconImgv.image = [UIImage imageNamed:@"kuang_xz"];
                }
            }
            
            
        }
        
        cell.detailLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isClick = YES;
    if (indexPath.section == 0) {
        _chooseID = indexPath.row;
        NSLog(@"%td",_chooseID);
        [_tableView reloadData];
    }
    else
    {
        _chooseJob[indexPath.row - 1] = !_chooseJob[indexPath.row - 1];
        [_tableView reloadData];
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
