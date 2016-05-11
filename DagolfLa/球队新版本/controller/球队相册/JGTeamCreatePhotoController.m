//
//  JGTeamCreatePhotoController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamCreatePhotoController.h"
#import "UITool.h"
#import "JGPhotoAlbumViewController.h"


@interface JGTeamCreatePhotoController ()
{
    UIButton* _btnAll;
    UIButton* _btnSome;
}

@end

@implementation JGTeamCreatePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建相册";
    self.view.backgroundColor = [UITool colorWithHexString:@"EEEEEE" alpha:1];


    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self createTitle];
    
    [self createSetting];
    
}

-(void)saveClick
{
    JGPhotoAlbumViewController* phoVc = [[JGPhotoAlbumViewController alloc]init];
    [self.navigationController pushViewController:phoVc animated:YES];
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
    [_btnAll setTitle:@"所有人可见" forState:UIControlStateNormal];
    [_btnAll setTitleColor:[UITool colorWithHexString:@"a0a0a0" alpha:1] forState:UIControlStateNormal];
    _btnAll.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    [viewSet addSubview:_btnAll];
    [_btnAll setImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateNormal];
    [_btnAll setTitleEdgeInsets:UIEdgeInsetsMake(0, 30*screenWidth/375, 0, screenWidth-130*screenWidth/375)];
    [_btnAll setImageEdgeInsets:UIEdgeInsetsMake(0, screenWidth-75*screenWidth/375, 0, 30*screenWidth/375)];
    [_btnAll addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnAll.tag = 1001;
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 45*screenWidth/375*2, screenWidth-20*screenWidth/375, 1*screenWidth/375)];
    line2.backgroundColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    [viewSet addSubview:line2];
    
    
    _btnSome = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSome.frame = CGRectMake(0, 45*screenWidth/375*2, screenWidth, 45*screenWidth/375);
    [_btnSome setTitle:@"仅成员可见" forState:UIControlStateNormal];
    [_btnSome setTitleColor:[UITool colorWithHexString:@"a0a0a0" alpha:1] forState:UIControlStateNormal];
    _btnSome.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    [viewSet addSubview:_btnSome];
    [_btnSome setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_btnSome setTitleEdgeInsets:UIEdgeInsetsMake(0, 30*screenWidth/375, 0, screenWidth-130*screenWidth/375)];
    [_btnSome setImageEdgeInsets:UIEdgeInsetsMake(0, screenWidth-75*screenWidth/375, 0, 30*screenWidth/375)];
    [_btnSome addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnSome.tag = 1002;
    
}
-(void)chooseClick:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [_btnAll setImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateNormal];
        [_btnSome setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else
    {
        [_btnAll setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_btnSome setImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateNormal];
    }
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
