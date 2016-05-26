//
//  JGHTeamMembersViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHTeamMembersViewControllerDelegate <NSObject>

- (void)didSelectMembers;

@end

@interface JGHTeamMembersViewController : ViewController

@property (nonatomic, weak)id <JGHTeamMembersViewControllerDelegate> delegate;

@property (nonatomic, strong)NSMutableArray *teamGroupAllDataArray;

@end
