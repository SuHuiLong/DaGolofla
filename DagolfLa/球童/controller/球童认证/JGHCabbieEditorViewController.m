//
//  JGHCabbieEditorViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieEditorViewController.h"
#import "JGHLableAndFileTextCell.h"
#import "JGHCabbiePhotoCell.h"
#import "JGHCaddieAuthModel.h"
#import "JGHSexCell.h"
#import "JGHLableAndLableCell.h"
#import "BallParkViewController.h"
#import "SXPickPhoto.h"

static NSString *const JGHLableAndFileTextCellIdentifier = @"JGHLableAndFileTextCell";
static NSString *const JGHCabbiePhotoCellIdentifier = @"JGHCabbiePhotoCell";
static NSString *const JGHSexCellIdentifier = @"JGHSexCell";
static NSString *const JGHLableAndLableCellIdentifier = @"JGHLableAndLableCell";

@interface JGHCabbieEditorViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHSexCellDelegate, JGHCabbiePhotoCellDelegate>
{
    NSArray *_titleArray;
   
    UIImage *_cabbieImage;
}

@property (nonatomic, strong)UITableView *cabbieEditorTableview;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation JGHCabbieEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑";
    
    _titleArray = @[@"", @"所属场地", @"姓名", @"姓别", @"球童编号", @"服务年限"];
    self.pickPhoto = [[SXPickPhoto alloc]init];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick:)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createCabbieEditorTableview];
    
}
#pragma mark -- 保存
- (void)saveBtnClick:(UIBarButtonItem *)btn{
    [self.view endEditing:YES];
    btn.enabled = NO;
    
    if (!_model.ballName) {
        [[ShowHUD showHUD]showToastWithText:@"请选择球场！" FromView:self.view];
        btn.enabled = YES;

        return;
    }
    
    if (!_model.name) {
        [[ShowHUD showHUD]showToastWithText:@"请填写姓名！" FromView:self.view];
        btn.enabled = YES;

        return;
    }
    
    if (!_model.number) {
        [[ShowHUD showHUD]showToastWithText:@"请填写球童编号！" FromView:self.view];
        btn.enabled = YES;

        return;
    }
    
    if (!_model.serviceTime) {
        [[ShowHUD showHUD]showToastWithText:@"请填写服务年限！" FromView:self.view];
        btn.enabled = YES;

        return;
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"保存中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *caddieAuthDict = [NSMutableDictionary dictionary];
    [caddieAuthDict setObject:_model.ballKey forKey:@"ballKey"];
    [caddieAuthDict setObject:_model.ballName forKey:@"ballName"];
    [caddieAuthDict setObject:_model.name forKey:@"name"];
    [caddieAuthDict setObject:@(_model.sex) forKey:@"sex"];
    [caddieAuthDict setObject:_model.number forKey:@"number"];
    [caddieAuthDict setObject:_model.serviceTime forKey:@"serviceTime"];
    [caddieAuthDict setObject:DEFAULF_USERID forKey:@"timeKey"];
    [dict setObject:caddieAuthDict forKey:@"caddieAuth"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/doSaveCaddieAuth" JsonKey:nil withData:dict failedBlock:^(id errType) {
        btn.enabled = YES;

        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        btn.enabled = YES;

        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if (_cabbieImage != nil) {
                NSMutableArray *imageArray = [NSMutableArray array];
                
                [imageArray addObject:UIImageJPEGRepresentation(_cabbieImage, 0.7)];
                
//                NSNumber* strTimeKey = [data objectForKey:@"timeKey"];
                // 上传图片
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
                
                [dict setObject:[NSString stringWithFormat:@"%@_caddie" ,DEFAULF_USERID] forKey:@"data"];
                [dict setObject:TYPE_USER_HEAD forKey:@"nType"];
                [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"5" withData:dict andDataArray:imageArray failedBlock:^(id errType) {
                    NSLog(@"errType===%@", errType);
                } completionBlock:^(id data) {
                    NSLog(@"data == %@", data);
                    if ([[data objectForKey:@"code"] integerValue] == 1) {
                        
                        [self.cabbieEditorTableview reloadData];
                        
                        //获取主线层
                        if ([NSThread isMainThread]) {
                            NSLog(@"Yay!");
                            [LQProgressHud showMessage:@"保存成功!"];
//                            [[ShowHUD showHUD]showToastWithText:@"保存成功!" FromView:self.view];
                            [self performSelector:@selector(popCtrl) withObject:self afterDelay:TIMESlEEP];
                        } else {
                            NSLog(@"Humph, switching to main");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [LQProgressHud showMessage:@"保存成功!"];
//                                [[ShowHUD showHUD]showToastWithText:@"保存成功!" FromView:self.view];
                                [self performSelector:@selector(popCtrl) withObject:self afterDelay:TIMESlEEP];
                            });
                        }
                    }else{
                        [LQProgressHud showMessage:@"头像上传失败!"];
//                        [[ShowHUD showHUD]showToastWithText:@"头像上传失败!" FromView:self.view];
                    }
                }];
            }else{
                [LQProgressHud showMessage:@"保存成功!"];
//                [[ShowHUD showHUD]showToastWithText:@"保存成功!" FromView:self.view];
                [self performSelector:@selector(popCtrl) withObject:self afterDelay:TIMESlEEP];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
- (void)popCtrl{
    _refreshBlock();
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createCabbieEditorTableview{
    self.cabbieEditorTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.cabbieEditorTableview.backgroundColor = [UIColor whiteColor];
    
    UINib *lableAndFileTextCellNib = [UINib nibWithNibName:@"JGHLableAndFileTextCell" bundle:[NSBundle mainBundle]];
    [self.cabbieEditorTableview registerNib:lableAndFileTextCellNib forCellReuseIdentifier:JGHLableAndFileTextCellIdentifier];
    
    UINib *cabbiePhotoCellNib = [UINib nibWithNibName:@"JGHCabbiePhotoCell" bundle:[NSBundle mainBundle]];
    [self.cabbieEditorTableview registerNib:cabbiePhotoCellNib forCellReuseIdentifier:JGHCabbiePhotoCellIdentifier];
    
    UINib *lableAndLableCellNib = [UINib nibWithNibName:@"JGHLableAndLableCell" bundle:[NSBundle mainBundle]];
    [self.cabbieEditorTableview registerNib:lableAndLableCellNib forCellReuseIdentifier:JGHLableAndLableCellIdentifier];
    
    UINib *sexCellNib = [UINib nibWithNibName:@"JGHSexCell" bundle:[NSBundle mainBundle]];
    [self.cabbieEditorTableview registerNib:sexCellNib forCellReuseIdentifier:JGHSexCellIdentifier];
    
    self.cabbieEditorTableview.delegate = self;
    self.cabbieEditorTableview.dataSource = self;
    
    self.cabbieEditorTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cabbieEditorTableview];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
        cabbiePhotoCell.proTextField.userInteractionEnabled = NO;
        if (_cabbieImage) {
            [cabbiePhotoCell configEditorImage:_cabbieImage andUserName:_model.name];
        }else{
            if (_model.name) {
                [cabbiePhotoCell configImageWithName:_model.name];
            }
        }
        
        cabbiePhotoCell.delegate = self;
        cabbiePhotoCell.proTextField.delegate = self;
        cabbiePhotoCell.proTextField.tag = 5;
        return cabbiePhotoCell;
    }else if (indexPath.section == 1){
        JGHLableAndLableCell *labelCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndLableCellIdentifier];
        labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        labelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (_model.ballName) {
            [labelCell configBallName:_model.ballName];
        }
        
        return labelCell;
    }else{
        if (indexPath.section == 3) {
            JGHSexCell *sexCell = [tableView dequeueReusableCellWithIdentifier:JGHSexCellIdentifier];
            [sexCell configSex:_model.sex];
            sexCell.delegate = self;
            sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return sexCell;
        }else{
            JGHLableAndFileTextCell *fielTextCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndFileTextCellIdentifier];
            fielTextCell.fielText.delegate = self;
            fielTextCell.fielText.tag = indexPath.section +100;
            fielTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            fielTextCell.fielText.enabled = YES;
            
            if (_model.ballName) {
                if (indexPath.section == 2) {
                    [fielTextCell configCabbieTitleString:_titleArray[indexPath.section] andVlaueString:[NSString stringWithFormat:@"%@", _model.name]];
                }else if (indexPath.section == 4){
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
    if (indexPath.section == 1) {
        //球场列表
        BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
        [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
            NSLog(@"%@----%ld", balltitle, (long)ballid);
            
            _model.ballKey = [NSNumber numberWithInteger:*(&(ballid))];
            _model.ballName = balltitle;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath];
            [self.cabbieEditorTableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [self.navigationController pushViewController:ballCtrl animated:YES];
    }
}
#pragma mark -- 性别选择
- (void)selectSexBtn:(UIButton *)btn{
    if (btn.tag == 10) {
        _model.sex = 0;
    }else{
        _model.sex = 1;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.cabbieEditorTableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath];
                [self.cabbieEditorTableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath];
                [self.cabbieEditorTableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
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
    if (textField.tag -100 == 4){
        _model.number = textField.text;
    }else if (textField.tag - 100 == 2){
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
