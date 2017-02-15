//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActivityMemberSetViewController.h"
#import "PYTableViewIndexManager.h"
#import "JGLGuestAddPlayerViewController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "MyattenModel.h"

#import "JGLAddActiivePlayModel.h"
#import "JGLGuestActiveMemberTableViewCell.h"
#import "JGTeamGroupViewController.h"
#import "JGHAddIntentionPalyerViewController.h"

@interface JGLActivityMemberSetViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
    
    NSInteger _signUpInfoKey;//0-意向成员，1-报名成员
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGLActivityMemberSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动成员";
    _signUpInfoKey = 0;
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"设置分组" style:UIBarButtonItemStylePlain target:self action:@selector(activityGroupManager)];
    item.tintColor=[UIColor whiteColor];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15*ProportionAdapter],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
    [self uiConfig];
    //    [self createHeadSearch];
    [self createBtn];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        self.searchController.searchBar.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [_tableView reloadData];
}
#pragma mark -- 返回
- (void)backButtonClcik:(UIButton *)btn{
    if (self.delegate) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate reloadActivityMemberData];
    }
}
#pragma mark -- 分组管理
- (void)activityGroupManager{
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.teamActivityKey = [_activityKey integerValue];
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*screenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(105*screenWidth/375, 12*screenWidth/375, 20*screenWidth/375, 20*screenWidth/375)];
    imgv.image = [UIImage imageNamed:@"addGes"];
    [btn addSubview:imgv];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30*screenWidth/375, 10*screenWidth/375, screenWidth-40*screenWidth/375, 24*screenWidth/375)];
    label.font = [UIFont systemFontOfSize:16*screenWidth/375];
    label.textColor = [UIColor whiteColor];
    label.text = @"批量添加活动成员";
    label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:label];
    
//    [btn setImage:[UIImage imageNamed:@"addGes"] forState:UIControlStateNormal];
//    [btn setTitle:@"批量添加活动成员" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(13*ProportionAdapter, 20*ProportionAdapter, 13*ProportionAdapter, 20*ProportionAdapter)];
    
}

-(void)finishClick
{
    
    JGHAddIntentionPalyerViewController *addTeamPlaysCtrl = [[JGHAddIntentionPalyerViewController alloc]init];
    addTeamPlaysCtrl.activityKey = [_activityKey integerValue];
    
    addTeamPlaysCtrl.teamKey = [_teamKey integerValue];
    addTeamPlaysCtrl.allListArray = _dataArray;
    addTeamPlaysCtrl.blockRefresh = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    };
    
    [self.navigationController pushViewController:addTeamPlaysCtrl animated:YES];
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375 - 54*screenWidth/375 * 2) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLGuestActiveMemberTableViewCell class] forCellReuseIdentifier:@"JGLGuestActiveMemberTableViewCell"];
    _tableView.tag = 1001;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    //    [dict setObject:[NSNumber numberWithInteger:] forKey:@"activityKey"];
    [dict setObject:_activityKey forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_teamKey forKey:@"teamKey"];//罗开创说不传off
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:[_teamKey integerValue] activityKey:[_activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if (_page == 0)
        {
            //清除数组数据  signUpInfoKey
            [_dataArray removeAllObjects];
        }
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            for (NSDictionary *dic in [data objectForKey:@"teamSignUpList"]) {
                JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //                [model setValue:[dict objectForKey:@"name"] forKey:@"userName"];
                model.userName = model.name;
                [_dataArray addObject:model];
            }
            self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:_dataArray]];
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            [_tableView reloadData];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 1001 ? 50*ScreenWidth/375 : 40*ScreenWidth/375;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 1001 ?[self.listArray[section] count] : 4;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tableView.tag == 1001 ?[self.listArray count] : 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1001) {
        if ([self.listArray[section] count] == 0) {
            return nil;
        }else{
            return self.keyArray[section];
        }
    }
    else{
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLGuestActiveMemberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLGuestActiveMemberTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JGLAddActiivePlayModel *model = self.listArray[indexPath.section][indexPath.row];
    cell.nameLabel.text = model.userName;
    [cell.iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    cell.iconImgv.layer.cornerRadius = cell.iconImgv.frame.size.height/2;
    cell.iconImgv.layer.masksToBounds = YES;
    
    cell.mobileLabel.text = [self.listArray[indexPath.section][indexPath.row]mobile];
    
    if ([model.sex integerValue] == 1) {
        [cell.sexImgv setImage: [UIImage imageNamed:@"xb_nn"]];
    }else if ([model.sex integerValue] == 0) {
        [cell.sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
    }
    
//    if ([model.signUpInfoKey integerValue] == -1) {
//        cell.moneyLabel.text = @"意向成员";
//        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"#7fc1ff"];
//    }
//    else{
//        NSString* strMoney = [NSString stringWithFormat:@"已付¥%@",model.payMoney];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strMoney];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e00000"] range:NSMakeRange(2, strMoney.length-2)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
//        cell.moneyLabel.attributedText = attributedString;
//    }
    
    if (model.almost) {
        cell.almostLabel.text = [NSString stringWithFormat:@"差点  %.1f", [model.almost floatValue]];
    }else{
        cell.almostLabel.text = @"差点";
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}



// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 1001) {
        //  改变索引颜色
        _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
        NSInteger number = [_listArray count];
        return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
    }
    else{
        return nil;
    }
    
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView.tag == 1001) {
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        
        if (![_listArray[index] count]) {
            
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    }
    else
    {
        return 0;
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.section == %td", indexPath.section);
    NSLog(@"indexPath.row == %td", indexPath.row);
    NSString *type = nil;
    JGLAddActiivePlayModel *model = self.listArray[indexPath.section][indexPath.row];
//    if ([model.signUpInfoKey integerValue] == -1) {
//        type = @"删除";
//        _signUpInfoKey = 0;
//    }else{
//        _signUpInfoKey = 1;
//        type = @"取消报名";
//    }
    type = @"取消报名";

    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:type handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"00000");
        [self cancelAndDeleateApplyIndex:indexPath.section andRow:indexPath.row];
    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
    /*
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
    }];
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];//可以定义RowAction的颜色
     */
    return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
}
#pragma mark -- 取消报名－－取消意向
- (void)cancelAndDeleateApplyIndex:(NSInteger)index andRow:(NSInteger)row{
    
    JGLAddActiivePlayModel *mod = self.listArray[index][row];

    
    NSString *alertString = [NSString stringWithFormat:@"是否要帮%@取消报名",mod.userName];
//    if (_signUpInfoKey == 0) {
//        alertString = @"确定取消意向？";
//    }else{
//        alertString = @"确定取消报名？";
//    }
    
    [Helper alertViewWithTitle:alertString withBlockCancle:^{
        NSLog(@"取消");
    } withBlockSure:^{
        JGLAddActiivePlayModel *model = self.listArray[index][row];
//        if (_signUpInfoKey == 0) {
//            //deleteLineTeamActivitySignUp
//            [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
//            /**
//             @Param(value="teamKey"               , require=true) Long teamKey,    // 球队key
//             @Param(value="userKey"               , require=true) Long userKey,    // 用户Key
//             @Param(value="signupKey"             , require=true) Long signupKey,  // 报名timeKey
//             */
//            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//            [postDict setObject:model.timeKey forKey:@"signupKey"];
//            //activityKey
//            [postDict setObject:[NSString stringWithFormat:@"%@", _teamKey] forKey:@"teamKey"];
//            [postDict setObject:DEFAULF_USERID forKey:@"userKey"];
//            
//            [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/deleteLineTeamActivitySignUp" JsonKey:nil withData:postDict failedBlock:^(id errType) {
//                NSLog(@"errType == %@", errType);
//                [[ShowHUD showHUD]hideAnimationFromView:self.view];
//            } completionBlock:^(id data) {
//                NSLog(@"data == %@", data);
//                [[ShowHUD showHUD]hideAnimationFromView:self.view];
//                
//                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//                    [LQProgressHud showMessage:@"删除意向成功"];
//                    [self headRereshing];
//                }else{
//                    if ([data objectForKey:@"packResultMsg"]) {
//                        [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
//                    }
//                }
//            }];
//        }else{
            //doUnSignUpTeamActivity
            [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            NSMutableArray *signupKeyArray = [NSMutableArray array];
            [signupKeyArray addObject:model.timeKey];
            //signupKeyList
            [postDict setObject:signupKeyArray forKey:@"signupKeyList"];
            //activityKey
            [postDict setObject:[NSString stringWithFormat:@"%@", _activityKey] forKey:@"activityKey"];
            
            [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doUnSignUpTeamActivity" JsonKey:nil withData:postDict failedBlock:^(id errType) {
                NSLog(@"errType == %@", errType);
                [[ShowHUD showHUD]hideAnimationFromView:self.view];
            } completionBlock:^(id data) {
                NSLog(@"data == %@", data);
                [[ShowHUD showHUD]hideAnimationFromView:self.view];
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    [LQProgressHud showMessage:@"取消报名成功！"];
                    [self headRereshing];
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                    }
                }
            }];
//        }
    } withBlock:^(UIAlertController *alertView) {
       [self presentViewController:alertView animated:YES completion:nil];
    }];
}

@end
