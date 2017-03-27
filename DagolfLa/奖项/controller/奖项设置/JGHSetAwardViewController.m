//
//  JGHSetAwardViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSetAwardViewController.h"
#import "JGHAddAwardImageCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHAwardModel.h"
#import "JGHAwardCell.h"
#import "JGHActivityBaseCell.h"
#import "JGHChooseAwardViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHCustomAwardViewController.h"
//#import "JGDPrizeViewController.h"

static NSString *const JGHAddAwardImageCellIdentifier = @"JGHAddAwardImageCell";
static NSString *const JGHAwardCellIdentifier = @"JGHAwardCell";
static NSString *const JGHActivityBaseCellIdentifier = @"JGHActivityBaseCell";

@interface JGHSetAwardViewController ()<UITableViewDelegate, UITableViewDataSource, JGHAwardCellDelegate>

{
    //NSInteger _publishPrize;
    //UIView *_psuhView;
}

@property (nonatomic, strong)UITableView *awardTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, strong)UIButton *psuhBtn;

@property (nonatomic, strong)UIView *psuhView;

@end

@implementation JGHSetAwardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    if (_dataArray.count == 0) {
        if (self.bgView == nil) {
            [self createNoData];
        }
    }else{
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
     */
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)backButtonClcik{
    _refreshBlock();
    [self.navigationController popViewControllerAnimated:YES];
}
- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"奖项设置";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadAwardData" object:nil];
    
    [self createAwardTableView];
        
//    [self loadData];
}
#pragma mark --未发布
- (void)createNoData{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2 - 45*ProportionAdapter, screenHeight/2 - 110*ProportionAdapter, 80*ProportionAdapter, 100*ProportionAdapter)];
    UIImageView *weifabuImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, self.bgView.frame.size.width-20*ProportionAdapter, self.bgView.frame.size.height - 40*ProportionAdapter)];
    weifabuImageview.image = [UIImage imageNamed:@"weifabutishi"];
    [self.bgView addSubview:weifabuImageview];
    
    UILabel *weifaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, weifabuImageview.frame.size.height + 15*ProportionAdapter, self.bgView.frame.size.width, 20*ProportionAdapter)];
    weifaLabel.text = @"暂未发布奖项";
    weifaLabel.textAlignment = NSTextAlignmentCenter;
    weifaLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    weifaLabel.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:weifaLabel];
    [self.awardTableView addSubview:self.bgView];
}
#pragma mark -- 下载数据
- (void)loadData{
//    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivityPrizeAllList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType = %@", errType);
//        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"data = %@", data);
//        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [self.dataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //_publishPrize = [[data objectForKey:@"publishPrize"] integerValue];
            //奖项是否发布：0: 未发布  1: 已发布
            //if (_publishPrize == 0) {
                [self.psuhBtn setTitle:@"完成" forState:UIControlStateNormal];
            //}else{
              //  [self.psuhBtn setTitle:@"保存奖项" forState:UIControlStateNormal];
            //}
            
            NSArray *array = [data objectForKey:@"list"];
            for (NSDictionary *dict in array) {
                JGHAwardModel *model = [[JGHAwardModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            
            /*
            if (array.count >0) {
                self.psuhBtn.userInteractionEnabled = YES;
                [self.psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
            }
             */
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        //轮询所有的奖项
        [self polingAwareIsSet];
        
        [self.awardTableView.header endRefreshing];
        
        if (_dataArray.count == 0) {
            if (self.bgView == nil) {
                [self createNoData];
            }
            
            _psuhView.hidden = YES;
        }else{
            [self.bgView removeFromSuperview];
            self.bgView = nil;
            _psuhView.hidden = NO;
        }
        
        [self.awardTableView reloadData];
    }];
}
- (UIView *)psuhView{
    if (_psuhView == nil) {
        _psuhView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 65*ProportionAdapter - 64, screenWidth, 65*ProportionAdapter)];
        _psuhView.backgroundColor = [UIColor whiteColor];
        [_psuhView addSubview:self.psuhBtn];
    }
    return _psuhView;
}
- (UIButton *)psuhBtn{
    if (_psuhBtn == nil) {
        _psuhBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 65*ProportionAdapter - 20*ProportionAdapter)];
        [_psuhBtn setTitle:@"完成" forState:UIControlStateNormal];
        _psuhBtn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
        _psuhBtn.layer.masksToBounds = YES;
        _psuhBtn.layer.cornerRadius = 8.0*ProportionAdapter;
        [_psuhBtn addTarget:self action:@selector(psuhAwardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _psuhBtn.userInteractionEnabled = YES;
        [_psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
    }
    return _psuhBtn;
}
#pragma mark -- 完成
- (void)psuhAwardBtnClick:(UIButton *)btn{
    //doPublishPrize
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doPublishPrize" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //if (_publishPrize == 0) {
            _refreshBlock();
            //}
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 返回
- (void)backCtrl{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 创建TB
- (void)createAwardTableView{
    self.awardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 65*ProportionAdapter -64) style:UITableViewStylePlain];
    self.awardTableView.delegate = self;
    self.awardTableView.dataSource = self;
    
    UINib *addAwardImageCellNib = [UINib nibWithNibName:@"JGHAddAwardImageCell" bundle: [NSBundle mainBundle]];
    [self.awardTableView registerNib:addAwardImageCellNib forCellReuseIdentifier:JGHAddAwardImageCellIdentifier];
    
    UINib *awardCellNib = [UINib nibWithNibName:@"JGHAwardCell" bundle: [NSBundle mainBundle]];
    [self.awardTableView registerNib:awardCellNib forCellReuseIdentifier:JGHAwardCellIdentifier];
    
    UINib *activityBaseCellNib = [UINib nibWithNibName:@"JGHActivityBaseCell" bundle: [NSBundle mainBundle]];
    [self.awardTableView registerNib:activityBaseCellNib forCellReuseIdentifier:JGHActivityBaseCellIdentifier];
    
    self.awardTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreahData)];
    [self.awardTableView.header beginRefreshing];

    self.awardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.awardTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.awardTableView];
}
- (void)refreahData{
    [self loadData];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 84 * ProportionAdapter;
    }else{
        if (indexPath.section == _dataArray.count + 1) {
            return 45 * ProportionAdapter;
        }else{
            return 115 * ProportionAdapter;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHActivityBaseCell *activityBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityBaseCellIdentifier];
        [activityBaseCell configJGTeamActivityModel:_model];
        return activityBaseCell;
    }else{
        if (indexPath.section == _dataArray.count + 1) {
            JGHAddAwardImageCell *addAwardImageCell = [tableView dequeueReusableCellWithIdentifier:JGHAddAwardImageCellIdentifier];
            [addAwardImageCell configAddAwardImageName:@"tianjiaanniu" andTiles:@"添加奖项"];
            return addAwardImageCell;
        }else{
            JGHAwardCell *awardCell = [tableView dequeueReusableCellWithIdentifier:JGHAwardCellIdentifier];
            awardCell.delegate = self;
            JGHAwardModel *model = [[JGHAwardModel alloc]init];
            model = _dataArray[indexPath.section -1];
            
            awardCell.deleBtn.tag = [model.timeKey integerValue];
            awardCell.editorBtn.tag = indexPath.section + 100;
            [awardCell configJGHAwardModel:model];
            
            return awardCell;
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
    if (indexPath.section != 0) {
        if (indexPath.section == _dataArray.count + 1) {
            NSLog(@"添加奖项");
            JGHChooseAwardViewController *chooseAwardCtrl = [[JGHChooseAwardViewController alloc]init];
            chooseAwardCtrl.teamKey = _teamKey;
            chooseAwardCtrl.activityKey = _activityKey;
            chooseAwardCtrl.selectChooseArray = _dataArray;
            [self.navigationController pushViewController:chooseAwardCtrl animated:YES];
        }
    }
}
#pragma mark -- 轮询所有奖项是否设置奖品／奖品数量，改变完成按钮状态
- (void)polingAwareIsSet{

    if (_dataArray.count >0) {
        [self.view addSubview:self.psuhView];
    }else{
        [self.psuhView removeFromSuperview];
        _awardTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
    }
}
#pragma mark -- 删除
- (void)selectAwardDeleBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    btn.enabled = NO;
    
    [Helper alertViewWithTitle:@"确定删除该奖项？" withBlockCancle:^{
        
    } withBlockSure:^{
        [self todoDeleClick:btn];
    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];    
    
    btn.enabled = YES;
}
#pragma mark -- 删除
- (void)todoDeleClick:(UIButton *)btn{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(btn.tag) forKey:@"prizeKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doDeletePrize" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"删除成功！" FromView:self.view];
            [self loadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 编辑
- (void)selectAwardEditorBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag - 100);
    btn.enabled = NO;
    
    JGHCustomAwardViewController *customCtrl = [[JGHCustomAwardViewController alloc]init];
    customCtrl.model = _dataArray[btn.tag - 100 -1];
    
    [self.navigationController pushViewController:customCtrl animated:YES];
    
    btn.enabled = YES;
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
