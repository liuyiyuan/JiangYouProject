//
//  WMServiceSetCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceSetCell.h"
#import "WMServicePriceCollectionViewCell.h"
#import "WMServiceUpdatePriceAPIManager.h"
#import "WMOpenServiceAPIManager.h"

@implementation WMServiceSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setCellValue:(WMServiceSetInfoModels *)model{
    self.openSwitch.on = ([model.openService isEqualToString:@"1"])?YES:NO;
    self._infoModel = model;
    if ([model.inquiryType isEqualToString:@"1"]) {     //图文咨询
        if ([model.type isEqualToString:@"0"]) {        //包月
            self.titleLabel.text = @"按次服务";
        }else{      //按次
            self.titleLabel.text = @"包月服务";
        }
    }else{      //朋友圈咨询
        if ([model.type isEqualToString:@"0"]) {        //包年
            self.titleLabel.text = @"全年服务";
        }else{      //半年
            self.titleLabel.text = @"半年服务";
        }
    }
    
    self.useOn = ([model.openService isEqualToString:@"1"])?YES:NO;
    
    [self.collectionView reloadData];       //刷新价格
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self._infoModel.custom isEqualToString:@"2"]) {
        return self._infoModel.prices.count + 2;
    }
    return self._infoModel.prices.count + 1;
}

- (IBAction)valueChange:(id)sender {
    NSLog(@"值被改变了");
    UISwitch * switchs = (UISwitch *)sender;
    [self changedSwitchValue:switchs.on];
    
    
}

- (void)changedSwitchValue:(BOOL)on{
    WMOpenServiceAPIManager * manager = [[WMOpenServiceAPIManager alloc]init];
    
    [manager loadDataWithParams:@{@"openService":@(on),@"typeId":self._infoModel.typeId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        self.collectionView.userInteractionEnabled = on;
        self.useOn = on;
        [self.collectionView reloadData];       //刷新价格
    } withFailure:^(ResponseResult *errorResult) {
    }];
    
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMServicePriceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMServicePriceCollectionViewCell" forIndexPath:indexPath];
    
    
    cell.priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.priceLabel.font = [UIFont systemFontOfSize:14];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    cell.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];

    
    if ([self._infoModel.custom isEqualToString:@"2"]) {        //自定义价格
        if (indexPath.row < self._infoModel.prices.count){
            cell.priceLabel.text = [NSString stringWithFormat:@"%d%@",[self._infoModel.prices[indexPath.row] intValue],self._infoModel.unit];      //单位拼接
        }else if(indexPath.row == self._infoModel.prices.count){
            cell.priceLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
            cell.priceLabel.font = [UIFont systemFontOfSize:16];
            cell.layer.borderWidth = 1;
            cell.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
            cell.priceLabel.text = [NSString stringWithFormat:@"%@%@",self._infoModel.price,self._infoModel.unit];
            cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }else{
            cell.priceLabel.text = @"自定义";
        }
    }else{
        if (indexPath.row != self._infoModel.prices.count) {
            if ([self._infoModel.price isEqualToString:[NSString stringWithFormat:@"%@",self._infoModel.prices[indexPath.row]]]) {        //如果是设定价格就改变成选中状态
                cell.priceLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
                cell.priceLabel.font = [UIFont systemFontOfSize:16];
                cell.layer.borderWidth = 1;
                cell.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
                cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            }
        }
        
        
        if (indexPath.row < self._infoModel.prices.count) {
            cell.priceLabel.text = [NSString stringWithFormat:@"%d%@",[self._infoModel.prices[indexPath.row] intValue],self._infoModel.unit];      //单位拼接
        }else{
            if ([self._infoModel.custom isEqualToString:@"1"]) {    //如果选中价格不是自定义，自定义cell文案为自定义
                cell.priceLabel.text = @"自定义";
            }
            
        }
    }
    
        
    if (!self.useOn) {
        cell.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        cell.layer.borderWidth = 0;
        cell.priceLabel.textColor = [UIColor colorWithHexString:@"c4c4c4"];
    }
    
    
    
    return cell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WMServicePriceCollectionViewCell * cell = (WMServicePriceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.priceLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
    
    if (indexPath.row >= self._infoModel.prices.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickBtn:)]) {
            [self.delegate cellClickBtn:self._infoModel.typeId];
        }
    }else{
        WMServiceUpdatePriceAPIManager * manager = [[WMServiceUpdatePriceAPIManager alloc]init];
        NSString * strPrice =[NSString stringWithFormat:@"%@",self._infoModel.prices[indexPath.row]];
        NSString * strTypeId = self._infoModel.typeId;
        [manager loadDataWithParams:@{@"price":strPrice,@"custom":@"1",@"typeId":strTypeId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            
//            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_model.price,@"price",_serviceModel.type,@"type", nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceNotification" object:@"flagValue" userInfo:dict];
//            [self.collectionView reloadData];
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshPrice)]) {
                [self.delegate refreshPrice];
            }
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }
    
}


//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    WMServicePriceCollectionViewCell * cell = (WMServicePriceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    cell.layer.borderWidth = 0.5;
//    cell.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
//}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    WMServicePriceCollectionViewCell * cell = (WMServicePriceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
