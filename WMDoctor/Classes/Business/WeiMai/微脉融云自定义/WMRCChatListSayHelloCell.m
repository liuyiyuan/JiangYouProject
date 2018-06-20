//
//  WMRCChatListSayHelloCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCChatListSayHelloCell.h"
#define kbadageWidth 20
#define Kgap 5         //控件间的间隙
#define KTopGap 15      //距离上面的间隙
#define kRightGap 15     //左边的的间隙
#define KAvatarHeight 40 //头像高度
#define KBadgeHeight  20

@implementation WMRCChatListSayHelloCell

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
        //self.contentLabel.text=@"您收到了一条打招呼消息";
        [self.contentView addSubview:self.contentLabel];
        
        //时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width-200,self.nameLabel.frame.origin.y, 200-15,15)];
        self.timeLabel.textColor=[UIColor colorWithHexString:@"a7a7a7"];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.text=@"";
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        
        //角标
        
        self.sayHelloImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_width-15-20,42,KBadgeHeight ,KBadgeHeight)];
        self.sayHelloImageView.image=[UIImage imageNamed:@"打招呼标签"];
        [self.contentView addSubview:self.sayHelloImageView];
        //[self.ppBadgeView bringSubviewToFront:self];
        
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
-(void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
