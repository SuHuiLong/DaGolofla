//
//  AddFootViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "AddFootViewController.h"

#import "ZYQAssetPickerController.h"
#import "IWTextView.h"
#import "BrowseImagesViewController.h"
#define LINE_COUNT 4
#define kUsersave_URL @"userMood/save.do"

#import "AreaViewController.h"
#import "DateTimeViewController.h"
#import "UIView+ChangeFrame.h"

#import "BallParkViewController.h"
@interface AddFootViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,UIPickerViewAccessibilityDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    NSMutableDictionary* _dict;
    
    UIView* _viewTime, * _viewNum, *_viewWhiteBase;
    UILabel* _labelPark, *_labelTime,* _labelNum;
    UIButton* _btnChoose;
    UIButton* _btnImage;
    
    IWTextView* _textView;
    UIView* _viewBase;
    UIScrollView* _scrollView;
    CGFloat _contentSizeY;
    
    UIView* _viewLine;
    UIView* _viewArea;
    UIButton* _fabuBtn;
    
    int indexBtn;
    
    UILabel* _labelChoose;
    
    UIButton* _btnAdd;
    NSInteger _btnNum;
    
    //是否同步到社区
    BOOL _isChoose;
    
    
    //选择器
    UIView* _selectDateView;
    UIPickerView* _pickerView;
    NSMutableArray* _numArray;
    UIButton *_button1, *_button2;
    BOOL _isChooseNum;
    
    // 左侧的箭头
    UIImageView *_leftImage;
    //存放拍照的照片数组
    NSMutableArray* _arrayCamera;
    
    NSArray *_strarray;
    
    MBProgressHUD* _progress;
    
}
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@end


@implementation AddFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加足迹";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, 568);
    _arrayCamera = [[NSMutableArray alloc]init];
    _dict = [[NSMutableDictionary alloc]init];
    
    /**
     选择器
     */
    _selectDateView = [[UIView alloc]init];
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _numArray = [[NSMutableArray alloc]init];
    _pickerView = [[UIPickerView alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSMutableString* str = [[NSMutableString alloc]init];
        str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
        [_dict setValue:str forKey:@"uId"];
    }
    
    
    [_dict setValue:@"1" forKey:@"moodType"];
    
    
    //球场
    [self createArea];
    
    
    
    
    //添加按钮
    [self createButton];
    
    //创建照片和心情视图
    [self createView];
    
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
-(void)createArea
{
    _viewWhiteBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100*ScreenWidth/375)];
    _viewWhiteBase.backgroundColor = [UIColor whiteColor];
    
    [_scrollView addSubview:_viewWhiteBase];
    //    viewBase.layer.masksToBounds = YES;
    //    viewBase.layer.cornerRadius = 8*ScreenWidth/375;
    
    
    _labelPark = [[UILabel alloc]initWithFrame:CGRectMake(12*ScreenWidth/375, 15*ScreenWidth/375, ScreenWidth-24*ScreenWidth/375, 20)];
    _labelPark.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _labelPark.text = @"请选择高尔夫球场";
    _labelPark.textColor = [UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.00f];
    [_viewWhiteBase addSubview:_labelPark];
    _labelPark.userInteractionEnabled = YES;
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - _labelPark.frameX  - 7, _labelPark.frameY + _labelPark.height / 2 - 5, 7, 10)];
    _leftImage.image = [UIImage imageNamed:@")"];
    [_viewWhiteBase addSubview:_leftImage];
    
    
    
    UIButton* btnChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnChoose addTarget:self action:@selector(btnChooseClick) forControlEvents:UIControlEventTouchUpInside];
    btnChoose.frame = CGRectMake(0, 0, ScreenWidth-24*ScreenWidth/375, 20*ScreenWidth/375);
    //    btnChoose.backgroundColor = [UIColor lightGrayColor];
    [_labelPark addSubview:btnChoose];
    
    
    // 直线
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(_labelPark.frameX, _labelPark.frameY + _labelPark.height + 12  *ScreenWidth/375, _labelPark.width, 1)];
    vi.backgroundColor = [UIColor colorWithRed:0.85f green:0.86f blue:0.86f alpha:1.00f];
    [_viewWhiteBase addSubview:vi];
    
    // 添加时间和杆数
    [self createTimeAndNum];
}

-(void)btnChooseClick
{
 
    
        //选择球场
        BallParkViewController* ballVc = [[BallParkViewController alloc]init];
        [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
            [_dict setValue:[NSNumber numberWithInteger:ballid] forKey:@"placeId"];
            _labelPark.text = balltitle;
            _labelPark.textColor = [UIColor blackColor];
            _leftImage.hidden = YES;
        }];
        [self.navigationController pushViewController:ballVc animated:YES];
    
    
}
/**
 *  添加时间和杆数
 */
-(void)createTimeAndNum
{
    _viewTime = [[UIView alloc]initWithFrame:CGRectMake(15*ScreenWidth/375, 58*ScreenWidth/375, ScreenWidth/2 - 18*ScreenWidth/375, 34*ScreenWidth/375)];
    [_viewWhiteBase addSubview:_viewTime];
    _viewTime.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    _viewTime.layer.masksToBounds = YES;
    _viewTime.layer.cornerRadius = 5*ScreenWidth/375;
    _viewTime.userInteractionEnabled = YES;
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _viewTime.frame.size.width, _viewTime.frame.size.height)];
    _labelTime.text = @"请选择时间";
    _labelTime.textColor = [UIColor colorWithRed:0.52f green:0.53f blue:0.53f alpha:1.00f];
    _labelTime.textAlignment = NSTextAlignmentCenter;
    _labelTime.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_viewTime addSubview:_labelTime];
    //    _labelTime.layer.masksToBounds = YES;
    //    _labelTime.layer.cornerRadius = 5*ScreenWidth/375;
    _labelTime.userInteractionEnabled = YES;
    
    
    UIButton* btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTime addTarget:self action:@selector(btnTimeClick) forControlEvents:UIControlEventTouchUpInside];
    btnTime.frame = CGRectMake(0, 0, _labelTime.frame.size.width, _labelTime.frame.size.height);
    [_labelTime addSubview:btnTime];
    
    
    _viewNum = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 6 *ScreenWidth/375, 58*ScreenWidth/375, ScreenWidth/2 - 18*ScreenWidth/375, 34*ScreenWidth/375)];
    [_viewWhiteBase addSubview:_viewNum];
    _viewNum.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    _viewNum.layer.masksToBounds = YES;
    _viewNum.layer.cornerRadius = 5*ScreenWidth/375;
    
    
    _labelNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _viewNum.frame.size.width, _viewNum.frame.size.height)];
    _labelNum.text = @"请选择球杆数";
    _labelNum.textColor = [UIColor colorWithRed:0.52f green:0.53f blue:0.53f alpha:1.00f];
    _labelNum.textAlignment = NSTextAlignmentCenter;
    _labelNum.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_viewNum addSubview:_labelNum];
    //    _labelNum.layer.masksToBounds = YES;
    //    _labelNum.layer.cornerRadius = 5*ScreenWidth/375;
    _labelNum.userInteractionEnabled = YES;
    
    UIButton* btnNum = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNum addTarget:self action:@selector(btnNumClick) forControlEvents:UIControlEventTouchUpInside];
    btnNum.frame = CGRectMake(0, 0, _viewNum.frame.size.width, _viewNum.frame.size.height);
    [_labelNum addSubview:btnNum];
    
}

-(void)btnNumClick
{
    //性别
    if (_isChooseNum == NO) {
        [self createDateClick];
    }
}


#pragma mark --时间选择器
//时间选择器
-(void)createDateClick {
    _isChooseNum = YES;
    _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    [UIView animateWithDuration:0.5 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight/3*2, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    _selectDateView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_selectDateView];
    
    _button1.frame = CGRectMake(20*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_selectDateView addSubview:_button1];
    [_button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _button1.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame = CGRectMake(ScreenWidth-50*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_selectDateView addSubview:_button2];
    _button2.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    _pickerView.frame = CGRectMake(50*ScreenWidth/375, 30, ScreenWidth-100*ScreenWidth/375, ScreenHeight/3-100*ScreenWidth/375);
    [_selectDateView addSubview:_pickerView];
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    for (int i = 0; i < 201; i++) {
        [_numArray addObject:[NSString stringWithFormat:@"%d杆",i]];
    }
    
    [_pickerView selectRow:72 inComponent:0 animated:YES];
}

#pragma mark --pickerview
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _numArray.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 80;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString* str = [NSString stringWithFormat:@"%@",_numArray[row]];
        _labelNum.text = str;
        _strarray = [str componentsSeparatedByString:@"杆"];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        
        return [_numArray objectAtIndex:row];
    }
    return nil;
}


- (void)button1Click:(UIButton*)button {
    _isChooseNum = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
}
- (void)button2Click:(UIButton*)button {
    _isChooseNum = NO;
    
    _labelNum.text = [_numArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
    _labelNum.textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.5 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    
}



-(void)btnTimeClick
{
    //日期
    DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
    dateVc.typeIndex = @1;
    [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
        _labelTime.text = dateStr;
        _labelTime.textColor = [UIColor blackColor];
        [_dict setValue:_labelTime.text forKey:@"playTimes"];
    }];
    [self.navigationController pushViewController:dateVc animated:YES];
}



//文字设置
-(void)createView
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 110*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _viewBase.backgroundColor = [UIColor whiteColor];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [_scrollView addSubview:_viewBase];
    
    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, 80*ScreenWidth/375)];
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = NO;
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
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 200*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, _imageWidth + 2 *10 *ScreenWidth/375)];
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
    
    _btnChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnChoose setTitle: @"是否同步到社区" forState:UIControlStateNormal];
    _btnChoose.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [_btnChoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _btnChoose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnChoose.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _btnChoose.frame = CGRectMake(10*ScreenWidth/375, 220*ScreenWidth/375+_imageWidth, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [_btnChoose addTarget:self action:@selector(isChooseClick) forControlEvents:UIControlEventTouchUpInside];
    
    _btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnImage.frame = CGRectMake(ScreenWidth-60*ScreenWidth/375, 2*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375);
    [_btnImage setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [_btnImage addTarget:self action:@selector(isChooseClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [_labelChoose addSubview:_btnChoose];
    [_btnChoose addSubview:_btnImage];
    [_scrollView addSubview:_btnChoose];

    
}
/**
 *  按钮选择，否返回0，是返回1
 */
-(void)isChooseClick
{
    if (_isChoose == NO) {
        _isChoose = YES;
        //        _btnChoose.backgroundColor = [UIColor orangeColor];
        [_btnImage setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
    }
    else
    {
        _isChoose = NO;
        [_btnImage setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
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
    
    BrowseImagesViewController *vc = [[BrowseImagesViewController alloc] initWithIndex:[_selectButtons indexOfObject:sender] selectImages:_selectImages];
    __weak AddFootViewController *weakSelf = self;
    
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
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, ScreenWidth-20*ScreenWidth/375, _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375);
    //重新规划文字的位置
    _btnChoose.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    //重写添加足迹按扭得位置
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 74*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    
    
    _contentSizeY = _contentSizeY + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375 - _imageWidth + 2 *10 *ScreenWidth/375;
    
    _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 2, ScreenWidth -20*ScreenWidth/375, 2);
    
    _viewArea.frame = CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375 + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);

    _fabuBtn.frame = CGRectMake(10*ScreenWidth/375, 174*ScreenWidth/375+ _addButton.bounds.size.height + _addButton.frame.origin.y, ScreenWidth - 20*ScreenWidth/375, 44);

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
    _btnNum = index;
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
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, 274*ScreenWidth/375+_imageWidth+ 65*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    _btnAdd.layer.masksToBounds = YES;
    _btnAdd.layer.cornerRadius = 8*ScreenWidth/375;
    
    [_btnAdd setTitle:@"发布" forState:UIControlStateNormal];
    [_btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAdd.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:_btnAdd];
    [_btnAdd addTarget:self action:@selector(FabuClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)FabuClick:(UIButton *)btn{

    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在发布...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    if (_strarray[0] == 0 || _strarray == nil) {
        [_dict setValue:@72 forKey:@"poleNum"];
    }else{
        [_dict setValue:_strarray[0] forKey:@"poleNum"];
    }
    
    NSString* str = [NSString stringWithFormat:@"%d",_isChoose];
    [_dict setValue:str forKey:@"isSync"];
    
    NSString* xIndex = [[NSString alloc]init];
    xIndex  = [NSString stringWithFormat:@"%@",self.lat];
    [_dict setValue:self.lat forKey:@"xIndex"];
    
    NSString* yIndex = [[NSString alloc]init];
    yIndex  = [NSString stringWithFormat:@"%@",self.lng];
    [_dict setValue:self.lng forKey:@"yIndex"];
    
    [_dict setValue:_textView.text forKey:@"moodContent"];
    
    if (_isChoose == YES) {
        if (![Helper isBlankString:_labelPark.text] && xIndex != nil && yIndex != nil && ![_labelPark.text isEqualToString:@"请选择高尔夫球场"]) {
            if (![Helper isBlankString:_labelTime.text] && ![_labelTime.text isEqualToString:@"请选择时间"]) {
                if ( ![Helper isBlankString:_labelNum.text] && ![_labelNum.text isEqualToString:@"请选择球杆数"])
                {
                    [[PostDataRequest sharedInstance]postDataAndImageRequest:kUsersave_URL parameter:_dict imageDataArr:_selectImages success:^(id respondsData) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        if ([[data objectForKey:@"success"] integerValue]) {
                            [Helper alertViewWithTitle:[data objectForKey:@"message"] withBlockCancle:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            } withBlockSure:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            } withBlock:^(UIAlertController *alertView) {
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [Helper alertViewWithTitle:[data objectForKey:@"message"]  withBlock:^(UIAlertController *alertView) {
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];
                        }
                        
                        
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [Helper alertViewNoHaveCancleWithTitle:@"\n链接超时！\n" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }];
                }else{
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [Helper alertViewWithTitle:@"您没有选择打球杆数"  withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
                
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Helper alertViewWithTitle:@"您没有选择打球时间"  withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Helper alertViewWithTitle:@"请重新选择打球球场"  withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }else{
        if (xIndex != nil && yIndex != nil && ![_labelPark.text isEqualToString:@"请选择高尔夫球场"]) {
            if (_labelTime.text != nil && ![_labelTime.text isEqualToString:@"请选择时间"]) {
                
                if ( _labelNum.text != nil && ![_labelNum.text isEqualToString:@"请选择球杆数"]) {
                    [[PostDataRequest sharedInstance]postDataAndImageRequest:kUsersave_URL parameter:_dict imageDataArr:_selectImages success:^(id respondsData) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        if ([[data objectForKey:@"success"] integerValue]) {

                            [Helper alertViewWithTitle:[data objectForKey:@"message"] withBlockCancle:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            } withBlockSure:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            } withBlock:^(UIAlertController *alertView) {
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];
                            
                        }
                        else
                        {
                            [Helper alertViewWithTitle:[data objectForKey:@"message"]  withBlock:^(UIAlertController *alertView) {
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];
                        }
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [Helper alertViewNoHaveCancleWithTitle:@"\n链接超时！\n" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }];
                }else{
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [Helper alertViewWithTitle:@"您没有选择打球杆数"  withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];

                }
                
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Helper alertViewWithTitle:@"您没有选择打球时间"  withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Helper alertViewWithTitle:@"请重新选择打球球场"  withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }
}


@end
