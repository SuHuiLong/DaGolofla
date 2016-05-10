//
//  TeamJoinReasonViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/1/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "TeamJoinReasonViewController.h"
#import "IWTextView.h"

#import "PostDataRequest.h"
#import "Helper.h"
@interface TeamJoinReasonViewController ()<UITextViewDelegate>
{
    IWTextView* _textView;
    NSMutableDictionary* _dict;
    BOOL _isChoose;
}
@end

@implementation TeamJoinReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请加入";
    _dict = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    [self createTextView];
    
    [self createReason];
    
    [self createBtn];
    
}

-(void)createTextView
{
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 150*ScreenWidth/375)];
    _textView.delegate = self;       //设置代理方法的实现类
    _textView.placeholder = @"请输入申请理由";
    [self.view addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textView.tag = 100;
    
}
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView.text) {
//        <#statements#>
//    }
//}

-(void)createReason
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10*ScreenWidth/375, 170*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];

    
    UILabel* reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width - 50*ScreenWidth/375, 44*ScreenWidth/375)];
    reasonLabel.text = @"喜欢不需要理由";
    reasonLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    reasonLabel.textAlignment = NSTextAlignmentLeft;
    [btn addSubview:reasonLabel];
    
    UIButton* btnChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnChoose setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    btnChoose.frame = CGRectMake(ScreenWidth-64*ScreenWidth/375, 0, 44*ScreenWidth/375, 44*ScreenWidth/375);
    [btn addSubview:btnChoose];
    [btnChoose addTarget:self action:@selector(loveReasonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loveReasonClick:(UIButton *)btn
{
    if (_isChoose == NO) {
        _isChoose = YES;
        [btn setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    }
    else
    {
        _isChoose = NO;
        [btn setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    }
}

-(void)createBtn
{
    UIButton* btnFabu = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFabu.frame = CGRectMake(10*ScreenWidth/375, 224*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btnFabu];
    [btnFabu addTarget:self action:@selector(fabuClick) forControlEvents:UIControlEventTouchUpInside];
    btnFabu.backgroundColor = [UIColor orangeColor];
    btnFabu.layer.cornerRadius = 8*ScreenWidth/375;
    btnFabu.layer.masksToBounds = YES;
    [btnFabu setTitle:@"申请" forState:UIControlStateNormal];
}
-(void)fabuClick
{
    //点击加入球队
    [_dict setObject:_teamId forKey:@"teamId"];
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]  forKey:@"userId"];
    [_dict setObject:@10 forKey:@"applyType"];
    [_dict setObject:_teamId forKey:@"userIds"];
    [_dict setObject:_teamType forKey:@"type"];
    
    if ([Helper isBlankString:_textView.text]) {
        
        if (_isChoose == NO) {
            [Helper alertViewNoHaveCancleWithTitle:@"请输入加入理由!" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
            [_dict setObject:@"喜欢不需要理由" forKey:@"applyContext"];
            [_dict setObject:[NSString stringWithFormat:@"%@申请加入您的球队",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
            [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/save.do" parameter:_dict success:^(id respondsData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"success"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alertView show];
                    _blockJoin(@"取消加入",@5);
                }
            } failed:^(NSError *error) {
                ////NSLog(@"%@",error);
            }];

        }
        
        
        
    }else{
        [_dict setObject:_textView.text forKey:@"applyContext"];
        
        [_dict setObject:[NSString stringWithFormat:@"%@申请加入您的球队",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"NoticeString"];
        [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/save.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([dict objectForKey:@"success"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alertView show];
                _blockJoin(@"取消加入",@5);
            }
        } failed:^(NSError *error) {
            ////NSLog(@"%@",error);
        }];
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
