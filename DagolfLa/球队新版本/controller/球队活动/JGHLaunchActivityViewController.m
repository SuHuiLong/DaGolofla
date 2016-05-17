//
//  JGHLaunchActivityViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "JGHTeamActivityImageCell.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGHLaunchActivityModel.h"
#import "JGTeamActibityNameViewController.h"
#import "SXPickPhoto.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamActivityImageCellIdentifier = @"JGHTeamActivityImageCell";


@interface JGHLaunchActivityViewController ()<UITableViewDelegate, UITableViewDataSource, JGHTeamActivityImageCellDelegate, JGHConcentTextViewControllerDelegate>
{
    //、、、、、、、
    NSArray *_titleArray;
    
    
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;

@property (nonatomic, strong)JGHLaunchActivityModel *model;

@property (nonatomic, strong)UIImage *headerImage;

@end

@implementation JGHLaunchActivityViewController

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGHLaunchActivityModel alloc]init];
        self.dataDict = [NSMutableDictionary dictionary];
        self.pickPhoto = [[SXPickPhoto alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动发布";
    
    _titleArray = @[@[], @[@"开始时间", @"结束时间", @"活动地点"], @[@"活动简介", @"费用说明"], @[@"奖项设置", @"费用设置", @"人员限制"]];
    
    [self createLaunchActivityTableView];
    
    [self createPreviewBtn];
}
#pragma mark -- 预览
- (void)createPreviewBtn{
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - 64 -44, screenWidth, 44)];
    [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor yellowColor];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
}
- (void)previewBtnClick:(UIButton *)btn{
    JGTeamActibityNameViewController *ActivityDetailCtrl = [[JGTeamActibityNameViewController alloc]init];
    ActivityDetailCtrl.isAdmin = @"0";
    [self.navigationController pushViewController:ActivityDetailCtrl animated:YES];
}
#pragma mark -- 创建tabelview
- (void)createLaunchActivityTableView{
    self.launchActivityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    [self.launchActivityTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];

    UINib *launchNib = [UINib nibWithNibName:@"JGHTeamActivityImageCell" bundle: [NSBundle mainBundle]];
    [self.launchActivityTableView registerNib:launchNib forCellReuseIdentifier:JGHTeamActivityImageCellIdentifier];
    
    self.launchActivityTableView.delegate = self;
    self.launchActivityTableView.dataSource = self;
    self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.launchActivityTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else{
        return 3;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHTeamActivityImageCell *launchImageActivityCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamActivityImageCellIdentifier forIndexPath:indexPath];
        launchImageActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        launchImageActivityCell.delegate = self;
        if (_headerImage != nil) {
            launchImageActivityCell.activityImage.image = _headerImage;
        }
        
        return launchImageActivityCell;
    }else{
        JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *str = _titleArray[indexPath.section];
        [launchActivityCell configTitlesString:str[indexPath.row]];
        
        [launchActivityCell configContionsStringWhitModel:self.model andIndexPath:indexPath];
        
        return launchActivityCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            //时间选择
            DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
            [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                if (indexPath.row == 0) {
                    [self.model setValue:dateStr forKey:@"startDate"];
                }else{
                    [self.model setValue:dateStr forKey:@"endDate"];
                }
                
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:dataCtrl animated:YES];
        }else{
            //地区选择
            TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
            areaVc.teamType = @10;
            areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
                [self.model setValue:[NSString stringWithFormat:@"%@-%@", strPro, strCity] forKey:@"activityAddress"];
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:areaVc animated:YES];
        }
    }else if (indexPath.section == 2){
        JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
        
        concentTextCtrl.itemText = @"内容";
        concentTextCtrl.delegate = self;
        [self.navigationController pushViewController:concentTextCtrl animated:YES];
    }
    
    [self.launchActivityTableView reloadData];
}

#pragma mark --添加活动头像－－JGHTeamActivityImageCellDelegate 
-(void)didSelectPhotoImage{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                [self.launchActivityTableView reloadData];
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                [self.launchActivityTableView reloadData];
            }
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}
#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    [self.model setValue:text forKey:@"activityInfo"];
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
