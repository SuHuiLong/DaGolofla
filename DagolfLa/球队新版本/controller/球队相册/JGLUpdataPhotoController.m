//
//  AddFootViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "JGLUpdataPhotoController.h"

#import "ZYQAssetPickerController.h"
#import "BrowseImagesViewController.h"


#define LINE_COUNT 4

#import "BallParkViewController.h"

#import "PostDataRequest.h"
@interface JGLUpdataPhotoController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,UIPickerViewAccessibilityDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    NSMutableDictionary* _dict;
    
    UIView* _viewTime, * _viewNum, *_viewWhiteBase;
    
    UIView* _viewBase;
    UIScrollView* _scrollView;

    //发布按钮
    UIButton* _btnAdd;
    
    // 左侧的箭头
    UIImageView *_leftImage;
    //存放拍照的照片数组
    NSMutableArray* _arrayCamera;
    
    NSArray *_strarray;

    
}
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@end


@implementation JGLUpdataPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传照片";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, 568);
    _arrayCamera = [[NSMutableArray alloc]init];
    
    
    
    //照片标题
    [self createPhotoTitle];
    
    
    //添加按钮
    [self createButton];

    /**
     相册照片添加的执行方法
     
     :returns:
     */
    [self initializeDataSource];
    [self initializeUserInterface];
    
    
}
/**
 *  球场选择
 */
-(void)createPhotoTitle
{
    _viewWhiteBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 65*ScreenWidth/375)];
    _viewWhiteBase.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewWhiteBase];
    
    UIView* viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 10*ScreenWidth/375, screenWidth, 45*ScreenWidth/375)];
    viewTitle.backgroundColor = [UIColor whiteColor];
    [_viewWhiteBase addSubview:viewTitle];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, screenWidth-20*ScreenWidth/375, 45*ScreenWidth/375)];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.text = [NSString stringWithFormat:@"相册名称:%@",_strTitle];
    labelTitle.textColor = [UIColor lightGrayColor];
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewTitle addSubview:labelTitle];
  
}




#pragma mark -- 图片选择
//图片选择
- (void)initializeDataSource {
    
    _selectButtons = [[NSMutableArray alloc] init];
    _selectImages = [[NSMutableArray alloc] init];
}

- (void)initializeUserInterface {
    
    _imageWidth = (ScreenWidth - ((LINE_COUNT + 1) * 20*ScreenWidth/375)) / LINE_COUNT;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0*ScreenWidth/375, 65*ScreenWidth/375, ScreenWidth, _imageWidth + 2 *10 *ScreenWidth/375)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    [_scrollView addSubview:_contentView];
    
//    _contentSizeY = _contentSizeY + _imageWidth + 2 *10 *ScreenWidth/375;
    
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
        [_actionSheet showInView:_scrollView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择9张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)imageButtonPressed:(UIButton *)sender {
    
    BrowseImagesViewController *vc = [[BrowseImagesViewController alloc] initWithIndex:[_selectButtons indexOfObject:sender] selectImages:_selectImages];
    __weak JGLUpdataPhotoController *weakSelf = self;
    
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
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, ScreenWidth, _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375);
    
    //重写添加足迹按扭得位置
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 30*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    
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
    return CGRectMake(10*ScreenWidth/375 * cloumn + (_imageWidth+10*ScreenWidth/375) * (cloumn - 1), 10*ScreenWidth/375 * row + _imageWidth * (row - 1), _imageWidth, _imageWidth);
}


/**
 *  按钮添加
 *
 *  @return
 */
-(void)createButton
{
    _btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, 120*ScreenWidth/375+_imageWidth+ 65*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    _btnAdd.layer.masksToBounds = YES;
    _btnAdd.layer.cornerRadius = 8*ScreenWidth/375;
    
    [_btnAdd setTitle:@"发布" forState:UIControlStateNormal];
    [_btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAdd.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:_btnAdd];
    [_btnAdd addTarget:self action:@selector(FabuClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)FabuClick:(UIButton *)btn{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_strTimeKey forKey:@"albumKey"];
    [dict setObject:@1 forKey:@"mediaType"];

    [[JsonHttp jsonHttp] httpRequest:@"team/saveTeamMedia" JsonKey:@"TeamMedia" withData:dict andArray:_selectImages requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"失败");
    } completionBlock:^(id data) {
        
    }];
    
}


@end
