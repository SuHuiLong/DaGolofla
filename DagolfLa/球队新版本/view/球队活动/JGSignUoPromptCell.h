//
//  JGSignUoPromptCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGSignUoPromptCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *pamaptLabel;

- (void)configPromptString:(NSString *)string;

@end
