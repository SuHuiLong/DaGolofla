//
//  JGAlreadyAddGuestCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGAlreadyAddGuestCellDelegate <NSObject>

- (void)didSelecctDeleteGuestId:(NSInteger)guesId;

@end

@interface JGAlreadyAddGuestCell : UITableViewCell
//姓名
@property (weak, nonatomic) IBOutlet UILabel *name;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sex;
//电话
@property (weak, nonatomic) IBOutlet UILabel *number;
//删除
@property (weak, nonatomic) IBOutlet UIButton *deleteGuest;

@property (weak, nonatomic) id <JGAlreadyAddGuestCellDelegate> delegate;

- (void)configDict:(NSMutableDictionary *)dict;

@end
