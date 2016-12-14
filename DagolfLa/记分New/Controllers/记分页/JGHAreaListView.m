//
//  JGHAreaListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAreaListView.h"

@interface JGHAreaListView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JGHAreaListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        
//        [self.listTableView registerClass:[JGLActiveAddPlayTableViewCell class] forCellReuseIdentifier:@"JGLActiveAddPlayTableViewCell"];
        
        [self addSubview:self.listTableView];
        
        
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 *ProportionAdapter;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
////
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return tableView.tag == 1001 ?[self.listArray count] : 1;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView.tag == 1001) {
//        if ([self.listArray[section] count] == 0) {
//            return nil;
//        }else{
//            return self.keyArray[section];
//        }
//    }
//    else{
//        return nil;
//    }
//    
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defCell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    cell.textLabel.text = _listArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row == %td", indexPath.row);
    if ([self.delegate respondsToSelector:@selector(areaString:andID:)]) {
        [self.delegate areaString:_listArray[indexPath.row] andID:indexPath.row];
    }
}

- (void)reloadAreaListView:(NSArray *)listArray{
    
    _listArray = listArray;
    [self.listTableView reloadData];
}


@end
