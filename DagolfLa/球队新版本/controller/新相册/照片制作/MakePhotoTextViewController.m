//
//  MakePhotoTextViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextViewController.h"
#import "RTDragCellTableView.h"
#import "MakePhotoTextViewModel.h"
#import "MakePhotoTextTableViewCell.h"
#import "MakePhotoTextSelectHeaderViewController.h"
#import "MakePhotoTextSelectFromAllViewController.h"
#import "MakePhotoTextAddTextViewController.h"
#import "JGPhotoListModel.h"
#import "MakePhotoTextDoneViewController.h"
@interface MakePhotoTextViewController ()<RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>
//tableview
@property(nonatomic, strong)RTDragCellTableView *mainTableView;
//标题
@property(nonatomic, copy) NSString *photoTitleLabelStr;
//作者
@property(nonatomic, copy) NSString *photoWriterStr;
//封面
@property(nonatomic, copy) NSNumber *headerViewTimekey;
@end

@implementation MakePhotoTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createTableView];
}
//创建导航
-(void)createNavigationView{
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnCLick)];
    leftBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnCLick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.title = @"制作";
}
//创建tableview
-(void)createTableView{
    RTDragCellTableView *tableView = [[RTDragCellTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = RGB(244, 244, 244);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = YES;
    [tableView registerClass:[MakePhotoTextTableViewCell class] forCellReuseIdentifier:@"MakePhotoTextTableViewCellId"];
    
    [self.view addSubview:tableView];
    _mainTableView = tableView;
}
//添加照片&&文字
-(void)createAddPhotoAndTextViewOnView:(UIView *)backView Y:(CGFloat)viewY section:(NSInteger )indexTag{
    
    //添加照片按钮
    UIButton *addPhoto = [Factory createButtonWithFrame:CGRectMake((screenWidth - kWvertical(69))/2, viewY, kWvertical(20), kWvertical(20)) image:[UIImage imageNamed:@"photoTextAddPhoto"] target:self selector:@selector(addPhotoClick:) Title:nil];
    addPhoto.tag = 100+indexTag*2;
    //添加文字按钮
    UIButton *addText = [Factory createButtonWithFrame:CGRectMake(addPhoto.x_width+kWvertical(25), viewY, kWvertical(20), kWvertical(20)) image:[UIImage imageNamed:@"photoTextAddText"] target:self selector:@selector(addTextClick:) Title:nil];
    addText.tag = 100+indexTag*2+1;
    [backView addSubview:addPhoto];
    [backView addSubview:addText];
    
}

#pragma mark - initData
-(void)initViewData{
    
}


#pragma mark - Action
//左按钮
-(void)leftBtnCLick{
    [self.navigationController popViewControllerAnimated:YES];
}
//右按钮
-(void)rightBtnCLick{
    //作者
    NSString *name = _photoWriterStr;
    
    if (_photoTitleLabelStr.length == 0) {
        _photoTitleLabelStr = @"无题";
    }
    if (name.length == 0) {
        name = _teamName;
    }
    NSMutableArray *listArray = [NSMutableArray array];
    for (NSArray *modelArray in self.dataArray) {
        MakePhotoTextViewModel *model = modelArray[0];
        NSNumber *timeKey = model.timeKey;
        NSDictionary *listDict =[NSDictionary dictionary];
        if (timeKey) {
            listDict = [NSDictionary dictionaryWithObject:timeKey forKey:@"mediaKey"];
        }else{
            listDict = [NSDictionary dictionaryWithObject:model.textStr forKey:@"describe"];
        }
        [listArray addObject:listDict];
    }
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"title":_photoTitleLabelStr,
                           @"name":name,
                           @"list":listArray
                           };
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"picShare/doCreatePicShare" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSuccess) {
            NSString *shareKey = [data objectForKey:@"shareKey"];
            NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&shareKey=%@dagolfla.com", DEFAULF_USERID,shareKey]];
            MakePhotoTextDoneViewController *vc = [[MakePhotoTextDoneViewController alloc] init];
            vc.headerStr = _photoTitleLabelStr;
            vc.timeKey = _headerViewTimekey;
            vc.writerStr = _photoWriterStr;
            vc.urlStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/picsShare.html?userKey=%@&shareKey=%@&md5=%@",DEFAULF_USERID,shareKey,md5Value];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
//删除点击
-(void)deleateBtnClick:(UIView *)sender{
    UIView *superView = sender.superview.superview.superview;
    if ([superView isKindOfClass:[MakePhotoTextTableViewCell class]]) {
        MakePhotoTextTableViewCell *cell = (MakePhotoTextTableViewCell *)superView;
        NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
        NSMutableArray *sectionMarray = self.dataArray[indexPath.section];
        [sectionMarray removeObjectAtIndex:indexPath.row];
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:sectionMarray];
        [self deleteEmptyArray];
    }
}
//更换标题
-(void)changeTitle{
    [self pushToTextWriteViewClickIndex:0 row:0 type:0];
}
//更换作者
-(void)changeWriter{
    [self pushToTextWriteViewClickIndex:0 row:0 type:1];
}
//更换封面
-(void)changeButtonClick{
    NSMutableArray *photoArray = [NSMutableArray array];
    //封面是否在列表
    BOOL headerInArray = false;
    for (NSArray *indexArray in self.dataArray) {
        //获取分组
        for (MakePhotoTextViewModel *model in indexArray) {
            //获取cell上数据
            if (model.timeKey) {
                JGPhotoListModel *Model = [[JGPhotoListModel alloc] init];
                Model.timeKey = model.timeKey;
                if ([model.timeKey isEqual:_headerViewTimekey]) {
                    headerInArray = true;
                    Model.isSelect = true;
                }
                [photoArray addObject:Model];
            }
        }
    }
    if (!headerInArray) {
        JGPhotoListModel *model = [[JGPhotoListModel alloc] init];
        model.timeKey = _headerViewTimekey;
        model.isSelect = true;
        [photoArray insertObject:model atIndex:0];
    }
    
    __weak typeof(self) weakself = self;
    MakePhotoTextSelectHeaderViewController *vc = [[MakePhotoTextSelectHeaderViewController alloc] init];
    [vc setSelectHeaderImageBlock:^(NSNumber *picTimeKey) {
        _headerViewTimekey = picTimeKey;
        [weakself.mainTableView reloadData];
    }];
    vc.teamTimeKey = _teamTimeKey;
    vc.dataArray = photoArray;
    [self.navigationController pushViewController:vc animated:YES];
}
//添加照片按钮点击
-(void)addPhotoClick:(UIButton *)btn{
    NSInteger btnIndex = (btn.tag-100)/2;
    [self pushToPhotoViewClickIndex:btnIndex row:0 type:0];
}
//添加文字按钮点击
-(void)addTextClick:(UIButton *)btn{
    NSInteger btnIndex = (btn.tag-1-100)/2;
    [self pushToTextWriteViewClickIndex:btnIndex row:0 type:2];
}
/*
 跳转至文字
 index:操作的位置的section
 indexRow: 操作位置的row
 pushType: 0:标题 1:作者 2:添加 3:更换
 */
-(void)pushToTextWriteViewClickIndex:(NSInteger )index row:(NSInteger)indexRow type:(NSInteger )pushType{
    NSArray *titleArray = @[@"标题",@"制作方",@"文字描述",@"文字描述"];
    NSString *titleStr = titleArray[pushType];
    
    MakePhotoTextAddTextViewController *vc = [[MakePhotoTextAddTextViewController alloc] init];
    __weak typeof(self) weakself = self;
    //处理返回值
    [vc setAddTextBlock:^(NSString *textStr) {
        MakePhotoTextViewModel *model = [[MakePhotoTextViewModel alloc] init];
        model.textStr = textStr;
        switch (pushType) {
            case 0:{//标题
                weakself.photoTitleLabelStr = textStr;
            }break;
            case 1:{//作者
                weakself.photoWriterStr = textStr;
            }break;
            case 2:{//添加
                NSMutableArray *addArray = [NSMutableArray arrayWithObject:model];
                [weakself.dataArray insertObject:addArray atIndex:index];
            }break;
            case 3:{//更改
                NSMutableArray *indexMarray = [NSMutableArray array];
                [indexMarray addObject:model];
                [weakself.dataArray replaceObjectAtIndex:index withObject:indexMarray];
            }break;
            default:
                break;
        }
        [weakself.mainTableView reloadData];
        
    }];
    vc.title = titleStr;
    vc.teamName = _teamName;
    if (pushType==0&&_photoTitleLabelStr.length==0){
        vc.DefaultText = _photoTitleLabelStr;
    }else if (pushType==1) {
        vc.DefaultText = _teamName;
    }else if (pushType == 3){

        NSMutableArray *indexSectionMarray = self.dataArray[index];
        MakePhotoTextViewModel *rowModel = indexSectionMarray[indexRow];
        vc.DefaultText = rowModel.textStr;
        
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
/*
 跳转至图片
 index:操作的位置的section
 indexRow: 操作位置的row
 pushType: 0:添加 1:更换
 */
-(void)pushToPhotoViewClickIndex:(NSInteger )index row:(NSInteger)indexRow type:(NSInteger )pushType{
    MakePhotoTextSelectFromAllViewController *vc = [[MakePhotoTextSelectFromAllViewController alloc] init];
    vc.teamTimeKey = _teamTimeKey;
    if (pushType==0) {
        vc.canMultipleChoice = true;
    }else{
        vc.canMultipleChoice = false;
    }
    __weak typeof(self) weakself = self;
    [vc SetSelectPhotoBlock:^(NSMutableArray *mArray) {
        
        switch (pushType) {
            case 0:{//添加
                for (int i = 0; i<mArray.count; i++) {
                    [weakself.dataArray insertObject:mArray[i] atIndex:index+i];
                }
            }break;
            case 1:{//更换
                NSMutableArray *indexMarray = [NSMutableArray array];
                MakePhotoTextViewModel *model = mArray[0][0];
                [indexMarray addObject:model];
                [weakself.dataArray replaceObjectAtIndex:index withObject:indexMarray];
            }break;
            default:
                break;
        }
        [weakself.mainTableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//删除数据源中空数组
-(void)deleteEmptyArray{
    NSMutableArray *mDataArray = [NSMutableArray arrayWithArray:_dataArray];
    NSMutableArray *dataMarray = [NSMutableArray array];
    for (NSMutableArray *indexArray in mDataArray) {
        for (MakePhotoTextViewModel  *model in indexArray) {
            NSMutableArray *rowMaaray = [NSMutableArray array];
            [rowMaaray addObject:model];
            [dataMarray addObject:rowMaaray];
        }
    }
    _dataArray = dataMarray;
    [self.mainTableView reloadData];
}


#pragma mark - UITableViewDelegatr
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return 0;
    }
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return kHvertical(336);
    }
    return 0.01;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(124);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return 0;
    }

    NSArray *array = self.dataArray[section];
    if (section == array.count) {
        return kHvertical(50);
    }
    return kHvertical(42);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MakePhotoTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakePhotoTextTableViewCellId"];
    if (!cell) {
        cell = [[MakePhotoTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MakePhotoTextTableViewCellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.deleateBtn addTarget:self action:@selector(deleateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *modelArray = self.dataArray[indexPath.section];
    MakePhotoTextViewModel *model = modelArray[indexPath.row];
    [cell configModel:model];
    return cell;
}
//底部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, screenWidth, kHvertical(42))];
    if (self.dataArray.count==0) {
        return footerView;
    }
    //创建添加按钮
    [self createAddPhotoAndTextViewOnView:footerView Y:kHvertical(10) section:section+1];
    return footerView;
}
//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return nil;
    }
    UIView *headerView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, screenWidth, kHvertical(336))];
    headerView.userInteractionEnabled = YES;
    //白色背景
    UIView *headerBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(284))];
    [headerView addSubview:headerBackView];
    
    //标题
    UILabel *photoTitleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(20), kHvertical(14), screenWidth - kWvertical(46), kHvertical(36)) textColor:RGB(160, 160, 160) fontSize:kHorizontal(17) Title:_photoTitleLabelStr];
    if (_photoTitleLabelStr.length==0) {
        photoTitleLabel.text =  @"添加个标题吧";
    }
    photoTitleLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *changeTitleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTitle)];
    [photoTitleLabel addGestureRecognizer:changeTitleTap];
    [headerBackView addSubview:photoTitleLabel];
    
    //封面
    UIImageView *headerImageView = [Factory createImageViewWithFrame:CGRectMake(0, kHvertical(55), screenWidth, kHvertical(164)) Image:nil];
    
    NSURL *fristIconUrl = [self getFristImageUrl];
    [headerImageView sd_setImageWithURL:fristIconUrl placeholderImage:[UIImage imageNamed:@"teamPhotoGroupDefault"]];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    headerImageView.backgroundColor = RandomColor;
    [headerBackView addSubview:headerImageView];
    headerImageView.userInteractionEnabled = YES;
    
    //切换封面点击区域
    UIButton *changeHeaderBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(20), kHvertical(20), headerImageView.width - kWvertical(40), headerImageView.height - kHvertical(40)) target:self selector:@selector(changeButtonClick) Title:nil];
    changeHeaderBtn.backgroundColor = ClearColor;
    [headerImageView addSubview:changeHeaderBtn];
    
    //更换提示
    UILabel *alertLabel = [Factory createLabelWithFrame:CGRectMake(changeHeaderBtn.width - kWvertical(65), changeHeaderBtn.height - kHvertical(18), kWvertical(65), kHvertical(18)) textColor:WhiteColor fontSize:kHorizontal(12) Title:@"更换封面"];
    alertLabel.backgroundColor = RGBA(0, 0, 0, 0.5);
    alertLabel.layer.masksToBounds = true;
    alertLabel.layer.cornerRadius = 9;
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    [changeHeaderBtn addSubview:alertLabel];
    
    //球队名输入框背景
    UIView *parknameBackView = [Factory createViewWithBackgroundColor:RGB(244,244,244) frame:CGRectMake(kWvertical(10), headerImageView.y_height + kHvertical(15), screenWidth - kWvertical(22), kHvertical(35))];
    parknameBackView.layer.masksToBounds = true;
    parknameBackView.layer.cornerRadius = 8;
    [headerBackView addSubview:parknameBackView];
    
    //球队名输入框
    if (_photoWriterStr.length==0) {
        _photoWriterStr = _teamName;
    }
    UILabel *photoWriter = [Factory createLabelWithFrame:CGRectMake(kWvertical(16), 0, parknameBackView.width - kWvertical(32),parknameBackView.height) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:_photoWriterStr];
    photoWriter.userInteractionEnabled = true;
    UITapGestureRecognizer *changeWriterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeWriter)];
    [photoWriter addGestureRecognizer:changeWriterTap];
    [parknameBackView addSubview:photoWriter];
    
    UIImageView *addIcon = [Factory createImageViewWithFrame:CGRectMake(parknameBackView.width - kWvertical(17), kWvertical(4), kWvertical(13), kWvertical(13)) Image:[UIImage imageNamed:@"teamPhotoInsertIcon"]];
    
    [parknameBackView addSubview:addIcon];
    
    //创建添加按钮
    [self createAddPhotoAndTextViewOnView:headerView Y:headerBackView.y_height+kHvertical(20) section:0];
    return headerView;
}

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return [NSArray arrayWithArray:_dataArray];
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    _dataArray = [NSMutableArray arrayWithArray:newArray];
    
}
-(void)cellDidEndMovingInTableView:(RTDragCellTableView *)tableView{
    //删除空数组
    [self deleteEmptyArray];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *selecSection = self.dataArray[indexPath.section];
    MakePhotoTextViewModel *indexModel = selecSection[indexPath.row];
    NSString *textStr = indexModel.textStr;
    if (textStr) {
        [self pushToTextWriteViewClickIndex:indexPath.section row:indexPath.row type:3];
    }else{
//        [self pushToPhotoViewClickIndex:indexPath.section row:indexPath.row type:1];
    }
}


#pragma mark - Other
//获取第一张照片
-(NSURL *)getFristImageUrl{
    if (_headerViewTimekey) {
        return [Helper setImageIconUrl:@"album/media" andTeamKey:[_headerViewTimekey integerValue] andIsSetWidth:NO andIsBackGround:NO];// 加载网络图片大图地址
    }else{
        for (NSArray *indexArray in self.dataArray) {
            for (MakePhotoTextViewModel *model in indexArray) {
                if (model.timeKey) {
                    JGPhotoListModel *Model = [[JGPhotoListModel alloc] init];
                    Model.timeKey = model.timeKey;
                    if (model.timeKey>0) {
                        _headerViewTimekey = model.timeKey;
                        return [Helper setImageIconUrl:@"album/media" andTeamKey:[model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:NO];// 加载网络图片大图地址
                    }
                }
            }
        }
        return nil;
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
