//
//  TeamPhotoViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamPhotoViewController.h"
#import "TeamPhotoAlbumViewCell.h"
#import "TeamCreatePhotoController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "TeamPhotoModel.h"
#import "TeamPhotoDetViewController.h"


@interface TeamPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    
    NSMutableArray* _dataArray;
    
    NSInteger _page;
}

@end

@implementation TeamPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _teamPhotoTitle;
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _page = 1;
    [self uiConfig];

    if ([_forrevent integerValue] == 1 || [_forrevent integerValue] == 2 || [_forrevent integerValue] == 4) {
        [self createPhotoAlbum];
    }
    
    
    
    
}


-(void)createPhotoAlbum
{
    UIView* viewPhoto = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    viewPhoto.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewPhoto];
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, viewPhoto.frame.size.width, viewPhoto.frame.size.height);
    [viewPhoto addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 12*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 12*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];

    [btnText setTitle:@"创建相册" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 8*ScreenWidth/375, 10*ScreenWidth/375, 14*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];
    
}
-(void)photoClick
{
    //创建相册
    TeamCreatePhotoController* crePVc = [[TeamCreatePhotoController alloc]init];
    crePVc.teamId = _teamId;
    [self.navigationController pushViewController:crePVc animated:YES];
}

-(void)uiConfig
{
    
    if ([_forrevent integerValue] == 1 || [_forrevent integerValue] == 2 || [_forrevent integerValue] == 4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, ScreenHeight-44*ScreenWidth/375) style:UITableViewStylePlain];
    }
    else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[TeamPhotoAlbumViewCell class] forCellReuseIdentifier:@"TeamPhotoAlbumViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(head1Rereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(foot1Rereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    [[PostDataRequest sharedInstance] postDataRequest:@"photos/queryByGroups.do" parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@10,@"teamId":_teamId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamPhotoModel *model = [[TeamPhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            _page ++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)head1Rereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)foot1Rereshing
{
    [self downLoadData:_page isReshing:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamPhotoAlbumViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamPhotoAlbumViewCell" forIndexPath:indexPath];
    [cell showData:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamPhotoDetViewController* teamVc =[[TeamPhotoDetViewController alloc]init];
    teamVc.model = _dataArray[indexPath.row];
    teamVc.forrevent = _forrevent;
    [self.navigationController pushViewController:teamVc animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_forrevent integerValue] == 1 || [_forrevent integerValue] == 2 || [_forrevent integerValue] == 4)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            // Delete the row from the data source.
            [Helper alertViewWithTitle:@"您是否确定要删除这个相册" withBlockCancle:^{
                
            } withBlockSure:^{
                [[PostDataRequest sharedInstance] postDataRequest:@"photos/deleteGroups.do" parameter:@{@"photoGroupsIds":[_dataArray[indexPath.row] photoGroupsId]} success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"] boolValue]) {
                        ////NSLog(@"1");
                        [_dataArray removeObjectAtIndex:indexPath.row];
                        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else
                    {
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除图片失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        [alert show];
                    }
                } failed:^(NSError *error) {
                    
                }];

            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
            
            
            
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    else
    {
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_forrevent integerValue] == 1 || [_forrevent integerValue] == 2 || [_forrevent integerValue] == 4)
    {
        return @"删除";
    }
    else
    {
        return nil;
    }
    
}
@end
