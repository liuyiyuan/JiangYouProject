//
//  WMCertificationViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCertificationViewController.h"
#import "WMCertificationTextTableViewCell.h"
#import "WMCertificationExampleCell.h"
#import "WMCertificationPictureCell.h"
#import "ZYQAssetPickerController.h"
#import <UIKit/UIKit.h>
#import "BlockUI.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "WMCertificationAPIManager.h"
#import "WMCertificationSucViewController.h"
#import "NSString+IDCardVerify.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
@import Photos;
@import AssetsLibrary;
#define IMAGESIZE_M 1024*1024
@interface WMCertificationViewController ()<UITableViewDelegate,UITableViewDataSource,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,WMCertificationPictureCellDelegate,UITextFieldDelegate>
{
     UITableView *_tableView;
}
@property (nonatomic ,strong)UIButton *sureButton;
@property (nonatomic,assign)int SupportNumber;
@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,strong)UITextField *idcardTextField;
@property (nonatomic,strong)UIView *sureView;
@end

@implementation WMCertificationViewController

- (void)viewDidLoad {
    if (_isFirstLogin==YES) {
       self.fd_interactivePopDisabled = YES;
    }
    [super viewDidLoad];
    self.title=@"实名认证";
    if (_isFirstLogin==YES) {
    [self setClearBarButtonItems];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage new] style:UIBarButtonItemStylePlain target:self action:nil];
    }
    self.photos=[[NSMutableArray alloc]initWithCapacity:0];
    [self setupView];
    // Do any additional setup after loading the view.
}
-(void)setupView{
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView=[[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 0, kScreen_width, kScreen_height-SafeAreaTopHeight);
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset=UIEdgeInsetsMake(0,0,0,0);
    [self.view addSubview:_tableView];
    
    _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame=CGRectMake(0, kScreen_height-SafeAreaTopHeight-49, kScreen_width, 49);
    [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
    
    _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
    [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    
    _sureButton.enabled=NO;
    [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.layer.masksToBounds=YES;
    [self.view addSubview:_sureButton];
    
    
    
    
    
}
#pragma mark--清除功能按钮
-(void)setClearBarButtonItems
{
    
     UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:[self sureView]];
    
    buttonItem.width=50;
    self.navigationItem.rightBarButtonItems = @[buttonItem];
    
}

-(UIView *)sureView{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, 50, 40);
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(0, 0, 50, 40);
    label.textColor=[UIColor whiteColor];
    label.text=@"跳过";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    [view addGestureRecognizer:PrivateLetterTap];
    return view;
}
-(void)jumpAction: (UITapGestureRecognizer *)gesture
{
    
    
     [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInSuccessNotification
     object:nil
     userInfo:@{@"EnterType":@"CheckEnter"}];
     

    NSLog(@"hahahha");
    
}


-(void)sureAction:(UIButton *)button{
    
    
    //WMCertificationPictureCell *certificationPictureCell =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //NSString *idcardStr=certificationPictureCell.identityCardField.text;
    
    
    if (![_idcardTextField.text isEqualToString:@""] && ![NSString validateIDCardNumber:_idcardTextField.text]) {
        [WMHUDUntil showMessageToWindow:@"身份证号码有误,请检查!"];
        return;
        
    }
    
    
    WMCertificationAPIManager * certificationAPIManager=[[ WMCertificationAPIManager alloc] init];
    
    [certificationAPIManager setFormDataBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data=[self imageConversionDateWithImage:[self.photos firstObject]];
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    
    }];
    
    NSDictionary *paramDic=[[NSDictionary alloc] initWithObjectsAndKeys:_idcardTextField.text,@"idcard", nil];
    
    [certificationAPIManager loadDataWithParams:paramDic withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        
        loginModel.certStatus=@"1";
        if (self.save_model) {
            self.save_model.certificationStatus = @"1"; //大渺
        }
        if (self.service_model) {
            self.service_model.certificationStatus = @"1"; //大渺
        }
        
        [WMLoginCache setDiskLoginModel:loginModel];
        [WMLoginCache setMemoryLoginModel:loginModel];
        NSString *certificationFail=[NSString stringWithFormat:@"certificationFail%@",loginModel.phone];
        
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:certificationFail];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSLog(@"responseObject=%@",responseObject);
        WMCertificationSucViewController *certificationSucVC=[[WMCertificationSucViewController alloc] init];
        certificationSucVC.isFirstLogin=self.isFirstLogin;
        [self.navigationController pushViewController:certificationSucVC animated:YES];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"responseObject=%@",errorResult);

    }];
    
      
}



-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section==0) {
        WMCertificationTextTableViewCell *certificationTextCell=(WMCertificationTextTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!certificationTextCell) {
            certificationTextCell=[[[NSBundle mainBundle]loadNibNamed:@"WMCertificationTextTableViewCell" owner:self options:Nil] lastObject];
        }
        certificationTextCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return certificationTextCell;

    }
    else if (indexPath.section==1){
        WMCertificationPictureCell *certificationPictureCell=(WMCertificationPictureCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!certificationPictureCell) {
            certificationPictureCell=[[[NSBundle mainBundle]loadNibNamed:@"WMCertificationPictureCell" owner:self options:Nil] lastObject];
            if (!_idcardTextField) {
                _idcardTextField=[[UITextField alloc] initWithFrame:CGRectMake(kScreen_width-200-15, 10, 200, 30)];

            }
            _idcardTextField.keyboardType = UIKeyboardTypeASCIICapable;
            _idcardTextField.textAlignment=NSTextAlignmentRight;
            _idcardTextField.font=[UIFont systemFontOfSize:14.0];
            _idcardTextField.placeholder=@"请输入你的身份证号码";
            _idcardTextField.delegate=self;
            [certificationPictureCell addSubview:_idcardTextField];
        }
        certificationPictureCell.delegate=self;
        certificationPictureCell.photos=self.photos;
        certificationPictureCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return certificationPictureCell;
        
    }
    else{
        WMCertificationExampleCell *certificationPictureCell=(WMCertificationExampleCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!certificationPictureCell) {
            certificationPictureCell=[[[NSBundle mainBundle]loadNibNamed:@"WMCertificationExampleCell" owner:self options:Nil] lastObject];
        }
        certificationPictureCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return certificationPictureCell;
    }
    

}

-(void)uploadPictureAction{
    
    [self changedImageAction];
    NSLog(@"越界了啊");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
        if (string.length>0 && self.photos.count>0) {
            _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
            [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            _sureButton.enabled=YES;
        }
        else{
            _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
            [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _sureButton.enabled=NO;
        }
        
        if ([textField.text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            return NO;
        }
        
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _idcardTextField.text = textField.text;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
       _idcardTextField.text = textField.text;
        if (!stringIsEmpty(textField.text)) {
            if (textField.text.length>0 && self.photos.count>0) {
                _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
                [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                _sureButton.enabled=YES;
            }
            else{
                _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
                [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
                _sureButton.enabled=NO;
            }
            

            if ([textField.text containsString:@"*"]) {
                if (![NSString validateIDCardNumber:_idcardTextField.text] ) {
                    [WMHUDUntil showMessageToWindow:@"身份证号码有误,请检查!"];
                    return;
                }
                
                
            }else{
                
                if (textField.text.length>0 && self.photos.count>0) {
                    _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
                    [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                    _sureButton.enabled=YES;
                }
                else{
                    _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
                    [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
                    _sureButton.enabled=NO;
                }
                
                if (![NSString validateIDCardNumber:_idcardTextField.text]) {
                    [WMHUDUntil showMessageToWindow:@"身份证号码有误,请检查!"];
                    return;
                }
                
                

            }
        
    }
    
}

-(void)uploadPictureAgainAction{
     [self.photos removeAllObjects];
     [self changedImageAction];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 10;
    }
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }
    else if (indexPath.section==1){
        return 216;
    }
    else if (indexPath.section==2){
        return 195;
    }
    return 0.001;
}




#pragma mark--相机
- (void)changedImageAction{
    __weak typeof(self) weakself = self;
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0://照相机
            {
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    [WMHUDUntil showMessage:@"相机权限受限制" toView:weakself.view];
                    return;
                }
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
                    if (granted) {
                        if ([weakself isCameraAvailable] && [weakself doesCameraSupportTakingPhotos])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                                controller.allowsEditing = NO;
                                controller.delegate = weakself;
                                [weakself presentViewController:controller animated:YES completion:NULL];
                            });
                        }
                    }
                }];
                
                
            }
                break;
            case 1://相册
            {
                [weakself jumpPhotoAlbum];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark--跳转相册
-(void)jumpPhotoAlbum{
   dispatch_async(dispatch_get_main_queue(), ^{
       _SupportNumber=1-(int )self.photos.count;
       ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
       picker.maximumNumberOfSelection = _SupportNumber;
       picker.assetsFilter = [ALAssetsFilter allAssets];//[PHAsset]
       picker.showEmptyGroups=NO;
       picker.delegate=self;
       picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
           if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
               NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
               return duration >= 1;
           } else {
               return YES;
           }
       }];
       
       [self presentViewController:picker animated:YES completion:NULL];
 
   });
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"拿到图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        UIImage * endImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *newImage=[self CutPictures:endImage];
        
        if (self.photos.count<2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photos addObject:newImage];
                if (_idcardTextField.text.length>0 && self.photos.count>0) {
                    _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
                    [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                    _sureButton.enabled=YES;
                }
                else{
                    _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
                    [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
                    _sureButton.enabled=NO;
                }
                [_tableView reloadData];
                
            });
        }
        //先判断大小 如果图片大于10M
        
    }];
    
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *) kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *) kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *) kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark - 相机相关代码
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
    
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        NSMutableArray *artayCount=[NSMutableArray new];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            UIImage *newImage=[self CutPictures: tempImg];
            
            [artayCount addObject:newImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photos addObjectsFromArray:artayCount];
            if (_idcardTextField.text.length>0 && self.photos.count>0) {
                _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
                [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                _sureButton.enabled=YES;
            }
            else{
                _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
                [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
                _sureButton.enabled=NO;
            }
            [_tableView reloadData];
            
        });
        
        
    });
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark--把图片转化为流
-(NSData *)imageConversionDateWithImage:(UIImage *)image{
    
    NSData * newData = UIImageJPEGRepresentation(image, 1);
    return newData;
}
-(UIImage *)CutPictures:(UIImage *)image{
    
    NSData * data = UIImageJPEGRepresentation(image, 1);
    NSLog(@"%lu==",(unsigned long)data.length);
    //先判断大小 如果图片大于10M
    if (data.length<IMAGESIZE_M) {
        //_base64Str = nil;
        //_base64Str = [data base64EncodedStringWithOptions:0];
        return image;
    }
    else if (data.length<IMAGESIZE_M*4){
        NSLog(@"大于");
        UIImage * newImage=[self imageWithImage:image minification:0.5];
        return newImage;
    }
    else if (data.length<IMAGESIZE_M*9){
        UIImage * newImage=[self imageWithImage:image minification:0.3];
        return newImage;
        
    }
    else if (data.length<IMAGESIZE_M*16){
        UIImage * newImage=[self imageWithImage:image minification:0.25];
        return newImage;
    }
    else if (data.length<IMAGESIZE_M*25){
        UIImage * newImage=[self imageWithImage:image minification:0.2];
        return newImage;
    }
    else {
        [PopUpUtil confirmWithTitle:@"温馨提示" message:@"图片过大，无法上传"  toViewController:self buttonTitles:@[@"确定"] completionBlock:^(NSUInteger buttonIndex) {
            
        }];
        
        return nil;
    }
    
}

//对图片尺寸进行压缩--图文咨询的图片压缩
- (UIImage *)imageWithImage:(UIImage*)image minification:(float )multiple{
    CGSize oldSize = CGSizeZero;
    oldSize=CGSizeMake(image.size.width*multiple, image.size.height*multiple);
    // Create a graphics image context
    UIGraphicsBeginImageContext(oldSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,oldSize.width,oldSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
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
