//
//  JGLAddPlayerViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddPlayerViewController.h"
#import "JGLAddPlayerTableViewCell.h"
#import "JGLPlayerNumberTableViewCell.h"
#import "JGLFriendAddViewController.h"
#import "JGLAddressAddViewController.h"
#import "UITool.h"
@interface JGLAddPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    UIView* _viewHeader;
}
@end

@implementation JGLAddPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加打球人";
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    [self.view addSubview:view];
    
    [self uiConfig];
    [self createHeader];
}

-(void)createHeader
{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100*screenWidth/375)];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _viewHeader;
//    _tableView.tableHeaderView.userInteractionEnabled = YES;
//    _viewHeader.userInteractionEnabled = YES;
    NSArray* arrTit = @[@"通讯录添加",@"扫描添加",@"球友列表添加"];
    NSArray* arrImg = @[@"addressBook",@"saomiao",@"tjdqr_qiuyou"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton* btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(screenWidth/3*i, 0, screenWidth/3, 100*screenWidth/375);
        btnAdd.tag = 100 + i;
        [_viewHeader addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(chooseStyleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i > 0) {
            UIView* vieeLine = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/3*i - 1, 15*screenWidth/375, 2, 70*screenWidth/375)];
            vieeLine.backgroundColor = [UIColor lightGrayColor];
            [_viewHeader addSubview:vieeLine];
        }
        
        UIImageView* imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/3*i +screenWidth/9 , 20*screenWidth/375, screenWidth/9, screenWidth/9)];
        imgvIcon.image = [UIImage imageNamed:arrImg[i]];
        [_viewHeader addSubview:imgvIcon];
        
        UILabel* labelN = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/3*i, 65*screenWidth/375, screenWidth/3, 30*screenWidth/375)];
        labelN.text = arrTit[i];
        labelN.font = [UIFont systemFontOfSize:15*screenWidth/375];
        labelN.textAlignment = NSTextAlignmentCenter;
        [_viewHeader addSubview:labelN];
    }
    
}

-(void)chooseStyleClick:(UIButton *)btn
{
    if (btn.tag == 100) {
        JGLFriendAddViewController* fVc = [[JGLFriendAddViewController alloc]init];
        [self.navigationController pushViewController:fVc animated:YES];
    }
    else if (btn.tag == 101)
    {
        
    }
    else{
        JGLAddressAddViewController* addVc = [[JGLAddressAddViewController alloc]init];
        [self.navigationController pushViewController:addVc animated:YES];
    }
}

-(void)uiConfig
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * screenWidth / 375)];
    view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, screenWidth - 20*screenWidth/375, 80*screenWidth/375)];
    label.text = @"记分完成后会生成唯一秘钥，用户注册APP会员后，点击“历史记分卡”右上角”取回记分”，填写秘钥即可得到该成绩；通过“球友列表”与“扫描二维码”添加的打球人，记分完成后，成绩会自动同步到被添加人的历史记分卡。";
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:14*screenWidth/375];
    label.textColor = [UITool colorWithHexString:@"b8b8b8" alpha:1];
    label.numberOfLines = 0;
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10 * screenWidth / 375, screenWidth, screenHeight-10 * screenWidth / 375) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLAddPlayerTableViewCell class] forCellReuseIdentifier:@"JGLAddPlayerTableViewCell"];
    [_tableView registerClass:[JGLPlayerNumberTableViewCell class] forCellReuseIdentifier:@"JGLPlayerNumberTableViewCell"];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLAddPlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLAddPlayerTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
        cell.labelTitle.text = @"手动添加打球人";
        return cell;
    }
    else{
        JGLPlayerNumberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNumberTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.labelName.hidden = YES;
            cell.imgvIcon.hidden = YES;
            cell.labelTitle.text = @"已添加打球人";
        }
        else{
            cell.labelTitle.hidden = YES;
            cell.labelName.text = @"林中小溪";
        }
        cell.backgroundColor = [UITool colorWithHexString:@"ffffff" alpha:1];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0 ? 80 * screenWidth / 375 : 40 * screenWidth / 375;
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
