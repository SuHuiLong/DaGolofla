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
#import "MyattenModel.h"
#import "TKAddressModel.h"

@interface JGLAddPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, JGLPlayerNumberTableViewCellDelegate>
{
    UITableView* _tableView;
    UIView* _viewHeader;
    
    NSArray *_numberPlayArray;
    
    NSMutableArray *_palyArray;
    
    NSMutableArray *_addressArray;
    
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
    
    _palyArray = [NSMutableArray array];
    _addressArray = [NSMutableArray array];
    
    for (int i=0; i<self.preListArray.count; i++) {
        NSDictionary *dict = self.preListArray[i];
        if ([[dict objectForKey:@"sourceKey"] integerValue] == 1) {
            TKAddressModel *myModel = [[TKAddressModel alloc]init];
            myModel.recordID = [[dict objectForKey:@"recordID"] integerValue];
            myModel.userName = [dict objectForKey:UserName];
            myModel.mobile = [dict objectForKey:Mobile];
//            myModel.
            [_addressArray addObject:myModel];
        }
        
        if ([[dict objectForKey:@"sourceKey"] integerValue] == 3) {
            MyattenModel *myModel = [[MyattenModel alloc]init];
            myModel.otherUserId = [NSNumber numberWithInteger:[[dict objectForKey:@"userKey"] integerValue]];
            
            
            [_palyArray addObject:myModel];
        }
    }
    
    _numberPlayArray = @[@"", @"二", @"三", @"四"];
    
    [self uiConfig];
    [self createHeader];
}

-(void)finishAction
{
    _blockSurePlayer([self.preListArray mutableCopy]);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createHeader
{
    //添加打球人页面，
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100*screenWidth/375)];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _viewHeader;

    NSArray* arrTit = @[@"通讯录添加",@"扫描添加",@"球友列表添加"];
    NSArray* arrImg = @[@"addressBook",@"blueErerima",@"tjdqr_qiuyou"];
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
    if (self.preListArray.count >= 4) {
        [[ShowHUD showHUD]showToastWithText:@"您最多只能选择3个人！" FromView:self.view];
        return;
    }
    
    //通讯录成员添加按钮
    if (btn.tag == 100) {
        JGLAddressAddViewController* addVc = [[JGLAddressAddViewController alloc]init];
        //选择好的通讯录成员
        addVc.blockAddressArray= ^(NSMutableArray* addressArray){
            _addressArray = [addressArray mutableCopy];
            
            //先清除原先添加的球友
            for (int i=0; i<self.preListArray.count; i++) {
                NSMutableDictionary *addressdict = self.preListArray[i];
                if ([[addressdict objectForKey:@"sourceKey"] integerValue] == 1) {
                    [self.preListArray removeObjectAtIndex:i];
                    i -= 1;
                }
            }
            
            //添加球友
            for (int i=0; i<_addressArray.count; i++) {
                TKAddressModel *addressModel = [[TKAddressModel alloc]init];
                addressModel = _addressArray[i];
                NSMutableDictionary *addressdict = [NSMutableDictionary dictionary];
                if (addressModel.userName == nil) {
                    [addressdict setObject:@"通讯录成员" forKey:UserName];
                }else{
                    [addressdict setObject:addressModel.userName forKey:UserName];
                }
                
                if (addressModel.mobile == nil) {
                    
                }else{
                    [addressdict setObject:[NSString stringWithFormat:@"%@", addressModel.mobile] forKey:Mobile];
                }
                
                [addressdict setObject:@(addressModel.recordID) forKey:@"recordID"];
                [addressdict setObject:@0 forKey:UserKey];
                [addressdict setObject:@1 forKey:@"sourceKey"];//球员列表
                [self.preListArray addObject:addressdict];
            }
            
            [_tableView reloadData];
        };
        
        addVc.addressArray = _addressArray;
        addVc.lastIndex = 4 -self.preListArray.count +_addressArray.count;
        [self.navigationController pushViewController:addVc animated:YES];
    }
    else if (btn.tag == 101)
    {
        JGLBarCodeViewController* barVc = [[JGLBarCodeViewController alloc]init];
        barVc.blockDict = ^(NSMutableDictionary *dict){
            
            NSMutableDictionary *addressdict = [NSMutableDictionary dictionary];
            addressdict = [dict mutableCopy];
            
            [addressdict setObject:@2 forKey:@"sourceKey"];//扫描
            
            [self.preListArray addObject:addressdict];
            
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:barVc animated:YES];
    }
    else{
        JGLFriendAddViewController* fVc = [[JGLFriendAddViewController alloc]init];
        //选择好的好友成员
        fVc.playArrayBlock = ^(NSMutableArray* playArray){
            _palyArray = playArray;
            
            //先清除原先添加的球友
            for (int i=0; i<self.preListArray.count; i++) {
                NSMutableDictionary *addressdict = self.preListArray[i];
                if ([[addressdict objectForKey:@"sourceKey"] integerValue] == 3) {
                    [self.preListArray removeObjectAtIndex:i];
                    i -= 1;
                }
            }
            
            //添加球友
            for (int i=0; i<_palyArray.count; i++) {
                MyattenModel *myModel = [[MyattenModel alloc]init];
                myModel = _palyArray[i];
                NSMutableDictionary *addressdict = [NSMutableDictionary dictionary];
                [addressdict setObject:myModel.userName forKey:UserName];
                [addressdict setObject:myModel.otherUserId forKey:UserKey];
                [addressdict setObject:myModel.sex forKey:@"sex"];
                [addressdict setObject:@3 forKey:@"sourceKey"];//球员列表
                [self.preListArray addObject:addressdict];
            }
            
            [_tableView reloadData];
        };
        
        fVc.playArray = _palyArray;
        fVc.lastIndex = 4 -self.preListArray.count +_palyArray.count;
        
        _isClick = NO;
        [self.navigationController pushViewController:fVc animated:YES];
    }
}

-(void)uiConfig
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * screenWidth / 375)];
    view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, screenWidth - 20*screenWidth/375, 100*screenWidth/375)];
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
        cell.delegate = self;
        cell.deleteBtn.tag = 100 + indexPath.row-1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.labelName.hidden = YES;
            cell.deleteBtn.hidden = YES;
            cell.labelTitle.text = @"已添加打球人";
        }else{
            
            if (indexPath.row -1 < self.preListArray.count) {
                cell.labelTitle.hidden = YES;
                
                if (indexPath.row == 1) {
                    cell.deleteBtn.hidden = YES;
                }else{
                    cell.deleteBtn.hidden = NO;
                }
                
                NSLog(@"%td", indexPath.row);
                NSDictionary *indexDict = self.preListArray[indexPath.row -1];
                
                cell.labelName.textColor = [UIColor blackColor];
                cell.labelName.text = [indexDict objectForKey:UserName];
                
            }else{
                cell.labelTitle.hidden = NO;
                cell.deleteBtn.hidden = YES;
                
                cell.labelName.textColor = [UIColor lightGrayColor];
                cell.labelName.text = [NSString stringWithFormat:@"打球人%@", _numberPlayArray[indexPath.row -1]];
            }
        }
        cell.backgroundColor = [UITool colorWithHexString:@"ffffff" alpha:1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0 ? 100 * screenWidth / 375 : 40 * screenWidth / 375;
}


-(void)addClick
{
    UITextField* textF = (UITextField *)[self.view viewWithTag:1234];
    if (![Helper isBlankString:textF.text]) {
        if (self.preListArray.count < 4) {
//            [_dictPeople setObject:textF.text forKey:textF.text];
            
            NSMutableDictionary *addressdict = [NSMutableDictionary dictionary];
            //            [addressdict setObject:[dict allKeys][0] forKey:Mobile];
            [addressdict setObject:textF.text forKey:UserName];
            [addressdict setObject:@0 forKey:UserKey];
            [addressdict setObject:@4 forKey:@"sourceKey"];//手动添加
            
            [self.preListArray addObject:addressdict];
            
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
#pragma mark -- 删除打球人
- (void)didSelectDeleteBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    btn.userInteractionEnabled = NO;
    
    [self.preListArray removeObjectAtIndex:btn.tag -100];
    [_tableView reloadData];
    
    btn.userInteractionEnabled = YES;
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
