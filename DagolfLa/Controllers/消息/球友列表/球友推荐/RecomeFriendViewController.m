//
//  ViewController.m
//  UITableView横用
//
//  Created by huangdl on 15-6-18.
//  Copyright (c) 2015年 黄驿. All rights reserved.
//

#import "RecomeFriendViewController.h"

@interface RecomeFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *rootTable, *insertTabelView;
    NSMutableArray* dataArray;
}
@end

@implementation RecomeFriendViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self initView];
    dataArray= [[NSMutableArray alloc]initWithObjects:@"中",@"梦",@"科",@"技",@"made in china",nil];
    self.navigationItem.title = @"TwoTableView";
    
}

-(void)initView
{
    CGRect frame = [[UIScreen mainScreen]bounds];
    frame.size.width = [[UIScreen mainScreen]bounds].size.height;
    frame.size.height = [[UIScreen mainScreen]bounds].size.width;
    rootTable = [[UITableView alloc]initWithFrame:frame];
    rootTable.center = self.view.center;
    //    rootTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    rootTable.delegate = self;
    rootTable.dataSource = self;
    rootTable.pagingEnabled = YES;
    rootTable.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [self.view addSubview:rootTable];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == rootTable)
    {
        return [[UIScreen mainScreen]bounds].size.width;
    }else
    {
        return 44;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == rootTable)
    {
        return 5;
    }else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == rootTable)
    {
        return 4;
    }else
    {
        return [dataArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    if (tableView == rootTable)
    {
        //        if (indexPath.row == 0)
        //        {
        insertTabelView= [[UITableView alloc]initWithFrame:CGRectMake(0, 64-15, self.view.frame.size.width, [dataArray count]*44)];
        insertTabelView.delegate = self;
        insertTabelView.dataSource = self;
        insertTabelView.scrollEnabled = NO;
        insertTabelView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [cell.contentView addSubview:insertTabelView];
        //        }else
        //        {
        //            cell.textLabel.text = @"rootTableView";
        //        }
        //
        return cell;
    }else
    {
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor yellowColor];
        //        cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == rootTable)
    {
        //NSLog(@"roottableView");
    }else
    {
        //NSLog(@"中");
    }
}


@end





