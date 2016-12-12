//
//  ChatDetailViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/2/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "PersonHomeController.h"
#import "UITabBar+badge.h"
#import "InfoDataViewController.h"
#import "AddNoteViewController.h"
#import "PostDataRequest.h"

@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.title = self.title;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    //    [self.];
    [self.conversationMessageCollectionView reloadData];
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
        
//        AddNoteViewController *addVC = [[AddNoteViewController alloc] init];
//    
//    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
//    [paraDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
//    [paraDic setObject:userId forKey:@"otherUserId"];
//    [[PostDataRequest sharedInstance] postDataRequest:@"user/queryByIds.do" parameter:paraDic success:^(id respondsData) {
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
//        if ([[dict objectForKey:@"success"] boolValue]) {
//            NSDictionary *dic = [dict objectForKey:@"rows"];
//            if ( [dic objectForKey:@"followState"]) {
//                addVC.isFollow = YES;
//            }else{
//                addVC.isFollow = NO;
//            }
//            
//            addVC.isInfo = YES;
//            addVC.otherUid = [NSNumber numberWithInteger:[userId integerValue]];
//            [self.navigationController pushViewController:addVC animated:YES];
//            
//            
//            
//
//        }else {
//           
//            
//        }
//    } failed:^(NSError *error) {
//        
//    }];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *numTemp = [numberFormatter numberFromString:userId];
    
        JGHPersonalInfoViewController *personVC = [[JGHPersonalInfoViewController alloc] init];
        personVC.personRemark = ^(NSString *remark){
            if ([remark length] != 0) {
                self.title = remark;
            }
        };
        personVC.otherKey = numTemp;
        personVC.fromChat = 1;
        [self.navigationController pushViewController:personVC animated:YES];
    
        
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
