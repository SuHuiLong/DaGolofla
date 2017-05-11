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
#import "UserDataInformation.h"

#import "IQKeyboardManager.h"

@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

- (void)deleteLocalCacheDataWithKey:(NSString *)key {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        
        // 删除缓存数据
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self deleteLocalCacheDataWithKey:@"Library/Caches/${appname}/RCloudCache"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.conversationMessageCollectionView reloadData];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    //    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:5];
    
    [self scrollToBottomAnimated:NO];
    
}
-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}
//更改聊天的字体 164981 7965
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
