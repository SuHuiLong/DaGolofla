//
//  JGDAddFromContactViewController.m
//  DagolfLa
//
//  Created by 東 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDAddFromContactViewController.h"
#import "JGDAddFromContactTableViewCell.h"

@interface JGDAddFromContactViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

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
    //    header.textLabel.textAlignment=NSTextAlignmentCenter;
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
    if (indexPath.row > 2) {
        cell.state = 1;
    }else{
        cell.state = 0;
    }
    
    return cell;
}

#pragma mark ------搜索框回调方法

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

- (void)searchAct{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
