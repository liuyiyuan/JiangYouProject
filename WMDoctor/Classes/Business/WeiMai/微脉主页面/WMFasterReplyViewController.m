//
//  WMFasterReplyViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMFasterReplyViewController.h"
#import "WMFasterReplyCell.h"

@interface WMFasterReplyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}
@property(nonatomic,strong)NSMutableArray *dateSoureArr;

@end

@implementation WMFasterReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"快捷回复";
    [self setupData];
    [self setupView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    // Do any additional setup after loading the view.
}
-(void)setupData{
    self.dateSoureArr=[[NSMutableArray alloc]initWithObjects:@"感谢您对我的信任，希望我的回答能够帮助到您。如果对我的服务满意，请记得给好评哟~",@"不好意思，我需要暂时离开一会儿，请稍等片刻。",@"要按医嘱吃药，准时到我门诊复查，这对病情重要。",@"这个问题比较复杂，你最好来门诊做个检查比较好。",@"生活上一定要注意饮食、多运动，这对康复有好处。", nil];
    
    /*
     1、感谢您对我的信任，希望我的回答能够帮助到您。如果对我的服务满意，请记得给好评哟~
     2、不好意思，我需要暂时离开一会儿，请稍等片刻。
     3、要按医嘱吃药，准时到我门诊复查，这对病情重要。
     4、这个问题比较复杂，你最好来门诊做个检查比较好。
     5、生活上一定要注意饮食、多运动，这对康复有好处。
     */
}
- (void)setupView {
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView=[UIView new];
    
    //刷新
    
    
}
#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dateSoureArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WMFasterReplyCell *cell=(WMFasterReplyCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"WMFasterReplyCell" owner:self options:Nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //        paragraphStyle.lineHeightMultiple = 20.f;
    //        paragraphStyle.maximumLineHeight = 25.f;
    //        paragraphStyle.minimumLineHeight = 15.f;
    //        paragraphStyle.firstLineHeadIndent = 20.f;
    //        paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:2.f];
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16],
                                  NSParagraphStyleAttributeName:paragraphStyle,
                                  NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]
                                  };
    
    //Label获取attStr式样
    cell.detailLabel.attributedText = [[NSAttributedString alloc]initWithString:self.dateSoureArr[indexPath.row] attributes:attributes];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString *str=self.dateSoureArr[indexPath.row];
    //
    //    float  detailHeight=[UILabel heightForLabelWithText:str width:kScreen_width-50 font:[UIFont systemFontOfSize:16]];
    //    if (detailHeight<40) {
    //
    //        return 40;
    //
    //    }
    //    else {
    //
    //        return detailHeight+30;
    //    }
    
    return 70;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *messageStr=self.dateSoureArr[indexPath.row];
    RCTextMessage *testMessage=[RCTextMessage messageWithContent:messageStr];
    if (_conversationVC != nil) {
        [[RCIM sharedRCIM] sendMessage:_conversationVC.conversationType
                              targetId:_conversationVC.targetId
                               content:testMessage
                           pushContent:nil
                              pushData:nil
                               success:^(long messageId) {
                                   NSLog(@"发送成功。当前消息ID：%ld", messageId);
                               } error:^(RCErrorCode nErrorCode, long messageId) {
                                   NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                               }];
    } else{
        [[RCIM sharedRCIM] sendMessage:_groupConversationVC.conversationType
                              targetId:_groupConversationVC.targetId
                               content:testMessage
                           pushContent:nil
                              pushData:nil
                               success:^(long messageId) {
                                   NSLog(@"发送成功。当前消息ID：%ld", messageId);
                               } error:^(RCErrorCode nErrorCode, long messageId) {
                                   NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                               }];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
