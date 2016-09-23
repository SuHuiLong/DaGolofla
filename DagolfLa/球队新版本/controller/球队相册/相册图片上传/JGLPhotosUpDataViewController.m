//
//  TeamPhotoAddViewController.m
//  DagolfLa
//
//  Created by bhxx on 15/11/28.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "JGLPhotosUpDataViewController.h"

#import "ZYQAssetPickerController.h"
#import "Helper.h"
#import "TeamBrowseViewController.h"
#define LINE_COUNT 4
#import "PostDataRequest.h"
#import "MBProgressHUD.h"

@interface JGLPhotosUpDataViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,UIPickerViewAccessibilityDelegate>
{
    UIScrollView* _scrollView;
    CGFloat _contentSizeY;
    int indexBtn;
    
    NSMutableArray* _arrayCamera;
    
    UIButton* _btnAdd;
    MBProgressHUD* _progress;
    NSMutableArray* _arrTimeKey;
}

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@end

@implementation JGLPhotosUpDataViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加照片";
    _arrayCamera = [[NSMutableArray alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40*ScreenWidth/375, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    [self createView];
    [self createAddPhoto];
    [self createBtnSure];
}

-(void)createView
{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40*ScreenWidth/375)];
    [self.view addSubview:label];
    label.text = @"点击加号按钮添加照片";
    label.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    label.backgroundColor = [UIColor colorWithRed:0.69f green:0.69f blue:0.69f alpha:1.00f];
}
-(void)createAddPhoto
{
    
    _arrTimeKey = [[NSMutableArray alloc]init];
    
    //    //图片选择
    [self initializeDataSource];
    [self initializeUserInterface];
}


-(void)createBtnSure
{
    _btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, 70*ScreenWidth/375+_imageWidth, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    _btnAdd.layer.masksToBounds = YES;
    _btnAdd.layer.cornerRadius = 8*ScreenWidth/375;
    [_btnAdd setTitle:@"发布" forState:UIControlStateNormal];
    [_btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAdd.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:_btnAdd];
    [_btnAdd addTarget:self action:@selector(fabuClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)fabuClick:(UIButton *)btn
{
    [self imageArray:_selectImages];
}
#pragma mark --上传图片方法
-(void)imageArray:(NSArray *)array
{
    if (_selectImages.count == 0) {
        [[ShowHUD showHUD] showToastWithText:@"请选择照片后进行发布" FromView:self.view];
        return;
    }
    
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"正在修改...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    /**
     *  获取timekey用来作为上传图片的timekey
     *
     *  @param errType nil
     *
     *  @return nil
     */
    
    for (int i = 0; i < _selectImages.count; i++) {
        NSString* url = [NSString stringWithFormat:@"%@%@",PORTOCOL_APP_ROOT_URL,@"globalCode/createTimeKey"];
        NSURL* urls = [NSURL URLWithString:url];
        //第二步，通过URL创建网络请求
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urls cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        //    NSLog(@"%@",str);     //就这么简单，到这里就完成了，str就是请求得到的结果
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:nil];
        NSNumber* TimeKey = [result objectForKey:@"timeKey"];
        [_arrTimeKey addObject:TimeKey];
    }

    for (int i = 0; i < _selectImages.count; i++) {
        NSMutableDictionary* dictMedia = [[NSMutableDictionary alloc]init];
        [dictMedia setObject:_arrTimeKey[i] forKey:@"data"];
        [dictMedia setObject:TYPE_MEDIA_IMAGE forKey:@"nType"];
        [dictMedia setObject:@"dagolfla" forKey:@"tag"];
        [[JsonHttp jsonHttp] httpRequestImage:@"1" withData:dictMedia andDataArray:_selectImages[i] failedBlock:^(id errType) {
            NSLog(@"errType===%@", errType);
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            self.navigationItem.hidesBackButton = NO;
            self.navigationItem.rightBarButtonItem.customView.hidden=NO;
        } completionBlock:^(id data) {
            /**
             上传图片的参数
             */
            if (i == _selectImages.count - 1) {
                if ([[data objectForKey:@"code"] integerValue] == 1) {
                    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                    if (_arrTimeKey.count != 0) {
                        [dict setObject:_arrTimeKey forKey:@"mediaKeys"];
                    }
                    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
                    [dict setObject:_albumKey forKey:@"albumKey"];
                    [dict setObject:@1 forKey:@"mediaType"];
                    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/batchCreateTeamMedia" JsonKey:nil withData:dict failedBlock:^(id errType) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                        self.navigationItem.hidesBackButton = NO;
                        self.navigationItem.rightBarButtonItem.customView.hidden=NO;
                    } completionBlock:^(id data) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                        self.navigationItem.hidesBackButton = NO;
                        self.navigationItem.rightBarButtonItem.customView.hidden=NO;
                        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                            _blockRefresh();
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else{
                            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                        }
                        
                    }];
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    self.navigationItem.hidesBackButton = NO;
                    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
                    [[ShowHUD showHUD]showToastWithText:@"上传图片失败" FromView:self.view];
                }
            }
            
        }];
    }

}

#pragma mark -- 图片选择
//图片选择
- (void)initializeDataSource {
    
    _selectButtons = [[NSMutableArray alloc] init];
    _selectImages = [[NSMutableArray alloc] init];
}

- (void)initializeUserInterface {
    
    _imageWidth = (ScreenWidth - ((LINE_COUNT + 1) * 20*ScreenWidth/375)) / LINE_COUNT;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 40*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, _imageWidth + 2 *10 *ScreenWidth/375)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    [_scrollView addSubview:_contentView];
    
    _contentSizeY = _contentSizeY + _imageWidth + 2 *10 *ScreenWidth/375;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth);
    [_addButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    //    _addButton.layer.borderWidth = 1;
    //    _addButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_addButton];
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"拍照" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选照片", nil];
    
}

#pragma mark --选择图片方法
//点击事件
- (void)addButtonClick:(UIButton *)sender {
    
    if (_selectImages.count < 9) {
        indexBtn++;
        [_actionSheet showInView:_scrollView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择9张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)imageButtonPressed:(UIButton *)sender {
    
    TeamBrowseViewController *vc = [[TeamBrowseViewController alloc] initWithIndex:[_selectButtons indexOfObject:sender] selectImages:_selectImages];
    __weak JGLPhotosUpDataViewController *weakSelf = self;
    
    vc.deleteBlock = ^(NSInteger index) {
        
        UIButton *button = [weakSelf.selectButtons objectAtIndex:index];
        [button removeFromSuperview];
        [weakSelf.selectButtons removeObjectAtIndex:index];
        [weakSelf updateUserInterface];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self selectFromCamera];
            break;
        case 1:
            [self selectFromPhoto];
            break;
        default:
            break;
    }
}

- (void)selectPhoto:(UITapGestureRecognizer *)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)selectFromCamera
{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_arrayCamera removeAllObjects];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData* photoData = UIImageJPEGRepresentation(image, 0.7);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_arrayCamera addObject:photoData];
    
    
    //    [_selectImages addObject:_arrayCamera[0]];
    //    ALAsset *asset = _arrayCamera[0];
    UIImage *imageCamera = [UIImage imageWithData:_arrayCamera[0]];
    /**
     *  将图片转成二进制数据
     *
     *  @param image 图片
     *  @param 0.5   保真值
     *
     *  @return return value description
     */
    [_selectImages addObject:UIImageJPEGRepresentation(imageCamera, 0.7)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth)];
    [button setImage:imageCamera forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    [_selectButtons addObject:button];
    [self updateUserInterface];
}
- (void)selectFromPhoto
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] initWithNSinter:(9-_selectImages.count)];
    
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (int i = 0; i < assets.count; i ++) {
        ALAsset *asset = assets[i];
        ////NSLog(@"%@",assets[i]);
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        /**
         *  将图片转成二进制数据
         *
         *  @param image 图片
         *  @param 0.5   保真值
         *
         *  @return return value description
         */
        [_selectImages addObject:UIImageJPEGRepresentation(image, 0.7)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth)];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        
        [_selectButtons addObject:button];
    }
    [self updateUserInterface];
}
//重画添加按钮和背景view的大小
- (void)updateUserInterface {
    
    [self resetAllImagePosition];
    
    
    
    _addButton.frame = [self frameWithButtonIndex:_selectButtons.count];
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, ScreenWidth-20*ScreenWidth/375, _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375);
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 40*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    
    _contentSizeY = _contentSizeY + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375 - _imageWidth + 2 *10 *ScreenWidth/375;
    
}
//重设图片的位置
- (void)resetAllImagePosition {
    
    
    
    NSInteger count = _selectButtons.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        UIButton *button = _selectButtons[i];
        button.frame = [self frameWithButtonIndex:i];
        //        if (count == 9) {
        //            _addButton.hidden = YES;
        //
        //        }
        
        
    }
}

//增加一张照片，设置照片的位置
- (CGRect)frameWithButtonIndex:(NSInteger)index {
    
    index ++;
    NSInteger row = ceil(index * 1.0 / LINE_COUNT); // 第几行
    NSInteger cloumn = index % LINE_COUNT; // 第几列
    
    if (cloumn == 0) {
        
        cloumn += LINE_COUNT;
    }
    _scrollView.contentSize = CGSizeMake(0, ScreenHeight + (_imageWidth)*((index-1)/3)- 64-49);
    //    ////NSLog(@"%ld",index);
    return CGRectMake(10*ScreenWidth/375 * cloumn + (_imageWidth+10*ScreenWidth/375) * (cloumn - 1), 10*ScreenWidth/375 * row + _imageWidth * (row - 1), _imageWidth, _imageWidth);
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
