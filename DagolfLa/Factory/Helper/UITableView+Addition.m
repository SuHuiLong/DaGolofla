//
//  UITableView+Addition.m
//  DagolfLa
//
//  Created by SHL on 2017/2/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "UITableView+Addition.h"

@implementation UITableView (Addition)

//隐藏tableviewcell分割线
-(void)setExtraCellLineHidden{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

@end
