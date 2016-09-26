//
//  JGLGuestAddPlayerViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGuestAddPlayerViewController.h"
#import "JGLGuestAddressViewController.h"
#import "JGLGuestAddPlayerTableViewCell.h"
#import "JGLFinishBtnTableViewCell.h"
#import "JGLActiveChooseSTableViewCell.h"
#import "UITool.h"
#import "TKAddressModel.h"
#import "JGLTeamMemberModel.h"
#import "JGLAddTeaPlayerViewController.h"
@interface JGLGuestAddPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView* _viewHeader;
    UITableView* _tableView;
    
    NSString* _strName;
    NSString* _strAlmost;
    NSString* _strMobile;
    NSNumber* _sexNum;
    
    NSNumber* _userKey;//添加的成员的userkey
    
    NSMutableArray* _arrayTeamMember,* _arrayMemKey;//球队成员和球队成员key
    NSMutableDictionary* _dictTeamMem;//返回下一个界面的数据
    NSMutableArray* _arrayAddress;//通讯录成员
//    NSMutableArray* _dict;
    NSMutableArray* _arrayDataAll;
}
@end

@implementation JGLGuestAddPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sexNum = @2;//其他
    _userKey = @0;//默认为嘉宾，传0
    self.title = @"添加打球人";
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClick:)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
    
    _arrayTeamMember = [[NSMutableArray alloc]init];
    _arrayAddress    = [[NSMutableArray alloc]init];
    _arrayMemKey     = [[NSMutableArray alloc]init];
    _arrayDataAll    = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [self uiConfig];
    [self createHeader];
    
}

-(void)finishClick:(UIBarButtonItem *)btn
{
    [self.view endEditing:YES];
    if (_arrayAddress.count + _arrayTeamMember.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请选择意向成员" FromView:self.view];
        return;
    }
    
    /**
     NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
     [dict setObject:[[dictData objectForKey:_arrayMemKey[i]] userName] forKey:@"name"];
     [dict setObject:[[dictData objectForKey:_arrayMemKey[i]] mobile] forKey:@"mobile"];
     [dict setObject:[[dictData objectForKey:_arrayMemKey[i]] almost] forKey:@"almost"];
     [dict setObject:[[dictData objectForKey:_arrayMemKey[i]] sex] forKey:@"sex"];
     */
    for (int i = 0; i < _arrayMemKey.count; i ++) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[_arrayTeamMember[i] userName] forKey:@"name"];
        [dict setObject:[_arrayTeamMember[i] mobile] forKey:@"mobile"];
        [dict setObject:[_arrayTeamMember[i] almost] forKey:@"almost"];
        [dict setObject:[_arrayTeamMember[i] sex] forKey:@"sex"];
        [_arrayDataAll addObject:dict];
    }
    [_arrayDataAll addObjectsFromArray:_arrayAddress];
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_activityKey forKey:@"activityKey"];
    [dict setObject:_arrayDataAll forKey:@"teamActivitySignUpList"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/batchAddLineTeamActivitySignUp" JsonKey:@"teamActivitySignUp" withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _blockRefresh();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
    
}

-(void)createHeader
{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 10*screenWidth/375, screenWidth, 100*screenWidth/375)];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _viewHeader;

    NSArray* arrTit = @[@"添加队员",@"添加联系人"];
    NSArray* arrImg = @[@"palylianxil",@"palylianxir"];
    for (int i = 0; i < 2; i ++) {
        
        UIButton* btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(screenWidth/2*i, 0, screenWidth/2, 100*screenWidth/375);
        btnAdd.tag = 100 + i;
        [_viewHeader addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(chooseStyleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i > 0) {
            UIView* vieeLine = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2*i - 1, 15*screenWidth/375, 2, 70*screenWidth/375)];
            vieeLine.backgroundColor = [UIColor lightGrayColor];
            [_viewHeader addSubview:vieeLine];
        }
        
        UIImageView* imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2*i +screenWidth/16*3 , 20*screenWidth/375, screenWidth/9, screenWidth/9)];
        imgvIcon.image = [UIImage imageNamed:arrImg[i]];
        [_viewHeader addSubview:imgvIcon];
        
        UILabel* labelN = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2*i, 65*screenWidth/375, screenWidth/2, 30*screenWidth/375)];
        labelN.text = arrTit[i];
        labelN.font = [UIFont systemFontOfSize:15*screenWidth/375];
        labelN.textAlignment = NSTextAlignmentCenter;
        [_viewHeader addSubview:labelN];
    }
    
}

-(void)chooseStyleClick:(UIButton *)btn
{
    if (btn.tag == 100) {
        JGLAddTeaPlayerViewController* teamVc = [[JGLAddTeaPlayerViewController alloc]init];
        teamVc.teamKey = _teamKey;
        teamVc.dictFinish = _dictTeamMem;
        teamVc.blockTMemberPeople = ^(NSMutableDictionary *dictData){
            _dictTeamMem = dictData;//数据重新赋值
            if (_arrayMemKey.count != 0) {//如果有值，则删除
                [_arrayMemKey removeAllObjects];
                [_arrayTeamMember removeAllObjects];
            }
            [_arrayMemKey addObjectsFromArray:[dictData allKeys]];//获取所有key
            for (int i = 0; i < _arrayMemKey.count; i ++) {
                //  model
                [_arrayTeamMember addObject:[dictData objectForKey:_arrayMemKey[i]]];
            }
            [_tableView reloadData];//遍历找到value
        };
        [self.navigationController pushViewController:teamVc animated:YES];
    }
    else{
        JGLGuestAddressViewController* gesVc = [[JGLGuestAddressViewController alloc]init];
        gesVc.blockAddressPeople = ^(NSMutableDictionary * dict){
            TKAddressModel* model = [dict objectForKey:@1];
//            if (_arrayAddress.count != 0) {
//                [_arrayAddress removeAllObjects];
//            }
//            [_arrayAddress addObjectsFromArray:[dict allValues]];//将通讯录数据添加到数组
            _strName = model.userName;
            //去除数字以外的所有字符
            NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                           invertedSet ];
            _strMobile = [[model.mobile componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
            [_tableView reloadData];
        };
        gesVc.isGest = YES;
        [self.navigationController pushViewController:gesVc animated:YES];
    }
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorEffect = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLGuestAddPlayerTableViewCell class] forCellReuseIdentifier:@"JGLGuestAddPlayerTableViewCell"];
    [_tableView registerClass:[JGLFinishBtnTableViewCell class] forCellReuseIdentifier:@"JGLFinishBtnTableViewCell"];
    [_tableView registerClass:[JGLActiveChooseSTableViewCell class] forCellReuseIdentifier:@"JGLActiveChooseSTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else{
        return 1 + _arrayTeamMember.count + _arrayAddress.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JGLGuestAddPlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLGuestAddPlayerTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textName.delegate = self;
            cell.textName.tag = 2001;
            cell.textAlmost.delegate = self;
            cell.textAlmost.tag = 2002;
            cell.textMobile.delegate = self;
            cell.textMobile.tag = 2003;
            if (![Helper isBlankString:_strName]) {
                cell.textName.text = _strName;
            }
            else{
                cell.textName.placeholder = @"请输入姓名";
                cell.textName.text = @"";
            }
            if (![Helper isBlankString:_strAlmost]) {
                cell.textAlmost.text = _strAlmost;
            }
            else{
                cell.textAlmost.placeholder = @"必填";
                cell.textAlmost.text = @"";
            }
            
            if (![Helper isBlankString:_strMobile]) {
                cell.textMobile.text = _strMobile;
            }
            else{
                cell.textMobile.placeholder = @"必填";
                cell.textMobile.text = @"";
            }
            //0女  1男
            if ([_sexNum integerValue] == 0) {
                cell.imgvMan.image = [UIImage imageNamed:@"gou_w"];
                cell.imgvWomen.image = [UIImage imageNamed:@"gou_x"];
            }
            else if ([_sexNum integerValue] == 1){
                cell.imgvMan.image = [UIImage imageNamed:@"gou_x"];
                cell.imgvWomen.image = [UIImage imageNamed:@"gou_w"];
            }
            else{
                cell.imgvMan.image = [UIImage imageNamed:@"gou_w"];
                cell.imgvWomen.image = [UIImage imageNamed:@"gou_w"];
            }
            
            [cell.btnMan addTarget:self action:@selector(manClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnWomen addTarget:self action:@selector(womenClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else{
            JGLFinishBtnTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLFinishBtnTableViewCell" forIndexPath:indexPath];
            [cell.btnFInish addTarget:self action:@selector(addPlayerClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    else{
        JGLActiveChooseSTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLActiveChooseSTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
            cell.imgvDel.hidden = YES;
            if (_arrayAddress.count + _arrayTeamMember.count == 0) {
                cell.labelTitle.text = @"";
            }
            else{
                cell.labelTitle.text = @"已添加打球人";
            }
        }
        else{
            cell.labelTitle.font = [UIFont systemFontOfSize:14*screenWidth/375];
            cell.imgvDel.hidden = NO;
            if (indexPath.row <= _arrayAddress.count) {
                cell.labelTitle.text = [_arrayAddress[indexPath.row - 1] objectForKey:@"name"];
            }
            else{
                cell.labelTitle.text = [_arrayTeamMember[indexPath.row - _arrayAddress.count - 1] userName];
            }
        }
        return cell;
    }
    
}
#pragma mark --cell上按钮点击事件
-(void)addPlayerClick{
    [self.view endEditing:YES];
    if ([Helper isBlankString:_strName]) {
        [[ShowHUD showHUD]showToastWithText:@"请填写姓名或者选择意向成员" FromView:self.view];
        return;
    }
    if ([Helper isBlankString:_strMobile]) {
        [[ShowHUD showHUD]showToastWithText:@"请填写手机或者选择意向成员" FromView:self.view];
        return;
    }
    if ([Helper isBlankString:_strAlmost]) {
        [[ShowHUD showHUD]showToastWithText:@"请填写意向成员差点" FromView:self.view];
        return;
    }
    if ([_sexNum integerValue] == 2) {
        [[ShowHUD showHUD]showToastWithText:@"请选择意向成员性别" FromView:self.view];
        return;
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_strName forKey:@"name"];
    [dict setObject:_strMobile forKey:@"mobile"];
    [dict setObject:_strAlmost forKey:@"almost"];
    [dict setObject:_sexNum forKey:@"sex"];
    [_arrayAddress addObject:dict];
    _strName = nil;
    _strMobile = nil;
    _strAlmost = nil;
    _sexNum = @2;
    [_tableView reloadData];
}

-(void)manClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    JGLGuestAddPlayerTableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.imgvMan.image = [UIImage imageNamed:@"gou_x"];
    cell.imgvWomen.image = [UIImage imageNamed:@"gou_w"];
    _sexNum = @1;
    [_tableView reloadData];
}
-(void)womenClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    JGLGuestAddPlayerTableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.imgvMan.image = [UIImage imageNamed:@"gou_w"];
    cell.imgvWomen.image = [UIImage imageNamed:@"gou_x"];
    _sexNum = @0;
    [_tableView reloadData];
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10* screenWidth / 375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 100*ProportionAdapter : 50*ProportionAdapter;
    }
    else{
        return 40* screenWidth / 375;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row >= 1) {
            if (indexPath.row <= _arrayAddress.count) {
                [_arrayAddress removeObjectAtIndex:indexPath.row-1];
                [_tableView reloadData];
            }
            else{
                [_dictTeamMem removeObjectForKey:[NSString stringWithFormat:@"%@",_arrayMemKey[indexPath.row -_arrayAddress.count-1]]];
                [_arrayMemKey removeObjectAtIndex:indexPath.row -_arrayAddress.count-1];
                [_arrayTeamMember removeObjectAtIndex:indexPath.row-_arrayAddress.count-1];
                [_tableView reloadData];
            }
        }
    }
}


#pragma textfield Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 2001) {
        _strName = textField.text;
    }
    else if (textField.tag == 2002)
    {
        if ([Helper isPureNumandCharacters:textField.text] == YES) {
            _strAlmost = textField.text;
        }
        else{
            textField.text = @"";
            [[ShowHUD showHUD] showToastWithText:@"差点只能填写数字" FromView:self.view];
        }
        
    }
    else if (textField.tag == 2003)
    {
        _strMobile = textField.text;
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
