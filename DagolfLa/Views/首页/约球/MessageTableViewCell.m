//
//  MessageTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/10/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "ViewController.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _messBtn.layer.masksToBounds = YES;
    _messBtn.layer.cornerRadius = 3*ScreenWidth/375;
    [_messBtn addTarget:self action:@selector(messBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)messBtnClick
{
    [self sendMessage];
}
//发送短信的方法
-(void)sendMessage
{
    //用于判断是否有发送短信的功能（模拟器上就没有短信功能）
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    //判断是否有短信功能
    if (messageClass != nil) {
    //有发送功能要做的事情
        
        //有短信功能
        if ([messageClass canSendText]) {
            //发送短信
            //实例化MFMessageComposeViewController,并设置委托
//            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
//            messageController.delegate = self;
//            //拼接并设置短信内容
//            NSString *messageContent = @"qqwerqwer";
//            messageController.body = messageContent;
//            //设置发送给谁
//            messageController.recipients = @[@"18612341234"];
//            //推到发送试图控制器
//             [self presentViewController:messageController animated:YES completion:^{
//                
//            }];
            
//                NSString * str  = [NSString stringWithFormat:@"%@邀请您参加他的约球活动--来自打 高尔夫啦",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
            
//                //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]);
                MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                controller.recipients = @[_tealStr];
                controller.navigationBar.tintColor = [UIColor redColor];
                NSString *messageContent = @"我在打高尔夫啦发布了新的活动,邀您打高尔夫啦！--来自 打高尔夫啦";
                controller.body = messageContent;
                controller.messageComposeDelegate = self;
                [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"高尔夫"];//修改短信界面标题
                _block(controller);
        }else{
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备没有发送短信的功能~" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alterView show];
        }
    }else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"iOS版本过低（iOS4.0以后）" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alterView show];
    }
}

//发送短信后回调的方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *tipContent;
    switch (result) {
        case MessageComposeResultCancelled:
        {
            tipContent = @"已发送短信";
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case MessageComposeResultFailed:
        {
            tipContent = @"发送短信失败";
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case MessageComposeResultSent:
        {
            tipContent = @"发送成功";
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            default:
            break;
    }
    
}

@end
