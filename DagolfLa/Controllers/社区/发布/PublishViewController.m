//
//  PublishViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "PublishViewController.h"
#import "IWTextView.h"
#import "ZYQAssetPickerController.h"
#import "BrowseImagesViewController.h"
#import "BallParkViewController.h"
#import "CommunityViewController.h"
#import <TAESDK/TaeSDK.h>
//数据
#define LINE_COUNT 4
#define kUsersave_URL @"userMood/save.do"

@interface PublishViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UITextViewDelegate>
{
    //    IWTextView* _textView;
    UIView* _viewBase;
    UIScrollView* _scrollView;
    CGFloat _contentSizeY;
    
    UIView* _viewLine;
    UIView* _viewArea;
    UIButton* _fabuBtn;
    
    int indexBtn;
    
    NSMutableDictionary* _dict;
    UILabel* _labelArea;
    
    NSMutableArray* _arrayCamera;
    
    UILabel *_placeholder_label;
    UITextView * _textView;
    
    MBProgressHUD* _progress;
    NSData *_vedioData;
}
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@property (nonatomic, strong) UIImage *vedioDefualtImage;

@end

@implementation PublishViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
        
    _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 1, ScreenWidth -40*ScreenWidth/375, 1);
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
    
    self.title = @"发表消息";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _arrayCamera = [[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSMutableString* str = [[NSMutableString alloc]init];
        str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
        [_dict setValue:str forKey:@"uId"];
    }
    
    //添加textview
    [self createView];
    
    //图片选择
    [self initializeDataSource];
    [self initializeUserInterface];
    
    //地区
    [self createAreaChoose];
    
    [self createFabu];
}
//文字设置
-(void)createView
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _viewBase.backgroundColor = [UIColor whiteColor];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [self.view addSubview:_viewBase];
    
    //发布的文字
    //    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, 80*ScreenWidth/375)];
    ////    _textView.backgroundColor=[UIColor redColor]; //背景色
    //    //垂直方向上可以拖拽
    //    _textView.alwaysBounceVertical = YES;
    //    _textView.delegate = self;       //设置代理方法的实现类
    //    _textView.placeholder = @"说点什么吧";
    //    [_viewBase addSubview:_textView];
    //    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    //    _textView.tag = 100;
    //    // 1.监听textView文字改变的通知
    //    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.tag = 100;
    
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.cornerRadius = 5.0;
    _textView.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [self.view addSubview:_textView];
    
    _placeholder_label = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, 300, 30)];
    _placeholder_label.text = @"说点什么吧!";
    _placeholder_label.font =  [UIFont boldSystemFontOfSize:13];
    _placeholder_label.textColor = [UIColor lightGrayColor];
    _placeholder_label.layer.cornerRadius = 10;
    _placeholder_label.layer.masksToBounds = YES;
    [self.view addSubview:_placeholder_label];
}
#pragma textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (_textView.text.length != 0) {
        _placeholder_label.text = @"";
        _placeholder_label.hidden = YES;
    }
    else{
        _placeholder_label.text = @"说点什么吧!";
        _placeholder_label.hidden = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    _placeholder_label.text = @"";
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        if (_textView.text.length == 0)
        {
            _placeholder_label.text = @"说点什么吧!";
            _placeholder_label.hidden = NO;
        }
        return NO;
    }
    
    return YES;
}
/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
    [_dict setValue:_textView.text forKey:@"moodContent"];
}

#pragma mark --键盘响应事件
//键盘响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    
    [textField resignFirstResponder];
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
#pragma mark -- 图片选择
//图片选择
- (void)initializeDataSource {
    
    _selectButtons = [[NSMutableArray alloc] init];
    _selectImages = [[NSMutableArray alloc] init];
}

- (void)initializeUserInterface {
    
    _imageWidth = (ScreenWidth - ((LINE_COUNT + 1) * 20*ScreenWidth/375)) / LINE_COUNT;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, _imageWidth + 2 *10 *ScreenWidth/375)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    [self.view addSubview:_contentView];
    
    _contentSizeY = _contentSizeY + _imageWidth + 2 *10 *ScreenWidth/375;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth);
    [_addButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    //    _addButton.layer.borderWidth = 1;
    //    _addButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _addButton.tag = 11;//区分添加图片
    [_addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_contentView addSubview:_addButton];
    
    _viewLine = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 1, ScreenWidth -40*ScreenWidth/375, 1)];
    [_contentView addSubview:_viewLine];
    _viewLine.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark --添加图片／拍照／视频点击事件
- (void)addButtonPressed:(UIButton *)sender {
    [_textView resignFirstResponder];
    if (sender.tag == 11) {
        //添加事件
        if (_selectImages.count == 0) {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:@"拍照" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小视频", @"拍照", @"选照片", nil];
            _actionSheet.tag = 120;
            [_actionSheet showInView:_scrollView];
        }else if(_selectImages.count < 9 && _selectImages.count > 0) {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:@"拍照" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选照片", nil];
            indexBtn++;
            [_textView resignFirstResponder];
            _actionSheet.tag = 110;
            [_actionSheet showInView:_scrollView];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择9张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (sender.tag == 12){
        //播放视频
        
    }
}

- (void)imageButtonPressed:(UIButton *)sender {
    
    
    BrowseImagesViewController *vc = [[BrowseImagesViewController alloc] initWithIndex:[_selectButtons indexOfObject:sender] selectImages:_selectImages];
    __weak PublishViewController *weakSelf = self;
    _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 1, ScreenWidth -40*ScreenWidth/375, 1);
    
    vc.deleteBlock = ^(NSInteger index) {
        
        UIButton *button = [weakSelf.selectButtons objectAtIndex:index];
        [button removeFromSuperview];
        [weakSelf.selectButtons removeObjectAtIndex:index];
        [weakSelf updateUserInterface];
    };
    //发出通知隐藏标签栏
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 120) {
        //存在视频
        switch (buttonIndex) {
            case 0:
                [self selectFromVideoCamera];
                break;
            case 1:
                [self selectFromCamera];
                break;
            case 2:
                [self selectFromPhoto];
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == 110){
        //不存在视频
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
}
#pragma mark -- 拍摄视频
- (void)selectFromVideoCamera{
    id<ALBBQuPaiPluginPluginServiceProtocol> sdk = [[TaeSDK sharedInstance] getService:@protocol(ALBBQuPaiPluginPluginServiceProtocol)];
    [sdk setDelegte:(id<QupaiSDKDelegate>)self];
    //可选配置信息
    [sdk setEnableWatermark:YES];
    [sdk setWatermarkImage:[UIImage imageNamed:@"watermask"]];
    /* 基本设置 */
    NSInteger minDuration = 2;
    NSInteger maxDuration = 8;
    NSInteger bitRate = 2000000;
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:minDuration maxDuration:maxDuration bitRate:bitRate];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:recordController];
    navigation.navigationBarHidden = YES;
    [self presentViewController:navigation animated:YES completion:nil];
}



#pragma mark --  视频保存后调用
- (void)qupaiSDK:(id<ALBBQuPaiPluginPluginServiceProtocol>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    NSLog(@"Qupai SDK compelete %@",videoPath);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [_selectImages removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        NSData *data = [NSData dataWithContentsOfFile:videoPath];
        NSString *encodedVedioStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        _vedioData = [[NSData alloc] initWithBase64EncodedString:encodedVedioStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    //缩略图
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
        self.vedioDefualtImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:thumbnailPath]];
        [_selectImages addObject:UIImageJPEGRepresentation(self.vedioDefualtImage, 0.7)];
    }
    
    [self updateUserInterface];
}

- (BOOL)prefersStatusBarHidden

{
    return NO;//隐藏为YES，显示为NO
    
}


- (void)selectFromCamera
{
    _vedioData = nil;
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
    _vedioData = nil;
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
        //NSLog(@"%@",assets[i]);
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
    //判断图片 OR 视频
    if (_vedioData) {
        [_addButton setImage:self.vedioDefualtImage forState:UIControlStateNormal];
        _addButton.tag = 12;//区分播放视频事件
    }else{
        [self resetAllImagePosition];
        
        _addButton.frame = [self frameWithButtonIndex:_selectButtons.count];
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, ScreenWidth-20*ScreenWidth/375, _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375);
        _contentSizeY = _contentSizeY + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375 - _imageWidth + 2 *10 *ScreenWidth/375;
        
        _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 1, ScreenWidth -40*ScreenWidth/375, 1);
        _viewArea.frame = CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375 + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);
        
        _fabuBtn.frame = CGRectMake(10*ScreenWidth/375, 174*ScreenWidth/375+ _addButton.bounds.size.height + _addButton.frame.origin.y, ScreenWidth - 20*ScreenWidth/375, 44);
    }
}
//重设图片的位置
- (void)resetAllImagePosition {
    
    NSInteger count = _selectButtons.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        UIButton *button = _selectButtons[i];
        button.frame = [self frameWithButtonIndex:i];
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
    
    return CGRectMake(10*ScreenWidth/375 * cloumn + (_imageWidth+10*ScreenWidth/375) * (cloumn - 1), 10*ScreenWidth/375 * row + _imageWidth * (row - 1), _imageWidth, _imageWidth);
}


-(void)createAreaChoose
{
    _viewArea = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375 + _imageWidth + 2 *10 *ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375)];
    _viewArea.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewArea];
    
    UIButton* btnArea = [UIButton buttonWithType:UIButtonTypeSystem];
    btnArea.frame = CGRectMake(0, 0, _viewArea.frame.size.width, _viewArea.frame.size.height);
    btnArea.backgroundColor = [UIColor clearColor];
    [_viewArea addSubview:btnArea];
    [btnArea addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchUpInside];
    
    _labelArea = [[UILabel alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375,  _viewArea.frame.size.width -10*ScreenWidth/375, 35*ScreenWidth/375)];
    _labelArea.text = @"请选择球场";
    _labelArea.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [btnArea addSubview:_labelArea];
    
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(_viewArea.frame.size.width - 30, 13*ScreenWidth/375, 13*ScreenWidth/375, 16*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@")"];
    [btnArea addSubview:imgv];
    
    
    
}
-(void)areaClick
{
    
    BallParkViewController* ballVc = [[BallParkViewController alloc]init];
    [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
        [_dict setValue:[NSNumber numberWithInteger:ballid] forKey:@"placeId"];
        _labelArea.text = balltitle;
    }];
    [self.navigationController pushViewController:ballVc animated:YES];
}

#pragma mark -- 发布按钮
-(void)createFabu
{
    _fabuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _fabuBtn.backgroundColor = [UIColor orangeColor];
    _fabuBtn.frame = CGRectMake(10*ScreenWidth/375, 174*ScreenWidth/375+_imageWidth, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);
    [_fabuBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_fabuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_fabuBtn];
    [_fabuBtn addTarget:self action:@selector(faClick) forControlEvents:UIControlEventTouchUpInside];
    
    _fabuBtn.layer.cornerRadius = 10;
    _fabuBtn.layer.masksToBounds = YES;
    
}
-(void)faClick{
    
    [_textView resignFirstResponder];
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在发布...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    NSString* str = [[NSString alloc]init];
    str = @"0";
    //    BOOL type = 0;
    [_dict setValue:str forKey:@"moodType"];
    NSString* xIndex = [[NSString alloc]init];
    xIndex  = @"12";
    [_dict setValue:self.lat forKey:@"xIndex"];
    
    NSString* yIndex = [[NSString alloc]init];
    yIndex  = @"18";
    [_dict setValue:self.lng forKey:@"yIndex"];
    
    
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
    [_dict setValue:_textView.text forKey:@"moodContent"];
    
    if (![Helper isBlankString:_textView.text]) {
        if (_vedioData) {
            [[PostDataRequest sharedInstance]postDataAndVideoDataRequest:kUsersave_URL parameter:_dict videoData:_vedioData imageDataArr:_selectImages success:^(id respondsData) {
                [MBProgressHUD hideHUDForView:self.view  animated:YES];
                
                //NSLog(@"%@",dict);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.view endEditing:YES];
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                    if (_blockRereshing) {
                        _blockRereshing();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                alertView.tag = 1000;
            } failed:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view  animated:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
            }];
        }else{
            [[PostDataRequest sharedInstance]postDataAndImageRequest:kUsersave_URL parameter:_dict imageDataArr:_selectImages success:^(id respondsData) {
                [MBProgressHUD hideHUDForView:self.view  animated:YES];
                
                //NSLog(@"%@",dict);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.view endEditing:YES];
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                    if (_blockRereshing) {
                        _blockRereshing();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                alertView.tag = 1000;
                
            } failed:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view  animated:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
            }];
        }
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        //
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请重新输入文字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alertView show];
        [Helper alertViewWithTitle:@"请重新输入文字" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}




@end
