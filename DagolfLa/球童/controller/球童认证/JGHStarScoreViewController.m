//
//  JGHStarScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHStarScoreViewController.h"
#import "JGHLableAndFileTextCell.h"
#import "JGHBtnCell.h"
#import "JGHCabbiePhotoCell.h"
#import "JGHCaddieAuthModel.h"
#import "JGHSexCell.h"
#import "JGHLableAndLableCell.h"
#import "BallParkViewController.h"
#import "SXPickPhoto.h"
#import "JGHCabbieEditorViewController.h"
#import "JGLCaddieScoreViewController.h"

static NSString *const JGHLableAndFileTextCellIdentifier = @"JGHLableAndFileTextCell";
static NSString *const JGHBtnCellIdentifier = @"JGHBtnCell";
static NSString *const JGHCabbiePhotoCellIdentifier = @"JGHCabbiePhotoCell";
static NSString *const JGHSexCellIdentifier = @"JGHSexCell";
static NSString *const JGHLableAndLableCellIdentifier = @"JGHLableAndLableCell";

@interface JGHStarScoreViewController ()<UITableViewDelegate, UITableViewDataSource, JGHBtnCellDelegate>
{
    NSArray *_titleArray;
    JGHCaddieAuthModel *_model;
    UIImage *_cabbieImage;
}

@property (nonatomic, strong)UITableView *cabbieCertSuccessTableView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation JGHStarScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"资料页";
    
    _titleArray = @[@"", @"所属场地", @"姓别", @"球童编号", @"服务年限"];
    _model = [[JGHCaddieAuthModel alloc]init];
    self.pickPhoto = [[SXPickPhoto alloc]init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editorBtnClick:)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createCabbieCertSuccessTableView];
    
    [self loadData];
}
#pragma mark -- 编辑
- (void)editorBtnClick:(UIBarButtonItem *)item{
    JGHCabbieEditorViewController *cabbEditorCtrl = [[JGHCabbieEditorViewController alloc]init];
    cabbEditorCtrl.model = _model;
    [self.navigationController pushViewController:cabbEditorCtrl animated:YES];
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
        if (_model.name) {
            [cabbiePhotoCell configCabbieSuccess:1 andName:_model.name];
        }
        
        cabbiePhotoCell.proTextField.tag = 5;
        return cabbiePhotoCell;
    }else if (indexPath.section == 1){
        JGHLableAndLableCell *labelCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndLableCellIdentifier];
        labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        labelCell.accessoryType = UITableViewCellAccessoryNone;
        
        if (_model.ballName) {
            [labelCell configBallName:_model.ballName];
        }
        
        return labelCell;
    }else if (indexPath.section == 5){
        JGHBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHBtnCellIdentifier];
        [btnCell configStartBtn];
        btnCell.delegate = self;
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return btnCell;
    }else{
        JGHLableAndFileTextCell *fielTextCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndFileTextCellIdentifier];
        fielTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
        fielTextCell.fielText.enabled = NO;
        
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
    JGLCaddieScoreViewController *cabbieRewardCtrl = [[JGLCaddieScoreViewController alloc]init];
    cabbieRewardCtrl.isCaddie = 1;
    [self.navigationController pushViewController:cabbieRewardCtrl animated:YES];
    btn.enabled = YES;
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
