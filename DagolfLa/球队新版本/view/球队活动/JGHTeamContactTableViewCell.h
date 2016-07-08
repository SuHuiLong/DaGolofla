//
//  JGHTeamContactTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol JGHTeamContactTableViewCellDelegate <NSObject>
//
//- (void)inputTextString:(NSString *)string;
//
//@end

@interface JGHTeamContactTableViewCell : UITableViewCell

//联系人电话
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

@property (weak, nonatomic) IBOutlet UITextField *tetfileView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactLabelLeft;

- (void)configConstraint;


//@property (weak, nonatomic) id <JGHTeamContactTableViewCellDelegate> delegate;

@end
