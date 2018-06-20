//
//  WMRCChatListCell.m
//  Micropulse
//
//  Created by 茭白 on 16/9/11.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMRCChatListCell.h"
#define kbadageWidth 20
#define Kgap 5         //控件间的间隙
#define KTopGap 15      //距离上面的间隙
#define kRightGap 15     //左边的的间隙
#define KAvatarHeight 40 //头像高度
#define KBadgeHeight  20
@implementation WMRCChatListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self setSeparatorInset:UIEdgeInsetsMake(0,80,0,0)];
        //头像
        self.avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(kRightGap, 20, KAvatarHeight, KAvatarHeight)];
        self.avatarImage.contentMode=UIViewContentModeScaleAspectFill;
        self.avatarImage.clipsToBounds = YES;
        self.avatarImage.layer.cornerRadius = 20;
        self.avatarImage.image = [UIImage imageNamed:@"wm_message_news"];
        [self.contentView addSubview:self.avatarImage];
        
        self.flogImageView.hidden=YES;
        self.flogImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_width-15, 0, KTopGap, KTopGap)];
        self.flogImageView.contentMode=UIViewContentModeScaleAspectFill;
        self.flogImageView.image = [UIImage imageNamed:@"wm_homepage_mess_topsign"];
        [self.contentView addSubview:self.flogImageView];
        
        
        
        //realName
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImage.frame.origin.x+self.avatarImage.frame.size.width+kRightGap, KTopGap+5,150, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor=[UIColor colorWithHexString:@"1a1a1a"];
        self.nameLabel.text=@"微脉家庭医生";
        [self.contentView addSubview:self.nameLabel];
        
        //vip标签
        self.vipTag = [[UIImageView alloc] initWithFrame:CGRectMake(150 + kRightGap, 1, 30, 18)];
        self.vipTag.image = [UIImage imageNamed:@"vipTag"];
        self.vipTag.hidden = YES;
//        [self.nameLabel addSubview:self.vipTag];
        
        self.tagView = [[UIView alloc] initWithFrame:CGRectMake(150 + kRightGap, 1, 30, 18)];
        self.tagView.hidden = YES;
        [self.nameLabel addSubview:self.tagView];
        
        /*医生职位
        self.doctorPositionLable=[[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+kgap, self.nameLabel.frame.origin.y, 100, self.nameLabel.frame.size.height)];
        self.doctorPositionLable.font=[UIFont systemFontOfSize:14];
        self.doctorPositionLable.textAlignment=NSTextAlignmentLeft;
        self.doctorPositionLable.text=@"主治医生";
        [self.contentView addSubview:self.doctorPositionLable];
        */
        
        //内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x,self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+Kgap, kScreen_width-self.nameLabel.frame.origin.x-15-20, 15)];
        //加评论按钮的CGRectMake(self.nameLabel.frame.origin.x,self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+Kgap, kScreen_width-self.nameLabel.frame.origin.x-90, 15)
        self.contentLabel.textColor=[UIColor colorWithHexString:@"a7a7a7"];
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        self.contentLabel.text=@"您的健康是我们最大的心愿";
        [self.contentView addSubview:self.contentLabel];

        //时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width-200,self.nameLabel.frame.origin.y, 200-15,15)];
        self.timeLabel.textColor=[UIColor colorWithHexString:@"a7a7a7"];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.text=@"";
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        
        //角标
        self.ppBadgeView = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width-15-20,42,KBadgeHeight ,KBadgeHeight)];
        self.ppBadgeView.font = [UIFont systemFontOfSize:12.0];
        self.ppBadgeView.layer.cornerRadius=KBadgeHeight*0.5;
        self.ppBadgeView.textColor=[UIColor colorWithHexString:@"ffffff"];
        self.ppBadgeView.layer.masksToBounds=YES;
        self.ppBadgeView.textAlignment=NSTextAlignmentCenter;
        if ([self.ppBadgeView.text intValue]>0) {
            self.ppBadgeView.backgroundColor=[UIColor colorWithHexString:@"255555"];
            
        }else
        {
            self.ppBadgeView.backgroundColor=[UIColor clearColor];
        }
        
        [self.contentView addSubview:self.ppBadgeView];
        [self.ppBadgeView bringSubviewToFront:self];
        
        //评价按钮
        /*
        self.commentButton=[[WMBlueButton alloc]initWithFrame:CGRectMake(kScreen_width-75, 35, 60, 20)];
        [self.commentButton wmButtonWithTitle:@"去评价"];
        [self.commentButton wmButtonWithRounded:2];
        self.commentButton.titleLabel.font=[UIFont systemFontOfSize:14];
        //[self.advisoryButton addTarget:self action:@selector(advisoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.commentButton];
        */
    }
    return self;
}

- (void)setTagViewWithUserInfo:(RCUserInfo *)user{
    float tagLabRight = 0;
    NSString *allTagsStr = @"";
    for (NSString *tagStr in user.tagNames) {
        float tagLabWidth = [CommonUtil widthForLabelWithText:tagStr height:16 font:[UIFont systemFontOfSize:11]];
        UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(tagLabRight, 0, tagLabWidth + 10, 18)];
        tagLab.text = tagStr;
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.backgroundColor = [UIColor colorWithHexString:@"FFA800"];
        tagLab.textColor = [UIColor whiteColor];
        tagLab.font = [UIFont systemFontOfSize:11];
        tagLab.layer.masksToBounds = YES;
        tagLab.layer.cornerRadius = 9;
        [self.tagView addSubview:tagLab];
        tagLabRight = tagLabRight + tagLabWidth + 10 + 6;
        allTagsStr = [allTagsStr stringByAppendingString:tagStr];
    }
    NSLog(@"username : %@", user.name);
    NSLog(@"usertag : %@", user.tagNames);
    if (user.tagNames.count > 0 && !stringIsEmpty(allTagsStr)) {
        self.tagView.hidden = NO;
        self.tagView.frame = CGRectMake([CommonUtil widthForLabelWithText:user.name height:20 font:[UIFont systemFontOfSize:16]] + 10, 1, 30, 18);
    } else{
        self.tagView.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
