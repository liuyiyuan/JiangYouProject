//
//  WMJSONModel.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/26.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 * @ brief JSON转换Model<子类实现需集成该父类>
 * @ param
 * @ return
 */

@interface WMJSONModel : JSONModel

@end

/**
 *  分页加载数据入参父类
 */
@interface WMPageCustomModel :WMJSONModel

@property (nonatomic, copy) NSString <Optional>*pageNum;            /*分页*/
@property (nonatomic, copy) NSString <Optional>*pageSize;           /*分页*/

@end
