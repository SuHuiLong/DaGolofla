//
//  JGHTeamPalerBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLTeamMemberModel;

@interface JGHTeamPalerBaseCell : UITableViewCell

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UILabel *nameValue;

@property (nonatomic, retain)UILabel *age;

@property (nonatomic, retain)UILabel *ageValue;

@property (nonatomic, retain)UILabel *sex;

@property (nonatomic, retain)UILabel *sexValue;

@property (nonatomic, retain)UILabel *almost;

@property (nonatomic, retain)UILabel *almostValue;

@property (nonatomic, retain)UILabel *veteran;//行业

@property (nonatomic, retain)UILabel *veteranValue;

@property (nonatomic, retain)UILabel *mobile;

@property (nonatomic, retain)UILabel *mobileValue;

@property (nonatomic, retain)UILabel *company;

@property (nonatomic, retain)UILabel *companyValue;

@property (nonatomic, retain)UILabel *position;//职位

@property (nonatomic, retain)UILabel *positionValue;

@property (nonatomic, retain)UILabel *address;

@property (nonatomic, retain)UILabel *addressValue;

@property (nonatomic, retain)UILabel *dressSize;

@property (nonatomic, retain)UILabel *dressSizeValue;

//惯用手Use hand
@property (nonatomic, retain)UILabel *useHand;

@property (nonatomic, retain)UILabel *useHandValue;


- (void)configJGLTeamMemberModel:(JGLTeamMemberModel *)model;

@end
