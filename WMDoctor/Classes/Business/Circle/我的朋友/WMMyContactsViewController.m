//
//  WMMyContactsViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContactsCell.h"

@interface WMMyContactsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _contactsArr;
}
@property (nonatomic,weak) IBOutlet UITableView * tableView;
@end

@implementation WMMyContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupUI];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData{
    _contactsArr = [NSMutableArray array];
    [self fetchAddressBookBeforeIOS9];
    [self.tableView reloadData];
}

- (void)setupUI{
    
}


- (void)fetchAddressBookBeforeIOS9{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //用户授权
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {//首次访问通讯录
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (!error) {
                if (granted) {//允许
                    NSArray *contacts = [self fetchContactWithAddressBook:addressBook];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"contacts:%@", contacts);
                        for (int i = 0; i < contacts.count; i++) {
                            NSLog(@"contacts:%@",contacts[i]);
                        }
                    });
                }else{//拒绝
                }
            }else{
                NSLog(@"错误!");
            }
        });
    }else{//非首次访问通讯录
        NSArray *contacts = [self fetchContactWithAddressBook:addressBook];
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"contacts:%@", contacts);
            for (int i = 0; i < contacts.count; i++) {
                NSLog(@"contacts:%@",contacts[i]);
            }
        });
    }
}

- (NSMutableArray *)fetchContactWithAddressBook:(ABAddressBookRef)addressBook{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {////有权限访问
        //获取联系人数组
        NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            //获取联系人
            ABRecordRef people = CFArrayGetValueAtIndex((__bridge ABRecordRef)array, i);
            
            //获取联系人详细信息,如:姓名,电话,住址等信息
            NSString *firstName = stringIsEmpty((__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty))?@"":(__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            NSString *lastName = stringIsEmpty((__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty))?@"":(__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            ABMutableMultiValueRef *phoneNumRef = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *phoneNumber =  stringIsEmpty(((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef)).lastObject)?@"":((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef)).lastObject;
            
            //获取头像
            NSData *imageData = (__bridge NSData*)ABPersonCopyImageData(people);
            UIImage *image = [UIImage imageWithData:imageData];
            [_contactsArr addObject:@{@"name": [firstName stringByAppendingString:lastName], @"phoneNumber": phoneNumber,@"headImage":(image == nil)?[UIImage imageNamed:@"AppIcon"]:image}];
            [contacts addObject:@{@"name": [firstName stringByAppendingString:lastName], @"phoneNumber": phoneNumber,@"headImage":(image == nil)?[UIImage imageNamed:@"AppIcon"]:image}];
        }
        return contacts;
    }else{//无权限访问
        NSLog(@"无权限访问通讯录");
        return nil;
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.000000001f;
    }else if (section == 1) {
        return 10.0f;
    }else{
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _contactsArr.count;
    }else if(section == 1){
        return 3;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ContactsCell *cell = (ContactsCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WMContactsModel * model = [[WMContactsModel alloc]init];
        model.contactName = _contactsArr[indexPath.row][@"name"];
        model.contactNumber = _contactsArr[indexPath.row][@"phoneNumber"];
        model.contactImage = [[UIImageView alloc]initWithImage:(UIImage *)_contactsArr[indexPath.row][@"headImage"]];
        
        [cell setCellValue:model];
        return cell;
    }else{
        ContactsCell *cell = (ContactsCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WMContactsModel * model = [[WMContactsModel alloc]init];
        model.contactName = @"吴大渺";
        model.contactNumber = @"18258830044";
        model.contactImage = [[UIImageView alloc]init];
        
        [cell setCellValue:model];
        return cell;
    }
    
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
