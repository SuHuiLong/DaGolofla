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

#import "JGHNoteViewController.h"

#import "NoteModel.h"
#import "NoteHandlle.h"
//#import "OtherDataModel.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;
@property (strong, nonatomic)UITapGestureRecognizer *infoTap;

@property (nonatomic, strong) UIImageView *cryImageV;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) UILabel *addFriendSumLB;

@end

@implementation ContactViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIButton *costumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21 * ProportionAdapter, 21 * ProportionAdapter)];
    [costumBtn setImage:[UIImage imageNamed:@"jqy"] forState:(UIControlStateNormal)];
    [costumBtn addTarget:self action:@selector(contact) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithCustomView:costumBtn];
    
    self.navigationItem.rightBarButtonItem = itm;

//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jqy"] style:UIBarButtonItemStylePlain target:self action:@selector(contact)];
//    
//    item.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = item;
    
    self.title = @"球友通讯录";
//    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, screenHeight - 50 * ProportionAdapter)];
    self.tableView.rowHeight = 49 * ScreenWidth / 375;
    self.view = self.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    //    [self setData];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIView *EEEVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    EEEVIew.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.tableHeaderView = EEEVIew;
    
    [self setData];

    // Do any additional setup after loading the view.
}

-(void)contact
{
    TeamFriListViewController * tVc = [[TeamFriListViewController alloc]init];
    [self.navigationController pushViewController:tVc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
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
        cell1.myImageV.frame = CGRectMake(20*ScreenWidth/375,13*ScreenWidth/375, 26*ScreenWidth/375, 23*ScreenWidth/375);
        cell1.myLabel.frame = CGRectMake(cell1.myImageV.frame.size.width + 5 * 5 * ScreenWidth / 375 + 3 * ScreenWidth / 375, 0, 200, 49 * ScreenWidth/375);
        cell1.myLabel.textColor = [UIColor colorWithHexString:@"#0054bd"];
        cell1.myLabel.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
        cell1.myImageV.layer.masksToBounds = NO;
        cell1.myImageV.contentMode = UIViewContentModeScaleAspectFit;
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.sexImageV.hidden = YES;
        if (indexPath.row == 0) {
            cell1.myLabel.text = @"球友推荐";
            cell1.myImageV.image = [UIImage imageNamed:@"xxpy"];
        }else{
            cell1.myLabel.text = @"新球友";
            cell1.myImageV.image = [UIImage imageNamed:@"icon_intro-new"];
            
            if ([_addFriendSum integerValue] > 0) {
                self.addFriendSumLB.text = [_addFriendSum stringValue];
                [cell1.myImageV addSubview:self.addFriendSumLB];
            }

        }
        
        return cell1;
    }else{
//        self.infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infotapclick:)];
//        [cell.myImageV addGestureRecognizer:self.infoTap];
        
        MyattenModel *model = self.listArray[indexPath.section - 1][indexPath.row];
//        NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
//        if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
//            
//        }else{
//            model.userName = modell.userremarks;
//        }
        
        
        cell.myModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NewFriendViewController *newVC = [[NewFriendViewController alloc] init];
            newVC.fromWitchVC = 1;
            [self.navigationController pushViewController:newVC animated:YES];
            
        }else{
            NewFriendViewController *newVC = [[NewFriendViewController alloc] init];
            newVC.fromWitchVC = 2;
            _addFriendSum = 0;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            [self.navigationController pushViewController:newVC animated:YES];
            
        }
        
    }else{
        JGHPersonalInfoViewController *vc = [[JGHPersonalInfoViewController alloc] init];
        
        //设置对方的id
        vc.otherKey = [_listArray[indexPath.section - 1][indexPath.row] friendUserKey];

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
    self.tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
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
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject: [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp] httpRequest:@"userFriend/getUserFriendList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                
                NSArray *array = [data objectForKey:@"list"];
                NSMutableArray *allFriarr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in array) {
                    MyattenModel *model = [[MyattenModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    if (![model.userName isEqualToString:@""]) {
//                        NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
//                        if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
//                            
//                        }else{
//                            model.userName = modell.userremarks;
//                        }
                        if (model.userName) {
                            [allFriarr addObject:model];
                        }
                        //                [self.keyArray addObject:model.userName];
                    }
                    
                }
                
                self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:allFriarr]];
                
                _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
                
                for (int i = (int)self.listArray.count-1; i>=0; i--) {
                    if ([self.listArray[i] count] == 0) {
                        [self.keyArray removeObjectAtIndex:i];
                        [self.listArray removeObjectAtIndex:i];
                    }
                }
                
                if ([self.tableView.subviews containsObject:self.cryImageV]) {
                    self.cryImageV.hidden = YES;
                    self.tipLB.hidden = YES;
                }
                
                [self.tableView reloadData];
                
            }else{

                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 110 * ProportionAdapter, screenWidth, screenHeight)];
                bgView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
                [self.tableView addSubview:bgView];
                
                self.cryImageV = [[UIImageView alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 100 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
                self.cryImageV.image = [UIImage imageNamed:@"bg-shy"];
                [bgView addSubview:self.cryImageV];
                
                self.tipLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 230 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 20 * ProportionAdapter)];
                self.tipLB.text = @"您还没有球友哦，赶快去添加吧！";
                self.tipLB.textAlignment = NSTextAlignmentCenter;
                self.tipLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
                [bgView addSubview:self.tipLB];

            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
        
    }];
    
    
    
    
    //    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/querbyUserFollowList.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":@0,@"page":@0,@"rows":@0} success:^(id respondsData) {
    //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
    //
    //        if ([[dict objectForKey:@"success"] boolValue]) {
    //            NSArray *array = [dict objectForKey:@"rows"];
    //            NSMutableArray *allFriarr = [[NSMutableArray alloc] init];
    //            for (NSDictionary *dic in array) {
    //                MyattenModel *model = [[MyattenModel alloc] init];
    //                [model setValuesForKeysWithDictionary:dic];
    //                if (![model.userName isEqualToString:@""]) {
    //                    NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
    //                    if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
    //
    //                    }else{
    //                        model.userName = modell.userremarks;
    //                    }
    //
    //                    [allFriarr addObject:model];
    //                    //                [self.keyArray addObject:model.userName];
    //                }
    //
    //            }
    //
    //            self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:allFriarr]];
    //
    //            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    //
    //            for (int i = (int)self.listArray.count-1; i>=0; i--) {
    //                if ([self.listArray[i] count] == 0) {
    //                    [self.keyArray removeObjectAtIndex:i];
    //                    [self.listArray removeObjectAtIndex:i];
    //                }
    //            }
    //            [self.tableView reloadData];
    //        }else {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //            [alert show];
    //        }
    //
    //    } failed:^(NSError *error) {
    //
    //
    //    }];
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BallFriListCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewRowAction *note = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 实现相关的逻辑代码
        // ...
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
        tableView.editing = NO;
        JGHNoteViewController *AVC = [[JGHNoteViewController alloc] init];

        MyattenModel *model = self.listArray[indexPath.section - 1][indexPath.row];
        AVC.friendUserKey = model.friendUserKey;
        AVC.blockRereshNote = ^(NSString *name){
            cell.myLabel.text = name;
            model.userName = name;
        };
        [self.navigationController pushViewController:AVC animated:YES];
    }];
    
    return @[note];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return NO;
    }else{
        return YES;
    }
    
}

- (NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    }
    return _keyArray;
}

- (UILabel *)addFriendSumLB{
    if (!_addFriendSumLB) {
        _addFriendSumLB = [[UILabel alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, -5 * ProportionAdapter, 16 * ProportionAdapter, 16 * ProportionAdapter)];
        _addFriendSumLB.layer.cornerRadius = 8 * ProportionAdapter;
        _addFriendSumLB.clipsToBounds = YES;
        _addFriendSumLB.backgroundColor = [UIColor  redColor];
        _addFriendSumLB.textAlignment = NSTextAlignmentCenter;
        _addFriendSumLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        _addFriendSumLB.textColor = [UIColor whiteColor];
    }
    return _addFriendSumLB;
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
