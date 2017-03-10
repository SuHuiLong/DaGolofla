//
//  AddNoteViewController.m
//  DagolfLa
//
//  Created by 東 on 16/4/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "AddNoteViewController.h"
#import "PostDataRequest.h"

#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"

#import "PersonHomeController.h"

@interface AddNoteViewController ()

@property (nonatomic, strong)UIImageView *iconV;
@property (nonatomic, strong)UILabel *nameLB;
@property (nonatomic, strong)UILabel *nickName;
@property (nonatomic, strong)UILabel *state;
@property (nonatomic, strong)NSMutableDictionary *updateDic;
@property (nonatomic, strong)UITextField *nameTF;
@property (nonatomic, strong)UITextField *phoneNumberTF;
@property (nonatomic, strong)UITextView *describeTV;
@property (nonatomic, strong)UIView *infoView;
@property (nonatomic, strong)UIButton *btn ;


@end

@implementation AddNoteViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NoteModel *newModle = [NoteHandlle selectNoteWithUID:self.otherUid];
//    if ([newModle.userremarks isEqualToString:@"(null)"] || [newModle.userremarks isEqualToString:@""] || newModle.userremarks == nil) {
//    }else{
//        self.nameTF.text = newModle.userremarks;
//        self.nameLB.text = newModle.userremarks;
//    }
    
//    if ([newModle.userMobile isEqualToString:@"(null)"] || [newModle.userMobile isEqualToString:@""] || newModle.userMobile == nil) {
//    }else{
//        self.phoneNumberTF.text = newModle.userMobile;
//    }
    
//    if ([newModle.userSign isEqualToString:@"(null)"] || [newModle.userSign isEqualToString:@""] || newModle.userSign == nil) {
//    }else{
//        self.describeTV.text = newModle.userSign;
//    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [dic setObject:self.otherUid forKey:@"otherUserId"];
    [[PostDataRequest sharedInstance] postDataRequest:@"user/queryByIds.do" parameter:dic success:^(id respondsData) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dataDic objectForKey:@"success"] boolValue]) {
            NSDictionary *dicModel = [dataDic objectForKey:@"rows"];
            [self.iconV sd_setImageWithURL:[Helper imageIconUrl:[dicModel objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"moren.jpg"]];

            
            self.nickName.text = [NSString stringWithFormat:@"昵称：%@",[dicModel objectForKey:@"userName"]] ;
            
            if (![[dicModel objectForKey:@"userSign"] isEqual:[NSNull null]]) {
                self.state.text = [dicModel objectForKey:@"userSign"];
            }
        }
    } failed:^(NSError *error) {
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightB = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(complete)];
    rightB.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightB;
    
    [self creatUI];
    
    // Do any additional setup after loading the view.
}

- (void)complete{
    
    [self.updateDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [self.updateDic setObject:self.otherUid forKey:@"otherUserId"];
    [self.updateDic setObject:self.nameTF.text forKey:@"userremarks"];
    [self.updateDic setObject:self.phoneNumberTF.text forKey:@"userMobile"];
    [self.updateDic setObject:self.describeTV.text forKey:@"userSign"];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/updateUserRemarks.do" parameter:self.updateDic success:^(id respondsData) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dic objectForKey:@"success"]) {
            
//            NoteModel *model = [[NoteModel alloc] init];
//            model.userremarks = self.nameTF.text;
//            model.userMobile = self.phoneNumberTF.text;
//            model.userSign = self.describeTV.text;
//            model.otherUserId = self.otherUid;
//            NoteModel *newModle = [NoteHandlle selectNoteWithUID:self.otherUid];
//            if (newModle.userremarks || newModle.userMobile || newModle.userSign) {
//                [NoteHandlle updateNoteWithUID:self.otherUid newInfo:model];
//            }else{
//                [NoteHandlle insertNote:model];
//            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {
        
    }];
    
    
    
}

- (void)creatUI{
    

    self.iconV = [[UIImageView alloc] initWithFrame:CGRectMake(15 * ScreenWidth / 375, 15 * ScreenWidth / 375, 80 * ScreenWidth / 375, 80 * ScreenWidth / 375)];
    self.iconV.backgroundColor = [UIColor cyanColor];
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 8 * ScreenWidth / 375;
    [self.view addSubview:self.iconV];
    
    self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(120 * ScreenWidth / 375, 20 * ScreenWidth / 375, 120 * ScreenWidth / 375, 20 * ScreenWidth / 375)];
    [self.view addSubview:self.nameLB];
    
    self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(120 * ScreenWidth / 375, 50 * ScreenWidth / 375, 150 * ScreenWidth / 375, 16 * ScreenWidth / 375)];
    self.nickName.font = [UIFont systemFontOfSize:18 * ScreenWidth / 375];
    [self.view addSubview:self.nickName];
    
    self.state = [[UILabel alloc] initWithFrame:CGRectMake(120 * ScreenWidth / 375, 80 * ScreenWidth / 375, ScreenWidth - 120 * ScreenWidth / 375, 16 * ScreenWidth / 375)];
    self.state.font = [UIFont systemFontOfSize:18 * ScreenWidth / 375];
    [self.view addSubview:self.state];
    
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 100 * ScreenWidth / 375, ScreenWidth, _isInfo ? 40 * ScreenWidth / 375 : 0)];
    self.infoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    [self.infoView addGestureRecognizer:tapG];
    [self.view addSubview:self.infoView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _isInfo ? 10 * ScreenWidth / 375 : 0)];
    lineView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.infoView addSubview:lineView];
    
    UILabel *infLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * ScreenWidth / 375, ScreenWidth, _isInfo ? 30 * ScreenWidth / 375 : 0)];
    infLB.text =@" 查看个人主页";
    [self.infoView addSubview:infLB];
    
    
    
    
    
    
    UILabel *noteLB = [[UILabel alloc] initWithFrame:CGRectMake(0, _isInfo ? 140 * ScreenWidth / 375 : 100 * ScreenWidth / 375, ScreenWidth, 30 * ScreenWidth / 375)];
    noteLB.text = @" 备注";
    noteLB.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:noteLB];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, _isInfo ? 170 * ScreenWidth / 375 : 130 * ScreenWidth / 375, ScreenWidth, 30 * ScreenWidth / 375)];
    self.nameTF.placeholder = @"请输入备注名";
    [self.view addSubview:self.nameTF];
    
    self.phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(0, _isInfo ? 200 * ScreenWidth / 375 : 160 * ScreenWidth / 375, ScreenWidth, 30 * ScreenWidth / 375)];
    self.phoneNumberTF.placeholder = @"请输入电话号码";
    self.phoneNumberTF.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneNumberTF];
    
    UILabel *otherLB = [[UILabel alloc] initWithFrame:CGRectMake(0, _isInfo ? 230 * ScreenWidth / 375 : 190 * ScreenWidth / 375, ScreenWidth, 30 * ScreenWidth / 375)];
    otherLB.text = @" 其他信息";
    otherLB.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:otherLB];
    
    self.describeTV = [[UITextView alloc] initWithFrame:CGRectMake(0, _isInfo ? 260 * ScreenWidth / 375 : 220 * ScreenWidth / 375, ScreenWidth, 160 * ScreenWidth / 375)];
    self.describeTV.font = [UIFont systemFontOfSize:18 * ScreenWidth / 375];
    [self.view addSubview:self.describeTV];

    UIView *grayV = [[UIView alloc] initWithFrame:CGRectMake(0,  _isInfo ? 420 * ScreenWidth / 375 : 380 * ScreenWidth / 375, ScreenWidth, ScreenHeight - 380 * ScreenWidth / 375)];
    grayV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:grayV];;
    
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ScreenWidth / 375, _isInfo ? 440 * ScreenWidth / 375 : 410 * ScreenWidth / 375, ScreenWidth - 20 * ScreenWidth / 375, 50 * ScreenWidth / 375)];
    [self.btn setBackgroundColor:[UIColor orangeColor]];
//    [btn setBackgroundColor:[UIColor colorWithRed:0.96 green:0.60 blue:0.19 alpha:1]];
    
    if (_isFollow) {
        [self.btn setTitle:@"球友" forState:(UIControlStateNormal)];
    }else{
        [self.btn setTitle:@"加球友" forState:(UIControlStateNormal)];
    }
    [self.btn addTarget:self action:@selector(addFriend) forControlEvents:(UIControlEventTouchUpInside)];
    self.btn.layer.cornerRadius = 5.0;
    [self.view addSubview:self.btn];
}

- (void)personInfo{
    
    PersonHomeController *datailVc = [[PersonHomeController alloc] init];
    datailVc.strMoodId = self.otherUid;
    [self.navigationController pushViewController:datailVc animated:YES];
}

- (void)addFriend{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [dic setValue:self.otherUid forKey:@"otherUserId"];

    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/saveFollow.do" parameter:dic success:^(id respondsData) {

        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];

        if ([[userData objectForKey:@"success"] boolValue]) {
            [self.btn setTitle:@"球友" forState:UIControlStateNormal];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } failed:^(NSError *error) {

    }];

}


- (NSMutableDictionary *)updateDic{
    if (!_updateDic) {
        _updateDic = [[NSMutableDictionary alloc] init];
    }
    return _updateDic;
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
