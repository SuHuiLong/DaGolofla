//
//  JGDPersonalViewController.m
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPersonalViewController.h"
#import "JGDPersonalTableViewCell.h"
#import "JGDInputView.h"
#import "JGDPickerView.h"
#import "JGDDatePicker.h"
#import "JGDTextTipView.h"
#import "GPProvince.h"
#import "CityPickerView.h"
#import "SXPickPhoto.h"
#import "InformViewController.h"

@interface JGDPersonalViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic,strong) SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong) NSMutableDictionary* dict;
@property (nonatomic, strong) NSDictionary* downLoadDic;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableArray *picImageArray;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) CityPickerView *cityPickView;

@end

@implementation JGDPersonalViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary* dictUser = [[NSMutableDictionary alloc]init];
    [dictUser setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
    [dictUser setObject:strMD forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserInfo" JsonKey:nil withData:dictUser requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"]boolValue]) {
            
            self.downLoadDic = [data objectForKey:@"user"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    _pickPhoto = [[SXPickPhoto alloc]init];
    self.titleArray = [NSArray arrayWithObjects:@"昵称", @"性别", @"出生年月", @"行业", @"差点", @"球龄", @"城市", @"个人签名",  nil];
    self.keyArray = [NSArray arrayWithObjects:@"userName", @"sex", @"birthday", @"workName", @"almost", @"ballage", @"address", @"userSign", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[JGDPersonalTableViewCell class] forCellReuseIdentifier:@"JGDPersonalTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveAct)];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:UIControlStateNormal];
    saveBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 88 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    self.iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 73 * ProportionAdapter, 73 * ProportionAdapter)];
    self.iconBtn.center = headerView.center;
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[DEFAULF_USERID integerValue]];
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:bgUrl] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"bg_photo"]];
    //    [self.iconBtn setImage:[UIImage imageNamed:@"bg_photo"] forState:(UIControlStateNormal)];;
    self.iconBtn.layer.cornerRadius = 73 * ProportionAdapter / 2;
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.borderWidth = 1.5 * ProportionAdapter;
    self.iconBtn.layer.borderColor = [[UIColor colorWithHexString:@"#e4e4e4"] CGColor];
    self.iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconBtn addTarget:self action:@selector(iconChangeAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:self.iconBtn];
    
    [self downLoadData];
    // Do any additional setup after loading the view.
}

- (void)downLoadData{
    NSMutableDictionary* dictUser = [[NSMutableDictionary alloc]init];
    [dictUser setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
    [dictUser setObject:strMD forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserInfo" JsonKey:nil withData:dictUser requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"]boolValue]) {
            
            self.downLoadDic = [data objectForKey:@"user"];
            [_tableView reloadData];
        }
    }];
}

#pragma mark -- 保存 提交

- (void)saveAct{
    
    if ([self.picImageArray count] > 0) {
        NSNumber* strTimeKey = DEFAULF_USERID;
        // 上传图片
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:strTimeKey forKey:@"data"];
        [dict setObject:TYPE_USER_HEAD forKey:@"nType"];
        [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
        
        [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:self.picImageArray failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            
            NSString *headUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/user/head/%@.jpg@120w_120h", DEFAULF_USERID];
            [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES];
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            if (![Helper isBlankString:headUrl]) {
                [user setObject:headUrl forKey:@"pic"];
            }
            [user synchronize];
        }];
    }
    
    
    //  - - -
    
    
    for (JGDPersonalTableViewCell *cell in self.tableView.visibleCells) {
        
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        if (![cell.nameLB.text isEqualToString:@"请选择"]) {
            [self.dict setObject:cell.nameLB.text forKey:self.keyArray[index.row]];
        }
    }
    
    if ([self.dict objectForKey:@"ballage"]) {
        
        if ([[self.dict objectForKey:@"ballage"] isEqualToString:@"1-2年"]) {
            [self.dict setObject:@0 forKey:@"ballage"];
            
        }else if ([[self.dict objectForKey:@"ballage"] isEqualToString:@"3-5年"]) {
            [self.dict setObject:@1 forKey:@"ballage"];
            
        }else if ([[self.dict objectForKey:@"ballage"] isEqualToString:@"6-10年"]) {
            [self.dict setObject:@2 forKey:@"ballage"];
            
        }else if ([[self.dict objectForKey:@"ballage"] isEqualToString:@"10年 以上"]) {
            [self.dict setObject:@3 forKey:@"ballage"];
            
        }
    }
    
    if ([self.dict objectForKey:@"sex"]) {
        if ([[self.dict objectForKey:@"sex"] isEqualToString:@"男"]) {
            [self.dict setObject:@1 forKey:@"sex"];
        }else{
            [self.dict setObject:@0 forKey:@"sex"];
        }
    }
    
    if ([self.dict objectForKey:@"address"]) {
        NSArray *array = [[self.dict objectForKey:@"address"] componentsSeparatedByString:@" "];
        [self.dict setObject:array[0] forKey:@"province"];
        [self.dict setObject:array[1] forKey:@"city"];
    }
    
    [self.dict setObject:DEFAULF_USERID forKey:@"userId"];
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:self.dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"保－存");
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDPersonalTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = self.titleArray[indexPath.row];
    
    if ([self.downLoadDic objectForKey:self.keyArray[indexPath.row]]) {
        
        NSString *string = [NSString stringWithFormat:@"%@", [self.downLoadDic objectForKey:self.keyArray[indexPath.row]]];
        if (indexPath.row == 1) {
            
            [string isEqualToString:@"0"] ? (cell.nameLB.text = @"女") : (cell.nameLB.text = @"男");
        }else if (indexPath.row == 2) {
            
            cell.nameLB.text = [string substringToIndex:10];
        }else if (indexPath.row == 4) {
            
            [string isEqualToString:@"-10000"] ? (cell.nameLB.text = @"请选择") : (cell.nameLB.text = string);
        }else if (indexPath.row == 5) {
            
            
            if ([string isEqualToString:@"0"]) {
                cell.nameLB.text = @"1-2年";
                
            }else if ([string isEqualToString:@"1"]) {
                cell.nameLB.text = @"3-5年";
                
            }else if ([string isEqualToString:@"2"]) {
                cell.nameLB.text = @"6-10年";
                
            }else if ([string isEqualToString:@"3"]) {
                cell.nameLB.text = @"10年 以上";
                
            }
        }else if (indexPath.row == 6) {
            
            cell.nameLB.text = [NSString stringWithFormat:@"%@ %@", [self.downLoadDic objectForKey:@"province"], [self.downLoadDic objectForKey:@"city"]];
        }else{
            cell.nameLB.text = [NSString stringWithFormat:@"%@", [self.downLoadDic objectForKey:self.keyArray[indexPath.row]]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDPersonalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0 || indexPath.row == 7) {
        JGDInputView *inputV = [[JGDInputView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (indexPath.row == 0) {
            inputV.height = 52.0;
            inputV.placeHolderString = @"请输入您的个性昵称";
        }else{
            inputV.height = 150.0;
            inputV.placeHolderString = @"请输入您的个人签名";
        }
        
        inputV.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        
        [self.view addSubview:inputV];
        
    }else if (indexPath.row == 1) {
        
        JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        pickView.dataArray = @[@"男", @"女"];
        pickView.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        [self.view addSubview:pickView];
        
    }else if (indexPath.row == 2) {
        
        JGDDatePicker *datePic = [[JGDDatePicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        if ([cell.nameLB.text isEqualToString:@"请选择"]) {
            datePic.lastDate = [NSDate date];
        }else{
            NSDate * date = [formatter dateFromString:cell.nameLB.text];
            datePic.lastDate = date;
        }
        
        datePic.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        [self.view addSubview:datePic];
    }else if (indexPath.row == 3) {
        
        NSURL *url = [NSURL URLWithString:@"http://res.dagolfla.com/download/json/industry.json"];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error1 = nil;
        
        if (data) {
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in [dataDic objectForKey:@"-1"]) {
                [array addObject:[dic objectForKey:@"name"]];
            }
            
            JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            pickView.dataArray = array;
            pickView.blockStr = ^(NSString *string){
                cell.nameLB.text = string;
            };
            [self.view addSubview:pickView];
        }
        
    }else if (indexPath.row == 4) {
        
        // -10 30
        // almost_system_setting  1 是不能改
        if ([[self.downLoadDic objectForKey:@"almost_system_setting"] integerValue] == 0) {
            
            JGDTextTipView *tipView = [[JGDTextTipView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            tipView.isUseJG = [[self.downLoadDic objectForKey:@"almost_system_setting"] boolValue];
            tipView.blockManual = ^{
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSInteger i = -10; i <= 30; i ++) {
                    [array addObject:[NSString stringWithFormat:@"%td", i]];
                }
                
                JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                pickView.dataArray = array;
                pickView.blockStr = ^(NSString *string){
                    cell.nameLB.text = string;
                };
                [self.view addSubview:pickView];
            };
            
            tipView.blocksys = ^{
                InformViewController *infoVC = [[InformViewController alloc] init];
                [self.navigationController pushViewController:infoVC animated:YES];
            };
            
            [self.view addSubview:tipView];
            
            
        }else{
            
            JGDTextTipView *tipView = [[JGDTextTipView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            tipView.isUseJG = [[self.downLoadDic objectForKey:@"almost_system_setting"] boolValue];
            tipView.blockManual = ^{
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSInteger i = -10; i <= 30; i ++) {
                    [array addObject:[NSString stringWithFormat:@"%td", i]];
                }
                
                JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                pickView.dataArray = array;
                pickView.blockStr = ^(NSString *string){
                    cell.nameLB.text = string;
                };
                [self.view addSubview:pickView];
            };
            
            tipView.blocksys = ^{
                InformViewController *infoVC = [[InformViewController alloc] init];
                [self.navigationController pushViewController:infoVC animated:YES];
            };
            
            [self.view addSubview:tipView];
        }
        
    }else if (indexPath.row == 5) {
        
        
        // 球龄   1-2 (0) ， 3-5 (1)   ， 6-10 (2)， 10 以上 (3)
        JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        NSArray *array = [NSArray arrayWithObjects:@"1-2年", @"3-5年" ,@"6-10年", @"10年 以上", nil];
        pickView.dataArray = array;
        pickView.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        [self.view addSubview:pickView];
        
        
    }else if (indexPath.row == 6) {
        
        [[JsonHttp jsonHttp] httpRequest:@"http://res.dagolfla.com/download/json/area.json" failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            NSMutableArray *mDataArray = [NSMutableArray array];
            NSMutableArray *totalProvinceArray = [NSMutableArray array];
            if (![data isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            NSDictionary *dataDict = [NSDictionary dictionaryWithDictionary:data];
            //获取中国
            NSArray *chinaArray = [dataDict objectForKey:@"5203335563984"];
            //获取省份
            for (NSDictionary *provinceDict in chinaArray) {
                NSString *provinceName = [provinceDict objectForKey:@"name"];
                NSString *timeKey = [NSString stringWithFormat:@"%@",[provinceDict objectForKey:@"timeKey"]];
                id cityArray = [dataDict objectForKey:timeKey];
                NSMutableArray *mCityArray = [NSMutableArray array];
                //获取城市
                for (NSDictionary *cityDict in cityArray) {
                    NSString *cityName = [cityDict objectForKey:@"name"];
                    [mCityArray addObject:cityName];
                }
                NSDictionary *indexProvinceDict = @{
                                                    @"name":provinceName,
                                                    @"cities":mCityArray
                                                    };
                [totalProvinceArray addObject:indexProvinceDict];
                
            }
            for (NSDictionary *dict in totalProvinceArray) {
                // 字典转模型
                GPProvince *p = [GPProvince provinceWithDict:dict];
                [mDataArray addObject:p];
            }
            self.cityPickView.provincesArray = mDataArray;
            [self.cityPickView setBlock:^(NSDictionary *dict) {
                cell.nameLB.text = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"proVinceName"], [dict objectForKey:@"cityName"]];
                
            }];
            [self.view addSubview:self.cityPickView];
            
        }];
        
    }
    //    else if (indexPath.row == 7) {
    //
    //        JGDPersonalCard *personalCard = [[JGDPersonalCard alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //        [self.view addSubview:personalCard];
    //    }
    //
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


#pragma mark - 调用手机相机和相册
//更换头像
- (void)iconChangeAct:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            self.picImageArray = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self.iconBtn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
            //            [self imageArray:_arrayPage];
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            self.picImageArray = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self.iconBtn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
            
            //            [self imageArray:_arrayPage];
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:nil message:@"选择头像" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}


#pragma mark --上传图片方法

-(void)imageArray:(NSMutableArray *)array
{
    NSNumber* strTimeKey = DEFAULF_USERID;
    // 上传图片
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strTimeKey forKey:@"data"];
    [dict setObject:TYPE_USER_HEAD forKey:@"nType"];
    [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
    
    [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:array failedBlock:^(id errType) {
        NSLog(@"errType===%@", errType);
    } completionBlock:^(id data) {
        //        [self post:@{@"userId": DEFAULF_USERID}];
        
        
        NSString *headUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/user/head/%@.jpg@120w_120h", DEFAULF_USERID];
        [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES];
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        if (![Helper isBlankString:headUrl]) {
            [user setObject:headUrl forKey:@"pic"];
        }
        [user synchronize];
        //        [self synchronizeUserInfoRCIM];
    }];
}


- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

- (NSDictionary *)downLoadDic{
    if (!_downLoadDic) {
        _downLoadDic = [[NSDictionary alloc] init];
    }
    return _downLoadDic;
}

- (NSMutableArray *)picImageArray{
    if (!_picImageArray) {
        _picImageArray = [[NSMutableArray alloc] init];
    }
    return _picImageArray;
}

- (CityPickerView *)cityPickView{
    if (!_cityPickView) {
        _cityPickView = [[CityPickerView alloc] init];
    }
    return _cityPickView;
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
