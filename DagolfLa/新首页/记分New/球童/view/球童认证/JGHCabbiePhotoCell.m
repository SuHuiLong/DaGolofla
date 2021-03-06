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
    self.backgroundColor = [UIColor whiteColor];
    
    self.proTextField.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.promptLableTop.constant = 12 *ProportionAdapter;
    self.cammaDown.constant = 12 *ProportionAdapter;
    
    self.photoImageW.constant = 120 *ProportionAdapter;
    self.photoImageH.constant = 140 *ProportionAdapter;
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
    
    self.photoImage.image = image;
    
    self.proTextField.text = @"求真相";
    self.proTextField.enabled = NO;
    self.cammaImageView.hidden = NO;
}

- (void)configCabbieSuccess:(NSInteger)editor andName:(NSString *)name{
    self.titleLable.hidden = YES;
    
    self.proTextField.enabled = NO;
    self.cammaImageView.hidden = YES;
    
    self.proTextField.text = name;
    self.proTextField.userInteractionEnabled = NO;
    
    self.photoImageTop.constant = 22 *ProportionAdapter;
    
    NSString *url = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/user/head/%@_caddie.jpg", DEFAULF_USERID];
    
    [[SDImageCache sharedImageCache] removeImageForKey:url fromDisk:YES withCompletion:nil];
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cabbieHeader"]];
}

- (void)configImageWithName:(NSString *)name{
    self.titleLable.hidden = YES;
    self.proTextField.enabled = YES;
    self.cammaImageView.hidden = NO;
    
    self.proTextField.text = name;
    self.proTextField.userInteractionEnabled = NO;
    
    self.photoImageTop.constant = 22 *ProportionAdapter;
    
    NSString *url = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/user/head/%@_caddie.jpg", DEFAULF_USERID];
    
    [[SDImageCache sharedImageCache] removeImageForKey:url fromDisk:YES withCompletion:nil];
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cabbieHeader"]];
}

- (void)configEditorImage:(UIImage *)image andUserName:(NSString *)name{
    self.titleLable.hidden = YES;
    self.proTextField.enabled = YES;
    self.cammaImageView.hidden = NO;
    
    self.proTextField.text = name;
    self.proTextField.userInteractionEnabled = NO;
    
    self.photoImage.image = nil;
    [self.photoImage setImage:image];
}

@end
