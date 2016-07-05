//
//  JGSignUoPromptCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGSignUoPromptCell : UITableViewCell


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pamapLabelLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pamapLabelRight;

@property (weak, nonatomic) IBOutlet UILabel *pamaptLabel;

- (void)configPromptString:(NSString *)string;

- (void)configPromptPasswordString:(NSString *)string;

- (void)configPromptSetPasswordString:(NSString *)string;

- (void)configAllPromptString:(NSString *)str andLeftCon:(NSInteger)leftCon andRightCon:(NSInteger)rightCon;

@end
