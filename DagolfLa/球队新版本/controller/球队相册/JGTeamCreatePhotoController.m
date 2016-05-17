//
//  JGTeamCreatePhotoController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamCreatePhotoController.h"
#import "UITool.h"



@interface JGTeamCreatePhotoController ()
{
    UIButton* _btnAll;
    UIButton* _btnSome;
    UIImageView* _imgvAll;
    UIImageView* _imgvSome;
}

@end

@implementation JGTeamCreatePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UITool colorWithHexString:@"EEEEEE" alpha:1];


    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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
    }
    
    
    
}

-(void)saveClick
{
    
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
    
    
    
    UITextField* textTitle = [[UITextField alloc]initWithFrame:CGRectMake(120*screenWidth/375, 1*screenWidth/375, screenWidth-130*screenWidth/375, 45*screenWidth/375)];
    textTitle.placeholder = @"输入相册名";
    textTitle.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    textTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [viewTitle addSubview:textTitle];
    
    
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
    _imgvAll.image = [UIImage imageNamed:@"duihao"];
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

    
}

-(void)chooseClick:(UIButton *)btn
{
    if (btn.tag == 1001) {
        _imgvAll.image = [UIImage imageNamed:@"duihao"];
        _imgvSome.image = [UIImage imageNamed:@""];
    }
    else
    {
        _imgvAll.image = [UIImage imageNamed:@""];
        _imgvSome.image = [UIImage imageNamed:@"duihao"];
    }
}

#pragma mark --创建相册管理页面 ，
-(void)createManage
{
    //相册封面
    UIView* viewCover = [[UIView alloc]initWithFrame:CGRectMake(0, 75*screenWidth/375 + 45*screenWidth/375*3, screenWidth, 45*screenWidth/375)];
    viewCover.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewCover];
    
    UILabel* labelCover = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
    labelCover.textColor = [UIColor lightGrayColor];
    [viewCover addSubview:labelCover];
    labelCover.text = @"相册封面";
    labelCover.font = [UIFont systemFontOfSize:15*screenWidth/375];
    
    //照片编辑
    
    UIView* viewEdit = [[UIView alloc]initWithFrame:CGRectMake(0, 85*screenWidth/375 + 45*screenWidth/375*4, screenWidth, 45*screenWidth/375)];
    viewEdit.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewEdit];
    
    UILabel* labelEdit = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
    labelEdit.textColor = [UIColor lightGrayColor];
    [viewEdit addSubview:labelEdit];
    labelEdit.text = @"照片编辑";
    labelEdit.font = [UIFont systemFontOfSize:15*screenWidth/375];
    

    //删除相册按钮
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.backgroundColor = [UIColor darkGrayColor];
    [btnDelete setTitle:@"删除相册" forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btnDelete];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
    btnDelete.frame = CGRectMake(10*screenWidth/375, 95*screenWidth/375 + 45*screenWidth/375*5, screenWidth-20*screenWidth/375, 45*screenWidth/375);
    btnDelete.layer.cornerRadius = 8*screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    [btnDelete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteClick
{
    
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
