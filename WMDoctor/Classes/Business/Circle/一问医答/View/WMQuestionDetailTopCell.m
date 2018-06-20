//
//  WMQuestionDetailTopCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionDetailTopCell.h"
#include <CoreText/CTFont.h>
#include <CoreText/CTStringAttributes.h>
#include <CoreText/CTFramesetter.h>

@implementation WMQuestionDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelHiddeView.hidden = YES;
    
    _labelHiddeView.userInteractionEnabled = YES;
    [_labelHiddeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMore)]];
    
    _labelHideImage.userInteractionEnabled = YES;
    [_labelHideImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMore)]];
    
//    _labelHiddeView.backgroundColor = [UIColor blueColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellValue:(WMQuestionDetailInfoModel *)model andFlag:(BOOL)flag{
    
    [_picView removeFromSuperview];
    _picView = nil;
    _picView.delegate = nil;
//    _textHideFlag = flag;
    _dataArr = model.pritureIndexs;
    if ([model.state isEqualToString:@"1"] || [model.state isEqualToString:@"5"]) {        //待解答
        self.questionLabel.text = model.content;
//        CGFloat labelheight = [CommonUtil heightForLabelWithText:model.content width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
//        self.QuestionHeight.constant = 51 + labelheight;
        
        self.questionLabel.text = model.content;
        CGFloat labelheight = [CommonUtil heightForLabelWithText:self.questionLabel.text width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
        self.QuestionHeight.constant = 51 + labelheight;
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
//        self.timeLabel.text = model.remainingTime;
        self.timeLabel.text = @"请在下方输入回答";
        self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        float picHeight = 0;
        
        if (!_picView) {
            if (model.pritureIndexs.count > 4) {
                picHeight = 200;
            }else{
                picHeight = 100;
            }
            //适配大屏幕
            if (kScreen_width > 380) {
                picHeight += 20;
            }
            _picView = [[WMNewPictureSelectView alloc]initWithFrame:CGRectMake(0, self.QuestionHeight.constant, kScreen_width, picHeight) withArray:_dataArr withWideHighScale:1.0 withShowType:ShowPictureType];
            _picView.delegate = self;
        }
        
        
        //计算行数
        NSArray * linesArr = [self getSeparatedLinesFromLabel:self.questionLabel.text andFont:self.questionLabel.font andRect:self.questionLabel.frame];
        
        //        NSLog(@"行数是%lu",(unsigned long)[self getSeparatedLinesFromLabel:@"刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1" andFont:self.questionLabel.font andRect:self.questionLabel.frame].count);
        //        NSLog(@"hangshushi:%ld",(long)self.questionLabel.numberOfLines);
        if (linesArr.count>4) {
            
            if (!flag) {
                self.labelHideImage.image = [UIImage imageNamed:@"ic_zhankai"];
                self.questionLabel.numberOfLines = 4;
                self.QuestionHeight.constant = 77.f + 51.f;
                
            }else{
                self.labelHideImage.image = [UIImage imageNamed:@"ic_shouqi"];
                self.questionLabel.numberOfLines = 0;
                CGFloat labelheight = [CommonUtil heightForLabelWithText:self.questionLabel.text width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
                self.QuestionHeight.constant = 51 + labelheight;
            }
            _textHideFlag = flag;
            //
            //            self.questionLabel.numberOfLines = 4;
            //            self.QuestionHeight.constant = 77.f + 51.f;
            self.labelHiddeView.hidden = NO;
            //            self.labelHideImage.image = [UIImage imageNamed:@"ic_zhankai"];
            
            _picView.frame = CGRectMake(0, self.QuestionHeight.constant + 40, kScreen_width, picHeight);
            
        }
        
        
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
//        self.timeLabel.text = model.remainingTime;
        self.timeLabel.text = @"请在下方输入回答";
//        WMNewPictureSelectView * picView = [[WMNewPictureSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 100) withArray:_dataArr withWideHighScale:1.0 withShowType:ShowPictureType];
//        picView.delegate = self;
        if (model.pritureIndexs.count >= 1) {
            [self addSubview:_picView];
        }
        
//    }else if([model.state isEqualToString:@"2"]){   //被抢答
        
    }else if([model.state isEqualToString:@"3"] || [model.state isEqualToString:@"2"]){   //已解答 或 被抢答
        self.questionLabel.text = model.content;
        CGFloat labelheight = [CommonUtil heightForLabelWithText:self.questionLabel.text width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
        self.QuestionHeight.constant = 51 + labelheight;
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
//        self.timeLabel.text = [NSString stringWithFormat:@"剩余时间%@小时",model.remainingTime];
        self.timeLabel.text = @"请在下方输入回答";
        self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        float picHeight = 0;
        if (!_picView) {
            if (model.pritureIndexs.count > 4) {
                picHeight = 200;
            }else{
                picHeight = 100;
            }
            
            //适配大屏幕
            if (kScreen_width > 380) {
                picHeight += 20;
            }
            
            _picView = [[WMNewPictureSelectView alloc]initWithFrame:CGRectMake(0, self.QuestionHeight.constant, kScreen_width, picHeight) withArray:_dataArr withWideHighScale:1.0 withShowType:ShowPictureType];
            
        }
        _picView.delegate = self;
        NSLog(@"_picView========%@",_picView);
        
        //计算行数
        NSArray * linesArr = [self getSeparatedLinesFromLabel:self.questionLabel.text andFont:self.questionLabel.font andRect:self.questionLabel.frame];
    
//        NSLog(@"行数是%lu",(unsigned long)[self getSeparatedLinesFromLabel:@"刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1刷卡机来说宽带就离开见识到了刷卡机来说宽带1" andFont:self.questionLabel.font andRect:self.questionLabel.frame].count);
//        NSLog(@"hangshushi:%ld",(long)self.questionLabel.numberOfLines);
        if (linesArr.count>4) {
            
            if (!flag) {
                self.labelHideImage.image = [UIImage imageNamed:@"ic_zhankai"];
                self.questionLabel.numberOfLines = 4;
                self.QuestionHeight.constant = 77.f + 51.f;
                
            }else{
                self.labelHideImage.image = [UIImage imageNamed:@"ic_shouqi"];
                self.questionLabel.numberOfLines = 0;
                CGFloat labelheight = [CommonUtil heightForLabelWithText:self.questionLabel.text width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
                self.QuestionHeight.constant = 51 + labelheight;
            }
            _textHideFlag = flag;
            //
//            self.questionLabel.numberOfLines = 4;
//            self.QuestionHeight.constant = 77.f + 51.f;
            self.labelHiddeView.hidden = NO;
//            self.labelHideImage.image = [UIImage imageNamed:@"ic_zhankai"];
            
            _picView.frame = CGRectMake(0, self.QuestionHeight.constant + 40, kScreen_width, picHeight);
            
        }
        
        self.timeViewHeight.constant = 10;
        self.timeLabel.hidden = YES;
        
        
        //
        if (model.pritureIndexs.count >= 1) {
            [self addSubview:_picView];
        }
    }else if([model.state isEqualToString:@"4"]){   //已关闭
        
    }
    
    
}

//展开收起
- (void)openMore{
    if (!_textHideFlag) {
        self.labelHideImage.image = [UIImage imageNamed:@"ic_shouqi"];
        _textHideFlag = true;
        self.questionLabel.numberOfLines = 0;
        CGFloat labelheight = [CommonUtil heightForLabelWithText:self.questionLabel.text width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
        self.QuestionHeight.constant = 51 + labelheight;
    }else{
        self.labelHideImage.image = [UIImage imageNamed:@"ic_zhankai"];
        _textHideFlag = false;
        self.questionLabel.numberOfLines = 4;
        self.QuestionHeight.constant = 77.f + 51.f;
    }
    NSLog(@"高度是=============%.f",self.QuestionHeight.constant);
    
    _picView.frame = CGRectMake(0, self.QuestionHeight.constant + 40, kScreen_width, _picView.frame.size.height);
    //触发代理改变外部cell高度
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeightChange:)]) {
        [self.delegate cellHeightChange:_textHideFlag];
    }
}

-(NSArray *)getSeparatedLinesFromLabel:(NSString *)thetext andFont:(UIFont *)thefont andRect:(CGRect )therect {
    
    NSString *text = thetext;
    
    UIFont *font = thefont;
    
    CGRect rect = therect;
    
    
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    
    
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    
    
    for (id line in lines)
        
    {
        
        CTLineRef lineRef = (__bridge CTLineRef )line;
        
        CFRange lineRange = CTLineGetStringRange(lineRef);
        
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        
        
        NSString *lineString = [text substringWithRange:range];
        
        [linesArray addObject:lineString];
        
    }
    
    return (NSArray *)linesArray;
    
}

-(void)previewPictureWithTag:(NSInteger )tag withShowType:(PictureShowType) showType{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPreviewPictureWithTag: withShowType:)]) {
        [self.delegate cellPreviewPictureWithTag:tag withShowType:showType];
    }

    
}

@end
