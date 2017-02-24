//
//  JGDPersonalCard.m
//  DagolfLa
//
//  Created by 東 on 17/2/22.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPersonalCard.h"

@interface JGDPersonalCard () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *pointTF; // 差点
@property (nonatomic, strong) UIButton *industryBtn; // 行业
@property (nonatomic, strong) UITextField *industryTF; // 行业
@property (nonatomic, strong) UIButton *isUseJGBtn;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UITableView *industryTable;


@property (nonatomic, assign) BOOL isUerJG;

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) SXPickPhoto * pickPhoto;//相册类

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSMutableArray *picImageArray;

@end

@implementation JGDPersonalCard

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        
        _pickPhoto = [[SXPickPhoto alloc]init];

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(13 * ProportionAdapter,50 * ProportionAdapter, screenWidth - 26 * ProportionAdapter, 477 * ProportionAdapter)];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 8 * ProportionAdapter;
        self.backView.clipsToBounds = YES;
        [self addSubview:self.backView];
        
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 26 * ProportionAdapter, 133 * ProportionAdapter)];
        imageView.image = [UIImage imageNamed:@"personalCardBG"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.backView addSubview:imageView];
        
        NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[DEFAULF_USERID integerValue]];
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - 26 * ProportionAdapter)/2 - 66 * ProportionAdapter / 2, 133 * ProportionAdapter - 66 * ProportionAdapter / 2, 66 * ProportionAdapter, 66 * ProportionAdapter)];
        [iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:bgUrl] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"bg_photo"]];
        iconBtn.layer.cornerRadius = 66 * ProportionAdapter / 2;
        iconBtn.clipsToBounds = YES;
        iconBtn.layer.borderWidth = 1.5 * ProportionAdapter;
        iconBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.backView addSubview:iconBtn];
        iconBtn.contentMode = UIViewContentModeScaleAspectFill;
        [iconBtn addTarget:self action:@selector(changeIcon:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIButton *removeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        removeBtn.frame = CGRectMake(screenWidth - 66 * ProportionAdapter, 13 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter);
        [removeBtn setImage:[UIImage imageNamed:@"date_close"] forState:(UIControlStateNormal)];
        [removeBtn addTarget:self action:@selector(removeAct) forControlEvents:(UIControlEventTouchUpInside)];
        [removeBtn setTintColor:[UIColor whiteColor]];
        
        [self.backView addSubview:removeBtn];
        
        
        self.maleBtn = [[UIButton alloc] initWithFrame:CGRectMake(65.5 * ProportionAdapter, 175 * ProportionAdapter, 80 * ProportionAdapter, 37 * ProportionAdapter)];
        [self.maleBtn setImage:[UIImage imageNamed:@"icn_men_color"] forState:(UIControlStateNormal)];
        [self.maleBtn setTitle:@"男" forState:(UIControlStateNormal)];
        [self.maleBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [self.maleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15 * ProportionAdapter, 0, 0)];
        [self.maleBtn addTarget:self action:@selector(changeMaleAct:) forControlEvents:(UIControlEventTouchUpInside)];
        self.maleBtn.tag = 200;
        [self.backView addSubview:self.maleBtn];
        
        
        self.femaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(212.5 * ProportionAdapter, 175 * ProportionAdapter, 80 * ProportionAdapter, 37 * ProportionAdapter)];
        [self.femaleBtn setImage:[UIImage imageNamed:@"icn_women_nocolor"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitle:@"女" forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleColor:[UIColor colorWithHexString:@"#d2d2d2"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15 * ProportionAdapter, 0, 0)];
        [self.femaleBtn addTarget:self action:@selector(changeMaleAct:) forControlEvents:(UIControlEventTouchUpInside)];
        self.femaleBtn.tag = 201;
        [self.backView addSubview:self.femaleBtn];
        
        
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 227 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        self.nameTF.placeholder = @"请输入您的个性昵称";
        self.nameTF.borderStyle = UITextBorderStyleRoundedRect;
        self.nameTF.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [self.backView addSubview:self.nameTF];
        
        self.pointTF = [[UITextField alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 277 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        self.pointTF.placeholder = @"请输入您的差点";
        self.pointTF.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.pointTF.borderStyle = UITextBorderStyleRoundedRect;
        self.pointTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.backView addSubview:self.pointTF];
        
        
        
        self.industryTF = [[UITextField alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 326 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        self.industryTF.placeholder = @"请选择您的行业";
        self.industryTF.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.industryTF.borderStyle = UITextBorderStyleRoundedRect;
        [self.backView addSubview:self.industryTF];
        
        self.industryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.industryBtn setImage:[UIImage imageNamed:@"icn_show_arrowup"] forState:(UIControlStateNormal)];
        [self.industryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 250 * ProportionAdapter, 0, 0)];
        [self.industryBtn addTarget:self action:@selector(indstryAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.industryTF addSubview:self.industryBtn];
        
        
        self.isUseJGBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 370 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.isUseJGBtn setImage:[UIImage imageNamed:@"icn_register"] forState:(UIControlStateNormal)];
        [self.isUseJGBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 220 * ProportionAdapter)];
        self.isUseJGBtn.titleLabel.font = [UIFont systemFontOfSize:11 * ProportionAdapter];
        [self.isUseJGBtn setTitle:@"使用君高差点管理系统,根据您的记分自动更新差点" forState:(UIControlStateNormal)];
        [self.isUseJGBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        [self.isUseJGBtn addTarget:self action:@selector(isJGSystemAct:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.backView addSubview:self.isUseJGBtn];
        
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 420 * ProportionAdapter, screenWidth - 106 * ProportionAdapter, 33 * ProportionAdapter)];
        self.commitBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
        self.commitBtn.layer.cornerRadius = 6 * ProportionAdapter;
        self.commitBtn.clipsToBounds = YES;
        [self.commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        [self.commitBtn addTarget:self action:@selector(commitAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.backView addSubview:self.commitBtn];
        
        if ([[user objectForKey:@"sex"] integerValue] == 0) {
            [self changeMaleAct:self.femaleBtn];
        }
        
        if ([user objectForKey:@"userName"]) {
            self.nameTF.text = [user objectForKey:@"userName"];
        }
        
        if ([user objectForKey:@"almost"] && ([[user objectForKey:@"almost"] integerValue] != -10000)) {
            self.pointTF.text = [NSString stringWithFormat:@"%@" ,[user objectForKey:@"almost"]];
        }
        
        if ([user objectForKey:@"workName"]) {
            self.industryTF.text = [user objectForKey:@"workName"];
        }
        
        if ([[user objectForKey:@"almost_system_setting"] integerValue] == 0) {
            [self.isUseJGBtn setImage:[UIImage imageNamed:@"icn_registerlay"] forState:(UIControlStateNormal)];
            self.isUerJG = NO;
        }else{
            self.isUerJG = YES;
        }
        
        
    }
    return self;
}

- (void)changeMaleAct:(UIButton *)btn{
    
    if (btn.tag == 200) {
        [self.dataDic setObject:@1 forKey:@"sex"];
        [self.maleBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        [self.maleBtn setImage:[UIImage imageNamed:@"icn_men_color"] forState:(UIControlStateNormal)];
        
        [self.femaleBtn setImage:[UIImage imageNamed:@"icn_women_nocolor"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleColor:[UIColor colorWithHexString:@"#d2d2d2"] forState:(UIControlStateNormal)];
        
    }else{
        [self.dataDic setObject:@0 forKey:@"sex"];
        [self.maleBtn setTitleColor:[UIColor colorWithHexString:@"#d2d2d2"] forState:(UIControlStateNormal)];
        [self.maleBtn setImage:[UIImage imageNamed:@"icn_men_nocolor"] forState:(UIControlStateNormal)];
        
        [self.femaleBtn setImage:[UIImage imageNamed:@"icn_women_color"] forState:(UIControlStateNormal)];
        [self.femaleBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        
    }
}

#pragma mark --  提交

- (void)commitAct{
    
    
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
    
    // - -
    
    if (self.nameTF.text) {
        [self.dataDic setObject:self.nameTF.text forKey:@"userName"];
    }
    
    if (self.pointTF.text) {
        [self.dataDic setObject:self.pointTF.text forKey:@"almost"];
    }
    
    if (self.industryTF.text) {
        [self.dataDic setObject:self.industryTF.text forKey:@"workName"];
    }
    
    [self.dataDic setObject:DEFAULF_USERID forKey:@"userId"];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self];
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"user/doPerfectUserInfo" JsonKey:nil withData:self.dataDic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self removeFromSuperview];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}

- (void)isJGSystemAct:(UIButton *)btn{
    
    if (self.isUerJG) {
        self.isUerJG = NO;
        [self.dataDic setObject:@0 forKey:@"almost_system_setting"];
        [btn setImage:[UIImage imageNamed:@"icn_registerlay"] forState:(UIControlStateNormal)];
    }else{
        self.isUerJG = YES;
        [self.dataDic setObject:@1 forKey:@"almost_system_setting"];
        [self.isUseJGBtn setImage:[UIImage imageNamed:@"icn_register"] forState:(UIControlStateNormal)];
    }
    
}

- (void)removeAct{
    [self removeFromSuperview];
}

- (void)indstryAct{
    
    if ([self.backView.subviews containsObject:self.industryTable]) {
        [self.industryTable removeFromSuperview];
        
    }else{
        [self.backView addSubview:self.industryTable];
        
    }
}

- (void)changeIcon:(UIButton *)btn{
    
    
    UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto ShowTakePhotoWithController:self.controller andWithBlock:^(NSObject *Data) {
            self.picImageArray = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [btn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto SHowLocalPhotoWithController:alertWindow.rootViewController andWithBlock:^(NSObject *Data) {
            self.picImageArray = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [btn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
            
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:nil message:@"选择头像" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [alertWindow.rootViewController presentViewController:aleVC animated:YES completion:nil];
}

- (UITableView *)industryTable{
    if (!_industryTable) {
        _industryTable = [[UITableView alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 353 * ProportionAdapter, screenWidth - 86 * ProportionAdapter, 121 * ProportionAdapter)];
        _industryTable.delegate = self;
        _industryTable.dataSource = self;
        [_industryTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _industryTable.rowHeight = 30 * ProportionAdapter;
        _industryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _industryTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card"]];
    }
    return _industryTable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.industryTF.text = self.dataArray[indexPath.row];
    [self.industryTable removeFromSuperview];
}

- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://res.dagolfla.com/download/json/industry.json"];
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error1 = nil;
        
        if (data) {
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
            for (NSDictionary *dic in [dataDic objectForKey:@"-1"]) {
                [_dataArray addObject:[dic objectForKey:@"name"]];
            }
        }
    }
    return _dataArray;
}

//- (UIViewController *) controller
//{
//    if (!_controller) {
//        UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        alertWindow.rootViewController = [[UIViewController alloc] init];
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        [alertWindow makeKeyAndVisible];
//        [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
//    }
//    return _controller;
//
//}

- (NSMutableArray *)picImageArray{
    if (!_picImageArray) {
        _picImageArray = [[NSMutableArray alloc] init];
    }
    return _picImageArray;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
