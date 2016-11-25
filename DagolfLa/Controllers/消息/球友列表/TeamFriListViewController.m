//
//  InformViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/3/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "TeamFriListViewController.h"
#import "ContactViewController.h"
#import "PostDataRequest.h"
#import "RecomeFriendViewController.h"
#import "NewFriendModel.h"
#import "NewFriendTableViewCell.h"
#import "MJDIYBackFooter.h"

#import "MJRefreshComponent.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"

#import "PersonHomeController.h"
#import "MyattenModel.h"


#import "JGScanAddTableViewCell.h" // 扫描添加cell

#import "JGLAddressAddTableViewCell.h" 

#import "JGSearchNewFriendTableViewCell.h"

#import "JGLBarCodeViewController.h"  // 扫码框


@interface TeamFriListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableDictionary *paraDic;
@property (assign, nonatomic) int page;

@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, assign) BOOL begainSearch;

@property (nonatomic, assign) BOOL contactISOpen;

@property (nonatomic, strong) UITableView *contactTableView;

// 通讯录
@property (nonatomic, strong) NSMutableArray *addressBookTemp;
@property (strong, nonatomic) NSMutableArray *keyArray;
@property (strong, nonatomic) NSMutableArray *listArray;

@end

//static int page = 1;
@implementation TeamFriListViewController

//- (void)dealloc{
//    self.searchController = nil;
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        //        [self.searchController.searchBar removeFromSuperview];
        self.searchController.searchBar.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加球友";

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
//    self.view = _tableView;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    self.searchController.searchBar.placeholder = @"请输入昵称／手机号添加好友";
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.searchController.searchBar.barTintColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UISearchBar *searchBar = self.searchController.searchBar;
    UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = RGBA(238,238,238,1).CGColor;
    barImageView.layer.borderWidth = 1;
    
    
    UITextField *searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
//    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.clearButtonMode = UITextFieldViewModeNever;
    searchTextField.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    searchTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"msg_search_kuang"]];
    
    self.contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(333 * ProportionAdapter, searchBar.frame.origin.y + 13, 20 * ProportionAdapter, 20 * ProportionAdapter)];
    [self.contactBtn setImage:[UIImage imageNamed:@"phonenumber"] forState:(UIControlStateNormal)];
    [self.contactBtn addTarget:self action:@selector(contantAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.searchController.searchBar addSubview:self.contactBtn];
    self.contactBtn.enabled = NO;
    
    self.begainSearch = NO;
    self.contactISOpen = NO;
    // Do any additional setup after loading the view.
}


#pragma mark --- 联系人tableview

- (void)contantAct:(UIButton *)btn{
    
    [self.searchController.searchBar endEditing:YES];

    self.tableView.scrollEnabled = NO;

    
    
    self.contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54 * ProportionAdapter, screenWidth, screenHeight-15*screenWidth/375)];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    [self.view addSubview:self.contactTableView];
    
    [self.contactTableView registerClass:[JGLAddressAddTableViewCell class] forCellReuseIdentifier:@"JGLAddressAddTableViewCell"];
    self.contactISOpen = YES;
    
    
    
    
    [self.listArray removeAllObjects];
    [self.keyArray removeAllObjects];
    [self.addressBookTemp removeAllObjects];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TKAddressModel *addressBook = [[TKAddressModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.userName = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.isSelectNumber = 0;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.mobile = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.addressBookTemp addObject:addressBook];
        
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    if (self.addressBookTemp.count != 0) {
        TKAddressModel *addressBook = self.addressBookTemp[0];
        addressBook.isSelectNumber=1;
        
        self.listArray = [[NSMutableArray alloc]initWithArray:[JGTeamMemberManager archiveNumbers:self.addressBookTemp]];
        
        _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
        
        for (int i = (int)self.listArray.count-1; i>=0; i--) {
            if ([self.listArray[i] count] == 0) {
                [self.keyArray removeObjectAtIndex:i];
                [self.listArray removeObjectAtIndex:i];
            }
        }
        
        
    }
    [_contactTableView reloadData];

    
}

// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    if (self.contactISOpen == YES) {
    _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
    NSInteger number = [_listArray count];
    return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
    }else{
        return nil;
    }
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if (![_listArray[index] count]) {
        return 0;
    }else{
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        return index;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (!self.searchController.active || [self.searchArray count] == 0) {
//        return 60 * ProportionAdapter;
//    }else{
//        return 70 * ProportionAdapter;
//    }
    return 60 * ProportionAdapter;
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.begainSearch == YES) {
        if (self.contactISOpen == YES) {
            return [self.listArray[section] count];
        }else{
            return [self.searchArray count];
        }
    }else{
        self.tableView.footer = nil;
        return 1;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.contactISOpen == YES) {
        return [self.listArray count];
    }else{
        return 1;
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.begainSearch == YES) {
        
        
        if (self.contactISOpen == YES) {
            JGLAddressAddTableViewCell* cell = [_contactTableView dequeueReusableCellWithIdentifier:@"JGLAddressAddTableViewCell"];
            cell.isGest = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelName.text = [self.listArray[indexPath.section][indexPath.row] userName];
            
            cell.labelMobile.text = [self.listArray[indexPath.section][indexPath.row] mobile];
            
            cell.imgvState.hidden = YES;
            return cell;
            
        }else{
            
            static NSString *identifier = @"cellF";
            JGSearchNewFriendTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell==nil) {
                cell=[[JGSearchNewFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([self.searchArray count] > 0) {
                NewFriendModel *myAtModel = [[NewFriendModel alloc] init];
                myAtModel = self.searchArray[indexPath.row];
                [cell showData:myAtModel];
            }
            
            [cell.addBtn addTarget:self action:@selector(addFriAct:event:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }


    }else{
        static NSString *flag=@"cellFlag";
        JGScanAddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell==nil) {
            cell=[[JGScanAddTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:flag];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}


#pragma mark ------搜索框回调方法

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

}


#pragma mark --- 添加好友的按钮

- (void)addFriAct:(UIButton *)btn event:(id)event{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    
//    JGSearchNewFriendTableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    NewFriendModel *myAtModel = self.searchArray[indexPath.row];
    
    [[ShowHUD showHUD] showAnimationWithText:@"发送中…" FromView:self.view];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:myAtModel.userId forKey:@"friendUserKey"];
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"userFriend/doApply" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];

    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            [LQProgressHud showMessage:@"添加请求已发送"];
            [self.searchArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}


#pragma mark ---搜索

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [[ShowHUD showHUD] showAnimationWithText:@"搜索中…" FromView:self.view];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:DEFAULF_USERID forKey:@"userKey"];
    [dic setValue:searchBar.text forKey:@"searchStr"];
    [dic setValue:@"0" forKey:@"offset"];
    
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"userFriend/getSearchUser" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                [self.searchArray removeAllObjects];
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    NewFriendModel *myAtModel = [[NewFriendModel alloc] init];
                    [myAtModel setValuesForKeysWithDictionary:dic];
                    [self.searchArray addObject:myAtModel];
                }
                [self.tableView reloadData];
            }else{
                [LQProgressHud showMessage:@"找不到该用户"];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
        
    }];
    
//    [[JsonHttp jsonHttp] httpRequest:@"userFriend/getSearchUser" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
//        
//    } completionBlock:^(id data) {

        

//    }];

    
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.begainSearch == YES) {
//        if (indexPath.row == 1) {
//            RecomeFriendViewController* reVc = [[RecomeFriendViewController alloc]init];
//            [self.navigationController pushViewController:reVc animated:YES];
//        }
//        
        if (self.contactISOpen == YES) {
            self.contactISOpen = NO;
            TKAddressModel *addressBook = self.listArray[indexPath.section][indexPath.row];
            self.searchController.searchBar.text = addressBook.mobile;
            [self.contactTableView removeFromSuperview];
            [self.searchController.searchBar becomeFirstResponder];
        }
    }
    else
    {
        
        
        JGLBarCodeViewController *barSorVC = [[JGLBarCodeViewController alloc] init];
        barSorVC.fromWitchVC = 2;
        [self.navigationController pushViewController:barSorVC animated:YES];
//        PersonHomeController *selfVC = [[PersonHomeController alloc] init];
//        MyattenModel *myModel = self.searchArray[indexPath.row];
//        selfVC.strMoodId = myModel.userId;
//        [self.navigationController pushViewController:selfVC animated:YES];
    }
}


- (void)refrenshing1{
    _page ++;
    [self.paraDic setObject:[NSNumber numberWithInt:_page] forKey:@"page"];
    [[PostDataRequest sharedInstance] postDataRequest:@"user/searchTuser.do" parameter:self.paraDic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSArray *arra = [dict objectForKey:@"rows"];
            
            for (NSDictionary *dic in arra) {
                NewFriendModel *myModel = [[NewFriendModel alloc] init];
                [myModel setValuesForKeysWithDictionary:dic];
                [self.searchArray addObject:myModel];
            }
            
            [self.tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView.footer endRefreshing];
    } failed:^(NSError *error) {
        
    }];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    self.navigationController.navigationBarHidden = YES;
    if ([self.view.subviews containsObject:self.contactTableView]) {
        self.contactISOpen = NO;
        [self.contactTableView removeFromSuperview];
    }

    self.contactBtn.frame = CGRectMake(280 * ProportionAdapter, self.searchController.searchBar.frame.origin.y + 13, 20 * ProportionAdapter, 20 * ProportionAdapter);
    self.begainSearch = YES;
    _tableView.scrollEnabled = YES;
    self.contactBtn.enabled = YES;
    [self.tableView reloadData];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    if ([self.view.subviews containsObject:self.contactTableView]) {
        self.contactISOpen = NO;
        [self.contactTableView removeFromSuperview];
    }
    self.navigationController.navigationBarHidden = NO;
    self.begainSearch = NO;
    [self.tableView reloadData];
    _tableView.scrollEnabled = NO;
    self.contactBtn.frame = CGRectMake(333 * ProportionAdapter,  self.searchController.searchBar.frame.origin.y + 13, 20 * ProportionAdapter, 20 * ProportionAdapter);
    self.contactBtn.enabled = NO;

}

- (NSMutableArray *)addressBookTemp{
    if (!_addressBookTemp) {
        _addressBookTemp = [[NSMutableArray alloc] init];
    }
    return _addressBookTemp;
}

- (NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc] init];
    }
    return _keyArray;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
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
