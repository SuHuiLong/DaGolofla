//
//  JGHCabbiePhotoCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHCabbiePhotoCellDelegate <NSObject>

- (void)selectCabbieImageBtn:(UIButton *)btn;

@end

@interface JGHCabbiePhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableTop;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//20

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageW;//120
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageH;//140

@property (weak, nonatomic) IBOutlet UITextField *proTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptLableTop;//10

@property (weak, nonatomic)id <JGHCabbiePhotoCellDelegate> delegate;

- (IBAction)imageViewBtn:(UIButton *)sender;

- (void)configCabbieCommitImage:(UIImage *)image;

- (void)configCabbieSuccess:(NSInteger)editor andName:(NSString *)name;

@end
