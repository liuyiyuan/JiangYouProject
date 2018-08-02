//
//  WMNewHotQuestionView.m
//  Micropulse
//
//  Created by 王攀登 on 2018/3/22.
//  Copyright © 2018年 iChoice. All rights reserved.
//

#import "WMNewHotQuestionView.h"

#import <SDCycleScrollView.h>

#import "WMNewHotQuestionCell.h"


#define kSpace10 10.0f
#define kSpace15 15.0f
#define kSpace20 20.0f
@interface WMNewHotQuestionView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIImageView       *bgImgView;
@property (nonatomic, strong) UIImageView       *logoImgView;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) SDCycleScrollView *hotScrollView;
@property (nonatomic, copy)   NSArray           *hotArray;
@property (nonatomic, copy)   NSString          *hotQaNum;

@end

@implementation WMNewHotQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgImgView = [UIImageView new];
        [self addSubview:_bgImgView];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.frame = CGRectMake(11, 5, kScreen_width-2*11, 70.0f);
        UIImage *remenimage = [UIImage imageNamed:@"img_jinriremen"];
//        UIImage *newImage = [remenimage stretchableImageWithLeftCapWidth:remenimage.size.width*0.5 topCapHeight:remenimage.size.height*0.5];
        [_bgImgView setImage:remenimage];
//        [_bgImgView setClipsToBounds:YES];
//        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        _logoImgView = [UIImageView new];
        [_bgImgView addSubview:_logoImgView];
        _logoImgView.frame = CGRectMake(kSpace15+4, 15.0f, 38.0f, 38.0f);
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E1E2E3"];
        [_bgImgView addSubview:_lineView];
        _lineView.frame = CGRectMake(CGRectGetMaxX(_logoImgView.frame)+kSpace15, 15.0f, 0.5f, 38.0f);
        
        CGRect scrollFrame  = CGRectMake(CGRectGetMaxX(_logoImgView.frame)+2*kSpace10, 13.0f,kScreen_width-2*kSpace15-kSpace15-38-kSpace10*2, 40.0f);
        _hotScrollView     = [SDCycleScrollView cycleScrollViewWithFrame:scrollFrame delegate:self placeholderImage:nil];
        _hotScrollView.scrollDirection        = UICollectionViewScrollDirectionVertical;
        _hotScrollView.pageControlStyle       = SDCycleScrollViewPageContolStyleNone;
        _hotScrollView.autoScrollTimeInterval = 3.0f;
//        [_hotScrollView disableScrollGesture];
        _hotScrollView.delegate        = self;
        _hotScrollView.backgroundColor = [UIColor clearColor];
        [_bgImgView addSubview:_hotScrollView];
    }
    return self;
}

- (void)configHotIcon:(NSString *)iconUrl qaNum:(NSString *)qaNum hotArray:(NSMutableArray *)hotArray {
    self.hotQaNum = qaNum;
    self.hotArray = [NSArray arrayWithArray:hotArray];
    [_logoImgView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"ic_jinriremen"]];
    if (self.hotArray.count > 0) {
        _hotScrollView.localizationImageNamesGroup = self.hotArray;
    }
}

#pragma mark ============= SDScollViewDelegate ==============

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != _hotScrollView) {
        return nil;
    }
    return [WMNewHotQuestionCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    WMNewHotQuestionCell *myCell = (WMNewHotQuestionCell *)cell;
    WMNewHotQuestionModel *model = self.hotArray[index];
    if ([model.type integerValue] == 2) {
        myCell.isHotQa = YES;
        [myCell configHotQaNum:self.hotQaNum content:model.qaContent];
    }else {
        myCell.isHotQa = NO;
        [myCell configHotTopContent:model.topNewsContent bottomContent:model.bottomNewsContent];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WMNewHotQuestionModel *model = self.hotArray[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wmNewHotQuestionViewClickWithModel:)]) {
        [self.delegate wmNewHotQuestionViewClickWithModel:model];
    }
}



@end
