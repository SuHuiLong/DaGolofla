//
//  ChatWithViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ChatWithViewController.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "KeyBordVIew.h"


#import "PostDataRequest.h"
#import "Helper.h"
#import "UIView+ChangeFrame.h"
#import "ChatPeopleMessageModel.h"

@interface ChatWithViewController ()<UITableViewDataSource,UITableViewDelegate,KeyBordVIewDelegate,ChartCellDelegate>
{
    //用户私聊发送的消息
    NSString *_userChatMessage;
    
    // 查询私聊好友的消息
    NSMutableArray *_chatPeopleMessage;
    // 查询私聊好友的消息的数量
    NSInteger _chatPeopleMessageNumber;
    
    NSTimer *_timer;
    
    // 两个人的头像的储存地址
    NSString *_chatPeoplePath;
    NSString *_userPath;
    NSString* _strCont;
    
    NSNumber* _numberId;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyBordVIew *keyBordView;
@property (nonatomic,strong) NSMutableArray *cellFrames;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;

@end
static NSString *const cellIdentifier=@"QQChart";
@implementation ChatWithViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(inqureChatPeopleMessage) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    //如果在另一个线程中，则要开启loop
//    [[NSRunLoop currentRunLoop] run];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
        //        [self.tableView changeHeight:self.tableView.height - deltaY];
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![Helper isBlankString:_chatPeopleName]) {
        self.title= _chatPeopleName;
    }
    else
    {
        self.title = @"商家";
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.cellFrames=[NSMutableArray array];
    _chatPeopleMessage = [NSMutableArray array];
    
    
    _numberId = @0;
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybyMessage.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":@1,@"rows":@50,@"messType":_messType,@"sender":_chatPeopleId,@"mid":_numberId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSMutableArray *tempArr = [dict objectForKey:@"rows"];
            for (NSDictionary *dic in tempArr) {
                ChatPeopleMessageModel *model = [[ChatPeopleMessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_chatPeopleMessage addObject:model];
            }
        }
//        //NSLog(@" mid  第一次  ==   %@",_numberId);
        _numberId = [dict objectForKey:@"total"];
        
        
        
        //add UItableView
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-48) style:UITableViewStylePlain];
        [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        // tableView 容许选择
        self.tableView.allowsSelection = NO;
        
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
        
        self.tableView.dataSource=self;
        self.tableView.delegate=self;
        [self.view addSubview:self.tableView];
        
        //add keyBorad
        
        self.keyBordView=[[KeyBordVIew alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
        self.keyBordView.delegate=self;
        [self.keyBordView.addBtn addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.keyBordView];
        //初始化数据
        
        
        for (int i = 0 ; i < _chatPeopleMessage.count; i ++) {
            ChartCellFrame *cellFrameq=[[ChartCellFrame alloc]init];
            ChartMessage *chartMessageq=[[ChartMessage alloc]init];
            
            chartMessageq.icon= [_chatPeopleMessage[i] uPic];
            chartMessageq.messageType = [[_chatPeopleMessage[i] isMy] intValue];
//            //NSLog(@"zheshishawanyier    =     %d",[[[_chatPeopleMessage firstObject] isMy] intValue]);
            chartMessageq.content = [_chatPeopleMessage[i] content];
            cellFrameq.chartMessage=chartMessageq;
            
            if (chartMessageq.content.length != 0) {
                [self.cellFrames addObject:cellFrameq];
                [self.tableView reloadData];
                //滚动到当前行
                [self tableViewScrollCurrentIndexPath];
            }
        }

    } failed:^(NSError *error) {
        
    }];
    
    
    
    
    
}

#pragma mark - 发送
//点击发送，显示自己的对话框
- (void)sendButtonClick:(UIButton *)btn
{
    //发送消息的时候暂停定时器，发布完成并且保存到服务器后，重新打开
    [_timer setFireDate:[NSDate distantPast]];
    
    
    [self.view endEditing:YES];
    if ([Helper isBlankString:self.keyBordView.textField.text]) {
        return;
    }
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
//    chartMessage.icon= [NSString stringWithFormat:@"icon%02d.jpg",1];
    chartMessage.icon = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]];
    
    //    chartMessage.icon= _userPath;
    chartMessage.messageType=1;
    chartMessage.content=self.keyBordView.textField.text;
    _userChatMessage = self.keyBordView.textField.text;
//    cellFrame.chartMessage=chartMessage;
//    
//    [self.cellFrames addObject:cellFrame];
//    [self.tableView reloadData];
//    //保存自己的信息到服务器
    [self saveUserChatMessage];
//    //滚动到当前行
//    [self tableViewScrollCurrentIndexPath];
    self.keyBordView.textField.text=@"";
    
}



// 保存上传用户私聊的消息
- (void)saveUserChatMessage
{
//    //NSLog(@"发送  别人的：%@    自己的%@",_chatPeopleId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/saveChat.do" parameter:@{@"sender":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"content":_userChatMessage,@"userId":_chatPeopleId,@"messType":_messType} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            _numberId = [dict objectForKey:@"total"];
            [self tableViewScrollCurrentIndexPath];
            //重新开始这个定时器
            [_timer setFireDate:[NSDate distantPast]];
        }
        else
        {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        
    } failed:^(NSError *error) {
        
    }];
    
}

static int i = 0;
// 查询私聊的人的消息
- (void)inqureChatPeopleMessage
{
    
//    //NSLog(@"查询  别人的：%@    自己的%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],_chatPeopleId);
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybyMessage.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":@1,@"rows":@1,@"messType":_messType,@"sender":_chatPeopleId,@"mid":_numberId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if (_chatPeopleMessage.count != 0) {
            [_chatPeopleMessage removeAllObjects];
        }
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSMutableArray *tempArr = [dict objectForKey:@"rows"];
            for (NSDictionary *dic in tempArr) {
                ChatPeopleMessageModel *model = [[ChatPeopleMessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_chatPeopleMessage addObject:model];
            }
            
//            //NSLog(@"   shuzu    %ld",(unsigned long)_chatPeopleMessage.count);
            
            //如果id不一样，那么重新赋值
            if ([_numberId integerValue] != [[[_chatPeopleMessage lastObject] mId] integerValue])
            {
//                //NSLog(@" mid   发送  ==   %@",_numberId);
                _numberId = [[_chatPeopleMessage firstObject] mId];
            }
            //防止获得的消息数据是一样的
            if (![_strCont isEqualToString:[_chatPeopleMessage[0] content]]) {
                
//                //NSLog(@"%@",[[_chatPeopleMessage firstObject] mId]);
                
                ChartCellFrame *cellFrameq=[[ChartCellFrame alloc]init];
                ChartMessage *chartMessageq=[[ChartMessage alloc]init];
                
                chartMessageq.icon= [[_chatPeopleMessage firstObject] uPic];
                //        chartMessageq.icon= _chatPeoplePath;
//                chartMessageq.messageType=0;
                chartMessageq.messageType = [[[_chatPeopleMessage firstObject] isMy] intValue];
                chartMessageq.content = [_chatPeopleMessage[0] content];
                cellFrameq.chartMessage=chartMessageq;
                
                if (chartMessageq.content.length != 0) {
                    [self.cellFrames addObject:cellFrameq];
                    [self.tableView reloadData];
                    //滚动到当前行
                    [self tableViewScrollCurrentIndexPath];
                }
                _strCont = [_chatPeopleMessage[0] content];
            }
            else
            {
                i++;
//                //NSLog(@"%@",[_chatPeopleMessage[0] content]);
            }
        }
        
    } failed:^(NSError *error) {
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellFrames.count == 0 ? 1 : self.cellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChartCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    if (self.cellFrames.count != 0) {
        cell.cellFrame=self.cellFrames[indexPath.row];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellFrames.count == 0 ? 0 : [self.cellFrames[indexPath.row] cellHeight];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    //发送消息的时候暂停定时器，发布完成并且保存到服务器后，重新打开
    [_timer setFireDate:[NSDate distantPast]];
    
    
    [self.view endEditing:YES];
    if ([Helper isBlankString:self.keyBordView.textField.text]) {
        return;
    }
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
    //    chartMessage.icon= [NSString stringWithFormat:@"icon%02d.jpg",1];
    chartMessage.icon = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]];
    
    //    chartMessage.icon= _userPath;
    chartMessage.messageType=1;
    chartMessage.content=self.keyBordView.textField.text;
    _userChatMessage = self.keyBordView.textField.text;
    //    cellFrame.chartMessage=chartMessage;
    //
    //    [self.cellFrames addObject:cellFrame];
    //    [self.tableView reloadData];
    //    //保存自己的信息到服务器
    [self saveUserChatMessage];
    //    //滚动到当前行
    //    [self tableViewScrollCurrentIndexPath];
    self.keyBordView.textField.text=@"";
    
}


-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled
{
    //    [self tableViewScrollCurrentIndexPath];
    
}

-(void)tableViewScrollCurrentIndexPath
{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
    if ((self.cellFrames.count) > 0) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
