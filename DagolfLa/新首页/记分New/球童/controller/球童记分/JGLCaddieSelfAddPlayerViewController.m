//
//  JGLAddPlayerViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCaddieSelfAddPlayerViewController.h"
#import "JGLAddPlayerTableViewCell.h"
#import "JGLPlayerNumberTableViewCell.h"
#import "JGLFriendAddViewController.h"
#import "JGLAddressAddViewController.h"
#import "UITool.h"
#import "JGLBarCodeViewController.h"
@interface JGLCaddieSelfAddPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, JGLPlayerNumberTableViewCellDelegate>
{
    UITableView* _tableView;
    UIView* _viewHeader;
    
//    NSMutableArray *_palyArray;
    
    BOOL _isClick;
}
@end

@implementation JGLCaddieSelfAddPlayerViewController

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
//    _dictPeople = [[NSMutableDictionary alloc]init];//添加的成员
    //    }
    //    if (_peoFriend.count == 0) {
//    _peoFriend  = [[NSMutableDictionary alloc]init];//球友数据
    //    }
    //    if (_peoAddress.count == 0) {
//    _peoAddress = [[NSMutableDictionary alloc]init];//通讯录数据
    //    }
    
    if (_palyArray.count == 0) {
        _palyArray = [NSMutableArray array];
    }
    
    [self uiConfig];
    [self createHeader];
}

-(void)finishAction
{
    _blockSurePlayer(_palyArray);//返回用户数据倒上一层页面
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createHeader
{
    //扫码界面
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100*screenWidth/375)];
    _viewHeader.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _viewHeader;
    //    _tableView.tableHeaderView.userInteractionEnabled = YES;
    //    _viewHeader.userInteractionEnabled = YES;
    //saomiao
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, screenWidth, 100*screenWidth/375);
    [btnBack addTarget:self action:@selector(chooseStyleClick:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHeader addSubview:btnBack];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 25*ProportionAdapter, 120*ProportionAdapter, 45*ProportionAdapter)];
    label.text = @"扫描添加打球人";
    label.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    [_viewHeader addSubview:label];
    
    UIView* viewBack = [[UIView alloc]initWithFrame:CGRectMake(130*ProportionAdapter, 10*ProportionAdapter, screenWidth-150*ProportionAdapter, 75*ProportionAdapter)];
    viewBack.backgroundColor = [UIColor whiteColor];
    viewBack.layer.cornerRadius = 6*ProportionAdapter;
    viewBack.layer.masksToBounds = YES;
    [_viewHeader addSubview:viewBack];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(50*ProportionAdapter, 15*ProportionAdapter, 45*ProportionAdapter, 45*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"saomiao"];
    [viewBack addSubview:imgv];
    
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(viewBack.frame.size.width - 80*ProportionAdapter, 5*ProportionAdapter, 1, 65*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [viewBack addSubview:viewLine];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(viewBack.frame.size.width - 75*ProportionAdapter, 15*ProportionAdapter, 75*ProportionAdapter, 45*ProportionAdapter);
    [btn setTitle:@"扫码" forState:UIControlStateNormal];
    [btn setTitleColor:[UITool colorWithHexString:@"32b14d" alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [btn addTarget:self action:@selector(chooseStyleClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewBack addSubview:btn];
    
    UIButton* btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    btnView.frame = CGRectMake(0, 0, screenWidth, 100*screenWidth/375);
    [btnView addTarget:self action:@selector(chooseStyleClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewBack addSubview:btnView];
    
}

-(void)chooseStyleClick:(UIButton *)btn
{
    JGLBarCodeViewController* barVc = [[JGLBarCodeViewController alloc]init];
    barVc.blockDict = ^(NSMutableDictionary *dict){
        //先甩选掉重复的打球人
        NSArray *array = [NSArray arrayWithArray:_palyArray];
        for (int i=0; i<array.count; i++) {
            NSMutableDictionary *palyDict = [NSMutableDictionary dictionary];
            palyDict = array[i];
            if ([[palyDict objectForKey:@"userKey"] integerValue] == [[dict objectForKey:@"userKey"] integerValue]) {
                [[ShowHUD showHUD]showToastWithText:@"请勿重复添加打球人！" FromView:self.view];
            }else{
                [_palyArray addObject:dict];
                break;
            }
        }
        
//        [_palyArray addObject:dict];
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:barVc animated:YES];
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
        cell.delegate = self;
        cell.deleteBtn.tag = indexPath.row;
        
        if (indexPath.row == 0) {
            cell.labelName.hidden = YES;
            cell.deleteBtn.hidden = YES;
            cell.labelTitle.text = @"已添加打球人";//titile，可以不用管
        }
        else{
            if (indexPath.row == 1) {
                
                cell.deleteBtn.hidden = YES;
            }else{
                cell.deleteBtn.hidden = NO;
            }
            
            cell.labelTitle.hidden = YES;
            
            NSLog(@"indexPath.row == %td", indexPath.row);
            
            if (indexPath.row -1 < _palyArray.count) {
                [cell configJGLPlayerNumberTableViewCell:_palyArray[indexPath.row -1]];
                cell.labelName.textColor = [UIColor colorWithHexString:@"#313131"];
            }else{
                cell.labelName.text = @"请添加打球人";
                cell.labelName.textColor = [UIColor lightGrayColor];
                cell.deleteBtn.hidden = YES;
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
    
    return indexPath.section == 0 ? 80 * screenWidth / 375 : 40 * screenWidth / 375;
}


-(void)addClick
{
    UITextField* textF = (UITextField *)[self.view viewWithTag:1234];
    if (![Helper isBlankString:textF.text]) {
        if (_palyArray.count <= 4) {
            NSMutableDictionary *palyDict = [NSMutableDictionary dictionary];
            [palyDict setObject:textF.text forKey:UserName];
            [palyDict setObject:@0 forKey:@"userKey"];
            [palyDict setObject:@2 forKey:@"sex"];
            [_palyArray addObject:palyDict];
            textF.text = @"";
            [_tableView reloadData];
//            _isClick = NO;
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
    NSLog(@"btn.tag = %td", btn.tag -1);
    [_palyArray removeObjectAtIndex:btn.tag -1];
    [_tableView reloadData];
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
