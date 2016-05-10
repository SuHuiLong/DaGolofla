//
//  NoteModel.h
//  DagolfLa
//
//  Created by 東 on 16/4/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface NoteModel : BaseModel

@property (nonatomic, strong)NSNumber *userFollowId;
@property (nonatomic, strong)NSNumber *userId;
@property (nonatomic, strong)NSNumber *otherUserId;
@property (nonatomic, copy)NSString *userremarks;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *userMobile;
@property (nonatomic, copy)NSString *userSign;

@end
