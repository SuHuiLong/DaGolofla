//
//  JGHAddAwardImageCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHAddAwardImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewLeft;

@property (weak, nonatomic) IBOutlet UILabel *vlaue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vlaueLeft;


- (void)configAddAwardImageName:(NSString *)imageName andTiles:(NSString *)title;

@end
