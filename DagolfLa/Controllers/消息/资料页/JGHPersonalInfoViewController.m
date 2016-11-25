//
//  JGHPersonalInfoViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPersonalInfoViewController.h"
#import "JGHUserModel.h"

@interface JGHPersonalInfoViewController ()
{
    NSString *_handImgUrl;
}

@property (nonatomic, retain)NSMutableArray *momentsPicList;

@property (nonatomic, retain)JGHUserModel *model;

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
    
    [self createView];
    
    [self loadData];
}
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_otherKey forKey:@"seeUserKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&seeUserKey=%@dagolfla.com", DEFAULF_USERID, _otherKey]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserMainInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self.model setValuesForKeysWithDictionary:[data objectForKey:@"user"]];
            
            _handImgUrl = [data objectForKey:@"handImgUrl"];

            if ([data objectForKey:@"momentsPicList"]) {
                self.momentsPicList = [data objectForKey:@"momentsPicList"];
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
    [oneView addSubview:self.headerImageView];
    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 10 *ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
    self.name.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.name.text = @"风中奇缘";
    [oneView addSubview:self.name];
    
    self.sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180 *ProportionAdapter, 10 *ProportionAdapter, 15 *ProportionAdapter, 15 *ProportionAdapter)];
    self.sexImageView.image = [UIImage imageNamed:DefaultHeaderImage];
    [oneView addSubview:self.sexImageView];
    
    //昵称
    UILabel *nick = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 40 *ProportionAdapter, 30 *ProportionAdapter, 15 *ProportionAdapter)];
    nick.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    [oneView addSubview:nick];
    
    self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 40 *ProportionAdapter, screenWidth -140*ProportionAdapter, 15 *ProportionAdapter)];
    self.nickname.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nickname.text = @"Jess1494";
    [oneView addSubview:self.nickname];
    
    //差点
    UILabel *alm = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 65 *ProportionAdapter, 30 *ProportionAdapter, 15 *ProportionAdapter)];
    alm.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    alm.text = @"差点";
    [oneView addSubview:alm];
    
    self.almost = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 65 *ProportionAdapter, 100 *ProportionAdapter, 15 *ProportionAdapter)];
    self.almost.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.almost.text = @"72";
    [oneView addSubview:self.almost];
    
    //备注
    UIView *twoView = [[UIView alloc]initWithFrame:CGRectMake(0, 105 *ProportionAdapter, screenWidth, 50 *ProportionAdapter)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    UILabel *note = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10 *ProportionAdapter, 40 *ProportionAdapter, 30 *ProportionAdapter)];
    note.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    [twoView addSubview:note];
    
    UILabel *noteLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 80*ProportionAdapter, 30 *ProportionAdapter)];
    noteLable.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    [twoView addSubview:noteLable];
    
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
    
    UIImageView *dynamicarrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter, 35*ProportionAdapter, 10*ProportionAdapter, 14 *ProportionAdapter)];
    dynamicarrow.image = [UIImage imageNamed:@")"];
    [self.dynamicView addSubview:dynamicarrow];
    
    UIButton *dynamicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 84 *ProportionAdapter)];
    [dynamicBtn addTarget:self action:@selector(dynamicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicView addSubview:dynamicBtn];
    
    UILabel *dynLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 64 *ProportionAdapter, screenWidth - 10 *ProportionAdapter, 1)];
    dynamic.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    [self.dynamicView addSubview:dynLine];
    
    UILabel *footprint = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 95 *ProportionAdapter, 40 *ProportionAdapter, 20*ProportionAdapter)];
    footprint.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    footprint.text = @"足迹";
    [self.dynamicView addSubview:footprint];
    
    UIImageView *footprintarrow = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter, 95*ProportionAdapter, 10*ProportionAdapter, 14 *ProportionAdapter)];
    footprintarrow.image = [UIImage imageNamed:@")"];
    [self.dynamicView addSubview:footprintarrow];
    
    UIButton *footprintBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 85 *ProportionAdapter, screenWidth, 45*ProportionAdapter)];
    [footprintBtn addTarget:self action:@selector(footprintBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicView addSubview:footprintBtn];
}

#pragma mark -- 备注
- (void)noteBtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    
    
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
