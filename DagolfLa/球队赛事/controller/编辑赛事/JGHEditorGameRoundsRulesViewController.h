//
//  JGHEditorGameRoundsRulesViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHEditorGameRoundsRulesViewControllerDelegate <NSObject>

- (void)didSelectRulesDict:(NSDictionary *)rulesDict;

@end

@interface JGHEditorGameRoundsRulesViewController : ViewController


@property (nonatomic, strong)NSString *matchformatKey;//赛制选中的key


@property (nonatomic, strong)NSString *matchTypeKey;//赛制规则
//matchformatKey

@property (nonatomic, strong)id <JGHEditorGameRoundsRulesViewControllerDelegate> delegate;
//

@end
