//
//  JGLAuthorityTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGLAuthorityTableViewCell : UITableViewCell


/**
 *  权限设置
 */

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgv;


@end
