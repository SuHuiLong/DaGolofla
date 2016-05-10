//
//  TeamCreatePhotoController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamCreatePhotoController.h"

#import "ZYQAssetPickerController.h"
#import "IWTextView.h"

#import "BrowseImagesViewController.h"

#import "Helper.h"

#import "PostDataRequest.h"
#import "MBProgressHUD.h"


//数据
#define LINE_COUNT 4

@interface TeamCreatePhotoController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UITextFieldDelegate>
{
    IWTextView* _textView;
    UIView* _viewBase;
    UIScrollView* _scrollView;
    CGFloat _contentSizeY;
    
    UIView* _viewLine;
    UIView* _viewArea;
    UIButton* _btnFinish;
    
    int indexBtn;
    
    NSMutableDictionary* _dict;
    
    NSMutableArray* _arrayCamera;
    
    MBProgressHUD* _progress;
}
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@end

@implementation TeamCreatePhotoController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
//    _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 2, ScreenWidth -20*ScreenWidth/375, 2);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //显示
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    indexBtn = 0;
    _dict = [[NSMutableDictionary alloc]init];
    _arrayCamera = [[NSMutableArray alloc]init];
    
    self.title = @"创建相册";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    
    //相册名称
    [self createPhotoAlbumName];
    //添加textview
    [self createView];
    
    //图片选择
    [self initializeDataSource];
    [self initializeUserInterface];
    

    //完成按钮
    [self createFinish];
}

//相册名称
-(void)createPhotoAlbumName
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [_scrollView addSubview:viewBase];
    viewBase.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 12*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
    label.text = @"相册名称：";
    label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewBase addSubview:label];
    
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(120*ScreenWidth/375, 12*ScreenWidth/375, viewBase.frame.size.width-120*ScreenWidth/375, 20*ScreenWidth/375)];
    textField.placeholder = @"请输入相册名称";
    textField.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    textField.delegate = self;
    [viewBase addSubview:textField];
    textField.tag = 1001;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField.tag == 1001) {
        [textField resignFirstResponder];
    }
    return YES;
    
}



//文字设置
-(void)createView
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 70*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _viewBase.backgroundColor = [UIColor whiteColor];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [_scrollView addSubview:_viewBase];
    
    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, 80*ScreenWidth/375)];
//    _textView.backgroundColor=[UIColor redColor]; //背景色
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;       //设置代理方法的实现类
    _textView.placeholder = @"说点什么吧";
    [_viewBase addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textView.tag = 100;
    // 1.监听textView文字改变的通知
    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
}
/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
}

#pragma mark --键盘响应事件
//键盘响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    
    [textField resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}







#pragma mark -- 图片选择
//图片选择
- (void)initializeDataSource {
    
    _selectButtons = [[NSMutableArray alloc] init];
    _selectImages = [[NSMutableArray alloc] init];
}

- (void)initializeUserInterface {
    
    _imageWidth = (ScreenWidth - ((LINE_COUNT + 1) * 20*ScreenWidth/375)) / LINE_COUNT;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 160*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, _imageWidth + 2 *10 *ScreenWidth/375)];
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
        [_textView resignFirstResponder];
        [_actionSheet showInView:_scrollView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择9张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)imageButtonPressed:(UIButton *)sender {
    
    [self.view endEditing:YES];
    BrowseImagesViewController *vc = [[BrowseImagesViewController alloc] initWithIndex:[_selectButtons indexOfObject:sender] selectImages:_selectImages];
    __weak TeamCreatePhotoController *weakSelf = self;
    
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
    
    _btnFinish.frame = CGRectMake(10*ScreenWidth/375,  _contentView.frame.origin.y + _addButton.bounds.size.height + _addButton.frame.origin.y + 30*ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);
    
    _contentSizeY = _contentSizeY + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375 - _imageWidth + 2 *10 *ScreenWidth/375;
    
    _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 2, ScreenWidth -20*ScreenWidth/375, 2);
    _viewArea.frame = CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375 + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);
    
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



-(void)createFinish
{
    _btnFinish = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnFinish.backgroundColor = [UIColor orangeColor];
    _btnFinish.frame = CGRectMake(10*ScreenWidth/375, 190*ScreenWidth/375+_imageWidth, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);
    [_btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [_btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_btnFinish];
    [_btnFinish addTarget:self action:@selector(finish1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnFinish.layer.cornerRadius = 10;
    _btnFinish.layer.masksToBounds = YES;
    
}
#pragma MARK --发布点击事件
-(void)finish1Click:(UIButton *)btn
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在发布...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    btn.userInteractionEnabled = NO;
    UITextField* field = (UITextField *)[self.view viewWithTag:1001];
    [_dict setValue:field.text forKey:@"photoGroupsName"];
    [_dict setValue:_textView.text forKey:@"photoGroupsContent"];
    [_dict setValue:_teamId forKey:@"photoGroupsTeamId"];
    [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"photoGroupsCreateUserId"];
    [[PostDataRequest sharedInstance] postDataAndImageRequest:@"photos/saveGroup.do" parameter:_dict imageDataArr:_selectImages success:^(id respondsData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        btn.userInteractionEnabled = YES;
        if ([[dict objectForKey:@"success"] boolValue]) {
            ////NSLog(@"%@",[dict objectForKey:@"message"]);
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        btn.userInteractionEnabled = YES;
    }];
 
}
@end
