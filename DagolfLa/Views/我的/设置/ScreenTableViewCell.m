//
//  ScreenTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/3/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ScreenTableViewCell.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation ScreenTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


//static NSInteger tag = 200;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 160, self.frame.size.height - 6)];
        self.myLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview: self.myLabel];
        
        self.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 3, 30, self.frame.size.height - 6)];
        //        self.mySwitch.tag = tag ++;
        [self.contentView addSubview:self.mySwitch];
        
    }
    return self;
}


- (void)setInformSetmodel:(InformSetmodel *)informSetmodel{
    
    switch (self.mySwitch.tag) {
        case 300:
            if (informSetmodel.sysMessAll == 1) {
                self.mySwitch.on = YES;
            }else{
                self.mySwitch.on = NO;
            }
            break;
            
        case 301:
            if (informSetmodel.sysMessaboutball == 1) {
                self.mySwitch.on = YES;
            }else{
                self.mySwitch.on = NO;
            }
            break;
            
        case 302:
            if (informSetmodel.sysMessball == 1) {
                self.mySwitch.on = YES;
            }else{
                self.mySwitch.on = NO;
            }
            break;
            
        case 303:
            if (informSetmodel.sysMessaboutballre == 1) {
                self.mySwitch.on = YES;
            }else{
                self.mySwitch.on = NO;
            }
            break;
            
        case 304:
            if (informSetmodel.sysMessevent == 1) {
                self.mySwitch.on = YES;
            }else{
                self.mySwitch.on = NO;
            }
            break;
            
        default:
            break;
    }
    
    
    
    //    self.mySwitch.on = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
