//
//  ActiveScoreController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ActiveScoreController.h"
#import "ScoreTitleTableViewCell.h"
#import "ScoreDetailTableViewCell.h"

#import "ScoreSelfViewController.h"

#import "ScoreCommentOtherViewCell.h"
#import "ScoreCommentSelfViewCell.h"
@interface ActiveScoreController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UITableView* _tableView;
    
    UITableView* _tableViewCom;
    
    //输入框
    UIView* _commentView;
    UITextView* _commentTextView;
    UIButton* _sendButton;
    
    BOOL _isMove;//是否移动了
    NSInteger _moveHight;//移动的高度
    NSInteger _keyHight;//记录上一次键盘的高度
    
    //
    BOOL _isClickText;
}

@end

@implementation ActiveScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动成绩";
    
    
    _isMove = NO;
    _moveHight = 0;
    _keyHight = 0;
    
    //键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKey:) name:UIKeyboardWillShowNotification object:nil];
    //输入框contentSize大小变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextView:) name:UITextViewTextDidChangeNotification object:nil];
    
    //头视图
    [self createLabel];
    //成绩分数列表
    [self createScoreView];
    //评论列表
    [self createComment];
    
    [self creatjudementView];
}

-(void)createLabel
{
    UILabel* labelHead = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40*ScreenWidth/375)];
    labelHead.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    labelHead.textAlignment = NSTextAlignmentCenter;
    labelHead.text = @"宝马杯高尔夫公开赛成绩列表";
    labelHead.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [self.view addSubview:labelHead];
}
-(void)createScoreView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40*ScreenWidth/375, ScreenWidth, 40*ScreenWidth/375+11*30*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tag = 100;
    _tableView.bounces = NO;
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}
-(void)createComment
{
    _tableViewCom = [[UITableView alloc]initWithFrame:CGRectMake(0, 80*ScreenWidth/375+11*30*ScreenWidth/375, ScreenWidth, 200*ScreenWidth/375) style:UITableViewStylePlain];
    _tableViewCom.delegate = self;
    _tableViewCom.dataSource = self;
    [self.view addSubview:_tableViewCom];
    _tableViewCom.bounces = NO;
    _tableViewCom.scrollEnabled = NO;
    _tableViewCom.tag = 101;
    
    [_tableViewCom registerNib:[UINib nibWithNibName:@"ScoreCommentOtherViewCell" bundle:nil] forCellReuseIdentifier:@"ScoreCommentOtherViewCell"];
    [_tableViewCom registerNib:[UINib nibWithNibName:@"ScoreCommentSelfViewCell" bundle:nil] forCellReuseIdentifier:@"ScoreCommentSelfViewCell"];
    
    //添加手势
    //开启用户交互
    _tableViewCom.userInteractionEnabled = YES;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTableCom:)];
    [_tableViewCom addGestureRecognizer:g];
    
//    
//    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
//    [swipeGestureRecognizer addTarget:self action:@selector(clickTableCom:)];
//    [swipeGestureRecognizer setNumberOfTouchesRequired:1];
//    [swipeGestureRecognizer setDirection:2];
//    [_tableViewCom addGestureRecognizer:swipeGestureRecognizer];
    
}
/**
 *  点击评论列表，展开评论，同时打开评论列表的滑动操作，取消手势。。并且关闭记分列表的滑动，在记分列表上添加手势
 *  改变评论列表的位置
 *  @param g 在评论列表上添加的手势
 */
- (void)clickTableCom:(UIGestureRecognizer *)g
{
    [UIView animateWithDuration:0.5 animations:^{
         _tableViewCom.frame = CGRectMake(0, 8*30*ScreenWidth/375, ScreenWidth, 300*ScreenWidth/375+2*30*ScreenWidth/375+3*ScreenWidth/375);
        _tableViewCom.contentOffset = CGPointMake(0, 0);
        _tableView.contentOffset = CGPointMake(0, 0);
    }];
    
   
    _tableViewCom.bounces = YES;
    _tableViewCom.scrollEnabled = YES;
    [_tableViewCom removeGestureRecognizer:g];
    
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    //添加手势
    //开启用户交互
    _tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTable:)];
    
    [_tableView addGestureRecognizer:f];
    
//    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
//    [swipeGestureRecognizer addTarget:self action:@selector(clickTable:)];
//    [swipeGestureRecognizer setNumberOfTouchesRequired:1];
//    [swipeGestureRecognizer setDirection:2];
//    [_tableViewCom addGestureRecognizer:swipeGestureRecognizer];
    
}
/**
 *  点击记分列表，收起评论，同时打开关闭列表的滑动操作，添加手势。。并且打开记分列表的滑动，在记分列表上移除手势
 *  改变评论列表的位置
 *  @param f 记分列表上添加的手势
 */
-(void)clickTable:(UIGestureRecognizer *)f
{
    
    [UIView animateWithDuration:0.5 animations:^{
        _tableViewCom.frame = CGRectMake(0, 80*ScreenWidth/375+11*30*ScreenWidth/375, ScreenWidth, 200*ScreenWidth/375);
        _tableViewCom.contentOffset = CGPointMake(0, 0);
        _tableView.contentOffset = CGPointMake(0, 0);

    }];

    [UIView animateWithDuration:0.2 animations:^{
        _commentView.frame = CGRectMake(0, ScreenHeight-45, ScreenWidth, 45);
    }];
    _tableViewCom.bounces = NO;
    _tableViewCom.scrollEnabled = NO;
    
    _tableView.bounces = YES;
    _tableView.scrollEnabled = YES;
    [_tableView removeGestureRecognizer:f];
    
    
    _tableViewCom.userInteractionEnabled = YES;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTableCom:)];
    [_tableViewCom addGestureRecognizer:g];
}

#pragma mark --评论输入框



#pragma mark - 修改输入框高度
- (void)changeTextView:(NSNotification*)notif {
    if (_commentTextView.contentSize.height >_commentTextView.frame.size.height && _commentTextView.frame.size.height<58) {
        
        //改变View  fram
        _commentView.frame = CGRectMake(_commentView.frame.origin.x,
                                        _commentView.frame.origin.y-(_commentTextView.contentSize.height-_commentTextView.frame.size.height),
                                        _commentView.frame.size.width,
                                        _commentView.frame.size.height+(_commentTextView.contentSize.height-_commentTextView.frame.size.height));
        
        //改变textView  fram
        _commentTextView.frame = CGRectMake(_commentTextView.frame.origin.x,
                                            _commentTextView.frame.origin.y,
                                            ScreenWidth-5-40-10-10,
                                            _commentTextView.contentSize.height);
        
    }
    if (_commentTextView.contentSize.height < _commentTextView.frame.size.height && _commentTextView.frame.size.height>30) {
        
        //改变View  fram
        _commentView.frame = CGRectMake(_commentView.frame.origin.x,
                                        _commentView.frame.origin.y+(_commentTextView.frame.size.height-_commentTextView.contentSize.height), _commentView.frame.size.width,
                                        _commentView.frame.size.height-(_commentTextView.frame.size.height-_commentTextView.contentSize.height));
        
        //改变textView  fram
        _commentTextView.frame = CGRectMake(_commentTextView.frame.origin.x,
                                            _commentTextView.frame.origin.y,
                                            ScreenWidth-5-40-10-10,
                                            _commentTextView.contentSize.height);
    }
}
#pragma mark - 键盘显示      （会调用三次，用全局变量_keyHigh记录上一次键盘的高度）
- (void)showKey:(NSNotification*)info {
    NSInteger hight = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (_commentTextView.isFirstResponder) {
        _isMove = YES;
        _moveHight = hight-_keyHight;
        _keyHight = hight;
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.frame = CGRectMake(_tableView.frame.origin.x,
                                          _tableView.frame.origin.y,
                                          _tableView.frame.size.width,
                                          _tableView.frame.size.height-_moveHight);
            _commentView.frame = CGRectMake(_commentView.frame.origin.x,
                                            _commentView.frame.origin.y-_moveHight,
                                            _commentView.frame.size.width,
                                            _commentView.frame.size.height);
        }];
    }
}
#pragma mark - 将键盘弹出修改的试图还原
- (void)hiddenKey{
    if (_isMove) {
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, 0, _tableView.frame.size.width, ScreenHeight-64-45);
            
            _commentView.frame = CGRectMake(_commentView.frame.origin.x, ScreenHeight-45, _commentView.frame.size.width, 45);
            
            _commentTextView.frame = CGRectMake(_commentTextView.frame.origin.x, _commentTextView.frame.origin.y, _commentTextView.frame.size.width, 30);
        }];
        _moveHight = 0;
        _isMove = NO;
        _keyHight = 0;
    }
}



//创建评论输入框视图
- (void)creatjudementView {
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-45, ScreenWidth, 45)];
    _commentView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 7, ScreenWidth-5-40-10-10, 30)];
    _commentTextView.backgroundColor = [UIColor whiteColor];
    _commentTextView.clipsToBounds = YES;
    _commentTextView.layer.cornerRadius = 5;
    _commentTextView.returnKeyType = UIReturnKeySend;
    _commentTextView.keyboardType = UIKeyboardTypeNamePhonePad;
    _commentTextView.delegate = self;
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendButton.frame = CGRectMake(ScreenWidth-10-40, 12, 40, 21);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_commentView addSubview:_sendButton];
    [_commentView addSubview:_commentTextView];
    [self.view addSubview:_commentView];
}
//发送评论
- (void)sendBtnClick {
    [_commentTextView resignFirstResponder];
    _commentTextView.text = nil;
    
//    [UIView animateWithDuration:0.2 animations:^{
//        _commentView.frame = CGRectMake(0, ScreenHeight+45, ScreenWidth, 45);
//    }];
    _isClickText = NO;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendBtnClick];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self hiddenKey];
}





#pragma mark --TableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 100 ? (indexPath.row == 0 ? 40*ScreenWidth/375 : 30*ScreenWidth/375) : 70*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 100 ? 20 : 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //成绩
    if(tableView.tag == 100)
    {
        if (indexPath.row == 0) {
            static NSString *sportCell = @"ScoreTitleTableViewCell";
            ScoreTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sportCell];
            if (cell == nil) {
                //通过xib的名称加载自定义的cell
                //            cell = [[[NSBundle mainBundle] loadNibNamed:@"ScoreTitleTableViewCell" owner:self options:nil] lastObject];
                cell = [[ScoreTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sportCell];
            }
            cell.backgroundColor = [UIColor orangeColor];
            return cell;
        }else if (indexPath.row != 0){
            //主办方
            static NSString *companyCell = @"ScoreDetailTableViewCell";
            ScoreDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCell];
            if (cell == nil) {
                //通过xib的名称加载自定义的cell
                //            cell = [[[NSBundle mainBundle] loadNibNamed:@"ScoreDetailTableViewCell" owner:self options:nil] lastObject];
                
                cell = [[ScoreDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCell];
            }
            cell.backgroundColor = [UIColor orangeColor];
            return cell;
        }else{
            return nil;
        }
    }
    
    
    else if (tableView.tag == 101)
    {
        if (indexPath.row == 0) {
            ScoreCommentOtherViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCommentOtherViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor purpleColor];
            return cell;
        
        }else if (indexPath.row != 0){
            ScoreCommentSelfViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCommentSelfViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor purpleColor];
            return cell;
            
        }else{
            return nil;
        }

    }
    return nil;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        ScoreSelfViewController *selfVc = [[ScoreSelfViewController alloc]init];
        [self.navigationController pushViewController:selfVc animated:YES];
    }
    else
    {
        if (_isClickText == NO) {
//            [UIView animateWithDuration:0.2 animations:^{
//                _commentView.frame = CGRectMake(0, ScreenHeight-45-64, ScreenWidth, 45);
//            }];
            _isClickText = YES;
        }
//        else
//        {
//            [UIView animateWithDuration:0.2 animations:^{
//                _commentView.frame = CGRectMake(0, ScreenHeight-45, ScreenWidth, 45);
//            }];
//            _isClickText = NO;
//        }

    }
    
}

@end
