//
//  JGLAddPlayerViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddPlayerViewController.h"
#import "JGLAddPlayerTableViewCell.h"
#import "JGLPlayerNumberTableViewCell.h"
#import "JGLFriendAddViewController.h"
#import "JGLAddressAddViewController.h"
#import "UITool.h"
#import "JGLBarCodeViewController.h"
@interface JGLAddPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _tableView;
    UIView* _viewHeader;
    
    
    
    BOOL _isClick;
}
@end

@implementation JGLAddPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    self.title = @"添加打球人";
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    [self.view addSubview:view];
//    if (_dictPeople.count == 0) {
        _dictPeople = [[NSMutableDictionary alloc]init];
//    }
//    if (_peoFriend.count == 0) {
        _peoFriend  = [[NSMutableDictionary alloc]init];
//    }
//    if (_peoAddress.count == 0) {
        _peoAddress = [[NSMutableDictionary alloc]init];
//    }
    
    
    
    [self uiConfig];
    [self createHeader];
}

-(void)finishAction
{
    _blockSurePlayer(_dictPeople,_peoAddress,_peoAddress);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createHeader
{
    //添加打球人页面，
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100*screenWidth/375)];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _viewHeader;
//    _tableView.tableHeaderView.userInteractionEnabled = YES;
//    _viewHeader.userInteractionEnabled = YES;
    NSArray* arrTit = @[@"通讯录添加",@"扫描添加",@"球友列表添加"];
    NSArray* arrImg = @[@"addressBook",@"saomiao",@"tjdqr_qiuyou"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton* btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(screenWidth/3*i, 0, screenWidth/3, 100*screenWidth/375);
        btnAdd.tag = 100 + i;
        [_viewHeader addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(chooseStyleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i > 0) {
            UIView* vieeLine = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/3*i - 1, 15*screenWidth/375, 2, 70*screenWidth/375)];
            vieeLine.backgroundColor = [UIColor lightGrayColor];
            [_viewHeader addSubview:vieeLine];
        }
        
        UIImageView* imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/3*i +screenWidth/9 , 20*screenWidth/375, screenWidth/9, screenWidth/9)];
        imgvIcon.image = [UIImage imageNamed:arrImg[i]];
        [_viewHeader addSubview:imgvIcon];
        
        UILabel* labelN = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/3*i, 65*screenWidth/375, screenWidth/3, 30*screenWidth/375)];
        labelN.text = arrTit[i];
        labelN.font = [UIFont systemFontOfSize:15*screenWidth/375];
        labelN.textAlignment = NSTextAlignmentCenter;
        [_viewHeader addSubview:labelN];
    }
    
}

-(void)chooseStyleClick:(UIButton *)btn
{
    //通讯录成员添加按钮
    if (btn.tag == 100) {
        JGLAddressAddViewController* addVc = [[JGLAddressAddViewController alloc]init];
        //选择好的通讯录成员
        addVc.blockAddressPeople = ^(NSMutableDictionary* dict){
            _peoAddress = dict;
            [_dictPeople addEntriesFromDictionary:dict];
            
            [_tableView reloadData];
        };
        addVc.dictFinish = _peoAddress;
        if (_dictPeople.count != 0) {
            addVc.lastIndex = _dictPeople.count;
        }
        else{
            addVc.lastIndex = 0;
        }
        _isClick = NO;
        [self.navigationController pushViewController:addVc animated:YES];
    }
    else if (btn.tag == 101)
    {
        JGLBarCodeViewController* barVc = [[JGLBarCodeViewController alloc]init];
        barVc.blockDict = ^(NSMutableDictionary *dict){
            [_dictPeople addEntriesFromDictionary:dict];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:barVc animated:YES];
    }
    else{
        JGLFriendAddViewController* fVc = [[JGLFriendAddViewController alloc]init];
        //选择好的好友成员
        fVc.blockFriendDict = ^(NSMutableDictionary* dict){
            _peoFriend = dict;
            [_dictPeople addEntriesFromDictionary:dict];
            [_tableView reloadData];
        };
        fVc.dictFinish = _peoFriend;
        if (_dictPeople.count != 0) {
            fVc.lastIndex = _dictPeople.count;
        }
        else{
            fVc.lastIndex = 0;
        }
        
        _isClick = NO;
        [self.navigationController pushViewController:fVc animated:YES];
    }
}

-(void)uiConfig
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * screenWidth / 375)];
    view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, screenWidth - 20*screenWidth/375, 80*screenWidth/375)];
    label.text = @"记分完成后会生成唯一秘钥，用户注册APP会员后，点击“历史记分卡”右上角”取回记分”，填写秘钥即可得到该成绩；通过“球友列表”与“扫描二维码”添加的打球人，记分开始后，成绩会自动同步到被添加人的历史记分卡。";
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:14*screenWidth/375];
    label.textColor = [UITool colorWithHexString:@"b8b8b8" alpha:1];
    label.numberOfLines = 0;
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10 * screenWidth / 375, screenWidth, screenHeight-10 * screenWidth / 375) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = view;

    
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLAddPlayerTableViewCell class] forCellReuseIdentifier:@"JGLAddPlayerTableViewCell"];
    [_tableView registerClass:[JGLPlayerNumberTableViewCell class] forCellReuseIdentifier:@"JGLPlayerNumberTableViewCell"];
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLAddPlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLAddPlayerTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
        cell.labelTitle.text = @"手动添加打球人";
        
        cell.textField.tag = 1234;
        cell.textField.delegate = self;
        [cell.btnAdd addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        JGLPlayerNumberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNumberTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.labelName.hidden = YES;
            cell.imgvIcon.hidden = YES;
            cell.labelTitle.text = @"已添加打球人";
        }
        else{
            if (indexPath.row == 1) {
                cell.labelTitle.hidden = YES;
                cell.imgvIcon.hidden = YES;
                cell.labelName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
            }
            else{
                cell.labelTitle.hidden = YES;
                
                if (_dictPeople.count != 0) {
                    NSLog(@"%td",indexPath.row);
                    if ([_dictPeople allValues].count < 4) {
                        if (indexPath.row-2 < [_dictPeople allValues].count) {
                            if (_isClick == YES) {
                                if (indexPath.row-2 < [_dictPeople allValues].count) {
                                    cell.labelName.text = [_dictPeople allValues][indexPath.row - 2];
                                }
                                else{
                                    cell.labelName.text = @"暂无成员，请添加";
                                }
                            }
                            else{
                                cell.labelName.text = [_dictPeople allValues][indexPath.row - 2];
                            }
                        }
                        else{
                            cell.labelName.text = @"暂无成员，请添加";
                        }
                    }
                    else{
                        [[ShowHUD showHUD]showToastWithText:@"您最多只能添加四个人一起打球" FromView:self.view];
                    }
                }
                else{
                    cell.labelName.text = @"暂无成员，请添加";
                }
            }
            
            
        }
        cell.backgroundColor = [UITool colorWithHexString:@"ffffff" alpha:1];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row > 0) {
            if (indexPath.row-2 < [_dictPeople allValues].count) {
                NSLog(@"%@",[_dictPeople allKeys][indexPath.row-2]);
                
                [_peoAddress removeObjectForKey:[_dictPeople allKeys][indexPath.row-2]];
                [_peoFriend removeObjectForKey:[_dictPeople allKeys][indexPath.row-2]];
                [_dictPeople removeObjectForKey:[_dictPeople allKeys][indexPath.row-2]];
                [_tableView reloadData];
                _isClick = YES;
            }
        }
    }
    
    
    
//            if (indexPath.row - 2 < _dictPeople.count) {
//                bool isChange1 = false;
//                for (int i = 0; i < _dictPeople.count; i ++) {
//                    if (isChange1 == YES) {
//                        continue;
//                    }
////                    if ([[_dictPeople objectForKey:_dataKey[i]] isEqualToString:_dataPeoArr[indexPath.row-1]] == YES) {
////                        NSLog(@"%@",[_dictPeople allValues][i]);
////                        [_dictPeople removeObjectForKey:_dataKey[i]];
////                        [_dataKey removeObjectAtIndex:indexPath.row-1];
////                        [_userKey removeObjectAtIndex:indexPath.row-1];
////                        [_mobileArr removeObjectAtIndex:indexPath.row - 1];
////                        [_dataPeoArr removeObjectAtIndex:indexPath.row-1];
////                        isChange1 = YES;
////                        continue;
////                    }
//                    if (indexPath.row-2 < [_dictFin allValues].count) {
//                        NSLog(@"%@    %@",[_dictFin allKeys][indexPath.row-2],[_dictPeople allKeys][indexPath.row-2]);
//                        [_dictPeople removeObjectForKey:[_dictPeople allKeys][indexPath.row-2]];
//                        [_tableView reloadData];
//                        _isClick = YES;
//                        isChange1 = YES;
//                        continue;
//                    }
//                    
//                }
//                [_tableView reloadData];
//                isChange1 = NO;
//                
//            }
//            
//        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0 ? 80 * screenWidth / 375 : 40 * screenWidth / 375;
}


-(void)addClick
{
    UITextField* textF = (UITextField *)[self.view viewWithTag:1234];
    if (![Helper isBlankString:textF.text]) {
        if (_dictPeople.count < 3) {
            [_dictPeople setObject:textF.text forKey:textF.text];
            textF.text = @"";
            [_tableView reloadData];
            _isClick = NO;
        }
        else{
            [[ShowHUD showHUD]showToastWithText:@"您最多只能添加三个人" FromView:self.view];
        }
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"您添加的成员姓名不能为空" FromView:self.view];
    }
    
    
}


#pragma mark --uitextfield代理

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [_dictPeople setObject:textField.text forKey:textField.text];
//    [_tableView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
