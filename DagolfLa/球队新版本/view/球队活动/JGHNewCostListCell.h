//
//  JGHNewCostListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHNewCostListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTextFieldLeft;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTextFieldRight;//30


@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoTextFieldRight;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoTextFieldW;

- (void)configTextFeilSpeaclerText:(NSMutableDictionary *)dict;

- (void)configTextFeilSpeacler;

@end
