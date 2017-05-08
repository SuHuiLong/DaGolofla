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
#import "JGHAwardModel.h"

static NSString *const JGHChooseAwardCellIdentifier = @"JGHChooseAwardCell";
static NSString *const JGHAddAwardImageCellIdentifier = @"JGHAddAwardImageCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";

@interface JGHChooseAwardViewController ()<UITableViewDelegate, UITableViewDataSource, JGHChooseAwardCellDelegate>
{
    NSMutableArray *_selectArray;;//选择的数组
    NSMutableArray *_titleArray;
    NSInteger _select;//0-全选， 1- 取消全选
}

@property (nonatomic, strong)UITableView *chooseTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UIButton *item;

@end

@implementation JGHChooseAwardViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        _selectArray = [NSMutableArray array];
        self.selectChooseArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加奖项";
    _titleArray = [NSMutableArray array];
    self.item = [UIButton buttonWithType:UIButtonTypeCustom];
    self.item.frame = CGRectMake(0, 0, 64, 44);
    self.item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.item.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    _select = 0;
    [self.item setTitle:@"全选" forState:UIControlStateNormal];
    
    [self.item addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.item];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    [self createChooseTableView];
    
    [self createSaveAwardBtn];
    
    [self createData];
}
#pragma mark -- 创建数据
- (void)createData{

    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getDefaultPrizeList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [_selectArray removeAllObjects];
            _titleArray = [data objectForKey:@"list"];
            for (int i=0; i<_titleArray.count; i++) {
                JGHAwardModel *model = [[JGHAwardModel alloc]init];
                model.name = _titleArray[i];
                
                for (int j=0; j<_selectChooseArray.count; j++) {
                    JGHAwardModel *modelChoose = [[JGHAwardModel alloc]init];
                    modelChoose = _selectChooseArray[j];
                    if ([model.name isEqualToString:modelChoose.name]) {
                        model.select = 1;
                        [_selectArray addObject:model.name];
                        NSLog(@"select == %td", model.select);
                        break;
                    }else{
                        model.select = 0;
                    }
                }
                
                [self.dataArray addObject:model];
            }
            
            if (self.selectChooseArray.count >= self.dataArray.count) {
                [self.item setTitle:@"取消全选" forState:UIControlStateNormal];
                _select = 1;
            }else{
                _select = 0;
                [self.item setTitle:@"全选" forState:UIControlStateNormal];
            }

        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.chooseTableView reloadData];
    }];
}

#pragma mark -- 创建工具栏
- (void)createSaveAwardBtn{

    UIButton *psuhBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWvertical(10), kHvertical(550), screenWidth - kWvertical(20), kHvertical(45))];
    [psuhBtn setTitle:@"保存" forState:UIControlStateNormal];
    [psuhBtn setBackgroundColor:[UIColor colorWithHexString:Click_Color]];
    psuhBtn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    psuhBtn.layer.masksToBounds = YES;
    psuhBtn.layer.cornerRadius = 8.0;
    [psuhBtn addTarget:self action:@selector(saveAwardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:psuhBtn];
}

#pragma mark -- 保存奖项
- (void)saveAwardBtnClick:(UIButton *)btn{
    [self performSelector:@selector(pushCtrl) withObject:self afterDelay:0.3];

}
- (void)pushCtrl{
    self.refreshBlock(_selectArray);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 全选
- (void)chooseAll:(UIButton *)btn{
    [_selectArray removeAllObjects];
    for (int i =0; i<_dataArray.count; i++) {
        JGHAwardModel *model = [[JGHAwardModel alloc]init];
        model = _dataArray[i];
        if (_select == 0) {
            model.select = 1;
            [_dataArray replaceObjectAtIndex:i withObject:model];
            [_selectArray addObject:model.name];
        }else{
            model.select = 0;
            [_dataArray replaceObjectAtIndex:i withObject:model];
            [_selectArray removeAllObjects];
        }
    }
    
    if (_select == 0) {
        _select = 1;
        [self.item setTitle:@"取消全选" forState:UIControlStateNormal];
    }else{
        _select = 0;
        [self.item setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    [self.chooseTableView reloadData];
}
#pragma mark -- 创建TB
- (void)createChooseTableView{
    self.chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - kHvertical(60) - 64) style:UITableViewStylePlain];
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
        [addAwardImageCell configAddAwardImageName:@"icn_addawards" andTiles:@"自定义添加奖项"];
        return addAwardImageCell;
    }else{
        if (indexPath.section == _dataArray.count + 1) {
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
            [signUoPromptCell configAllPromptString:@"选择好奖项后，请对每个奖项的奖品和数量进行设置" andLeftCon:10 andRightCon:10];
            return signUoPromptCell;
        }else{
            JGHChooseAwardCell *chooseAwardCell = [tableView dequeueReusableCellWithIdentifier:JGHChooseAwardCellIdentifier];
            chooseAwardCell.delegate = self;
            chooseAwardCell.chooseBtn.tag = indexPath.section + 100;
            chooseAwardCell.chooseBtn.enabled = NO;
            if (_dataArray.count > 0) {
                NSLog(@"%td", _dataArray.count);
                NSLog(@"%td", indexPath.section);
                [chooseAwardCell configJGHAwardModel:_dataArray[indexPath.section-1]];
            }
            
            return chooseAwardCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 0) {
        return 10*ProportionAdapter;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    if (section == 1) {
        view.frame = CGRectMake(0, 0, screenWidth, 10*ProportionAdapter);
    }else{
        view.frame = CGRectMake(0, 0, screenWidth, 1);
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHCustomAwardViewController *customAwardCtrl = [[JGHCustomAwardViewController alloc]init];
        customAwardCtrl.teamKey = _teamKey;
        customAwardCtrl.activityKey = _activityKey;
        [self.navigationController pushViewController:customAwardCtrl animated:YES];
    }else{
        NSLog(@"%td", indexPath.section -1);
        for (int i =0; i<_dataArray.count; i++) {
            if (indexPath.section -1 == i) {
                JGHAwardModel *model = [[JGHAwardModel alloc]init];
                model = _dataArray[i];
                if (model.select == 1) {
                    model.select = 0;
                }else{
                    model.select = 1;
                }
                
                [_dataArray replaceObjectAtIndex:i withObject:model];
                if (![_selectArray containsObject:model.name]) {
                    [_selectArray addObject:model.name];
                }else{
                    [_selectArray removeObject:model.name];
                }
            }
        }
        
        [self.chooseTableView reloadData];
    }
}

#pragma mark -- 勾选
- (void)selectChooseAwardBtnClick:(UIButton *)btn{
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
