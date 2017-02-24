//
//  CityPickerView.m
//  DagolfLa
//
//  Created by SHL on 2017/2/22.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "CityPickerView.h"
#import "GPProvince.h"

@interface CityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
//选择器界面
@property (nonatomic, copy) UIView *pickerView;
//选中的省份
@property (nonatomic, assign) NSInteger proIndex;
//选择的数据
@property (nonatomic, copy) NSDictionary *selectDict;

@end

@implementation CityPickerView

// 懒加载省会
- (NSMutableArray *)provinces
{
    if (_provincesArray == nil) {
        // 装所有的省会
        _provincesArray = [NSMutableArray array];
    }
    return _provincesArray;
}
//设置Block
-(void)setBlock:(cityPickerBlock)block{
    self.cityPickerBlock = block;
}

#pragma mark - init
-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [self createUI];
    }
    return self;
}
#pragma mark - CreateUI
-(void)createUI{
    UIView *backView = [Factory createViewWithBackgroundColor:BlackColor frame:self.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:tap];
    backView.alpha = 0.5;
    
    _pickerView= [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, screenHeight - kHvertical(218)-64, screenWidth, kHvertical(218))];

    UIButton *cancelBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(60), kHvertical(55)) titleFont:kHorizontal(15) textColor:[UIColor colorWithHexString:@"a0a0a0"] backgroundColor:ClearColor target:self selector:@selector(cancelBtnClick) Title:@"取消"];
    
    UIButton *sureBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth-kWvertical(60), 0, kWvertical(60), kHvertical(55)) titleFont:kHorizontal(15) textColor:[UIColor colorWithHexString:@"a0a0a0"] backgroundColor:ClearColor target:self selector:@selector(sureBtnClick) Title:@"确定"];
    
    
    UIPickerView *cityPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kHvertical(50), screenWidth, kHvertical(163))];
    cityPickView.delegate = self;
    cityPickView.dataSource = self;
    
    [self addSubview:backView];
    [self addSubview:_pickerView];
    [_pickerView addSubview:cancelBtn];
    [_pickerView addSubview:sureBtn];
    [_pickerView addSubview:cityPickView];
    
    
    
}

#pragma mark - Action
//取消点击
-(void)cancelBtnClick{
    [self removeSelfView];

}
//确认点击
-(void)sureBtnClick{
    if (!_selectDict) {
        GPProvince *fristDict = _provincesArray[0];
        NSString *provincesName = fristDict.name;
        NSString *cityName = fristDict.cities[0];
        _selectDict = @{
                        @"proVinceName":provincesName,
                        @"cityName":cityName
                        };
    }
    if (self.cityPickerBlock!=nil) {
        _cityPickerBlock(_selectDict);
    }
    [self removeSelfView];
}

-(void)removeSelfView{

    [self removeFromSuperview];

}

#pragma mark - pickerDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinces.count;
    }else{
        // 获取省会
        GPProvince *p = self.provinces[_proIndex];
        return p.cities.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component ==0) {
        GPProvince *p = self.provinces[row];
        return p.name;
    }else{
        // 获取选中省会城市名
        GPProvince *p = self.provinces[_proIndex];
        return p.cities[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) { // 滚动省会,刷新城市（1列）
        // 记录当前选中的省会
        _proIndex = [pickerView selectedRowInComponent:0];
        [pickerView reloadComponent:1];
    }
    // 获取选中省会
    GPProvince *p = self.provinces[_proIndex];
    // 获取选中的城市
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];
    NSString *proVinceName = p.name;
    NSString *cityName = p.cities[cityIndex];
    _selectDict = @{
                    @"proVinceName":proVinceName,
                    @"cityName":cityName
                    };
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth/2, kHvertical(22)) textColor:BlackColor fontSize:kHorizontal(18) Title:nil];
//        pickerLabel = [[UILabel alloc] init];
        
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = kHorizontal(18);
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont systemFontOfSize:kHorizontal(18)]];

    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
