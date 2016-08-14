//
//  JGHCabbieCertSuccessViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieCertSuccessViewController.h"
#import "JGHLableAndFileTextCell.h"
#import "JGHBtnCell.h"
#import "JGHCabbiePhotoCell.h"
#import "JGHCaddieAuthModel.h"
#import "JGHSexCell.h"
#import "JGHLableAndLableCell.h"
#import "BallParkViewController.h"
#import "SXPickPhoto.h"
#import "JGHCabbieRewardViewController.h"
#import "JGLChooseScoreViewController.h"

static NSString *const JGHLableAndFileTextCellIdentifier = @"JGHLableAndFileTextCell";
static NSString *const JGHBtnCellIdentifier = @"JGHBtnCell";
static NSString *const JGHCabbiePhotoCellIdentifier = @"JGHCabbiePhotoCell";
static NSString *const JGHSexCellIdentifier = @"JGHSexCell";
static NSString *const JGHLableAndLableCellIdentifier = @"JGHLableAndLableCell";

@interface JGHCabbieCertSuccessViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHSexCellDelegate, JGHBtnCellDelegate, JGHCabbiePhotoCellDelegate>
{
    NSInteger _editor;//编辑－0，保存－1
    UIBarButtonItem *_item;
    
    NSInteger _sex;
    
    NSArray *_titleArray;
    JGHCaddieAuthModel *_model;
    UIImage *_cabbieImage;
}

@property (nonatomic, strong)UITableView *cabbieCertSuccessTableView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation JGHCabbieCertSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"认证完成";
    _titleArray = @[@"", @"所属场地", @"姓别", @"球童编号", @"服务年限"];
    _model = [[JGHCaddieAuthModel alloc]init];
    self.pickPhoto = [[SXPickPhoto alloc]init];
    _sex = 0;
    _editor = 0;
    _item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editorBtnClick:)];
    _item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _item;
    
    [self createCabbieCertSuccessTableView];
    
    [self loadData];
}
#pragma mark -- 编辑／保存
- (void)editorBtnClick:(UIBarButtonItem *)item{
    if (_editor == 0) {
        _editor = 1;
        [_item setTitle:@"保存"];
        [self.cabbieCertSuccessTableView reloadData];
    }else{
        _editor = 0;
        [_item setTitle:@"编辑"];
        
        [self.view endEditing:YES];
        
        if (!_model.ballName) {
            [[ShowHUD showHUD]showToastWithText:@"请选择球场！" FromView:self.view];
            return;
        }
        
        if (!_model.name) {
            [[ShowHUD showHUD]showToastWithText:@"请填写姓名！" FromView:self.view];
            return;
        }
        
        if (!_model.number) {
            [[ShowHUD showHUD]showToastWithText:@"请填写球童编号！" FromView:self.view];
            return;
        }
        
        if (!_model.serviceTime) {
            [[ShowHUD showHUD]showToastWithText:@"请填写服务年限！" FromView:self.view];
            return;
        }
        
        [[ShowHUD showHUD]showAnimationWithText:@"保存中..." FromView:self.view];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableDictionary *caddieAuthDict = [NSMutableDictionary dictionary];
        [caddieAuthDict setObject:_model.ballKey forKey:@"ballKey"];
        [caddieAuthDict setObject:_model.ballName forKey:@"ballName"];
        [caddieAuthDict setObject:_model.name forKey:@"name"];
        [caddieAuthDict setObject:@(_sex) forKey:@"sex"];
        [caddieAuthDict setObject:_model.number forKey:@"number"];
        [caddieAuthDict setObject:_model.serviceTime forKey:@"serviceTime"];
        [caddieAuthDict setObject:DEFAULF_USERID forKey:@"timeKey"];
        [dict setObject:caddieAuthDict forKey:@"caddieAuth"];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/doSaveCaddieAuth" JsonKey:nil withData:dict failedBlock:^(id errType) {
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                
                if (_cabbieImage != nil) {
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
                            [[ShowHUD showHUD]showToastWithText:@"保存成功!" FromView:self.view];
                        }else{
                            [[ShowHUD showHUD]showToastWithText:@"头像上传失败!" FromView:self.view];
                        }
                    }];
                }else{
                    [[ShowHUD showHUD]showToastWithText:@"保存成功!" FromView:self.view];
                }
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
    }
    
    [self.cabbieCertSuccessTableView reloadData];
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
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict = [data objectForKey:@"caddieAuth"];
            [_model setValuesForKeysWithDictionary:dict];
            
            [self.cabbieCertSuccessTableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
- (void)createCabbieCertSuccessTableView{
    self.cabbieCertSuccessTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.cabbieCertSuccessTableView.backgroundColor = [UIColor whiteColor];
    
    UINib *lableAndFileTextCellNib = [UINib nibWithNibName:@"JGHLableAndFileTextCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertSuccessTableView registerNib:lableAndFileTextCellNib forCellReuseIdentifier:JGHLableAndFileTextCellIdentifier];
    
    UINib *btnCellNib = [UINib nibWithNibName:@"JGHBtnCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertSuccessTableView registerNib:btnCellNib forCellReuseIdentifier:JGHBtnCellIdentifier];
    
    UINib *cabbiePhotoCellNib = [UINib nibWithNibName:@"JGHCabbiePhotoCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertSuccessTableView registerNib:cabbiePhotoCellNib forCellReuseIdentifier:JGHCabbiePhotoCellIdentifier];
    
    UINib *lableAndLableCellNib = [UINib nibWithNibName:@"JGHLableAndLableCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertSuccessTableView registerNib:lableAndLableCellNib forCellReuseIdentifier:JGHLableAndLableCellIdentifier];
    
    UINib *sexCellNib = [UINib nibWithNibName:@"JGHSexCell" bundle:[NSBundle mainBundle]];
    [self.cabbieCertSuccessTableView registerNib:sexCellNib forCellReuseIdentifier:JGHSexCellIdentifier];
    
    self.cabbieCertSuccessTableView.delegate = self;
    self.cabbieCertSuccessTableView.dataSource = self;
    
    self.cabbieCertSuccessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cabbieCertSuccessTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_editor == 1) {
        return 5;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 260 *ProportionAdapter;
    }else if (indexPath.section == 5){
        return 54 *ProportionAdapter;
    }
    return 44 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHCabbiePhotoCell *cabbiePhotoCell = [tableView dequeueReusableCellWithIdentifier:JGHCabbiePhotoCellIdentifier];
        cabbiePhotoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_model.name) {
            [cabbiePhotoCell configCabbieSuccess:_editor andName:_model.name];
        }
        
        cabbiePhotoCell.delegate = self;
        cabbiePhotoCell.proTextField.delegate = self;
        cabbiePhotoCell.proTextField.tag = 5;
        return cabbiePhotoCell;
    }else if (indexPath.section == 1){
        JGHLableAndLableCell *labelCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndLableCellIdentifier];
        labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_editor == 1) {
            labelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            labelCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (_model.ballName) {
            [labelCell configBallName:_model.ballName];
        }
        
        return labelCell;
    }else if (indexPath.section == 5){
        JGHBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHBtnCellIdentifier];
        [btnCell configSuccessBtn];
        btnCell.delegate = self;
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return btnCell;
    }else{
        if (_editor == 1) {
            if (indexPath.section == 2) {
                JGHSexCell *sexCell = [tableView dequeueReusableCellWithIdentifier:JGHSexCellIdentifier];
                [sexCell configSex:_sex];
                sexCell.delegate = self;
                sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return sexCell;
            }else{
                JGHLableAndFileTextCell *fielTextCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndFileTextCellIdentifier];
                fielTextCell.fielText.delegate = self;
                fielTextCell.fielText.tag = indexPath.section +100;
                fielTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_editor == 0) {
                    fielTextCell.fielText.enabled = NO;
                }else{
                    fielTextCell.fielText.enabled = YES;
                }
                
                if (_model.ballName) {
                    if (indexPath.section == 3){
                        [fielTextCell configCabbieTitleString:_titleArray[indexPath.section] andVlaueString:[NSString stringWithFormat:@"%@", _model.number]];
                    }else{
                        [fielTextCell configCabbieTitleString:_titleArray[indexPath.section] andVlaueString:[NSString stringWithFormat:@"%@", _model.serviceTime]];
                    }
                }
                
                return fielTextCell;
            }
        }else{
            JGHLableAndFileTextCell *fielTextCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndFileTextCellIdentifier];
            fielTextCell.fielText.delegate = self;
            fielTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_editor == 0) {
                fielTextCell.fielText.enabled = NO;
            }else{
                fielTextCell.fielText.enabled = YES;
            }
            
            if (_model.ballName) {
                if (indexPath.section == 2){
                    [fielTextCell configCabbieTitleString:_titleArray[indexPath.section] andVlaueString:_model.sex==0? @"女":@"男"];
                }else if (indexPath.section == 3){
                    [fielTextCell configCabbieTitleString:_titleArray[indexPath.section] andVlaueString:[NSString stringWithFormat:@"%@", _model.number]];
                }else{
                    [fielTextCell configCabbieTitleString:_titleArray[indexPath.section] andVlaueString:[NSString stringWithFormat:@"%@", _model.serviceTime]];
                }
            }
            
            return fielTextCell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_editor == 0) {
        return;
    }
    
    if (indexPath.section == 1) {
        //球场列表
        BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
        [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
            NSLog(@"%@----%ld", balltitle, (long)ballid);
            
            _model.ballKey = [NSNumber numberWithInteger:*(&(ballid))];
            _model.ballName = balltitle;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath];
            [self.cabbieCertSuccessTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [self.navigationController pushViewController:ballCtrl animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        return 20 *ProportionAdapter;
    }else{
        if (section == 0 || section == 1) {
            return 0;
        }else{
            return 1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20 *ProportionAdapter)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake((20 +60 +40)*ProportionAdapter, 0, screenWidth - 20 *ProportionAdapter, 1)];
        lineLable.backgroundColor = [UIColor colorWithHexString:BG_color];
        [view addSubview:lineLable];
        return view;
    }else{
        if (section == 0 || section == 1) {
            return nil;
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake((20 +60 +40)*ProportionAdapter, 0, screenWidth - 20 *ProportionAdapter, 1)];
            lineLable.backgroundColor = [UIColor colorWithHexString:BG_color];
            [view addSubview:lineLable];
            return view;
        }
    }
}
#pragma mark -- 开始记分
- (void)commitCabbieCert:(UIButton *)btn{
    btn.enabled = NO;
    JGLChooseScoreViewController *chooseScoreCtrl = [[JGLChooseScoreViewController alloc]init];
    
    [self.navigationController pushViewController:chooseScoreCtrl animated:YES];
    
    btn.enabled = YES;
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
    [self.cabbieCertSuccessTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 图片选择
- (void)selectCabbieImageBtn:(UIButton *)btn{
    if (_editor == 0) {
        return;
    }
    
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _cabbieImage = (UIImage *)Data;
                
                [self.cabbieCertSuccessTableView reloadData];
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
                
                [self.cabbieCertSuccessTableView reloadData];
            }
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag -100 == 3){
        _model.number = textField.text;
    }else if (textField.tag == 5){
        _model.name = textField.text;
    }else{
        _model.serviceTime = textField.text;
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
