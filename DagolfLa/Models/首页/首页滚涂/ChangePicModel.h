//
//  ChangePicModel.h
//  DagolfLa
//
//  Created by bhxx on 16/2/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface ChangePicModel : BaseModel

@property (strong, nonatomic) NSNumber* sId;

@property (strong, nonatomic) NSString* title;

@property (strong, nonatomic) NSString* pic;

@property (strong, nonatomic) NSString* content;

@property (strong, nonatomic) NSNumber* scrollClass;

@property (strong, nonatomic) NSString* nexturl;



@end
/*
 "sId":3,
 "title":"aaa",
 "pic":"scroll/20151227150911982533.jpg",
 "content":"sss",
 "scrollClass":0,
 "nexturl":"aaaaaaaaaaaaaaaaaaaaaa"
 
 */