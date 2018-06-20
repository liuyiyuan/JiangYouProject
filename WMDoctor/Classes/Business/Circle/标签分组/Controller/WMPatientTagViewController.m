//
//  WMPatientTagViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/6/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMPatientTagViewController.h"
#import "WMTagGroupGetAPIManager.h"
#import "WMTagSelectModel.h"
#import "WMTagGroupSaveAPIManager.h"
#import "WMQAQuestionLabelsView.h"
#import "NSArray+Additions.h"

@interface WMPatientTagViewController ()<WMQAQuestionLabelsDelegate>{
    WMTagSelectModel * _allModel;
    WMTagModelCustom * _customModel;
}

@property (nonatomic, strong) UIButton *leftBarBtn;
@property (nonatomic, strong) UIButton *rightBarBtn;
@property(nonatomic, strong) WMQAQuestionLabelsView *questionLabelsView;
@property(nonatomic, strong) WMQAQuestionLabelsView *selectTagLabelsView;
@property(nonatomic, strong) NSString *textFieldStr;
@property(nonatomic, strong) NSMutableArray<WMPatientTagModel> *saveTags;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation WMPatientTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavBar];
    [self initView];
    [self loadData];
}

- (void)initData{
    self.textFieldStr = @"";
    self.saveTags = [NSMutableArray new];
}

- (void)initView{
    [self.view addSubview:self.selectTagLabelsView];
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.questionLabelsView];
}

- (void)initNavBar{
    
    self.title = @"标签分组";
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    [self.leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBarBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBarBtn addTarget:self action:@selector(leftBarBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
    
    //保存按钮
    self.rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    [self.rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBarBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.rightBarBtn.titleLabel.alpha = 0.5;
    self.rightBarBtn.userInteractionEnabled = NO;
    [self.rightBarBtn addTarget:self action:@selector(goSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

- (WMQAQuestionLabelsView *)selectTagLabelsView{
    if (!_selectTagLabelsView) {
        _selectTagLabelsView = [[WMQAQuestionLabelsView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 0.01)];
        [_selectTagLabelsView setLabelSizeWidth:21 height:11 showTitle:NO];
        _selectTagLabelsView.delegate = self;
    }
    return _selectTagLabelsView;
}

- (WMQAQuestionLabelsView *)questionLabelsView{
    if (!_questionLabelsView) {
        _questionLabelsView = [[WMQAQuestionLabelsView alloc] initWithFrame:CGRectMake(0, _selectTagLabelsView.bottom + 50, kScreen_width, 0.01)];
        [_questionLabelsView setLabelSizeWidth:21 height:11 showTitle:YES];
        _questionLabelsView.delegate = self;
    }
    return _questionLabelsView;
}

- (void)questionLabelsDidTapLabel:(UILabel *)label labelsView:(id)labelsView{
    
    if (labelsView == _selectTagLabelsView) {
        
        if ([[NSArray getTagNames:_allModel.allTags] containsObject:label.text]) {
            //固定标签
            [self deleteTagFromSelectedTags:_allModel.patientTags withTagName:label.text];
            [self setTagFlagWithTagName:label.text andFlag:@"1"];
            
        } else{
            //新增标签
            [self deleteTagFromSelectedTags:_allModel.patientTags withTagName:label.text];
            [self deleteTagFromSelectedTags:self.saveTags withTagName:label.text];
        }
        
    } else{
        
        if ([[NSArray getTagNames:self.saveTags] containsObject:label.text]) {
            //这个标签已经加过
            [self deleteTagFromSelectedTags:self.saveTags withTagName:label.text];
            [self deleteTagFromSelectedTags:_allModel.patientTags withTagName:label.text];
        } else{
            [self addTagToTags:self.saveTags andTagName:label.text andFlag:@"2"];
            [self addTagFromAllTagsToSelectedTagsWithTagName:label.text];
        }
    }
    
    [self setTagLabelsViewValueAndUpdataFrame];
    [self hiddenOrShowBarBtn];
}

- (void)deleteTagFromSelectedTags:(NSMutableArray *)selectedTags withTagName:(NSString *)tagName{
    [self setTagFlagWithTagName:tagName andFlag:@"1"];
    for (WMPatientTagModel *tag in selectedTags) {
        if ([tag.tagName isEqualToString:tagName]) {
            [selectedTags removeObject:tag];
            return;
        }
    }
}

- (void)addTagFromAllTagsToSelectedTagsWithTagName:(NSString *)tagName{
    [self setTagFlagWithTagName:tagName andFlag:@"2"];
    for (WMPatientTagModel *tag in _allModel.allTags) {
        if ([tag.tagName isEqualToString:tagName]) {
            [_allModel.patientTags addObject:tag];
            return;
        }
    }
}

- (void)addTagToTags:(NSMutableArray *)tags andTagName:(NSString *)tagName andFlag:(NSString *)flag{
    if ([[NSArray getTagNames:tags] containsObject:tagName]) {
        return;
    }
    WMPatientTagModel *tag = [[WMPatientTagModel alloc] init];
    tag.tagName = tagName;
    tag.flag = flag;
    [tags addObject:tag];
}

- (void)setTagFlagWithTagName:(NSString *)tagName andFlag:(NSString *)flag{

    for (WMPatientTagModel *tag in self.saveTags) {
        if ([tag.tagName isEqualToString:tagName]) {
            tag.flag = flag;
            return;
        }
    }
}

- (void)setTagLabelsViewValueAndUpdataFrame{
    [self.selectTagLabelsView setValueWithSelectedTagsArr:_allModel.patientTags];
    [self.questionLabelsView setValueWithAllTagsArr:_allModel.allTags andSelectedTagsArr:_allModel.patientTags];
    self.selectTagLabelsView.frame = CGRectMake(0, 0, kScreen_width, _selectTagLabelsView.viewHeight);
    [self setAllTagsViewFrame];
}

- (void)setAllTagsViewFrame{
    if (_questionLabelsView.viewHeight > kScreen_height - self.selectTagLabelsView.bottom) {
        self.scrollView.frame = CGRectMake(0, self.selectTagLabelsView.bottom, kScreen_width, kScreen_height - self.selectTagLabelsView.bottom);
        self.scrollView.contentSize = CGSizeMake(kScreen_width, _questionLabelsView.viewHeight + 60);
        self.questionLabelsView.frame = CGRectMake(0, 0, kScreen_width, _questionLabelsView.viewHeight);
        self.scrollView.scrollEnabled = YES;
    } else{
        self.scrollView.frame = CGRectMake(0, self.selectTagLabelsView.bottom, kScreen_width, kScreen_height - self.selectTagLabelsView.bottom);
        self.questionLabelsView.frame = CGRectMake(0, 0, kScreen_width, _questionLabelsView.viewHeight);
        self.scrollView.scrollEnabled = NO;
    }
}

- (void)textFieldDidChanged:(NSString *)text{
    NSLog(@"text : %@", text);
    self.textFieldStr = text;
    [self hiddenOrShowBarBtn];
}

- (void)keyboardWillHidden:(UITextField *)textField{
    if ([[NSArray getTagNames:self.saveTags] containsObject:textField.text]) {
        [WMHUDUntil showMessage:@"该标签已存在" toView:self.view];
        textField.text = @"";
    } else{
        
        [self addTagToTags:self.saveTags andTagName:textField.text andFlag:@"2"];
        [self addTagToTags:_allModel.patientTags andTagName:textField.text andFlag:@"2"];
        
        [_selectTagLabelsView setValueWithSelectedTagsArr:_allModel.patientTags];
        self.selectTagLabelsView.frame = CGRectMake(0, 0, kScreen_width, _selectTagLabelsView.viewHeight);
        [self setAllTagsViewFrame];
    }
    self.textFieldStr = @"";
}

- (void)loadData{
    WMTagGroupGetAPIManager * apiManager = [WMTagGroupGetAPIManager new];
    NSDictionary *param = @{
                            @"weimaihao" : self.weimaihao
                            };
    [apiManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _allModel = [[WMTagSelectModel alloc]initWithDictionary:responseObject error:nil];
        [self.saveTags addObjectsFromArray:_allModel.patientTags];
        [self setTagLabelsViewValueAndUpdataFrame];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

- (void)goSave{
    
    if (!stringIsEmpty(self.textFieldStr)) {
        
        if (![[NSArray getTagNames:self.saveTags] containsObject:self.textFieldStr]) {
            [self addTagToTags:self.saveTags andTagName:self.textFieldStr andFlag:@"2"];
            [self addTagToTags:_allModel.patientTags andTagName:self.textFieldStr andFlag:@"2"];
        }
    }
    
    WMTagGroupSaveAPIManager * apiManager = [WMTagGroupSaveAPIManager new];
    _customModel = [[WMTagModelCustom alloc]init];
    
    _customModel.patientTags = self.saveTags;
    _customModel.weimaihao = self.weimaihao;
    [apiManager loadDataWithParams:_customModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"save tag responseObject : %@", responseObject);
        self.patientData.tags = _allModel.patientTags;
        [self.navigationController popViewControllerAnimated:YES];
    } withFailure:^(ResponseResult *errorResult) {
        if (!stringIsEmpty(self.textFieldStr)) {
            [self.saveTags removeLastObject];
            [_allModel.patientTags removeLastObject];
        }
    }];
}

- (void)leftBarBtnClickAction{
    [self remindAgainToReturn];
}

- (void)hiddenOrShowBarBtn{
    if (!stringIsEmpty(self.textFieldStr) || [NSArray getTagNames:self.patientData.tags] != [NSArray getTagNames:_allModel.patientTags]) {
        self.rightBarBtn.titleLabel.alpha = 1;
        self.rightBarBtn.userInteractionEnabled = YES;
    } else{
        self.rightBarBtn.titleLabel.alpha = 0.5;
        self.rightBarBtn.userInteractionEnabled = NO;
    }
}

- (void)remindAgainToReturn{
    if (!stringIsEmpty(self.textFieldStr) || ![[NSArray getTagNames:self.patientData.tags] isEqualToArray:[NSArray getTagNames:_allModel.patientTags]]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃本次修改" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
