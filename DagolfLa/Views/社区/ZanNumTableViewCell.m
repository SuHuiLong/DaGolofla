//
//  ZanNumTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ZanNumTableViewCell.h"

@implementation ZanNumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserAssisModel:(UserAssistModel *)userAssisModel {
    _userAssisModel = userAssisModel;
    
    if (![Helper isBlankString:userAssisModel.userPic]) {
        
        [_iconImage sd_setImageWithURL:[Helper imageIconUrl:userAssisModel.userPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    }else{
        _iconImage.image = [UIImage imageNamed:DefaultHeaderImage];
    }
    
    
//    NoteModel *model = [NoteHandlle selectNoteWithUID:userAssisModel.uId];
//    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        _nameLabel.text = userAssisModel.userName;
        
//    }else{
//        _nameLabel.text = model.userremarks;
//    }
    
    
    _ageLabel.text = [NSString stringWithFormat:@"%@",userAssisModel.age];
    
    _chadianLabel.text = [NSString stringWithFormat:@"差点:%@",userAssisModel.almost];
    
    if ([userAssisModel.sex integerValue] == 1) {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    

}


-(void)showTeamPeopleData:(TeamPeopleModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.userPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = model.userName;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    _chadianLabel.text = [NSString stringWithFormat:@"差点:%@",model.almost];
}

- (NSString*)fromDateToAge:(NSDate*)date{
    
    NSDate *myDate = date;
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    
    int year = [comps year];
    
    return [NSString stringWithFormat:@"%d",year];
}


@end
