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

@interface JGHPersonalInfoViewController ()
{
    NSString *_handImgUrl;
    
    NSInteger _state;//好友状态
}

@property (nonatomic, retain)NSMutableArray *momentsPicList;

@property (nonatomic, retain)JGHUserModel *model;

@property (nonatomic, retain)UIButton *submitBtn;

@property (nonatomic, retain)UIView *dynamicImageView;

@end

@implementation JGHPersonalInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
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
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserMainInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [LQProgressHud hide];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
            userDict = [data objectForKey:@"user"];
            [self.model setValuesForKeysWithDictionary:userDict];
            
            _handImgUrl = [data objectForKey:@"handImgUrl"];
            
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_handImgUrl] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];

            [self.dynamicImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            if ([data objectForKey:@"momentsPicList"]) {
                self.momentsPicList = [data objectForKey:@"momentsPicList"];
                for (int i=0; i<self.momentsPicList.count; i++) {
                    UIImageView *dynImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*64*ProportionAdapter + i*10*ProportionAdapter, 0, 64*ProportionAdapter, 64*ProportionAdapter)];
                    [dynImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.momentsPicList[i] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    [self.dynamicImageView addSubview:dynImageView];
                }
            }
            
            if ([data objectForKey:@"userFriend"]) {
                
            }else{
                _state = 0;
                
                self.name.text = [NSString stringWithFormat:@"%@", _model.userName];
                [self.submitBtn setTitle:@"加好友" forState:UIControlStateNormal];
                self.nickname.text = @"";
                self.nick.text = @"";
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
    [oneView addSubview:self.headerImageView];
    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
    self.name.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.name.text = @"";
    [oneView addSubview:self.name];
    
    self.sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180 *ProportionAdapter, 12 *ProportionAdapter, 15 *ProportionAdapter, 15 *ProportionAdapter)];
    self.sexImageView.image = [UIImage imageNamed:@"xb_nn"];
    [oneView addSubview:self.sexImageView];
    
    //昵称
    self.nick = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter)];
    self.nick.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nick.text = @"昵称";
    [oneView addSubview:self.nick];
    
    self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 40 *ProportionAdapter, screenWidth -140*ProportionAdapter, 15 *ProportionAdapter)];
    self.nickname.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nickname.text = @"";
    [oneView addSubview:self.nickname];
    
    //差点
    UILabel *alm = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 60 *ProportionAdapter, 40 *ProportionAdapter, 15 *ProportionAdapter)];
    alm.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    alm.text = @"差点";
    [oneView addSubview:alm];
    
    self.almost = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 65 *ProportionAdapter, 100 *ProportionAdapter, 15 *ProportionAdapter)];
    self.almost.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.almost.text = @"";
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
    
    UIImageView *noteArrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-20*ProportionAdapter, 18 *ProportionAdapter, 10 *ProportionAdapter, 14*ProportionAdapter)];
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
    
    UIImageView *dynamicarrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter, 35*ProportionAdapter, 10*ProportionAdapter, 14 *ProportionAdapter)];
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
    
    UIImageView *footprintarrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter, 95*ProportionAdapter, 10*ProportionAdapter, 14 *ProportionAdapter)];
    footprintarrow.image = [UIImage imageNamed:@")"];
    [self.dynamicView addSubview:footprintarrow];
    
    UIButton *footprintBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 86 *ProportionAdapter, screenWidth, 45*ProportionAdapter)];
    [footprintBtn addTarget:self action:@selector(footprintBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicView addSubview:footprintBtn];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 400 *ProportionAdapter, screenWidth -20 *ProportionAdapter, 50 *ProportionAdapter)];
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
    noteCtrl.blockRereshNote = ^(NSString *note){
        _model.userName = note;
        
    };
    [self.navigationController pushViewController:noteCtrl animated:YES];
    btn.userInteractionEnabled = YES;
}

#pragma mark -- 动态
- (void)dynamicBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    
    
    btn.userInteractionEnabled = YES;
}

#pragma mark -- 足迹
- (void)footprintBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    
    
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 加好友、发送消息、通过验证
- (void)submitBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    if (_state == 0) {
        //
    }else if (_state == 1){
        //
        
    }else{
        //
        
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
