//
//  JGTeamCreatePhotoController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamCreatePhotoController.h"
#import "SelectPhotoAsHeaderViewController.h"
#import "UITool.h"
#import "SXPickPhoto.h"

@interface JGTeamCreatePhotoController (){
    UIButton* _btnAll;
    UIButton* _btnSome;
    UIImageView* _imgvAll;
    UIImageView* _imgvSome;
    //判断球队是否公开，0：全部可见。1：球队成员
    NSInteger _isOpen;
    UITextField* _textTitle;
    
    UIImageView* _imgvChange;
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation JGTeamCreatePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UITool colorWithHexString:@"EEEEEE" alpha:1];

    _isOpen = 0;
    self.pickPhoto = [[SXPickPhoto alloc]init];
   
    
    /**
     *  创建相册名称
     */
    [self createTitle];
    /**
     *  创建相册权限设置
     */
    [self createSetting];
    /**
     *  相册管理页面 ，
     ismanage == 1 需要创建，否则不创建
     */
    if (_isManage == 1) {
        [self createManage];
        [self createDelete];
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    else
    {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    [self tipCreate];
    
}

// http://keeper.dagolfla.com

- (void)tipCreate{
    UILabel *oneLable = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight -64-80 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    oneLable.text = @"照片太多，手机上传太慢？";
    oneLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    oneLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    oneLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:oneLable];
    
    UILabel *twoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight -64-60 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    twoLable.text = @"我们提供了PC端导入工具，海量照片，一键导入！";
    twoLable.textAlignment = NSTextAlignmentCenter;
    twoLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    twoLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    [self.view addSubview:twoLable];
    
    UILabel *threeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight -64-40 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    threeLable.text = @"PC端登录地址：http://keeper.dagolfla.com";
    threeLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    //    self.baseLabel.text = [NSString stringWithFormat:@"用户本人线上支付-%.2f", price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:threeLable.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:B31_Color] range:NSMakeRange(8, threeLable.text.length-8)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    threeLable.attributedText = attributedString;
    
    threeLable.textAlignment = NSTextAlignmentCenter;
    threeLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    [self.view addSubview:threeLable];
}

#pragma mark --修改
-(void)upDataClick
{
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"正在修改...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInteger:_isOpen] forKey:@"power"];
    [dict setObject:_timeKey forKey:@"timeKey"];
    if (![Helper isBlankString:_textTitle.text]) {
        [dict setObject:[NSString stringWithFormat:@"%@",_textTitle.text] forKey:@"name"];
    }
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamAlbum" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    } completionBlock:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if ([[data objectForKey:@"packSuccess"] boolValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"修改相册信息成功" FromView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
#pragma mark --上传
-(void)saveClick
{
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"正在上传...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    if (![Helper isBlankString:_textTitle.text]) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        //    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
        [dict setObject:[Helper returnCurrentDateString] forKey:@"createTime"];
        [dict setObject:[NSNumber numberWithInteger:_isOpen] forKey:@"power"];
        [dict setObject:@0 forKey:@"timeKey"];
        [dict setObject:_teamKey forKey:@"teamKey"];
        if (![Helper isBlankString:_textTitle.text]) {
            [dict setObject:[NSString stringWithFormat:@"%@",_textTitle.text] forKey:@"name"];
        }
        
        
        
        [[JsonHttp jsonHttp]httpRequest:@"team/createTeamAlbum" JsonKey:@"teamAlbum" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        } completionBlock:^(id data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if ([[data objectForKey:@"packSuccess"] boolValue] == 1) {
                _createBlock();
                //            [Helper alertViewWithTitle:@"创建相册成功" withBlock:^(UIAlertController *alertView) {
                [self.navigationController popViewControllerAnimated:YES];
                //                [self.navigationController presentViewController:alertView animated:YES completion:nil];
                //            }];
            }
            
        }];
    }
    else
   {
       [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
       [[ShowHUD showHUD]showToastWithText:@"请填写相册名称" FromView:self.view];
   }
}
/*\
 字体 15   a0a0a0    黑色 313131
 */
-(void) createTitle
{
    
    
    UIView* viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 10*screenWidth/375, screenWidth, 45*screenWidth/375)];
    viewTitle.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTitle];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
    labelTitle.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    labelTitle.text = @"相册名称";
    labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [viewTitle addSubview:labelTitle];
    
    _textTitle = [[UITextField alloc]initWithFrame:CGRectMake(120*screenWidth/375, 1*screenWidth/375, screenWidth-130*screenWidth/375, 45*screenWidth/375)];
    _textTitle.placeholder = @"输入相册名";
    _textTitle.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    _textTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [viewTitle addSubview:_textTitle];
    if (![Helper isBlankString:_titleStr]) {
        _textTitle.text = _titleStr;
    }
  
}

#pragma mark --创建权限设置页面
-(void) createSetting
{
    UIView* viewSet = [[UIView alloc]initWithFrame:CGRectMake(0, 65*screenWidth/375, screenWidth, 45*screenWidth/375*3)];
    viewSet.backgroundColor = [UIColor whiteColor];
    viewSet.userInteractionEnabled = YES;
    [self.view addSubview:viewSet];
    
    UILabel* labelSet = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 44*screenWidth/375)];
    labelSet.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    labelSet.text = @"相册权限设置";
    labelSet.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [viewSet addSubview:labelSet];
    
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 45*screenWidth/375, screenWidth-20*screenWidth/375, 1*screenWidth/375)];
    line1.backgroundColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    [viewSet addSubview:line1];
    
    _btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAll.frame = CGRectMake(0, 45*screenWidth/375, screenWidth, 44*screenWidth/375);
    [viewSet addSubview:_btnAll];
    [_btnAll addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnAll.tag = 1001;
    
    UILabel* labelAll = [[UILabel alloc]initWithFrame:CGRectMake(40*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
    labelAll.text = @"所有人可见";
    labelAll.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [_btnAll addSubview:labelAll];
    labelAll.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    
    _imgvAll = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-50*screenWidth/375, 15*screenWidth/375, 15*screenWidth/375, 15*screenWidth/375)];
    if ([_isShowMem integerValue] == 0) {
        _imgvAll.image = [UIImage imageNamed:@"duihao"];
    }
    else if ([_isShowMem integerValue] == 1)
    {
        _imgvAll.image = [UIImage imageNamed:@""];
    }
    else
    {
        _imgvAll.image = [UIImage imageNamed:@"duihao"];
    }
    [_btnAll addSubview:_imgvAll];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 45*screenWidth/375*2, screenWidth-20*screenWidth/375, 1*screenWidth/375)];
    line2.backgroundColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    [viewSet addSubview:line2];
    
    
    _btnSome = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSome.frame = CGRectMake(0, 45*screenWidth/375*2, screenWidth, 45*screenWidth/375);
    [viewSet addSubview:_btnSome];
    [_btnSome addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnSome.tag = 1002;
    
    UILabel* labelSome = [[UILabel alloc]initWithFrame:CGRectMake(40*screenWidth/375, 0, 130*screenWidth/375, 45*screenWidth/375)];
    labelSome.text = @"仅球队成员可见";
    labelSome.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [_btnSome addSubview:labelSome];
    labelSome.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    
    _imgvSome = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-50*screenWidth/375, 15*screenWidth/375, 15*screenWidth/375, 15*screenWidth/375)];
    [_btnSome addSubview:_imgvSome];
    if ([_isShowMem integerValue] == 0) {
        _imgvSome.image = [UIImage imageNamed:@""];
    }
    else if ([_isShowMem integerValue] == 1)
    {
        _imgvSome.image = [UIImage imageNamed:@"duihao"];
    }
    else{
        
    }

    
}

-(void)chooseClick:(UIButton *)btn
{
    if (btn.tag == 1001) {
        _imgvAll.image = [UIImage imageNamed:@"duihao"];
        _imgvSome.image = [UIImage imageNamed:@""];
        _isOpen = 0;
    }
    else
    {
        _imgvAll.image = [UIImage imageNamed:@""];
        _imgvSome.image = [UIImage imageNamed:@"duihao"];
        _isOpen = 1;
    }
}

#pragma mark --创建相册管理页面 ，
-(void)createManage
{
    //相册封面
    UIView* viewCover = [[UIView alloc]initWithFrame:CGRectMake(0, 75*screenWidth/375 + 45*screenWidth/375*3, screenWidth, 70*screenWidth/375)];
    viewCover.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewCover];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, screenWidth, 70*screenWidth/375);
    [viewCover addSubview:btn];
    [btn addTarget:self action:@selector(changeBackClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1001;
    
    UILabel* labelCover = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 70*screenWidth/375)];
    labelCover.textColor = [UIColor lightGrayColor];
    [viewCover addSubview:labelCover];
    labelCover.text = @"相册封面";
    labelCover.font = [UIFont systemFontOfSize:15*screenWidth/375];
    
    
    
    _imgvChange = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-70*screenWidth/375, 0, 70*screenWidth/375, 70*screenWidth/375)];
    [viewCover addSubview:_imgvChange];
    _imgvChange.layer.masksToBounds = YES;
    _imgvChange.contentMode = UIViewContentModeScaleToFill;
    [_imgvChange sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[_numPhotoKey integerValue]andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
    
    
}

#pragma mark --更换相册封面的点击事件
-(void)changeBackClick:(UIButton *)btn
{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //球队相册
    UIAlertAction * act4 = [UIAlertAction actionWithTitle:@"从球队相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //球队相册
        SelectPhotoAsHeaderViewController *vc = [[SelectPhotoAsHeaderViewController alloc] init];
        vc.albumKey = _timeKey;
        vc.selectUrl = ^(NSInteger picTimeKey) {
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            
            [dict setObject:[NSString stringWithFormat:@"%ld",picTimeKey] forKey:@"mediaKey"];
            [dict setObject:_timeKey forKey:@"timeKey"];
            [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
            [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamAlbum" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            } completionBlock:^(id data) {
                NSString *urlStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/album/media/%ld.jpg", (long)picTimeKey];
                NSURL *url = [NSURL URLWithString:urlStr];
                [_imgvChange sd_setImageWithURL:url];
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];

    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            NSArray* arrayData = [NSArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self imageArray:arrayData];
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            NSArray* arrayData = [NSArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self imageArray:arrayData];
        }];
    }];
    
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act4];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}

#pragma mark --上传图片方法
-(void)imageArray:(NSArray *)array
{
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.label.text = @"正在上传...";
    [self.view addSubview:progress];
    [progress show:YES];
    /**
     *  获取timekey用来作为上传图片的timekey
     *
     *  @param errType nil
     *
     *  @return nil
     */
    [[JsonHttp jsonHttp] httpRequest:@"globalCode/createTimeKey" JsonKey:nil withData:nil requestMethod:@"GET" failedBlock:^(id errType) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    }completionBlock:^(id data) {
        NSNumber* TimeKey = [data objectForKey:@"timeKey"];
        
        /**
         上传图片
         */
        NSMutableDictionary* dictMedia = [[NSMutableDictionary alloc]init];
        [dictMedia setObject:[NSString stringWithFormat:@"%@" ,TimeKey] forKey:@"data"];
        [dictMedia setObject:TYPE_MEDIA_IMAGE forKey:@"nType"];
        [dictMedia setObject:@"dagolfla" forKey:@"tag"];
        [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dictMedia andDataArray:array failedBlock:^(id errType) {
            NSLog(@"errType===%@", errType);
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        } completionBlock:^(id data) {
            /**
             上传图片的参数
             */
            
            if ([[data objectForKey:@"code"] integerValue] == 1) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                if (TimeKey != nil) {
                   [dict setObject:TimeKey forKey:@"mediaKey"];
                }
                [dict setObject:_timeKey forKey:@"timeKey"];
                [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
                
                [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamAlbum" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
                    NSLog(@"errType == %@", errType);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                } completionBlock:^(id data) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    _imgvChange.image = [UIImage imageWithData:array[0]];
                }];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [[ShowHUD showHUD]showToastWithText:@"上传图片失败" FromView:self.view];
            }
            
        }];
        
    }];
}



#pragma 创建删除按钮
-(void)createDelete
{
    //删除相册按钮
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.backgroundColor = [UIColor orangeColor];
    [btnDelete setTitle:@"删除相册" forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btnDelete];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
    btnDelete.frame = CGRectMake(10*screenWidth/375, 110*screenWidth/375 + 45*screenWidth/375*4, screenWidth-20*screenWidth/375, 45*screenWidth/375);
    btnDelete.layer.cornerRadius = 8*screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    [btnDelete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteClick
{
    
    
    
    [Helper alertViewWithTitle:@"删除相册不可找回，您是否确认删除？" withBlockCancle:^{
    } withBlockSure:^{
        MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
        progress.mode = MBProgressHUDModeIndeterminate;
        progress.labelText = @"正在删除...";
        [self.view addSubview:progress];
        [progress show:YES];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
        [dict setObject:@[_timeKey] forKey:@"timeKeyList"];
        [dict setObject:_teamKey forKey:@"teamKey"];
        [[JsonHttp jsonHttp]httpRequest:@"team/batchDeleteTeamAlbum" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        } completionBlock:^(id data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if ([[data objectForKey:@"packSuccess"] boolValue] == 1) {
                _createBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }];
    } withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
    
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
