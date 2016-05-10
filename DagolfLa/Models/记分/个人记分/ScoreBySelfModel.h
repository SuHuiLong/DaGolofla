//
//  ScoreBySelfModel.h
//  DagolfLa
//
//  Created by bhxx on 15/12/3.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface ScoreBySelfModel : BaseModel


@property (strong, nonatomic) NSArray* ballAreas;
@property (strong, nonatomic) NSArray* tAll;

@end

/*
 "rows": {
 "ballAreas": [
 "B区",
 "A区"
 ],
 "tAll": [
 "黑T",
 "白T",
 "蓝T",
 "红T"
 ]
 */