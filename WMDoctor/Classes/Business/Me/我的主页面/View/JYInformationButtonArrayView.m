//
//  JYInformationButtonArrayView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYInformationButtonArrayView.h"

@implementation JYInformationButtonArrayView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configUI {
    NSArray *titlearray = self.buttonTitlearray;
    
    int col = 3;
    
    int margin = pixelValue(20);
    
    for (int i = 0; i < titlearray.count; i++) {
        
        int page = i/col;
        
        int index = i%col;
        
        
        
        
        UIButton *BtnSearch = [[UIButton alloc]initWithFrame:CGRectMake(index * (UI_SCREEN_WIDTH - pixelValue(180) - (col + 1) * margin) / col + margin * index,pixelValue(80) * page + pixelValue(10),(UI_SCREEN_WIDTH - pixelValue(180) - (col + 1) * margin) / col,pixelValue(60) )];
        
        BtnSearch.backgroundColor = [UIColor whiteColor];
        
        [BtnSearch setImage:[UIImage imageNamed:@"information_btn_normal"] forState:UIControlStateNormal];
        [BtnSearch setImage:[UIImage imageNamed:@"information_btn_selected"] forState:UIControlStateSelected];
        
        BtnSearch.tag = i;
        
        [BtnSearch setTitle:titlearray[i] forState:UIControlStateNormal];
        
        [BtnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [BtnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        BtnSearch.titleLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
        
        [BtnSearch addTarget:self action:@selector(click_btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:BtnSearch];
        
        if (i == 0) {
            
            BtnSearch.backgroundColor = [UIColor whiteColor];
            
            BtnSearch.selected = YES;
            
            self.selectedButton = BtnSearch;
            
            
        }
    }
    
}

-(void)click_btnTouch:(UIButton *)Btn{
    if (!Btn.isSelected) {

        self.selectedButton.selected = !self.selectedButton.selected;

        Btn.selected = !Btn.selected;

        self.selectedButton = Btn;
    }
    
    if ([self.delegate respondsToSelector:@selector(btnSelectedWithView:tag:)]) {
        [self.delegate btnSelectedWithView:self tag:self.selectedButton.tag];
    }
}

@end
