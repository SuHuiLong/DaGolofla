//
//  JGHAddressCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHAddressCellDelegate <NSObject>

- (void)didSelectBtn:(UIButton *)btn;

@end

@interface JGHAddressCell : UITableViewCell
//地址内容
@property (weak, nonatomic) IBOutlet UILabel *addressContact;

//select按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtn:(UIButton *)sender;


@property (weak, nonatomic)id <JGHAddressCellDelegate> delegate;

//- (void)configModel

@end
