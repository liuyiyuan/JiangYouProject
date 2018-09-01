//
//  JYMeAboutUsContentCollectionViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/9/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMeAboutUsContentCollectionViewController.h"

@interface JYMeAboutUsContentCollectionViewController ()

@property (nonatomic, strong) UILabel *aboutLabel;

@end

@implementation JYMeAboutUsContentCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.aboutLabel];
    
    [self.aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(20));
        make.left.mas_equalTo(pixelValue(10));
        make.right.mas_equalTo(-pixelValue(10));
    }];
 
}

-(UILabel *)aboutLabel{
    if(!_aboutLabel){
        _aboutLabel = [[UILabel alloc]init];
        _aboutLabel.numberOfLines = 0;
        _aboutLabel.text = @"    我们以服务本地企业和商户为宗旨，以满足用户需求为导向，打造本地遗留的媒体电商平台。江油全搜索APP集论坛，贴吧，同城信息于一体。关注江油本地资讯，了解身边大小事联系我们。\n\n客服电话：0816：3220058\n\n客服微信：Xcn-vx\n\n客服QQ:2384300692";
        _aboutLabel.textColor = [UIColor blackColor];
        _aboutLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
    }
    return _aboutLabel;
}
@end
