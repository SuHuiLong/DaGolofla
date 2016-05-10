//
//  MessageTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/10/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface MessageTableViewCell : UITableViewCell<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *messBtn;

@property(nonatomic,copy)void(^block)(MFMessageComposeViewController *vc);

@property (copy, nonatomic) NSString* tealStr;

@property (assign,nonatomic) NSInteger messType;

@end
