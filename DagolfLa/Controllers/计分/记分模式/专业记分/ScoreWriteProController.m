//
//  ScoreWriteProController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/14.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreWriteProController.h"
#import "ScoreProfessViewController.h"

#import "ScoreProWriteCell.h"

#import "Helper.h"
#import "PostDataRequest.h"

@interface ScoreWriteProController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isClick;
    UIButton* _btnChoose;
    
    UITableView* _tableView;
    
    BOOL _isStreet[4];
    UILabel* _labelTitle;
    
    NSMutableDictionary* _dict;
    //杆数
    NSMutableArray* _poleNumArray;
    //推杆
    NSMutableArray* _pushNumArray;
    
    //存放数据
    NSMutableDictionary* _dataDict;
    NSMutableDictionary* _poleDict,*_pushDict,*_streetDict;
    NSMutableDictionary* _peoPleDict;

    
    UIButton* _btnText;
    NSInteger _indexRow;
}
@end

@implementation ScoreWriteProController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _poleDict=[[NSMutableDictionary alloc] init];
    _pushDict=[[NSMutableDictionary alloc] init];
    _streetDict=[[NSMutableDictionary alloc] init];
    

    _isStreet[0] = YES;
    _isStreet[1] = YES;
    _isStreet[2] = YES;
    _isStreet[3] = YES;
    Num = _clickNum;
    
    for (int i=0; i<_arrayName.count; i++) {
        if (i == 0) {
            [_poleDict setObject:[_array1[_clickNum-1] professionalPolenumber] forKey:[NSString stringWithFormat:@"%d",i+1]];
            [_pushDict setObject:[_array1[_clickNum-1] professionalPushrod] forKey:[NSString stringWithFormat:@"%d",i+1]];
//            [_poleDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        else if (i == 1)
        {
            [_poleDict setObject:[_array2[_clickNum-1] professionalPolenumber] forKey:[NSString stringWithFormat:@"%d",i+1]];
            [_pushDict setObject:[_array2[_clickNum-1] professionalPushrod] forKey:[NSString stringWithFormat:@"%d",i+1]];
//            [_poleDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        else if (i == 2)
        {
            [_poleDict setObject:[_array3[_clickNum-1] professionalPolenumber] forKey:[NSString stringWithFormat:@"%d",i+1]];
            [_pushDict setObject:[_array3[_clickNum-1] professionalPushrod] forKey:[NSString stringWithFormat:@"%d",i+1]];
//            [_poleDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        else{
            [_poleDict setObject:[_array4[_clickNum-1] professionalPolenumber] forKey:[NSString stringWithFormat:@"%d",i+1]];
            [_pushDict setObject:[_array4[_clickNum-1] professionalPushrod] forKey:[NSString stringWithFormat:@"%d",i+1]];
//            [_poleDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        
    }
    
    
    self.title = @"专业记分";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];


    
    UIBarButtonItem* btnRight = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightFinishClick)];
    self.navigationItem.rightBarButtonItem = btnRight;
    btnRight.tintColor = [UIColor whiteColor];
    
    
    _dict = [[NSMutableDictionary alloc]init];
    
    _poleNumArray = [[NSMutableArray alloc]init];
    _pushNumArray = [[NSMutableArray alloc]init];
    //内容
    [self createTableView];
    //头视图创建
    [self detailTitle];
  
    //按钮
    [self createBtn];
    
    //重写导航栏的返回按钮，用来把标记的第几洞修改
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;

}

-(void)backButtonClcik
{
    Num = Num - 1;
    _clickNum = Num - 1;
    //NSLog(@"%ld",_clickNum);
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  导航栏点击事件
 */
-(void)rightFinishClick
{
    UITextField* texf = (UITextField *)[self.view viewWithTag:300+_indexRow];
    UITextField* texf1 = (UITextField *)[self.view viewWithTag:3000+_indexRow];
    [self.view endEditing:YES];
    if (texf.tag /300==1) {
        [_poleDict setObject:texf.text forKey:[NSString stringWithFormat:@"%ld",texf.tag%300+1]];
    }
    if (texf1.tag /300==10) {
        [_pushDict setObject:texf1.text forKey:[NSString stringWithFormat:@"%ld",texf1.tag%3000+1]];
    }
    
    
    
    UIViewController *target=nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ScoreProfessViewController class]]) {
            target=vc;
            
    
        }
    }
    if (target) {
        
        
        [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        [_dict setObject:_strType forKey:@"scoreType"];
        
        if (_clickNum <= 9) {
            [_dict setObject:@1 forKey:@"professionalNine"];
        }
        else
        {
            [_dict setObject:@2 forKey:@"professionalNine"];
        }
        //NSLog(@"%ld",_clickNum-1);
        [_dict setObject:[NSNumber numberWithInteger:_clickNum-1] forKey:@"professionalnextNums"];
        
        
        
        
        
        NSString *str1=@"";
        for (int i=0; i<_arrayName.count; i++) {
            NSString *str=[NSString stringWithFormat:@"%@",[_poleDict objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
            if ([Helper isBlankString:str1]==NO) {
                str1=[NSString stringWithFormat:@"%@,%@",str1,str];
            }else{
                str1=str;
            }
        }
        
        NSString *str2=@"";
        for (int i=0; i<_arrayName.count; i++) {
            NSString *str=[NSString stringWithFormat:@"%@",[_pushDict objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
            if ([Helper isBlankString:str2]==NO) {
                str2=[NSString stringWithFormat:@"%@,%@",str2,str];
            }else{
                str2=str;
            }
        }
        //把总杆数和推杆数的属猪全部方到数组里面作比较
        NSMutableArray* arrPole = [[NSMutableArray alloc]init];
        for (int i = 0; i < _poleDict.count; i++) {
            [arrPole addObject:[_poleDict allValues]];
        }
        NSMutableArray* arrPush = [[NSMutableArray alloc]init];
        for (int i = 0; i < _pushDict.count; i++) {
            [arrPush addObject:[_pushDict allValues]];
        }
        
        
        if (arrPole.count <= arrPush.count) {
            for (int i = 0; i < arrPole.count; i++) {
                
                if ([arrPole[0][i] integerValue]< [arrPush[0][i] integerValue]) {
                    [Helper alertViewWithTitle:@"您记录的推杆数不能大于总杆数，请重新输入" withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                    return ;
                }
            }
        }
        if (arrPole.count > arrPush.count) {
            for (int i = 0; i < arrPush.count; i++) {
                if (arrPole[i] < arrPush[i]) {
                    [Helper alertViewWithTitle:@"您记录的推杆数不能大于总杆数，请重新输入" withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                        
                    }];
                    return ;
                }
            }
        }
        
        
        //杆数
        [_dict setObject:str1 forKey:@"professionalPolenumber"];
        //推杆数
        [_dict setObject:str2 forKey:@"professionalPushrod"];
        
       


        //
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < _arrayName.count; i ++) {
            int i = 0;
            i = (int)_isStreet[i];
            [arr addObject:[NSNumber numberWithInt:(i+1)]];
            
            //        [arr addObject:[NSNumber numberWithBool:_isStreet[i]+1]];
        }
        ////NSLog(@"%@",arr);
        NSString *strStreet = [arr componentsJoinedByString:@","];
        [_dict setObject:strStreet forKey:@"professionalOnthefairway"];
        
        NSString *strName = [_arrayName componentsJoinedByString:@","];
        [_dict setObject:strName forKey:@"userName"];
        
        NSString *strMobile = [_arrayMobile componentsJoinedByString:@","];
        [_dict setObject:strMobile forKey:@"userMobile"];
        
        [_dict setObject:@-1 forKey:@"professionalPoor"];
        
        NSMutableArray* arraySId = [[NSMutableArray alloc]init];
        NSMutableArray* arraySDId = [[NSMutableArray alloc]init];
        if (_array1.count != 0) {
            [arraySId addObject:[_array1[_clickNum-1] professionalScoreId]];
            [arraySDId addObject:[_array1[_clickNum-1] professional_scoreId]];
        }
        if (_array2.count != 0) {
            [arraySId addObject:[_array2[_clickNum-1] professionalScoreId]];
            [arraySDId addObject:[_array2[_clickNum-1] professional_scoreId]];
        }
        if (_array3.count != 0) {
            [arraySId addObject:[_array3[_clickNum-1] professionalScoreId]];
            [arraySDId addObject:[_array3[_clickNum-1] professional_scoreId]];
        }
        if (_array4.count != 0) {
            [arraySId addObject:[_array4[_clickNum-1] professionalScoreId]];
            [arraySDId addObject:[_array4[_clickNum-1] professional_scoreId]];
        }
        
        NSString *strSId = [arraySId componentsJoinedByString:@","];
        [_dict setObject:strSId forKey:@"professionalScoreId"];
        
        NSString *strSdId = [arraySDId componentsJoinedByString:@","];
        [_dict setObject:strSdId forKey:@"professional_scoreId"];
        
        //标准杆
        [_dict setObject:_arrayStand[_clickNum-1] forKey:@"professionalStandardlever"];
        
        _clickNum++;

        //记分完成
        [[PostDataRequest sharedInstance] postDataRequest:@"tpscore/update.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                [self.navigationController popToViewController:target animated:YES];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
            
        } failed:^(NSError *error) {
            
        }];
        

    }
}

//创建头视图
-(void)detailTitle
{
    UIView* viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 88*ScreenWidth/375)];
    _tableView.tableHeaderView = viewHeader;
    
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    _labelTitle.backgroundColor = [UIColor whiteColor];
    //
    
    _labelTitle.text = [NSString stringWithFormat:@"第%ld洞(标准杆%@)",(long)_clickNum,_arrayStand[_clickNum-1]];
    _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:_labelTitle];
    
    NSArray* arrayTitle = @[@"打球人",@"总杆",@"推杆",@"上球道"];

    for (int i = 0; i < 4; i++) {
        UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/4*i, 44*ScreenWidth/375, ScreenWidth/4, 44*ScreenWidth/375)];
        labelTitle.text = arrayTitle[i];
        labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        [viewHeader addSubview:labelTitle];
        labelTitle.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    }
    
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60*ScreenWidth/375* _arrayName.count + 88*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[ScoreProWriteCell class] forCellReuseIdentifier:@"ScoreProWriteCell"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayName.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _indexRow = indexPath.row;
    ScoreProWriteCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreProWriteCell" forIndexPath:indexPath];
    cell.labelName.text = _arrayName[indexPath.row];
    [cell.btnStreet addTarget:self action:@selector(streetClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.textPole.tag = 300+(indexPath.row);
    cell.textPole.delegate = self;
    cell.textPole.keyboardType = UIKeyboardTypeNumberPad;
    if (indexPath.row == 0) {
        cell.textPole.placeholder = [NSString stringWithFormat:@"%@",[_array1[_clickNum-1] professionalPolenumber]];
        cell.textPush.placeholder = [NSString stringWithFormat:@"%@",[_array1[_clickNum-1] professionalPushrod]];
    }
    else if (indexPath.row == 1)
    {
        cell.textPole.placeholder = [NSString stringWithFormat:@"%@",[_array2[_clickNum-1] professionalPolenumber]];
        cell.textPush.placeholder = [NSString stringWithFormat:@"%@",[_array2[_clickNum-1] professionalPushrod]];
    }
    else if (indexPath.row == 2)
    {
        cell.textPole.placeholder = [NSString stringWithFormat:@"%@",[_array3[_clickNum-1] professionalPolenumber]];
        cell.textPush.placeholder = [NSString stringWithFormat:@"%@",[_array3[_clickNum-1] professionalPushrod]];
    }
    else
    {
        cell.textPole.placeholder = [NSString stringWithFormat:@"%@",[_array4[_clickNum-1] professionalPolenumber]];
        cell.textPush.placeholder = [NSString stringWithFormat:@"%@",[_array4[_clickNum-1] professionalPushrod]];
    }
    
    
    cell.textPush.tag = 3000+(indexPath.row);
    cell.textPush.delegate = self;
     cell.textPush.keyboardType = UIKeyboardTypeNumberPad;
    
    cell.btnStreet.tag = indexPath.row;
    return cell;
}
#pragma mark --textfield代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag /300==1) {
        [_poleDict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag%300+1]];
    }
    
    if (textField.tag /300==10) {
        [_pushDict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag%3000+1]];
    }
    [textField resignFirstResponder];
    ////NSLog(@"%@     %@",_poleDict,_pushDict);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
//    _btnText.hidden = YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    _btnText.hidden = NO;
    return YES;
}

-(void)streetClick:(UIButton *)btn
{
    if (_isStreet[btn.tag] == NO) {
        [btn setImage:[UIImage imageNamed:@"wsqd"] forState:UIControlStateNormal];
        _isStreet[btn.tag] = YES;
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"sqd"] forState:UIControlStateNormal];
        _isStreet[btn.tag] = NO;
    }
}


-(void)createBtn
{
    UIButton* btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(10*ScreenWidth/375,  60*ScreenWidth/375* _arrayName.count + 98*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [btnNext setTitle:@"下一洞" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btnNext];
    btnNext.backgroundColor = [UIColor orangeColor];
    btnNext.layer.masksToBounds = YES;
    btnNext.layer.cornerRadius = 8*ScreenWidth/375;
    [btnNext addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
static NSInteger Num  = 0;
-(void)nextClick:(UIButton *)btn
{
    
    [self.view endEditing:YES];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.userInteractionEnabled = NO;
    //用户id
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    ////NSLog(@"%@",_strType);
    //记分类型
    [_dict setObject:_strType forKey:@"scoreType"];
    
    //第几九洞
    if (_clickNum <= 9) {
        [_dict setObject:@1 forKey:@"professionalNine"];
    }
    else
    {
        [_dict setObject:@2 forKey:@"professionalNine"];
    }
    //记录的第几洞
    [_dict setObject:[NSNumber numberWithInteger:_clickNum-1] forKey:@"professionalnextNums"];

    NSString *string1=@"";
    for (int i=0; i<_arrayName.count; i++) {
        NSString *strnew=[NSString stringWithFormat:@"%@",[_poleDict objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
        if ([Helper isBlankString:string1]==NO) {
            string1=[NSString stringWithFormat:@"%@,%@",string1,strnew];
        }else{
            string1=strnew;
        }
    }
    
    NSString *str2=@"";
    for (int i=0; i<_arrayName.count; i++) {
        NSString *str=[NSString stringWithFormat:@"%@",[_pushDict objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
        if ([Helper isBlankString:str2]==NO) {
            str2=[NSString stringWithFormat:@"%@,%@",str2,str];
        }else{
            str2=str;
        }
    }
    //杆数
    [_dict setObject:string1 forKey:@"professionalPolenumber"];
    //推杆数
    [_dict setObject:str2 forKey:@"professionalPushrod"];
    
    //把总杆数和推杆数的属猪全部方到数组里面作比较
    NSMutableArray* arrPole = [[NSMutableArray alloc]init];
    for (int i = 0; i < _poleDict.count; i++) {
        [arrPole addObject:[_poleDict allValues]];
    }
    NSMutableArray* arrPush = [[NSMutableArray alloc]init];
    for (int i = 0; i < _pushDict.count; i++) {
        [arrPush addObject:[_pushDict allValues]];
    }
    
    
    if (arrPole.count <= arrPush.count) {
        for (int i = 0; i < arrPole.count; i++) {
            
            if ([arrPole[0][i] integerValue]< [arrPush[0][i] integerValue]) {
                [Helper alertViewWithTitle:@"您记录的推杆数不能大于总杆数，请重新输入" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                    btn.backgroundColor = [UIColor orangeColor];
                    btn.userInteractionEnabled = YES;
                }];
                return ;
            }
        }
    }
    if (arrPole.count > arrPush.count) {
        for (int i = 0; i < arrPush.count; i++) {
            if (arrPole[i] < arrPush[i]) {
                [Helper alertViewWithTitle:@"您记录的推杆数不能大于总杆数，请重新输入" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                    btn.backgroundColor = [UIColor orangeColor];
                    btn.userInteractionEnabled = YES;
                }];
                return ;
            }
        }
    }
//
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _arrayName.count; i ++) {
        int i = 0;
        i = (int)_isStreet[i];
        [arr addObject:[NSNumber numberWithInt:(i+1)]];
        
//        [arr addObject:[NSNumber numberWithBool:_isStreet[i]+1]];
    }
    //是否上球道
    NSString *strStreet = [arr componentsJoinedByString:@","];
    [_dict setObject:strStreet forKey:@"professionalOnthefairway"];
    
    NSString *strName = [_arrayName componentsJoinedByString:@","];
    [_dict setObject:strName forKey:@"userName"];
    
    NSString *strMobile = [_arrayMobile componentsJoinedByString:@","];
    [_dict setObject:strMobile forKey:@"userMobile"];
    //杆数减去标准杆
    [_dict setObject:@-1 forKey:@"professionalPoor"];
    
    NSMutableArray* arraySId = [[NSMutableArray alloc]init];
    NSMutableArray* arraySDId = [[NSMutableArray alloc]init];
    if (_array1.count != 0) {
         [arraySId addObject:[_array1[_clickNum-1] professionalScoreId]];
        [arraySDId addObject:[_array1[_clickNum-1] professional_scoreId]];
    }
    if (_array2.count != 0) {
        [arraySId addObject:[_array2[_clickNum-1] professionalScoreId]];
         [arraySDId addObject:[_array2[_clickNum-1] professional_scoreId]];
    }
    if (_array3.count != 0) {
        [arraySId addObject:[_array3[_clickNum-1] professionalScoreId]];
        [arraySDId addObject:[_array3[_clickNum-1] professional_scoreId]];
    }
    if (_array4.count != 0) {
        [arraySId addObject:[_array4[_clickNum-1] professionalScoreId]];
        [arraySDId addObject:[_array4[_clickNum-1] professional_scoreId]];
    }
    //记分id
    NSString *strSId = [arraySId componentsJoinedByString:@","];
    [_dict setObject:strSId forKey:@"professionalScoreId"];
    
    //记分卡id
    NSString *strSdId = [arraySDId componentsJoinedByString:@","];
    [_dict setObject:strSdId forKey:@"professional_scoreId"];

    //标准杆
    [_dict setObject:_arrayStand[_clickNum-1] forKey:@"professionalStandardlever"];
    
    
    ////NSLog(@"1 ==   %@",_dict);
    _clickNum = Num;
    _clickNum++;
//    Num = _clickNum;
    UIViewController *target=nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ScoreProfessViewController class]]) {
            target=vc;
            
        }
    }
    if (target) {
        ////NSLog(@"10010");
        [[PostDataRequest sharedInstance] postDataRequest:@"tpscore/update.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            btn.backgroundColor = [UIColor orangeColor];
            btn.userInteractionEnabled = YES;
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                if (_clickNum <= 18) {
                    ScoreWriteProController* scVc = [[ScoreWriteProController alloc]init];
                    scVc.arrayId = _arrayId;
                    scVc.arrayName = _arrayName;
                    scVc.arrayMobile = _arrayMobile;
                    scVc.clickNum = _clickNum;
//                    //NSLog(@"下一洞%ld",(long)scVc.clickNum);
                    
                    scVc.array1 = [[NSMutableArray alloc]init];
                    scVc.array2 = [[NSMutableArray alloc]init];
                    scVc.array3 = [[NSMutableArray alloc]init];
                    scVc.array4 = [[NSMutableArray alloc]init];
                    scVc.arrayStand = [[NSMutableArray alloc]init];
                    
                    if (scVc.array1.count != 0) {
                        [scVc.array1 removeAllObjects];
                    }
                    if (scVc.array2.count != 0) {
                        [scVc.array2 removeAllObjects];
                    }
                    if (scVc.array3.count != 0) {
                        [scVc.array3 removeAllObjects];
                    }
                    if (scVc.array4.count != 0) {
                        [scVc.array4 removeAllObjects];
                    }
                    if (scVc.arrayStand.count != 0) {
                        [scVc.arrayStand removeAllObjects];
                    }
                    
                    for (int i = 0; i < _array1.count; i++) {
                        [scVc.array1 addObject:_array1[i]];
                    }
                    for (int i = 0; i < _array2.count; i++) {
                        [scVc.array2 addObject:_array2[i]];
                    }
                    for (int i = 0; i < _array3.count; i++) {
                        [scVc.array3 addObject:_array3[i]];
                    }
                    for (int i = 0; i < _array4.count; i++) {
                        [scVc.array4 addObject:_array4[i]];
                    }
                    //标准杆
                    for (int i = 0; i < _arrayStand.count; i++) {
                        
                        [scVc.arrayStand addObject:_arrayStand[i]];
//                        //NSLog(@"stand   ===   %@",scVc.array1[i]);
                    }
                    
                    scVc.strType = _strType;
                    [self.navigationController pushViewController:scVc animated:YES];
                    

                    
                }
                else
                {
                    
                    btn.backgroundColor = [UIColor lightGrayColor];
                    [btn setTitle:@"完成" forState:UIControlStateNormal];
                    [self.navigationController popToViewController:target animated:YES];
                    
                }
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
            
        } failed:^(NSError *error) {
            btn.backgroundColor = [UIColor orangeColor];
            btn.userInteractionEnabled = YES;
        }];

        
    }
    
    
}
@end
