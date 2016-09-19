//
//  TKAddressModel.h
//  DagolfLa
//
//  Created by bhxx on 15/10/14.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"
@interface TKAddressModel : BaseModel

@property (assign, nonatomic) NSInteger sectionNumber;
@property (assign, nonatomic) NSInteger recordID;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *mobile;
@property (strong, nonatomic) ChineseString *chineseString;



@property (nonatomic, assign) NSInteger isSelectNumber;
@end
