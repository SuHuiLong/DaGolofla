//
//  JGLGroupPeopleDetileTableViewCell.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGroupPeopleDetileTableViewCell.h"
#import "JGLGroupPeoTableViewCell.h"
#import "JGLGroupCombatModel.h"
#import "JGLGroupSignUpMemberModel.h"

#import "JGLGroupSignUpMenViewController.h"
@implementation JGLGroupPeopleDetileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //2.初始化collectionView
        _dataArray = [[NSMutableArray alloc]init];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 104*ProportionAdapter) style:UITableViewStylePlain];
        _tableView.scrollEnabled=NO;
        [self.contentView addSubview:_tableView];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JGLGroupPeoTableViewCell class] forCellReuseIdentifier:@"JGLGroupPeoTableViewCell"];
    }
    return self;
}
-(void)tableViewReFresh:(NSMutableArray* )arr  withArrAll:(NSMutableArray *)arrAll;
{
    _dataArray = [arr mutableCopy];//界面上使用的数据
    _dataArrayAll = [arrAll mutableCopy];//所有的总数据，
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count != 0) {
        JGLGroupCombatModel* model = _dataArray[section];
        return [model.maxGroupIndex integerValue];
    }
    else{
        return 0;
    }
}
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104*ProportionAdapter;
}
//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70*ProportionAdapter;
}
//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLGroupPeoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLGroupPeoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count != 0) {
        JGLGroupCombatModel* model = _dataArray[indexPath.section];
        [cell showDataSignUp1:model withIndex:indexPath.row];//这个model所带的数据包括了所有的左边成员列表的成员数据
        [cell showDataSignUp2:model withIndex:indexPath.row];//同理，右边成员列表的数据

    }
    NSLog(@">>>>>>>>>>>>>>>>>>>>%td<<<<<<<<<<<<<<<<<<<",tableView.tag);
    if (_dataArrayAll.count != 0) {
        //当改轮次并未分组，则不可点击
        if ([[_dataArrayAll[tableView.tag - 1000] objectForKey:@"groupType"] integerValue] == 0) {
            cell.userInteractionEnabled = NO;
            cell.labelNum.hidden = YES;
            cell.imgvJt.hidden = YES;
        }
        else{
            cell.userInteractionEnabled = YES;
            cell.labelNum.hidden = NO;
            cell.imgvJt.hidden = NO;
        }
    }
    //添加点击事件
    [cell.btnHeader1 addTarget:self action:@selector(header1Click:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnHeader1.tag = 2000000 + (indexPath.section + 1)*10000 + indexPath.row;
    
    [cell.btnHeader2 addTarget:self action:@selector(header2Click:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnHeader2.tag = 3000000 + (indexPath.section + 1)*10000 + indexPath.row;
    
    [cell.btnHeader3 addTarget:self action:@selector(header3Click:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnHeader3.tag = 4000000 + (indexPath.section + 1)*10000 + indexPath.row;
    
    [cell.btnHeader4 addTarget:self action:@selector(header4Click:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnHeader4.tag = 5000000 + (indexPath.section + 1)*10000 + indexPath.row;
    return cell;
}

-(void)header1Click:(UIButton *)btn
{
    JGLGroupCombatModel* model = _dataArray[(btn.tag - 2000000)/10000-1];//section
    NSArray* arr1 = model.signUpList1;
    for (int i = 0 ; i < arr1.count; i ++) {
        JGLGroupSignUpMemberModel *modelSignUp = [[JGLGroupSignUpMemberModel alloc] init];
        [modelSignUp setValuesForKeysWithDictionary:arr1[i]];
        if ([modelSignUp.groupIndex integerValue] == (btn.tag - 2000000)%10000) {
            if ([modelSignUp.sortIndex integerValue] == 0) {
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 2000000)/10000-1] teamKey1] withUserKey:modelSignUp.userKey withGroupIndex:(btn.tag - 2000000)%10000 withSortIndex:0 withRows:(btn.tag - 2000000)%10000];
                    return;
                }
            }
            else
            {
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 2000000)/10000-1] teamKey1] withUserKey:nil withGroupIndex:(btn.tag - 2000000)%10000 withSortIndex:-1 withRows:(btn.tag - 2000000)%10000];
                    return;
                }
            }
        }
    }
}
-(void)header2Click:(UIButton *)btn
{
    //dataarray是comblist， 所以在这儿取section对应的model
    //如果是找成员，则是用index。row查找
    JGLGroupCombatModel* model = _dataArray[(btn.tag - 3000000)/10000-1];
    NSArray* arr1 = model.signUpList1;
    for (int i = 0 ; i < arr1.count; i ++) {
        JGLGroupSignUpMemberModel *modelSignUp = [[JGLGroupSignUpMemberModel alloc] init];
        [modelSignUp setValuesForKeysWithDictionary:arr1[i]];
        
        if ([modelSignUp.groupIndex integerValue] == (btn.tag - 3000000)%10000) {
            if ([modelSignUp.sortIndex integerValue] == 1) {
                if (self.delegate) {
                    NSLog(@"%td       %td",(btn.tag - 3000000)/10000-1, (btn.tag - 3000000)%10000);
                    [self.delegate pushController:[_dataArray[(btn.tag - 3000000)/10000-1] teamKey1] withUserKey:modelSignUp.userKey withGroupIndex:(btn.tag - 3000000)/10000-1 withSortIndex:1 withRows:(btn.tag - 3000000)%10000];
                    return;
                }
            }
            else{
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 3000000)/10000-1] teamKey1] withUserKey:nil withGroupIndex:(btn.tag - 3000000)/10000-1 withSortIndex:-1 withRows:(btn.tag - 3000000)%10000];
                    return;
                }
            }
        }
    }
}
-(void)header3Click:(UIButton *)btn
{
    JGLGroupCombatModel* model = _dataArray[(btn.tag - 4000000)/10000-1];
    NSArray* arr1 = model.signUpList2;
    for (int i = 0 ; i < arr1.count; i ++) {
        JGLGroupSignUpMemberModel *modelSignUp = [[JGLGroupSignUpMemberModel alloc] init];
        [modelSignUp setValuesForKeysWithDictionary:arr1[i]];
   
        if ([modelSignUp.groupIndex integerValue] == (btn.tag - 4000000)%10000) {
            if ([modelSignUp.sortIndex integerValue] == 0) {
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 4000000)/10000-1] teamKey2] withUserKey:modelSignUp.userKey withGroupIndex:(btn.tag - 4000000)%10000 withSortIndex:0 withRows:(btn.tag - 4000000)%10000];
                    return;
                }
            }
            else{
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 4000000)/10000-1] teamKey2] withUserKey:nil withGroupIndex:(btn.tag - 4000000)%10000 withSortIndex:-1 withRows:(btn.tag - 4000000)%10000];
                    return;
                }
            }
        }
    }
}
-(void)header4Click:(UIButton *)btn
{
    JGLGroupCombatModel* model = _dataArray[(btn.tag - 5000000)/10000-1];
    NSArray* arr1 = model.signUpList2;
    for (int i = 0 ; i < arr1.count; i ++) {
        JGLGroupSignUpMemberModel *modelSignUp = [[JGLGroupSignUpMemberModel alloc] init];
        [modelSignUp setValuesForKeysWithDictionary:arr1[i]];
        
        if ([modelSignUp.groupIndex integerValue] == (btn.tag - 5000000)%10000) {
            if ([modelSignUp.sortIndex integerValue] == 1) {
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 5000000)/10000-1] teamKey2] withUserKey:modelSignUp.userKey withGroupIndex:(btn.tag - 5000000)%10000 withSortIndex:1 withRows:(btn.tag - 5000000)%10000];
                    return;
                }
            }
            else{
                if (self.delegate) {
                    [self.delegate pushController:[_dataArray[(btn.tag - 5000000)/10000-1] teamKey2] withUserKey:nil withGroupIndex:(btn.tag - 5000000)%10000 withSortIndex:-1 withRows:(btn.tag - 5000000)%10000];
                    return;
                }
            }
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 70*ProportionAdapter)];
    
    UIImageView* backImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 35*ProportionAdapter)];
    backImgv.image = [UIImage imageNamed:@"vs_title"];
    [viewHead addSubview:backImgv];
    
    UILabel* leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*ProportionAdapter, 10*ProportionAdapter, 130*ProportionAdapter, 20*ProportionAdapter)];
    leftLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    [backImgv addSubview:leftLabel];
    if (_dataArray.count != 0) {
        JGLGroupCombatModel* model = _dataArray[section];
        leftLabel.text = model.teamName1;
    }
    else{
        leftLabel.text = @"暂无球队名";
    }
    
    leftLabel.textColor = [UIColor whiteColor];
    UILabel* rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 155*ProportionAdapter, 10*ProportionAdapter, 130*ProportionAdapter, 20*ProportionAdapter)];
    rightLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    [backImgv addSubview:rightLabel];
    rightLabel.textColor = [UIColor whiteColor];
    if (_dataArray.count != 0) {
        JGLGroupCombatModel* model = _dataArray[section];
        rightLabel.text = model.teamName2;
    }
    else{
        rightLabel.text = @"暂无球队名";
    }
    UIImageView* lineImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58*ProportionAdapter, screenWidth, 12*ProportionAdapter)];
    lineImgv.image = [UIImage imageNamed:@"iosopen"];
    [viewHead addSubview:lineImgv];
    return viewHead;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
