//
//  JGApplyMaterialViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLSelfSetViewController.h"
#import "JGApplyMaterialTableViewCell.h"
#import "JGButtonTableViewCell.h"


@interface JGLSelfSetViewController ()<UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *secondTableView;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *placeholderArray;
@property (nonatomic, strong)NSMutableDictionary *paraDic;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;

@end

@implementation JGLSelfSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"入队申请资料";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(complete)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //    [self creatTableView];
    [self creatNewTableView];
    // Do any additional setup after loading the view.
}

- (void)pickerVieCreate{
    self.pickerView = [[UIPickerView alloc]init];
    
}


#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return @[@"保密", @"男", @"女"][row];
    
}

//选择器
-(void)createDataClick:(NSString *)string
{
    
    self.pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/3, ScreenWidth, ScreenHeight/3)];
    //    self.pickerBackView.userInteractionEnabled = YES;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        self.pickerBackView.frame = CGRectMake(0, ScreenHeight/3*2 - 49, ScreenWidth, ScreenHeight/3);
    //        self.pickerBackView.userInteractionEnabled = NO;
    //    } completion:nil];
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBackView];
    
    UIButton *_button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button1.frame = CGRectMake(20, 5, 50, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button1 addTarget:self action:@selector(buttonShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button1];
    
    
    UIButton *_button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button2.frame = CGRectMake(ScreenWidth-50, 5, 50, 30);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button2 addTarget:self action:@selector(buttonMissClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button2];
    
    // 性别，年龄，差点的选择器
    // UIPickerView只有三个高度， heights for UIPickerView (162.0, 180.0 and 216.0)，用代码设置 pickerView.frame=cgrectmake()...
    [self setUpPickerView:1 frame:CGRectMake(screenWidth/ 2 - 50, 0, 100, 162)];
    
}

// 根据选择器的数量和尺寸建立选择器
- (void)setUpPickerView:(NSInteger)pickerViewNumber frame:(CGRect)frame
{
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.frame = frame;
    
    [self.pickerBackView addSubview:self.pickerView];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    //    [ self.pickerView. selectRow:1 inComponent:0 animated:YES];
}

- (void)buttonShowClick: (UIButton *)btn{
    [self.pickerBackView removeFromSuperview];
    [self.paraDic setObject:@0 forKey:@"sex"];
    NSIndexPath *indexpat = [NSIndexPath indexPathForRow:1 inSection:0];
    JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexpat];
    [cell.button setTitle:@"保密" forState:(UIControlStateNormal)];
}//button1

- (void)buttonMissClick: (UIButton *)btn{
    [self.pickerBackView removeFromSuperview];
    NSIndexPath *indexpat = [NSIndexPath indexPathForRow:1 inSection:0];
    JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexpat];
    if ([[self.paraDic objectForKey:@"sex"] integerValue] == 0) {
        [cell.button setTitle:@"保密" forState:(UIControlStateNormal)];
    }else if ([[self.paraDic objectForKey:@"sex"] integerValue] == 1) {
        [cell.button setTitle:@"男" forState:(UIControlStateNormal)];
    }else if ([[self.paraDic objectForKey:@"sex"] integerValue] == 2) {
        [cell.button setTitle:@"女" forState:(UIControlStateNormal)];
    }
}

- (void)creatNewTableView{
    
    self.secondTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.secondTableView.delegate = self;
    self.secondTableView.dataSource = self;
    [self.secondTableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.secondTableView registerClass:[JGButtonTableViewCell class] forCellReuseIdentifier:@"cellBtn"];
    [_secondTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    self.titleArray = [NSArray arrayWithObjects:@[@"姓名", @"性别", @"手机号码"], @[@"行业", @"公司", @"职业",   @"常住地址", @"衣服尺码", @"惯用手"], nil];
    self.placeholderArray = [NSArray arrayWithObjects:@[@"请输入真实姓名", @"请输入性别", @"请输入手机号" ],@[@"请输入你的行业",@"请输入你的公司",@"请输入你的职位",@"方便活动邀请", @"统一制服制定", @"制定特殊需求"],  nil];
    [self.view addSubview: self.secondTableView];
    
}

// 创建选择性别的选择器
- (void)cellBtn{
    [self createDataClick:@"FUCK"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.paraDic setObject:@(row) forKey:@"sex"];
}


- (void)complete{
    BOOL isLength = YES;
    NSArray *array = [NSArray arrayWithObjects:@"userName", @"sex", @"almost", @"mobile", nil];
    for (JGApplyMaterialTableViewCell *cell in self.tableView.visibleCells) {
        NSLog(@"%@", cell.textFD.text);
    }
    for (int i = 0; i < 4; i ++) {
        JGApplyMaterialTableViewCell *cell = self.tableView.visibleCells[i];
        if ([cell.textFD.text length] == 0) {
            isLength = NO;
        }else{
            
            if (i == 0 || i == 3) {
                [self.paraDic setObject:cell.textFD.text  forKey:array[i]];
                
            }else{
                [self.paraDic setObject:@([cell.textFD.text  integerValue]) forKey:array[i]];
            }
            
        }
    }
    
    if (isLength) {
        
        
        //        [self.paraDic setObject:@83 forKey:@"userKey"];   // TEST
        
        [self.paraDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
        [self.paraDic setObject:@(self.teamKey) forKey:@"teamKey"];
        [self.paraDic setObject:@0 forKey:@"state"];
        [self.paraDic setObject:@"2016-12-11 10:00:00" forKey:@"createTime"];
        [self.paraDic setObject:@0 forKey:@"timeKey"];
        
        [[JsonHttp jsonHttp] httpRequest:@"team/reqJoinTeam" JsonKey:@"teamMemeber" withData:self.paraDic requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"error *** %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊");
    }
    
    
}

- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[JGButtonTableViewCell class] forCellReuseIdentifier:@"cellBtn"];
    
    self.titleArray = [NSArray arrayWithObjects:@[@"姓名", @"性别", @"差点", @"手机号码"], @"常住地址", @"衣服尺码", @"惯用手", nil];
    self.placeholderArray = [NSArray arrayWithObjects:@[@"请输入真实姓名", @"请输入性别", @"请输入您的差点", @"请输入手机号" ],@"方便活动邀请（选填）",@"统一制服定做（选填）",@"制定特殊需求（选填）", nil];
    [self.view addSubview: self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 6;
    }
    else{
        return 1;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"必填项";
    }else if (section == 1){
        return @"选填项";
    }
    else
    {
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 30*screenWidth/375;
    }
    else
    {
        return 10*screenWidth/375;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        JGButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellBtn" forIndexPath:indexPath];
        cell.labell.text = self.titleArray[indexPath.section][indexPath.row];
        [cell.button addTarget:self action:@selector(cellBtn) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
    else if (indexPath.section == 2 || indexPath.section == 3)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
        if (indexPath.section == 2) {
            cell.textLabel.text = @"年费清单";
        }
        else{
            cell.textLabel.text = @"查看球队公共账务";
        }
        return cell;
    }
    else{
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            cell.labell.text = self.titleArray[indexPath.section][indexPath.row];
            cell.textFD.placeholder = self.placeholderArray[indexPath.section][indexPath.row];
        }else{
            cell.labell.text = self.titleArray[indexPath.section][indexPath.row];
            cell.textFD.placeholder = self.placeholderArray[indexPath.section][indexPath.row];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

//- (void)cellBtn{
//    NSLog(@"***********/n*************");
//}



- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
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
