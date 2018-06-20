//
//  ACOGLayout.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/21.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "ACOGLayout.h"

@interface ACOGLayout ()

@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *attributes;

@end


@implementation ACOGLayout


//懒加载数组
- (NSArray<UICollectionViewLayoutAttributes *> *)attributes
{
    if (_attributes == nil) {
        
        _attributes = [NSArray array];
    }
    
    return _attributes;
}


- (void)prepareLayout{
    
    [super prepareLayout];
    
    NSInteger count = 25;
    
    
    
    
    //创建临时数组 盛放布局属性
    NSMutableArray *tempAtt = [NSMutableArray array];
    
    //进行for  次数为 cell的个数  创建 att对象  并且放在对应的数组里面
    for (int i = 0; i < count; i ++) {
        
        
        int index = i ;
        
        //计算每一个cell的布局
        
        CGFloat itemW = 0.0;
        CGFloat itemH = 0.0;
        CGFloat itemX = 0.0;
        CGFloat itemY = 0.0;
        
        switch (index) {
            case 0:
                itemX = 1;
                itemY = 1;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 80;
                break;
            case 1:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 1;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 80;
                break;
            case 2:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3 -10;
                itemY = 1;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 80;
                break;
            case 3:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *3 +4 ;
                itemY = 1;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 375+5+10;
                break;
            case 4:
                itemX = 1;
                itemY = 82;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 80+10;
                
                break;
                
            case 5:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 82;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 80+10;
                break;
            case 6:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3-10;
                itemY = 82;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 80+10;
                break;
            case 7:
                itemX = 1;
                itemY = 80 *2 +3+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 45;
                break;
            case 8:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 80 *2 +3+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 45;
                break;
            case 9:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3-10;
                itemY = 80 *2 +3+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 45;
                
                break;
            case 10:
                itemX = 1;
                itemY = 80 *2 +45 +4+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 170+2;
                break;
            case 11:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 80 *2 +45 +4+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 45;
                
                break;
            case 12:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3-10;
                itemY = 80 *2 + 45 +4+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 45;
                break;
            case 13:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 80 *2 +45*2 +5+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 80;
                
                break;
            case 14:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3-10;
                itemY = 80 *2 +45*2 +5+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 80;
                
                break;
            case 15:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 80 * 3 + 45*2 +6;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 45+10;
                break;
                
                
            case 16:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3-10;
                itemY = 80 * 3 + 45*2 +6+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 45;
                break;
            case 17:
                itemX = 1;
                itemY = 80 *3  +45*3+7+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 45;
                break;
            case 18:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 80 *3  +45*3 +7+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4+ (UI_SCREEN_WIDTH - 5)/4 +1;
                itemH = 45;
                break;
            case 19:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3;
                itemY = 80 *3  +45*3 +7+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4 ;
                itemH = 0;
                break;
            case 20:
                itemX = (UI_SCREEN_WIDTH - 5)/4 * 3 +4;
                itemY = 80 *3  +45*3 +7+10;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 45;
                break;
            case 21:
                itemX = 1;
                itemY = 80 *3  +45*4 +8 +10;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 45;
                break;
            case 22:
                itemX = (UI_SCREEN_WIDTH - 5)/4 +2;
                itemY = 80 *3  +45*4 +8+10 ;
                itemW = (UI_SCREEN_WIDTH - 5)/4-10;
                itemH = 45;
                break;
            case 23:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *2 +3-10;
                itemY = 80 *3  +45*4 +8 +10;
                itemW = (UI_SCREEN_WIDTH - 5)/4+10;
                itemH = 45;
                break;
                
            case 24:
                itemX = (UI_SCREEN_WIDTH - 5)/4 *3 +4;
                itemY = 80 *3  +45*4 +8 +10;
                itemW = (UI_SCREEN_WIDTH - 5)/4;
                itemH = 45;
                break;
                
            default:
                break;
        }
        
        
        //创建布局属性 设置对应cell的frame
        UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        att.frame = CGRectMake(itemX , itemY , itemW, itemH);
        
        [tempAtt addObject:att];
        
    }
    
    self.attributes = [tempAtt copy];
    
    self.itemSize =CGSizeMake((UI_SCREEN_WIDTH - 5)/4, 68);
    
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.attributes;
}

@end
