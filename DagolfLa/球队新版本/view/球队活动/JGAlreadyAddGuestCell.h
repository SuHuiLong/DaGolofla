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
//年龄
@property (weak, nonatomic) IBOutlet UILabel *age;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sex;
//删除
@property (weak, nonatomic) IBOutlet UIButton *deleteGuest;

@property (weak, nonatomic) id <JGAlreadyAddGuestCellDelegate> delegate;


@end
