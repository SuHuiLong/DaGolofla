//
//  JGLGuestAddPlayerViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGuestAddPlayerViewController.h"
#import "JGLGuestAddressViewController.h"
#import "JGTeamMemberController.h"
#import "JGLGuestAddPlayerTableViewCell.h"
#import "UITool.h"
#import "TKAddressModel.h"
#import "JGLTeamMemberModel.h"
@interface JGLGuestAddPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView* _viewHeader;
    UITableView* _tableView;
    
    NSString* _strName;
    NSString* _strAlmost;
    NSString* _strMobile;
    NSNumber* _sexNum;
    
    NSNumber* _userKey;//添加的成员的userkey
    
}
@end

@implementation JGLGuestAddPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sexNum = @2;//其他
    _userKey = @0;//默认为嘉宾，传0
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClick:)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
    
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [self uiConfig];
    [self createHeader];
    
}

-(void)finishClick:(UIBarButtonItem *)btn
{
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
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_activityKey forKey:@"activityKey"];
    [dict setObject:_userKey forKey:@"userKey"];
    [dict setObject:_strName forKey:@"name"];
    [dict setObject:_strMobile forKey:@"mobile"];
    [dict setObject:_strAlmost forKey:@"almost"];
    [dict setObject:_sexNum forKey:@"sex"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/addLineTeamActivitySignUp" JsonKey:@"teamActivitySignUp" withData:dict failedBlock:^(id errType) {
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
    NSArray* arrImg = @[@"addressBook",@"saomiao"];
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
        JGTeamMemberController* teamVc = [[JGTeamMemberController alloc]init];
        teamVc.isGest = YES;
        teamVc.teamKey = @30053;
        teamVc.blockTMemberPeople = ^(JGLTeamMemberModel *model){
            _strName = model.userName;
            _strMobile = model.mobile;
            _strAlmost = [NSString stringWithFormat:@"%@",model.almost];
            _sexNum = model.sex;
            _userKey = model.userKey;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:teamVc animated:YES];
    }
    else{
        JGLGuestAddressViewController* gesVc = [[JGLGuestAddressViewController alloc]init];
        gesVc.blockAddressPeople = ^(TKAddressModel * model){
            _strName   = model.userName;
            _strMobile = model.mobile;
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
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGLGuestAddPlayerTableViewCell class] forCellReuseIdentifier:@"JGLGuestAddPlayerTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    return 100* screenWidth / 375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma textfield Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 2001) {
        _strName = textField.text;
    }
    else if (textField.tag == 2002)
    {
        _strAlmost = textField.text;
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
