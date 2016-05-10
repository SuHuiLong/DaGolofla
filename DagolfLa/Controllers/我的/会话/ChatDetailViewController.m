//
//  ChatDetailViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/2/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ChatDetailViewController.h"

@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.title = self.title;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    
    [self scrollToBottomAnimated:NO];


}
-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}
//更改聊天的字体
-(void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textCell=(RCTextMessageCell *)cell;
        RCMessageModel *model=self.conversationDataRepository[indexPath.row];
        NSInteger mmm=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
        if (mmm==[model.senderUserId integerValue]) {
            textCell.textLabel.textColor=[UIColor whiteColor];
        }else{
            textCell.textLabel.textColor=[UIColor blackColor];
        }
    }
}
//点击头像
//一定要设置info，否则肯定拿不到信息
- (void)didTapCellPortrait:(NSString *)userId{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if ([userId integerValue]!=[[user objectForKey:@"userId"] integerValue]) {
//        PersonalInformationViewController *infomation=[[PersonalInformationViewController alloc] init];
//        infomation.userId=[userId integerValue];
//        [self.navigationController pushViewController:infomation animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
