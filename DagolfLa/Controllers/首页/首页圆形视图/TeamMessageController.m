//
//  TeamMessageController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamMessageController.h"

#import "MessageTableViewCell.h"

@interface TeamMessageController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
}

@end

@implementation TeamMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    
    ////NSLog(@"%@",_dataArray);
    
//    _dataArray = [[NSMutableArray alloc]init];
//    _telArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    [self createHead];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageTableViewCell"];
}

-(void)createHead
{
    UILabel* labelHead = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    labelHead.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    labelHead.text = @"    短信通知好友";
    labelHead.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:labelHead];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = _dataArray[indexPath.row];
    cell.tealStr = _telArray[indexPath.row];
    cell.block = ^(MFMessageComposeViewController *vc){
        [self presentViewController:vc animated:YES completion:nil];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //code
}

@end
