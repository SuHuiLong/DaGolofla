//
//  SearchWithCityTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWithCityTableViewCell.h"
#import "SearchWithCityCollectionViewCell.h"
@implementation SearchWithCityTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
#pragma mark - CreateView
-(void)createView{
    //区域
    self.areaLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(12), kHvertical(20), kWvertical(40), kHvertical(16)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:nil];
    [self.contentView addSubview:self.areaLabel];
    //城市和球场数量
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =CGSizeMake((screenWidth - kWvertical(134))/3, kHvertical(26));
    
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kWvertical(49), 0, screenWidth-kWvertical(54), self.contentView.height) collectionViewLayout:layout];
    mainCollectionView.backgroundColor = ClearColor;
    [mainCollectionView registerClass:[SearchWithCityCollectionViewCell class] forCellWithReuseIdentifier:@"SearchWithCityCollectionViewCellId"];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [self.contentView addSubview:mainCollectionView];
    self.cityView = mainCollectionView;    
}

// 配置数据
-(void)configModel:(SearchWIthCityModel *)model{
    NSString *areaStr = model.areaName;
    self.areaLabel.text = areaStr;
    self.dataArray = [NSMutableArray arrayWithArray:model.provinceList];

    NSInteger cityNum = _dataArray.count;
    NSInteger numberLine = cityNum/3;
    NSInteger remainder = cityNum%3;
    if (remainder>0) {
        numberLine ++ ;
    }
    self.cityView.height = kHvertical(40)*numberLine + kHvertical(10);
    [self.cityView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cityView.width/3 , kHvertical(40));
}

// 该方法是设置一个section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
 
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kWvertical(0);
}

// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchWithCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchWithCityCollectionViewCellId" forIndexPath:indexPath];
    [cell configModel:self.dataArray[indexPath.item]];
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchWithCityDetailModel *model = self.dataArray[indexPath.item];
    
    self.blockAddress(model.provinceName);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
