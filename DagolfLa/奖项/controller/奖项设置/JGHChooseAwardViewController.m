//
//  JGHChooseAwardViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHChooseAwardViewController.h"
#import "JGHChooseAwardCell.h"
#import "JGHAddAwardImageCell.h"
#import "JGSignUoPromptCell.h"
#import "JGHCustomAwardViewController.h"

static NSString *const JGHChooseAwardCellIdentifier = @"JGHChooseAwardCell";
static NSString *const JGHAddAwardImageCellIdentifier = @"JGHAddAwardImageCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";

@interface JGHChooseAwardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *chooseTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHChooseAwardViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"选择奖项";
    
    [self createChooseTableView];
}

#pragma mark -- 创建TB
- (void)createChooseTableView{
    self.chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.chooseTableView.delegate = self;
    self.chooseTableView.dataSource = self;
    
    UINib *chooseAwardCellNib = [UINib nibWithNibName:@"JGHChooseAwardCell" bundle: [NSBundle mainBundle]];
    [self.chooseTableView registerNib:chooseAwardCellNib forCellReuseIdentifier:JGHChooseAwardCellIdentifier];
    
    UINib *addAwardImageCellNib = [UINib nibWithNibName:@"JGHAddAwardImageCell" bundle: [NSBundle mainBundle]];
    [self.chooseTableView registerNib:addAwardImageCellNib forCellReuseIdentifier:JGHAddAwardImageCellIdentifier];
    
    UINib *signUoPromptCellNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.chooseTableView registerNib:signUoPromptCellNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    self.chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chooseTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.chooseTableView];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == _dataArray.count + 1) {
        static JGSignUoPromptCell *cell;
        if (!cell) {
            cell = [self.chooseTableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        }
        
        cell.pamaptLabel.text = @"提示：选择好奖项后，请对每个奖项的奖品和数量进行设置";
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }else{
        return 55 * ProportionAdapter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHAddAwardImageCell *addAwardImageCell = [tableView dequeueReusableCellWithIdentifier:JGHAddAwardImageCellIdentifier];
        [addAwardImageCell configAddAwardImageName:@"zidingyibianji" andTiles:@"自定义添加奖项"];
        return addAwardImageCell;
    }else{
        if (indexPath.section == _dataArray.count + 1) {
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
            [signUoPromptCell configAllPromptString:@"提示：选择好奖项后，请对每个奖项的奖品和数量进行设置" andLeftCon:10 andRightCon:10];
            return signUoPromptCell;
        }else{
            JGHChooseAwardCell *chooseAwardCell = [tableView dequeueReusableCellWithIdentifier:JGHChooseAwardCellIdentifier];
            return chooseAwardCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHCustomAwardViewController *customAwardCtrl = [[JGHCustomAwardViewController alloc]init];
        customAwardCtrl.teamKey = _teamKey;
        customAwardCtrl.activityKey = _activityKey;
        [self.navigationController pushViewController:customAwardCtrl animated:YES];
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
