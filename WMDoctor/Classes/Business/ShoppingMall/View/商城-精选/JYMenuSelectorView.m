//
//  JYMenuSelectorView.m
//  WMDoctor
//
//  Created by xugq on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMenuSelectorView.h"


@interface JYMenuSelectorView(){
    UIScrollView *_menuScrollView;
    UIButton *_selectedBtn;
}

@end

@implementation JYMenuSelectorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor colorWithHexString:@"#50B8FB"];
    _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width - 35, 44)];
    _menuScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_menuScrollView];
}



- (void)setMenuWithArr:(NSArray *)arr{
    float menuViewContnetWith = [self getMenuScrollViewConstentSizeWidthWithMenuArr:arr];
    _menuScrollView.contentSize = CGSizeMake(menuViewContnetWith, 35);
    for (int i = 0; i < arr.count; i ++) {
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        float menu_x = i * 98 + 13;
        float menu_w = [CommonUtil widthForLabelWithText:arr[i] height:15 font:[UIFont systemFontOfSize:15]];
        menuBtn.frame = CGRectMake(menu_x, 15, menu_w + 10, 15);
        [menuBtn setTitle:arr[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuBtn.tag = i;
        [menuBtn addTarget:self action:@selector(menuBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _selectedBtn = menuBtn;
            [menuBtn setTitleColor:[UIColor colorWithHexString:@"044F80"] forState:UIControlStateNormal];
        }
        [_menuScrollView addSubview:menuBtn];
    }
}

- (float)getMenuScrollViewConstentSizeWidthWithMenuArr:(NSArray *)menus{
    if (menus.count > 0) {
        return 98 * (menus.count - 1) + 43;
    }
    return 0;
}

- (void)menuBtnClickAction:(UIButton *)btn{
    NSLog(@"menu click");
    [_selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#044F80"] forState:UIControlStateNormal];
    _selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuSelectorViewClick:)]) {
        [self.delegate menuSelectorViewClick:btn.tag];
    }
}



@end
