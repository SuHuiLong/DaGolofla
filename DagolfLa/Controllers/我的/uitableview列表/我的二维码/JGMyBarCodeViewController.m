//
//  JGMyBarCodeViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMyBarCodeViewController.h"
#import "UITool.h"
#import "PostDataRequest.h"
@interface JGMyBarCodeViewController ()

@end

@implementation JGMyBarCodeViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的二维码";
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [self createView];
    
}


-(void)createView
{
    UIView* viewBack = [[UIView alloc]initWithFrame:CGRectMake(15*screenWidth/375, 25*screenWidth/375, screenWidth - 30*screenWidth/375, screenHeight - 77*screenWidth/375 - 64)];
    viewBack.backgroundColor = [UIColor whiteColor];
    viewBack.layer.cornerRadius = 8*screenWidth/375;
    viewBack.layer.masksToBounds = YES;
    [self.view addSubview:viewBack];
    
    
    
    
    UIImageView* imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 30*screenWidth/375, 60*screenWidth/375, 60*screenWidth/375)];
    [viewBack addSubview:imgvIcon];
    imgvIcon.layer.cornerRadius = 6*screenWidth/375;
    imgvIcon.layer.masksToBounds = YES;
    [imgvIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[DEFAULF_USERID integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    /**
     
     */
    UIImageView* imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(80*screenWidth/375, 54*screenWidth/375, 14*screenWidth/375, 17*screenWidth/375)];
    [viewBack addSubview:imgvSex];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] == 0) {
        imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/375, 30*screenWidth/375, 200*screenWidth/375, 60*screenWidth/375)];
    labelName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    labelName.font = [UIFont systemFontOfSize:20*screenWidth/375];
    [viewBack addSubview:labelName];
    
    
    
    
    UIImageView* imgvBar = [[UIImageView alloc]initWithFrame:CGRectMake(viewBack.frame.size.width/2 - 125*screenWidth/375, 130*screenWidth/375, 250*screenWidth/375, 250*screenWidth/375)];
    [viewBack addSubview:imgvBar];
//    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(imgvBar.frame.size.width / 2 - 30, imgvBar.frame.size.height / 2 - 30, 60*screenWidth/375, 60*screenWidth/375)];
//    [imgvBar addSubview:imageV];
//    imageV.layer.cornerRadius = 6*screenWidth/375;
//    imageV.layer.masksToBounds = YES;
//    [imageV sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[DEFAULF_USERID integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
//    //添加边框
//    CALayer * layer = [imageV layer];
//    layer.borderColor = [[UIColor whiteColor] CGColor];
//    layer.borderWidth = 2.0f;
    NSString* strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%tddagolfla.com",[DEFAULF_USERID integerValue] ]];
    //清楚缓存
    NSString *bgUrl = [NSString stringWithFormat:@"http://mobile.dagolfla.com/qcode/userQCode?userKey=%@&md5=%@",DEFAULF_USERID,strMd];
    
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
    
    
    NSString* strUrl = [NSString stringWithFormat:@"http://mobile.dagolfla.com/qcode/userQCode?userKey=%@&md5=%@",DEFAULF_USERID,strMd];
    [imgvBar sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:TeamBGImage]];

    
    UILabel* labelSign = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, viewBack.frame.size.height - 70*screenWidth/375, viewBack.frame.size.width - 20*screenWidth/375, 40*screenWidth/375)];
    labelSign.text = @"扫一扫图上二维码，添加好友。";
    labelSign.font = [UIFont systemFontOfSize:20*screenWidth/375];
    labelSign.textAlignment = NSTextAlignmentCenter;
    [viewBack addSubview:labelSign];
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
