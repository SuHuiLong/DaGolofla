//
//  BallFriListCell.m
//  DagolfLa
//
//  Created by 東 on 16/3/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//
#import "BallFriListCell.h"
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@implementation BallFriListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10* ProportionAdapter, 4* ProportionAdapter, 40* ProportionAdapter, 40* ProportionAdapter)];
        self.myImageV.layer.masksToBounds = YES;
        self.myImageV.layer.cornerRadius = 20 * ProportionAdapter;
        self.myImageV.userInteractionEnabled = YES;
        //      cell.myImageV.contentMode = UIViewContentModeScaleAspectFill;
        
        
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myImageV.frame.size.width + 5 * 5 * ScreenWidth / 375 + 3 * ScreenWidth / 375, 7 * ProportionAdapter, 200, 18 * ScreenWidth/375)];
        self.myLabel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        
        
        self.sexImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.myImageV.frame.size.width + 5 * 5 * ScreenWidth / 375 + 3 * ScreenWidth / 375, 28 * ProportionAdapter, 12 * ProportionAdapter, 12 * ProportionAdapter)];

        
        [self.contentView addSubview:self.sexImageV];
        [self.contentView addSubview:self.myImageV];
        [self.contentView addSubview:self.myLabel];
    }
    return self;
}

- (void)setMyModel:(MyattenModel *)myModel{
    
       NoteModel *model = [NoteHandlle selectNoteWithUID:myModel.otherUserId];
    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        self.myLabel.text = myModel.userName;
    }else{
        self.myLabel.text = model.userremarks;
    }
    
    [self.myImageV sd_setImageWithURL:[Helper imageIconUrl:myModel.pic]];
    
    self.sexImageV.image = [UIImage imageNamed:@"sexIcon"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
