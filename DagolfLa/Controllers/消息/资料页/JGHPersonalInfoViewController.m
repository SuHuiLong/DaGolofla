//
//  JGHPersonalInfoViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPersonalInfoViewController.h"
#import "JGHUserModel.h"
#import "JGHNoteViewController.h"
#import "SXPickPhoto.h"
#import "ChatDetailViewController.h"
#import "JGAddFriendViewController.h"
#import "PersonHomeController.h"

#import "JGAddFriendViewController.h"

@interface JGHPersonalInfoViewController ()
{
    NSString *_handImgUrl;
    
    NSInteger _state;//好友状态
    
    UIImage *_headerImage;
    
    NSString *_userFriendTimeKey;//关系Key
}

@property (nonatomic, retain)NSMutableArray *momentsPicList;

@property (nonatomic, retain)JGHUserModel *model;

@property (nonatomic, retain)UIButton *submitBtn;

@property (nonatomic, retain)UIView *dynamicImageView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation JGHPersonalInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"个人信息";
    self.momentsPicList = [NSMutableArray array];
    self.model = [[JGHUserModel alloc]init];
    
    [self createView];
    
    [self loadData];
}
- (void)loadData{
    [LQProgressHud showLoading:@"加载中..."];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_otherKey forKey:@"seeUserKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&seeUserKey=%@dagolfla.com", DEFAULF_USERID, _otherKey]] forKey:@"md5"];

    [[JsonHttp jsonHttp]httpRequest:@"user/getUserMainInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType){
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [LQProgressHud hide];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
            userDict = [data objectForKey:@"user"];
            [self.model setValuesForKeysWithDictionary:userDict];
            
            _handImgUrl = [data objectForKey:@"handImgUrl"];
            
            [[SDImageCache sharedImageCache] removeImageForKey:_handImgUrl fromDisk:YES];

            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_handImgUrl] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];

            [self.dynamicImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            if ([data objectForKey:@"momentsPicList"]) {
                self.momentsPicList = [data objectForKey:@"momentsPicList"];
                for (int i=0; i<self.momentsPicList.count; i++) {
                    UIImageView *dynImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*64*ProportionAdapter + i*10*ProportionAdapter, 0, 64*ProportionAdapter, 64*ProportionAdapter)];
                    dynImageView.clipsToBounds = YES;
                    dynImageView.contentMode = UIViewContentModeScaleAspectFill;
                    
                    [dynImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.momentsPicList[i] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    [self.dynamicImageView addSubview:dynImageView];
                }
            }
            
            if ([data objectForKey:@"userFriend"]) {
                NSDictionary *userFriend = [NSDictionary dictionary];
                userFriend = [data objectForKey:@"userFriend"];
                _userFriendTimeKey = [NSString stringWithFormat:@"%@", [userFriend objectForKey:@"timeKey"]];
                NSInteger state = [[userFriend objectForKey:@"state"] integerValue];
//                if (state == -1) {
//                    //加好友
//                    [self.submitBtn setTitle:@"加球友" forState:UIControlStateNormal];
//                }else if (state == 0){
//                    //待验证
//                    [self.submitBtn setTitle:@"待验证" forState:UIControlStateNormal];
//                }else if (state == 1){
//                    //发消息
//                    [self.submitBtn setTitle:@"发消息" forState:UIControlStateNormal];
//                }else{
//                    //2 -- 拒绝
//                    [self.submitBtn setTitle:@"加球友" forState:UIControlStateNormal];
//                }
                
                if (state == 1) {
                    //发消息
                    [self.submitBtn setTitle:@"发消息" forState:UIControlStateNormal];
                }else if (state == 0){
                    [self.submitBtn setTitle:@"通过验证" forState:UIControlStateNormal];
                }else{
                    [self.submitBtn setTitle:@"加球友" forState:UIControlStateNormal];
                }
                
                _state = state;
                
                if ([userFriend objectForKey:@"remark"]) {
                    CGSize remarkSize = [[userFriend objectForKey:@"remark"] boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ProportionAdapter]} context:nil].size;
                    if ((screenWidth -remarkSize.width) <120) {
                        self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, screenWidth -120 *ProportionAdapter, 20 *ProportionAdapter);
                    }else{
                        self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, remarkSize.width, 20 *ProportionAdapter);
                    }
                    
                    self.name.text = [NSString stringWithFormat:@"%@", [userFriend objectForKey:@"remark"]];
                    
                    self.nick.frame = CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter);
                    self.nick.text = @"昵称";
                    
                    self.nickname.frame = CGRectMake(130 *ProportionAdapter, 39 *ProportionAdapter, screenWidth -140*ProportionAdapter, 17 *ProportionAdapter);
                    self.nickname.text = [NSString stringWithFormat:@"%@", _model.userName];
                    if ([_model.almost floatValue] == -10000) {
                        self.almost.text = @"差点  --";
                    }else{
                        self.almost.text = [NSString stringWithFormat:@"差点  %@", (_model.almost)?_model.almost:@"--"];
                    }
                }else{
                    CGSize nameSize = [_model.userName boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ProportionAdapter]} context:nil].size;
                    self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, nameSize.width, 20 *ProportionAdapter);
                    self.name.text = [NSString stringWithFormat:@"%@", _model.userName];
                    self.nickname.text = @"";
                    self.nick.text = @"";
                    
                    self.alm.frame = CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter);
                    self.almost.frame = CGRectMake(130 *ProportionAdapter, 40 *ProportionAdapter, screenWidth -140*ProportionAdapter, 15 *ProportionAdapter);
                    if ([_model.almost floatValue] == -10000) {
                        self.almost.text = @"差点  --";
                    }else{
                        self.almost.text = [NSString stringWithFormat:@"差点  %@", (_model.almost)?_model.almost:@"--"];
                    }
                }
                
                self.sexImageView.frame = CGRectMake(self.name.frame.origin.x +10*ProportionAdapter + self.name.frame.size.width, self.name.frame.origin.y +2*ProportionAdapter, 15*ProportionAdapter, 15*ProportionAdapter);
            }else{
                _state = -1;
                CGSize nameSize = [_model.userName boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ProportionAdapter]} context:nil].size;
                self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, nameSize.width, 20 *ProportionAdapter);
                self.name.text = [NSString stringWithFormat:@"%@", _model.userName];
                self.sexImageView.frame = CGRectMake(self.name.frame.origin.x +10*ProportionAdapter + self.name.frame.size.width, self.name.frame.origin.y +2*ProportionAdapter, 15*ProportionAdapter, 15*ProportionAdapter);
                if (_friendNew == 1) {
                    _state = 0;
                    [self.submitBtn setTitle:@"通过验证" forState:UIControlStateNormal];
                }else{
                [self.submitBtn setTitle:@"加球友" forState:UIControlStateNormal];
                }
                self.nickname.text = @"";
                self.nick.text = @"";
                
                self.alm.frame = CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter);
                self.almost.frame = CGRectMake(130 *ProportionAdapter, 40 *ProportionAdapter, screenWidth -140*ProportionAdapter, 15 *ProportionAdapter);
                if ([_model.almost floatValue] == -10000) {
                    self.almost.text = @"差点  --";
                }else{
                    self.almost.text = [NSString stringWithFormat:@"差点  %@", (_model.almost)?_model.almost:@"--"];
                }
            }
            
            if (_model.sex == 0) {
                self.sexImageView.image = [UIImage imageNamed:@"xb_n"];
            }else{
                self.sexImageView.image = [UIImage imageNamed:@"xb_nn"];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)createView{
    UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*ProportionAdapter, screenWidth, 85*ProportionAdapter)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10*ProportionAdapter, 65 *ProportionAdapter, 65 *ProportionAdapter)];
    self.headerImageView.image = [UIImage imageNamed:DefaultHeaderImage];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 5.0 *ProportionAdapter;
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIButton *headerImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65 *ProportionAdapter, 65 *ProportionAdapter)];
    [headerImageBtn addTarget:self action:@selector(headerImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerImageView addSubview:headerImageBtn];
    
    [oneView addSubview:self.headerImageView];
    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
    self.name.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.name.text = @"";
    [oneView addSubview:self.name];
    
    self.sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180 *ProportionAdapter, 14 *ProportionAdapter, 10 *ProportionAdapter, 15 *ProportionAdapter)];
    self.sexImageView.image = [UIImage imageNamed:@"xb_nn"];
    [oneView addSubview:self.sexImageView];
    
    //昵称
    self.nick = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter)];
    self.nick.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nick.text = @"昵称:";
    self.nick.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    [oneView addSubview:self.nick];
    
    self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 39 *ProportionAdapter, screenWidth -140*ProportionAdapter, 15 *ProportionAdapter)];
    self.nickname.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nickname.text = @"";
    self.nickname.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    [oneView addSubview:self.nickname];
    
    //差点
    self.alm = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 60 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter)];
    self.alm.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.alm.text = @"差点:";
    self.alm.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    [oneView addSubview:self.alm];
    
    self.almost = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 60 *ProportionAdapter, 100 *ProportionAdapter, 15 *ProportionAdapter)];
    self.almost.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.almost.text = @"";
    self.almost.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    [oneView addSubview:self.almost];
    
    //备注
    UIView *twoView = [[UIView alloc]initWithFrame:CGRectMake(0, 105 *ProportionAdapter, screenWidth, 50 *ProportionAdapter)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    UILabel *note = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10 *ProportionAdapter, 40 *ProportionAdapter, 30 *ProportionAdapter)];
    note.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    note.text = @"备注";
    [twoView addSubview:note];
    
//    UILabel *noteLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 80*ProportionAdapter, 30 *ProportionAdapter)];
//    noteLable.font = [UIFont systemFontOfSize:16*ProportionAdapter];
//    [twoView addSubview:noteLable];
    
    UIImageView *noteArrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-20*ProportionAdapter, 18 *ProportionAdapter, 8 *ProportionAdapter, 13*ProportionAdapter)];
    noteArrow.image = [UIImage imageNamed:@")"];
    [twoView addSubview:noteArrow];
    
    UIButton *noteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50 *ProportionAdapter)];
    [noteBtn addTarget:self action:@selector(noteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:noteBtn];
    
    //动态
    self.dynamicView = [[UIView alloc]initWithFrame:CGRectMake(0, 165 *ProportionAdapter, screenWidth, 130 *ProportionAdapter)];
    self.dynamicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.dynamicView];
    
    UILabel *dynamic = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10 *ProportionAdapter, 40 *ProportionAdapter, 64 *ProportionAdapter)];
    dynamic.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    dynamic.backgroundColor = [UIColor whiteColor];
    dynamic.text = @"动态";
    [self.dynamicView addSubview:dynamic];
    
    self.dynamicImageView = [[UIView alloc]initWithFrame:CGRectMake(60*ProportionAdapter, 10 *ProportionAdapter, 64*4 *ProportionAdapter +30*ProportionAdapter, 64 *ProportionAdapter)];
    self.dynamicImageView.backgroundColor = [UIColor whiteColor];
    [self.dynamicView addSubview:self.dynamicImageView];
    
    UIImageView *dynamicarrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter, 35*ProportionAdapter, 8*ProportionAdapter, 13 *ProportionAdapter)];
    dynamicarrow.image = [UIImage imageNamed:@")"];
    [self.dynamicView addSubview:dynamicarrow];
    
    UIButton *dynamicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 83 *ProportionAdapter)];
    [dynamicBtn addTarget:self action:@selector(dynamicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicView addSubview:dynamicBtn];
    
    UILabel *dynLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 84 *ProportionAdapter, screenWidth - 10 *ProportionAdapter, 1)];
    dynLine.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    [self.dynamicView bringSubviewToFront:dynLine];
    [self.dynamicView addSubview:dynLine];
    
    UILabel *footprint = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 95 *ProportionAdapter, 40 *ProportionAdapter, 20*ProportionAdapter)];
    footprint.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    footprint.text = @"足迹";
    [self.dynamicView addSubview:footprint];
    
    UIImageView *footprintarrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter, 100*ProportionAdapter, 8*ProportionAdapter, 13 *ProportionAdapter)];
    footprintarrow.image = [UIImage imageNamed:@")"];
    [self.dynamicView addSubview:footprintarrow];
    
    UIButton *footprintBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 86 *ProportionAdapter, screenWidth, 45*ProportionAdapter)];
    [footprintBtn addTarget:self action:@selector(footprintBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicView addSubview:footprintBtn];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 400 *ProportionAdapter, screenWidth -20 *ProportionAdapter, 45 *ProportionAdapter)];
    [self.submitBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = [UIColor orangeColor];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:20 *ProportionAdapter];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5.0*ProportionAdapter;
    [self.submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
}

#pragma mark -- 备注
- (void)noteBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    JGHNoteViewController *noteCtrl = [[JGHNoteViewController alloc]init];
    noteCtrl.userName = _model.userName;
    noteCtrl.blockRereshNote = ^(NSString *note){
        
        
        _personRemark(note);//返回备注到列表

        // 备注为空   取消备注
        if ([note length] > 0) {
            
            
            CGSize remarkSize = [note boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ProportionAdapter]} context:nil].size;
            if ((screenWidth -remarkSize.width) <120) {
                self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, screenWidth -120 *ProportionAdapter, 20 *ProportionAdapter);
            }else{
                self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, remarkSize.width, 20 *ProportionAdapter);
            }
            
            self.name.text = note;
            
            self.nick.frame = CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter);
            self.nick.text = @"昵称:";
            
            self.nickname.frame = CGRectMake(130 *ProportionAdapter, 39 *ProportionAdapter, screenWidth -140*ProportionAdapter, 17 *ProportionAdapter);
            self.nickname.text = [NSString stringWithFormat:@"%@", _model.userName];
            
            self.sexImageView.frame = CGRectMake(self.name.frame.origin.x +10*ProportionAdapter + self.name.frame.size.width, self.name.frame.origin.y +2*ProportionAdapter, 15*ProportionAdapter, 15*ProportionAdapter);
        
            self.alm.frame = CGRectMake(90 *ProportionAdapter, 60 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter);
            self.almost.frame = CGRectMake(130 *ProportionAdapter, 60 *ProportionAdapter, 100 *ProportionAdapter, 15 *ProportionAdapter);
            self.nick.hidden = NO;
            self.nickname.hidden = NO;

        
        }else{
            
            CGSize remarkSize = [_model.userName boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ProportionAdapter]} context:nil].size;
            
            self.name.frame = CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, remarkSize.width, 20 *ProportionAdapter);
            self.name.text = [NSString stringWithFormat:@"%@", _model.userName];

            self.sexImageView.frame = CGRectMake(self.name.frame.origin.x +10*ProportionAdapter + self.name.frame.size.width, self.name.frame.origin.y +2*ProportionAdapter, 15*ProportionAdapter, 15*ProportionAdapter);

            
            self.alm.frame = CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter);
            self.almost.frame = CGRectMake(130 *ProportionAdapter, 40 *ProportionAdapter, screenWidth -140*ProportionAdapter, 15 *ProportionAdapter);
            if ([_model.almost floatValue] == -10000) {
                self.almost.text = @"差点  --";
            }else{
                self.almost.text = [NSString stringWithFormat:@"差点  %@", (_model.almost)?_model.almost:@"--"];
            }
            
            self.nick.hidden = YES;
            self.nickname.hidden = YES;
        }

    };
    noteCtrl.friendUserKey = _model.userId;
    [self.navigationController pushViewController:noteCtrl animated:YES];
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 头像
- (void)headerImageBtn:(UIButton *)btn{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString* userKeySelf = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    NSString* otherKey = [numberFormatter stringFromNumber:_otherKey];
    
    if (![userKeySelf isEqualToString:otherKey]) {
        return;
    }
    
    btn.userInteractionEnabled = NO;
    
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                self.headerImageView.image = _headerImage;
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                //
                _headerImage = (UIImage *)Data;
                self.headerImageView.image = _headerImage;
            }
        }];
    }];
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
    
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 动态
- (void)dynamicBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    if (_state == 0 || _state == -1) {
        [[ShowHUD showHUD]showToastWithText:@"请先添加球友！" FromView:self.view];
        btn.userInteractionEnabled = YES;
        return;
    }
    
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = _otherKey;
    selfVc.messType = @2;
    selfVc.selectedIndex = 0;
    [self.navigationController pushViewController:selfVc animated:YES];
    
    btn.userInteractionEnabled = YES;
}
//
#pragma mark -- 足迹
- (void)footprintBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    if (_state == 0 || _state == -1) {
        [[ShowHUD showHUD]showToastWithText:@"请先添加球友！" FromView:self.view];
        btn.userInteractionEnabled = YES;
        return;
    }
    
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    selfVc.strMoodId = _otherKey;
    selfVc.messType = @2;
    selfVc.selectedIndex = 1;
    [self.navigationController pushViewController:selfVc animated:YES];
    
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 加好友、发送消息、通过验证
- (void)submitBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    if (_state == 1){
        
        if (_fromChat == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //好友
            ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
            //设置聊天类型
            vc.conversationType = ConversationType_PRIVATE;
            //设置对方的id
            vc.targetId = [NSString stringWithFormat:@"%@", _otherKey];
            //设置对方的名字
            //    vc.userName = model.conversationTitle;
            //设置聊天标题
            vc.title = _name.text;
            //设置不现实自己的名称  NO表示不现实
            vc.displayUserNameInCell = NO;
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        

    }else if (_state == -1){
        
        
        JGAddFriendViewController *addFriendVC = [[JGAddFriendViewController alloc] init];
        addFriendVC.otherUserKey = _otherKey;
        addFriendVC.popToVC = ^(NSInteger sendNum){
            
//            if (sendNum) {
//                [btn setTitle:@"等待验证" forState:(UIControlStateNormal)];
//                btn.enabled = NO;
//            }
        };
        
        [self.navigationController pushViewController:addFriendVC animated:YES];
        
        
//        [LQProgressHud showLoading:@"加载中..."];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:_otherKey forKey:@"friendUserKey"];
//        [dict setObject:[NSString stringWithFormat:@"我是 %@", DEFAULF_UserName] forKey:@"reason"];
//        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
//        [[JsonHttp jsonHttp]httpRequestWithMD5:@"userFriend/doApply" JsonKey:nil withData:dict failedBlock:^(id errType) {
//            [LQProgressHud hide];
//        } completionBlock:^(id data) {
//            NSLog(@"%@", data);
//            [LQProgressHud hide];
//            
//            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//                [self loadData];
//            }else{
//                if ([data objectForKey:@"packResultMsg"]) {
//                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//                }
//            }
//        }];
    }else if (_state == 0){
        [LQProgressHud showLoading:@"申请中..."];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:_otherKey forKey:@"userFriendKey"];
        [dict setObject:@1 forKey:@"state"];
        [dict setObject:_userFriendTimeKey forKey:@"userFriendKey"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"userFriend/doApplyHandle" JsonKey:nil withData:dict failedBlock:^(id errType) {
            [LQProgressHud hide];
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            [LQProgressHud hide];
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [self loadData];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
        
    }else{
        JGAddFriendViewController *addFriendVC = [[JGAddFriendViewController alloc] init];
        addFriendVC.otherUserKey = _otherKey;
        addFriendVC.popToVC = ^(NSInteger num){
            [self loadData];
        };
        [self.navigationController pushViewController:addFriendVC animated:YES];
    }
    
    btn.userInteractionEnabled = YES;
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
