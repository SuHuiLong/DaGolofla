//
//  JGHCabbiePhotoCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbiePhotoCell.h"

@implementation JGHCabbiePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.promptLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.photoImageW.constant = 120 *ProportionAdapter;
    self.photoImageH.constant = 120 *ProportionAdapter;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)imageViewBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectCabbieImageBtn:sender];
    }
}

- (void)configCabbieCommitImage:(UIImage *)image{
    self.photoImageTop.constant = 10 *ProportionAdapter;
    self.promptLableTop.constant = 12 *ProportionAdapter;
}

- (void)configCabbieSuccess{
    self.titleLable.hidden = YES;
    self.photoImageTop.constant = 22 *ProportionAdapter;
    self.promptLableTop.constant = 12 *ProportionAdapter;
//    http://imgcache.dagolfla.com/user/head/244_caddie.jpg
    
    NSString *url = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/user/head/%@_caddie.jpg", DEFAULF_USERID];
    
    [[SDImageCache sharedImageCache] removeImageForKey:url fromDisk:YES];
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cabbieHeader"]];
}

@end
