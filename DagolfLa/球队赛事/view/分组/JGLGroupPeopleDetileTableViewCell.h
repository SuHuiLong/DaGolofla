//
//  JGLGroupPeopleDetileTableViewCell.h
//  DagolfLa
//
//  Created by Madridlee on 16/10/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGLGroupPeopleDetileTableViewCellDelegate <NSObject>

- (void)pushController:(NSNumber *)teamKey withUserKey:(NSNumber *)userKey;

@end

@interface JGLGroupPeopleDetileTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;//每一个球队内的数据

@property (strong, nonatomic) NSMutableArray* dataArrayAll;//总数据，用于完成时提交数据
-(void)tableViewReFresh:(NSMutableArray* )arr  withArrAll:(NSMutableArray *)arrAll;

@property (weak, nonatomic)id <JGLGroupPeopleDetileTableViewCellDelegate> delegate;

@end
