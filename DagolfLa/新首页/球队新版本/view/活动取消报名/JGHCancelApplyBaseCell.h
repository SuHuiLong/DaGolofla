//
//  JGHCancelApplyBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHCancelApplyBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;


- (void)configDict:(NSMutableDictionary *)dict;

@end
