//
//  XuanshangViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/31.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "XuanshangViewController.h"

@interface XuanshangViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
}
@end

@implementation XuanshangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    //self.title = @"111";
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //_tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    NSString *searchString = searchController.searchBar.text;
    //访问URL
    //////NSLog(@"-----%@",searchString);
}
@end
