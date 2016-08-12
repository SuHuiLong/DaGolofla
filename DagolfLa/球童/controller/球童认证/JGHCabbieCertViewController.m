//
//  JGHCabbieCertViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieCertViewController.h"
#import "JGHLableAndFileTextCell.h"
#import "JGHLableAndLableCell.h"
#import "JGHSexCell.h"
#import "JGHCabbiePhotoCell.h"
#import "JGHBtnCell.h"
#import "JGHCabbieCertSuccessViewController.h"
#import "JGHCaddieAuthModel.h"
#import "BallParkViewController.h"
#import "SXPickPhoto.h"

static NSString *const JGHLableAndFileTextCellIdentifier = @"JGHLableAndFileTextCell";
static NSString *const JGHLableAndLableCellIdentifier = @"JGHLableAndLableCell";
static NSString *const JGHSexCellIdentifier = @"JGHSexCell";
static NSString *const JGHCabbiePhotoCellIdentifier = @"JGHCabbiePhotoCell";
static NSString *const JGHBtnCellIdentifier = @"JGHBtnCell";

@interface JGHCabbieCertViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHBtnCellDelegate, JGHSexCellDelegate, JGHCabbiePhotoCellDelegate>

{
    NSString *_ballName;//球场名称,默认1
    NSInteger _ballKey;//球场Key
    NSString *_name;
    NSString *_cabbieNumber;
    NSString *_cabbieYear;
    NSInteger _sex;
    
    UIImage *_cabbieImage;
}

@property (nonatomic, strong)UITableView *cabbieCertTableView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation JGHCabbieCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"球童认证";
    self.pickPhoto = [[SXPickPhoto alloc]init];
    _ballName = @"1";
    _sex = 0;
    
    [self createPlayAddCaddieTableView];
    
    [self loadData];
}

- (void)loadData{
    //getCaddieAuth
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getCaddieAuth" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            JGHCaddieAuthModel *model = [[JGHCaddieAuthModel alloc]init];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict = [data objectForKey:@"caddieAuth"];
            [model setValuesForKeysWithDictionary:dict];
            
            [self.cabbieCertTableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)createPlayAddCaddieTableView{
    self.cabbieCertTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    
    UINib *lableAndFileTextCellNib = [UINib nibWithNibName:@"JGHLableAndFileTextCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertTableView registerNib:lableAndFileTextCellNib forCellReuseIdentifier:JGHLableAndFileTextCellIdentifier];
    
    UINib *lableAndLableCellNib = [UINib nibWithNibName:@"JGHLableAndLableCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertTableView registerNib:lableAndLableCellNib forCellReuseIdentifier:JGHLableAndLableCellIdentifier];
    
    UINib *sexCellNib = [UINib nibWithNibName:@"JGHSexCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertTableView registerNib:sexCellNib forCellReuseIdentifier:JGHSexCellIdentifier];
    
    UINib *cabbiePhotoCellNib = [UINib nibWithNibName:@"JGHCabbiePhotoCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertTableView registerNib:cabbiePhotoCellNib forCellReuseIdentifier:JGHCabbiePhotoCellIdentifier];
    
    UINib *btnCellNib = [UINib nibWithNibName:@"JGHBtnCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertTableView registerNib:btnCellNib forCellReuseIdentifier:JGHBtnCellIdentifier];
    
    self.cabbieCertTableView.delegate = self;
    self.cabbieCertTableView.dataSource = self;
    
    self.cabbieCertTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cabbieCertTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.cabbieCertTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 5) {
        return 182 *ProportionAdapter;
    }
    return 54 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHLableAndLableCell *labelCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndLableCellIdentifier];
        labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        labelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [labelCell configBallName:_ballName];
        return labelCell;
    }else if (indexPath.section == 6){
        JGHBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHBtnCellIdentifier];
        [btnCell configBtn];
        btnCell.delegate = self;
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return btnCell;
    }else if (indexPath.section == 2){
        JGHSexCell *sexCell = [tableView dequeueReusableCellWithIdentifier:JGHSexCellIdentifier];
        [sexCell configSex:_sex];
        sexCell.delegate = self;
        sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sexCell;
    }else if (indexPath.section == 5){
        JGHCabbiePhotoCell *cabbiePhotoCell = [tableView dequeueReusableCellWithIdentifier:JGHCabbiePhotoCellIdentifier];
        //        [tranCell configScoreJGLAddActiivePlayModel:_playModel];
        cabbiePhotoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cabbiePhotoCell;
    }else{
        JGHLableAndFileTextCell *fielTextCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndFileTextCellIdentifier];
        fielTextCell.fielText.delegate = self;
        fielTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
        fielTextCell.fielText.tag = 100 +indexPath.section;
        if (indexPath.section == 1) {
            [fielTextCell configCabbieName];
        }else if (indexPath.section == 3){
            [fielTextCell configCabbieNumber];
        }else{
            [fielTextCell configCabbieLenghtService];
        }
        
        return fielTextCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //球场列表
        BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
        [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
            NSLog(@"%@----%ld", balltitle, (long)ballid);
            _ballKey = *(&(ballid));
            _ballName = balltitle;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath];
            [self.cabbieCertTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [self.navigationController pushViewController:ballCtrl animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 6) {
        return 20 *ProportionAdapter;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 6) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20 *ProportionAdapter)];
        view.backgroundColor = [UIColor colorWithHexString:BG_color];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth - 20 *ProportionAdapter, 1)];
        lineLable.backgroundColor = [UIColor colorWithHexString:BG_color];
        [view addSubview:lineLable];
        return view;
    }
}
#pragma mark -- 图片选择
- (void)selectCabbieImageBtn:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _cabbieImage = (UIImage *)Data;
                
                [self.cabbieCertTableView reloadData];
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _cabbieImage = (UIImage *)Data;
                
                [self.cabbieCertTableView reloadData];
            }
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}
#pragma mark -- 性别选择
- (void)selectSexBtn:(UIButton *)btn{
    if (btn.tag == 10) {
        _sex = 0;
    }else{
        _sex = 1;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.cabbieCertTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 提交代理
- (void)commitCabbieCert:(UIButton *)btn{
    btn.enabled = NO;
    [self.view endEditing:YES];
    
    if ([_ballName isEqualToString:@"1"]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择球场！" FromView:self.view];
        return;
    }
    
    if (_name == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请填写姓名！" FromView:self.view];
        return;
    }
    
    if (_cabbieNumber == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请填写球童编号！" FromView:self.view];
        return;
    }
    
    if (_cabbieYear == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请填写服务年限！" FromView:self.view];
        return;
    }
    
    if (_cabbieImage == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请选择头像！" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *caddieAuthDict = [NSMutableDictionary dictionary];
    [caddieAuthDict setObject:@(_ballKey) forKey:@"ballKey"];
    [caddieAuthDict setObject:_ballName forKey:@"ballName"];
    [caddieAuthDict setObject:_name forKey:@"name"];
    [caddieAuthDict setObject:@(_sex) forKey:@"sex"];
    [caddieAuthDict setObject:_cabbieNumber forKey:@"number"];
    [caddieAuthDict setObject:_cabbieYear forKey:@"serviceTime"];
    [caddieAuthDict setObject:DEFAULF_USERID forKey:@"timeKey"];
    [dict setObject:caddieAuthDict forKey:@"caddieAuth"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/doSaveCaddieAuth" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            [imageArray addObject:UIImageJPEGRepresentation(_cabbieImage, 0.7)];
            
            NSNumber* strTimeKey = [data objectForKey:@"timeKey"];
            // 上传图片
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:TYPE_TEAM_BACKGROUND forKey:@"nType"];
            [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
            
            [dict setObject:[NSString stringWithFormat:@"%@_caddie" ,strTimeKey] forKey:@"data"];
            [dict setObject:TYPE_TEAM_BACKGROUND forKey:@"nType"];
            [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"5" withData:dict andDataArray:imageArray failedBlock:^(id errType) {
                NSLog(@"errType===%@", errType);
            } completionBlock:^(id data) {
                NSLog(@"data == %@", data);
                if ([[data objectForKey:@"code"] integerValue] == 1) {
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"活动创建成功!" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:commitAction];
                    //获取主线层
                    if ([NSThread isMainThread]) {
                        NSLog(@"Yay!");
                        [self presentViewController:alertController animated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        NSLog(@"Humph, switching to main");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    }
                    
                }else{
                    
                }
            }];

        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    btn.enabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%td", textField.tag);
    if (textField.tag -100 == 1) {
        _name = textField.text;
    }else if (textField.tag -100 == 3){
        _cabbieNumber = textField.text;
    }else{
        _cabbieYear = textField.text;
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
