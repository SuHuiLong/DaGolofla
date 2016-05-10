//
//  ContactViewController.m
//  DagolfLa
//
//  Created by 東 on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ContactViewController.h"
#import "PostDataRequest.h"
#import "MyattenModel.h"
#import "ChineseString.h"
#import "PYTableViewIndexManager.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "BallFriListCell.h"
#import "Helper.h"
#import "TeamFriListViewController.h"
#import "PersonHomeController.h"
#import "NewFriendViewController.h"
#import "ChatDetailViewController.h"

#import "AddNoteViewController.h"

#import "NoteModel.h"
#import "NoteHandlle.h"
//#import "OtherDataModel.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;
@property (strong, nonatomic)UITapGestureRecognizer *infoTap;

@end

@implementation ContactViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

#warning 推荐功能还没完善
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jqy"] style:UIBarButtonItemStylePlain target:self action:@selector(contact)];
//    item.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = item;
    
    self.title = @"球友通讯录";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.rowHeight = 60 * ScreenWidth / 375;
    self.view = self.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
//    [self setData];
    // Do any additional setup after loading the view.
}

-(void)contact
{
    TeamFriListViewController * tVc = [[TeamFriListViewController alloc]init];
    [self.navigationController pushViewController:tVc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [self.listArray[section - 1] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listArray count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        return nil;
    }else{
        if ([self.listArray[section - 1] count] == 0) {
            return nil;
        }else{
            return self.keyArray[section - 1];
        }}
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    BallFriListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BallFriListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        BallFriListCell* cell1 = [[BallFriListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"1"];
        cell1.myImageV.image = [UIImage imageNamed:@"xxpy"];
        cell1.myImageV.frame = CGRectMake(20*ScreenWidth/375,18*ScreenWidth/375, 30*ScreenWidth/375, 24*ScreenWidth/375);
        cell1.myLabel.text = @"新朋友";
        cell1.myLabel.textColor = [UIColor blueColor];
        cell1.myImageV.contentMode = UIViewContentModeScaleAspectFit;
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }else{
        self.infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infotapclick:)];
        [cell.myImageV addGestureRecognizer:self.infoTap];
        
        MyattenModel *model = self.listArray[indexPath.section - 1][indexPath.row];
        NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
        if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {

        }else{
            model.userName = modell.userremarks;
        }
        

        cell.myModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NewFriendViewController *newVC = [[NewFriendViewController alloc] init];
        [self.navigationController pushViewController:newVC animated:YES];
        
    }else{
        ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
        //设置聊天类型
        vc.conversationType = ConversationType_PRIVATE;
        //设置对方的id
        vc.targetId = [NSString stringWithFormat:@"%@",[_listArray[indexPath.section - 1][indexPath.row] otherUserId]];
        //设置对方的名字
        //    vc.userName = model.conversationTitle;
        //设置聊天标题
        vc.title = [_listArray[indexPath.section - 1][indexPath.row] userName];
        //设置不现实自己的名称  NO表示不现实
        vc.displayUserNameInCell = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ------球友列表头像点击事件

- (void)infotapclick:(UITapGestureRecognizer *)tap{
    
    BallFriListCell *cell = (BallFriListCell *)[[[tap view] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PersonHomeController *selfVC = [[PersonHomeController alloc] init];
    MyattenModel *myModel = self.listArray[indexPath.section - 1][indexPath.row];
    selfVC.strMoodId = myModel.otherUserId;
    [self.navigationController pushViewController:selfVC animated:YES];
    
}


// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    self.tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
    NSInteger number = [self.listArray count];
    return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index + 1];
    
    if (![self.listArray[index] count]) {
        
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        return index + 1;
    }
}


// 获取所有关注好友信息
- (void)setData{
    
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/querbyUserFollowList.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":@0,@"page":@0,@"rows":@0} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSArray *array = [dict objectForKey:@"rows"];
            NSMutableArray *allFriarr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                MyattenModel *model = [[MyattenModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];

                NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
                if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
                    
                }else{
                    model.userName = modell.userremarks;
                }
                
                [allFriarr addObject:model];
//                [self.keyArray addObject:model.userName];
            }
            
            self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:allFriarr]];
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];

            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            [self.tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failed:^(NSError *error) {
        
        
    }];
 
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BallFriListCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewRowAction *note = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 实现相关的逻辑代码
        // ...
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
        tableView.editing = NO;
        AddNoteViewController *AVC = [[AddNoteViewController alloc] init];
        AVC.isFollow = YES;
        AVC.userRemark = cell.myLabel.text;
        MyattenModel *model = self.listArray[indexPath.section - 1][indexPath.row];
        
        AVC.otherUid = model.otherUserId;
        
        [self.navigationController pushViewController:AVC animated:YES];
    }];

    return @[note];
    
}

- (NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    }
    return _keyArray;
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
