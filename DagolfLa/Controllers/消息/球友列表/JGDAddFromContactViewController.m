//
//  JGDAddFromContactViewController.m
//  DagolfLa
//
//  Created by 東 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDContactUpdata.h"
#import "JGLTeamMemberModel.h"

#import "JGDAddFromContactViewController.h"
#import "JGDAddFromContactTableViewCell.h"
#import "JGAddFriendViewController.h"
#import <MessageUI/MessageUI.h>

@interface JGDAddFromContactViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray *resultDataArray;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) UITextField *searchTF;


// 通讯录
@property (nonatomic, strong) NSMutableArray *addressBookTemp;
@property (strong, nonatomic) NSMutableArray *keyArray;
@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation JGDAddFromContactViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSearchTable];
    
    [self contactGet];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    [JGDContactUpdata contanctUpload:^(NSMutableArray *contactArray) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        [self.addressBookTemp removeAllObjects];
        if (contactArray.count != 0) {
            
            for (NSDictionary*dic in contactArray) {
                JGLTeamMemberModel *addressBook = [[JGLTeamMemberModel alloc] init];
                addressBook.userName = [dic objectForKey:@"cName"];
                addressBook.mobile = [dic objectForKey:@"phone"];
                addressBook.isFriend = [[dic objectForKey:@"isFriend"] integerValue];
                addressBook.isAppUser = [[dic objectForKey:@"isAppUser"] integerValue];
                if ([dic objectForKey:@"userKey"]) {
                    addressBook.userKey = [dic objectForKey:@"userKey"];
                }
                [self.addressBookTemp addObject:addressBook];
            }
            
            
            //            self.addressBookTemp = contactArray;
            
            //            TKAddressModel *addressBook = self.addressBookTemp[0];
            //            addressBook.isSelectNumber=1;
            
            self.listArray = [[NSMutableArray alloc]initWithArray:[JGTeamMemberManager archiveNumbers:self.addressBookTemp]];
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            
            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            
        }
        [self.searchTable reloadData];
        
        
    }error:^(NSString *error) {
        if (error) {
            [[ShowHUD showHUD] hideAnimationFromView:self.view];
            [LQProgressHud showMessage:error];
            
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)contactGet{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        NSLog(@"%@" , sema);
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
    [self.searchTable reloadData];
}


- (void)createSearchTable{
    
    self.searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 * ProportionAdapter, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    self.searchTable.tag = 50;
    self.searchTable.rowHeight = 28 * ProportionAdapter;
    self.searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTable.backgroundColor = [UIColor whiteColor];
    self.searchTable.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.searchTable registerClass:[JGDAddFromContactTableViewCell class] forCellReuseIdentifier:@"JGDAddFromContact"];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64 * ProportionAdapter)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10* ProportionAdapter, 25* ProportionAdapter, 300* ProportionAdapter, 30* ProportionAdapter)];
    self.searchTF.borderStyle = UITextBorderStyleNone;
    self.searchTF.layer.cornerRadius = 6 * ProportionAdapter;
    self.searchTF.clipsToBounds = YES;
    self.searchTF.placeholder = @"  搜索";
    self.searchTF.delegate = self;
    self.searchTF.background = [self imageFromColor:[UIColor whiteColor]];
    self.searchTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [headView addSubview:self.searchTF];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(310* ProportionAdapter, 25* ProportionAdapter, 60* ProportionAdapter, 30* ProportionAdapter)];
    [button setTitle:@"取消" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor colorWithHexString:@"#32B14D"] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    [button addTarget:self action:@selector(searchAct) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:button];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5 * ProportionAdapter, 5, 31 * ProportionAdapter, 17 * ProportionAdapter)];
    imageV.image = [UIImage imageNamed:@"Search-1"];
    self.searchTF.leftView = imageV;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    [self.view addSubview:headView];
    
    [self.view addSubview:self.searchTable];
    
    /*
     + (void)animateWithDuration:(NSTimeInterval)duration
     delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
     initialSpringVelocity:(CGFloat)velocity
     options:(UIViewAnimationOptions)options
     animations:(void (^)(void))animations
     completion:(void (^)(BOOL finished))completion
     */
    
}

// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    self.searchTable.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
    NSInteger number = [_listArray count];
    return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keyArray[section];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [header.textLabel setTextColor:[UIColor colorWithHexString:@"#a0a0a0"]];
    header.textLabel.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51 * ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDAddFromContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDAddFromContact"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLB.text = [self.listArray[indexPath.section][indexPath.row] userName];
    cell.mobileLB.text = [self.listArray[indexPath.section][indexPath.row] mobile];
    
    if ([self.listArray[indexPath.section][indexPath.row] isKindOfClass:[TKAddressModel class]]) {
        cell.button.hidden = YES;
        
    }else{
        cell.button.hidden = NO;
        if ([self.listArray[indexPath.section][indexPath.row] isAppUser] == 0) {
            // 邀请
            cell.state = 0;
            [cell.button addTarget:self action:@selector(clickAct:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }else{
            if ([self.listArray[indexPath.section][indexPath.row] isFriend] == 0) {
                // 添加
                cell.state = 1;
                [cell.button addTarget:self action:@selector(clickAct:) forControlEvents:(UIControlEventTouchUpInside)];
                
                
            }else{
                // 已添加
                cell.state = 2;
                
            }
        }
    }
    
    return cell;
}

- (void)clickAct:(UIButton *)currentBtn{
    
    JGDAddFromContactTableViewCell *cell = (JGDAddFromContactTableViewCell *)[[currentBtn superview] superview];
    NSIndexPath *indexPath = [self.searchTable indexPathForCell:cell];
    
    if ([self.listArray[indexPath.section][indexPath.row] isAppUser] == 0) {
        // 邀请

            [self showMessageView:@[[self.listArray[indexPath.section][indexPath.row] mobile]] title:@"" body:@"嗨！我正在使用君高高尔夫APP，感觉很不错，推荐你下载使用。下载链接：https://itunes.apple.com/cn/app/君高高尔夫-打造专业的高尔夫社群平台/id1056048082?mt=8"];
        
    }else{
        if ([self.listArray[indexPath.section][indexPath.row] isFriend] == 0) {
            // 添加
            JGAddFriendViewController *addVC = [[JGAddFriendViewController alloc] init];
            addVC.otherUserKey = [self.listArray[indexPath.section][indexPath.row] userKey];
            addVC.popToVC = ^(NSInteger sendNum){
                
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }else{
            // 已添加
            
        }
    }
    
    
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark messageComposeViewController Deleaget Method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(result==MessageComposeResultSent)
    {
        [LQProgressHud showMessage:@"发短信成功"];
    }
    else if(result==MessageComposeResultCancelled)
    {
        [LQProgressHud showMessage:@"发短信取消"];
    }
    else if(result==MessageComposeResultFailed)
    {
        [LQProgressHud showMessage:@"发短信失败"];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ------搜索框回调方法


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"TEXT - %@ - TEXT" ,textField.text);
    NSLog(@"sting - %@ - string" ,string);
    
    NSMutableString *sring = [NSMutableString stringWithFormat:@"%@" ,textField.text];
    [sring replaceCharactersInRange:range withString:string];
    NSLog(@"%@" ,sring);
    [self search:sring];
    return YES;
    
}


- (void)search:(NSString *)searchStr{
    NSDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setValue:DEFAULF_USERID forKey:@"userKey"];
    [userDic setValue:searchStr forKey:@"keyword"];
    [userDic setValue: [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp] httpRequest:@"mobileContact/getUserMobileContactList" JsonKey:nil withData:userDic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"cList"]) {
                
                [self.addressBookTemp removeAllObjects];
                if ([data objectForKey:@"cList"] != 0) {
                    
                    for (NSDictionary*dic in [data objectForKey:@"cList"]) {
                        JGLTeamMemberModel *addressBook = [[JGLTeamMemberModel alloc] init];
                        addressBook.userName = [dic objectForKey:@"cName"];
                        addressBook.mobile = [dic objectForKey:@"phone"];
                        addressBook.isFriend = [[dic objectForKey:@"isFriend"] integerValue];
                        addressBook.isAppUser = [[dic objectForKey:@"isAppUser"] integerValue];
                        
                        [self.addressBookTemp addObject:addressBook];
                    }
                    
                    
                    //            self.addressBookTemp = contactArray;
                    
                    //            TKAddressModel *addressBook = self.addressBookTemp[0];
                    //            addressBook.isSelectNumber=1;
                    
                    self.listArray = [[NSMutableArray alloc]initWithArray:[JGTeamMemberManager archiveNumbers:self.addressBookTemp]];
                    
                    _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
                    
                    for (int i = (int)self.listArray.count-1; i>=0; i--) {
                        if ([self.listArray[i] count] == 0) {
                            [self.keyArray removeObjectAtIndex:i];
                            [self.listArray removeObjectAtIndex:i];
                        }
                    }
                    
                }
                [self.searchTable reloadData];
                
            }
        }
    }];
}

//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//
//}

- (void)searchAct{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (UIImage *)imageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 3, 3);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (NSMutableArray *)addressBookTemp{
    if (!_addressBookTemp) {
        _addressBookTemp = [[NSMutableArray alloc] init];
    }
    return _addressBookTemp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * 获取用户的通讯录列表
 * @Title: getUserMobileContactList
 * @param userKey
 * @param keyword
 * @param md5
 * @param response
 * @throws Throwable
 * @author lyh
 @HttpService(RequestURL = "/getUserMobileContactList" , method = "get")
 public void getUserMobileContactList(
 @Param(value="userKey",  require=true)  Long    userKey,
 @Param(value="keyword",  require=false) String  keyword,
 @Param(value="md5"    ,  require=true)  String  md5,
 TcpResponse  response
 */



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
