//
//  JGCreateTeamViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGCreateTeamViewController.h"
#import "JGCreateTeamView.h"
#import "JGTeamDetailViewController.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGHConcentTextViewController.h"
#import "JGTeamDetail.h"

@interface JGCreateTeamViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, JGHConcentTextViewControllerDelegate>
@property (nonatomic, strong)JGCreateTeamView *creatTeamV;
@property (nonatomic, strong)JGTeamDetail *teamDetailModel;
@property (nonatomic, strong)NSMutableDictionary *paraDic;

@end

@implementation JGCreateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建球队";
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    
    self.creatTeamV = [[JGCreateTeamView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.creatTeamV];
    [self.creatTeamV.previewBtn addTarget:self action:@selector(preview) forControlEvents:(UIControlEventTouchUpInside)];
    [self.creatTeamV.addIconBtn addTarget:self action:@selector(usePhonePhotoAndCamera) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *dateBtn = [self.creatTeamV viewWithTag:200];
    [dateBtn addTarget:self action:@selector(dateBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton *areaBtn = [self.creatTeamV viewWithTag:201];
    [areaBtn addTarget:self action:@selector(area:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.creatTeamV.teamIntroduBtn addTarget:self action:@selector(intro) forControlEvents:(UIControlEventTouchUpInside)];
    // Do any additional setup after loading the view.
}

// 预览
- (void)preview{


    self.teamDetailModel.userName = @"Jay";
    self.teamDetailModel.userMobile = @"911";
    self.teamDetailModel.check = 0;
    
    JGTeamDetailViewController *detailV = [[JGTeamDetailViewController alloc] init];
    [detailV.teamDetailModel setValuesForKeysWithDictionary:self.paraDic];

    [self.paraDic setObject:self.creatTeamV.teamNmaeTV.text forKey:@"name"];

    [self.paraDic setObject:@"AAA" forKey:@"notice"];
    [self.paraDic setObject:@1 forKey:@"check"];
    [self.paraDic setObject:@"iOS" forKey:@"userName"];
    [self.paraDic setObject:@"110" forKey:@"userMobile"];
    [self.paraDic setObject:@"244" forKey:@"createUserKey"];

    [[JsonHttp jsonHttp] httpRequest:@"team/createTeam" JsonKey:@"team" withData:self.paraDic requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"error");
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"LB" forKey:@"name"];
    [dic setObject:@"AAA" forKey:@"crtyName"];
    [dic setObject:@"AAA" forKey:@"info"];
    [dic setObject:@"AAA" forKey:@"notice"];
    [dic setObject:@1 forKey:@"check"];
    [dic setObject:@"userName" forKey:@"userName"];
    [dic setObject:@"110" forKey:@"userMobile"];
    [dic setObject:@"244" forKey:@"createUserKey"];

    [[JsonHttp jsonHttp] httpRequest:@"team/createTeam" JsonKey:@"team" withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"error");
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
    
    [self.navigationController pushViewController:detailV animated:YES];
}

- (void)intro{
    JGHConcentTextViewController *introVC = [[JGHConcentTextViewController alloc] init];
    introVC.delegate = self;
    [self.navigationController pushViewController:introVC animated:YES];
}
// 代理方法
- (void)didSelectSaveBtnClick:(NSString *)text{
    
    [self.paraDic setObject:text forKey:@"info"];

}


- (void)dateBtn: (UIButton *)button{
    //日期选择
    DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
    dateVc.typeIndex = @1;
    [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
        
        NSArray* arr = [dateWeek componentsSeparatedByString:@"  "];
        
        [button setTitle:[NSString stringWithFormat:@"成立日期          %@,%@",dateStr,arr[1]] forState:(UIControlStateNormal)];
        
        NSString *datestring = [NSString stringWithFormat:@"%@", dateStr];
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        [dm setDateFormat:@"yyyy-MM-dd"];
        NSDate * newdate = [dm dateFromString:datestring];
        [self.paraDic setObject:[NSString stringWithFormat:@"%f", [newdate timeIntervalSince1970]] forKey:@"createtime"];
        //        NSDate *minu = [NSDate dateWithTimeInterval:+(24*60*60) sinceDate:newdate];

    }];
    [self.navigationController pushViewController:dateVc animated:YES];
}

//将时间戳转换成NSDate,加上时区偏移。这个转换之后是北京时间
-(NSDate*)zoneChange:(NSString*)spString
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    NSLog(@"%@",localeDate);
    return localeDate;
}


- (void)area:(UIButton *)btn{
    //地区选择
    TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
    areaVc.teamType = @10;
    areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
        [btn setTitle:[NSString stringWithFormat:@"所在地区          %@,%@", strPro, strCity] forState:(UIControlStateNormal)];

        [self.paraDic setObject:[NSString stringWithFormat:@"%@ %@", strPro, strCity] forKey:@"crtyName"];

    };
    [self.navigationController pushViewController:areaVc animated:YES];
    
}



#pragma mark - 调用手机相机和相册
- (void)usePhonePhotoAndCamera {
    
    UIActionSheet *selestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    
    [selestSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self usePhonCamera];
    }else if (buttonIndex == 1) {
        [self usePhonePhoto];
    }
}

#pragma mark - 调用相机
- (void)usePhonCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 调用相册
- (void)usePhonePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.creatTeamV.addIconBtn setImage:image forState:(UIControlStateNormal)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (JGTeamDetail *)teamDetailModel{
    if (!_teamDetailModel) {
        _teamDetailModel = [[JGTeamDetail alloc] init];
    }
    return _teamDetailModel;
}

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
