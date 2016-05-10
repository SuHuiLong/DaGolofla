//
//  RewardAreaViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/11.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "RewardAreaViewController.h"
#import "AreaChooseViewController.h"
@interface RewardAreaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _dataArray;
    
    NSArray* _provinces;
    NSArray* _cities;
    NSArray* _areas;
    NSString* _state;
    NSString* _city;
    NSString *_district;
}

@end

@implementation RewardAreaViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区选择";
    //解析
    [self createPlist];
    //搜索栏
    [self createSeachBar];
    //表
    [self createTableView];
    
    

}
-(void)createPlist
{
    _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    
    _state = [[_provinces objectAtIndex:0] objectForKey:@"state"];
    _city = [[_cities objectAtIndex:0] objectForKey:@"city"];
    
    _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
    if (_areas.count > 0) {
        _district = [_areas objectAtIndex:0];
    } else{
        _district = @"";
    }

    
    
}

-(void)createSeachBar{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37*ScreenWidth/375)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13*ScreenWidth/375, 5*ScreenWidth/375, ScreenWidth-80*ScreenWidth/375, 27*ScreenWidth/375)];
    imageView.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    imageView.layer.cornerRadius=13;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 7*ScreenWidth/375, 16*ScreenWidth/375, 16*ScreenWidth/375);
    [imageView addSubview:imageView2];
    
    UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 26*ScreenWidth/375)];
    textField.textColor=[UIColor lightGrayColor];
    textField.tag=888;
    [textField addTarget:self action:@selector(keyboardDown3:) forControlEvents:UIControlEventEditingDidEndOnExit];
    textField.placeholder=@"请输入类别或关键字";
    [imageView addSubview:textField];
    textField.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 3*ScreenWidth/375, 60*ScreenWidth/375, 30*ScreenWidth/375);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
-(void)keyboardDown3:(UITextField *)tf{
    
}
-(void)seachButtonClick{
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:88];
    UITextField *tf=(UITextField *)[imageView viewWithTag:888];
    if ([self isBlankString:tf.text]==NO) {
        AreaChooseViewController *AreaSearch=[[AreaChooseViewController alloc] init];
        AreaSearch.seachText=tf.text;
        [self.navigationController pushViewController:AreaSearch animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"123" message:@"请填写搜索信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(BOOL)isBlankString:(NSString *)string{
    if (string==nil||string==NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


-(void)createTableView
{
    _dataArray = [[NSArray alloc]init];
    ////NSLog(@"%@,%@",_provinces,_cities);
    _dataArray = @[@[@"0"],@[@"1"]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 37*ScreenWidth/375, ScreenWidth, ScreenHeight-37*ScreenWidth/375-64) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark --tableview的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _provinces.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    for (int i = 0; i < _provinces.count; i++) {
        if (section == i) {
            count = _cities.count;
        }
        
    }
    return count;
}
//返回每一行所对应的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[0][0];//表示这个数组里买呢有多少区。区里面有多少行
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    return cell;
}

//返回各个分区对应的头标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0?@"基本信息":@"悬赏要求";
}
//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*ScreenWidth/375;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击事件选中后传值
}


@end
