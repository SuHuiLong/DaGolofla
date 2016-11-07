//
//  MyNewsBoxViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/25.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyNewsBoxViewController.h"
#import "MyNewsBoxTableCell.h"

#import "NewsModel.h"

#import "PostDataRequest.h"
#import "Helper.h"

#import "ComDetailViewController.h"

#import "MyNewsListModel.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"


#import "MJDIYBackFooter.h"
#import "MJRefreshComponent.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

@interface MyNewsBoxViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    int _page;
}
@property (nonatomic, strong)NSMutableDictionary *paraDic;
@end

@implementation MyNewsBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.title = @"消息列表";
    
    [self createNewsData];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if(_pushType == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
    }else{

    }
}
- (void)rebackToRootViewAction {
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];//记得立即同步
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createNewsData
{
    //    userId    用户id   int
    //    messType   系统消息类型（可选）
    //    page      页码   int
    //    rows      一页显示数量
    
    self.paraDic = [[NSMutableDictionary alloc]init];
    _page = 1;
    [self.paraDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [self.paraDic setObject:@2 forKey:@"messType"];
    [self.paraDic setObject:@1 forKey:@"page"];
    [self.paraDic setObject:@10 forKey:@"rows"];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybySystem.do" parameter:self.paraDic success:^(id respondsData) {
        //        ////NSLog(@"numIndex = %@",numIndex);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"]boolValue]) {
            for (NSDictionary *messageDic in [dict objectForKey:@"rows"]) {
                //NSLog(@"%@",messageDic);
                MyNewsListModel * newsListModel = [[MyNewsListModel alloc]init];
                [newsListModel setValuesForKeysWithDictionary:messageDic];
                
                        NoteModel *model = [NoteHandlle selectNoteWithUID:[messageDic objectForKey:@"sender"]];
                        if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                       
                        }else{
                            newsListModel.title = [NSString stringWithFormat:@"%@评论了你", model.userremarks];
                        
                        }
                [_dataArray addObject:newsListModel];
            };
            
            [_tableView reloadData];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
    }];
}


-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-15*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyNewsBoxTableCell" bundle:nil] forCellReuseIdentifier:@"MyNewsBoxTableCell"];
    
    _tableView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refrenshing1)];
}

- (void)refrenshing1{
    _page ++;
    [self.paraDic setObject:[NSNumber numberWithInt:_page] forKey:@"page"];
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybySystem.do" parameter:self.paraDic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSArray *arra = [dict objectForKey:@"rows"];
            
            for (NSDictionary *dic in arra) {
                MyNewsListModel * newsListModel = [[MyNewsListModel alloc]init];
                [newsListModel setValuesForKeysWithDictionary:dic];
                
                NoteModel *model = [NoteHandlle selectNoteWithUID:[dic objectForKey:@"sender"]];
                if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                    
                }else{
                    newsListModel.title = [NSString stringWithFormat:@"%@评论了你", model.userremarks];
                }
                
                [_dataArray addObject:newsListModel];
            }
            
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_tableView.footer endRefreshing];
    } failed:^(NSError *error) {
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*ScreenWidth/375;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNewsBoxTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewsBoxTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.accessoryType = 1;
    [cell.iconImage sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[indexPath.row] senderPic]] placeholderImage:[UIImage imageNamed:@"moren.jpg"]];
    cell.titleLabel.text = [_dataArray[indexPath.row] title];
    cell.newsLabel.text = [_dataArray[indexPath.row] content];
    cell.timeLabel.hidden = NO;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        //点击cell进入详情
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
       
        DetailViewController * comDevc = [[DetailViewController alloc]init];
        
        comDevc.detailId = [_dataArray[indexPath.row] messObjid];

        [self.navigationController pushViewController:comDevc animated:YES];
        
    }else {
        
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
}




@end
