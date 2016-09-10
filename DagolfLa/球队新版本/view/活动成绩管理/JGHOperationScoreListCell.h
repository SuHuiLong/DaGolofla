//
//  JGHOperationScoreListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHOperationScoreListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *operationScoreListTable;

@property (nonatomic, strong)NSMutableArray *poleArray;

@property (nonatomic, copy)NSString *region1;
@property (nonatomic, copy)NSString *region2;

@property (nonatomic, assign)NSInteger selectId;

@property (nonatomic, copy)void (^returnHoleId)(NSInteger holeId);

- (void)reloadOperScoreBtnListCellData;

@end
