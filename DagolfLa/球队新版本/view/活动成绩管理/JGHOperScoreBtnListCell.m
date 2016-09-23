//
//  JGHOperScoreBtnListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperScoreBtnListCell.h"

@implementation JGHOperScoreBtnListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.oneBGView.layer.masksToBounds = YES;
    self.oneBGView.layer.cornerRadius = 5.0;
    
    self.oneBGViewLeft.constant = 10 *ProportionAdapter;
    self.oneBGViewRight.constant = 35 *ProportionAdapter;
    
    self.twoBGVIew.layer.masksToBounds = YES;
    self.twoBGVIew.layer.cornerRadius = 5.0;
    
    self.twoBGVIewRight.constant = 10 *ProportionAdapter;
    
    self.oneBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.twoBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.threeBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.fourBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
}

- (void)confgiTitleString{
    //Hole  Score
    [self.oneBtn setTitle:@"Hole"forState:UIControlStateNormal];
    [self.twoBtn setTitle:@"Score" forState:UIControlStateNormal];
    [self.threeBtn setTitle:@"Hole" forState:UIControlStateNormal];
    [self.fourBtn setTitle:@"Score" forState:UIControlStateNormal];
    
    [self.oneBtn setTitleColor:[UIColor colorWithHexString:@"#3AB152"] forState:UIControlStateNormal];
    [self.twoBtn setTitleColor:[UIColor colorWithHexString:@"#3AB152"] forState:UIControlStateNormal];
    [self.threeBtn setTitleColor:[UIColor colorWithHexString:@"#3AB152"] forState:UIControlStateNormal];
    [self.fourBtn setTitleColor:[UIColor colorWithHexString:@"#3AB152"] forState:UIControlStateNormal];
}

- (void)configIndex:(NSInteger)index andOneHoel:(NSInteger)oneHole andTwoHole:(NSInteger)twoHole{
    [self.oneBtn setTitle:[NSString stringWithFormat:@"0%td", index] forState:UIControlStateNormal];
    if (oneHole > 0) {
        [self.twoBtn setTitle:[NSString stringWithFormat:@"%td", oneHole] forState:UIControlStateNormal];
    }else{
        [self.twoBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self.threeBtn setTitle:[NSString stringWithFormat:@"%td", index+9] forState:UIControlStateNormal];
    if (twoHole >0) {
        [self.fourBtn setTitle:[NSString stringWithFormat:@"%td", twoHole] forState:UIControlStateNormal];
    }else{
        [self.fourBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    
    [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.twoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.fourBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

- (void)configViewBGColor:(NSInteger)selectHole{
    NSLog(@"selectHole == %td", selectHole);
    NSLog(@"oneBtn.tag  === %td", self.oneBtn.tag - 100);
    NSLog(@"threeBtn.tag  === %td", self.threeBtn.tag/3 - 100);
    if (self.oneBtn.tag - 100 -2 == selectHole) {
        self.oneBGView.backgroundColor = [UIColor colorWithHexString:BG_color];
    }else{
        self.oneBGView.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.threeBtn.tag - 300 -2 == selectHole) {
        self.twoBGVIew.backgroundColor = [UIColor colorWithHexString:BG_color];
    }else{
        self.twoBGVIew.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectOneHole:sender];
    }
}
- (IBAction)twoBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectOneHole:sender];
    }
}
- (IBAction)threeBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectThreeHole:sender];
    }
}
- (IBAction)fourBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectThreeHole:sender];
    }
}



@end
