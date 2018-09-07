//
//  QuickEntity+CoreDataClass.m
//  
//
//  Created by JacksonMichael on 2017/7/26.
//
//

#import "QuickEntity+CoreDataClass.h"

@implementation QuickEntity





//删除某条快捷回复
+ (void)deleteQuickEntity:(NSString *)userId andTheType:(NSString *)type andTheText:(NSString *)text{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId = %@ and theType = %@ and contentText = %@",userId,type,text];
    
    QuickEntity * quick = [QuickEntity MR_findFirstWithPredicate:predicate];
    NSManagedObjectContext * context = [quick managedObjectContext];
    [quick MR_deleteEntityInContext:context];
    [context MR_saveToPersistentStoreAndWait];
    
}

//获取快捷回复列表
+ (NSMutableArray *)getQuickEntityList:(NSString *)userId andType:(NSString *)type{
    //查询真实数据数量
    NSPredicate *temppredicate = [NSPredicate predicateWithFormat:@"userId = %@ and theType = %@ ",userId,type];
    NSArray *  temppatientEntitys = [QuickEntity MR_findAllSortedBy:@"order" ascending:NO withPredicate:temppredicate];
    
    
    if (temppatientEntitys.count < 1) { //用真实的数据做判断
        NSManagedObjectContext * context = [NSManagedObjectContext MR_defaultContext];
        NSArray * strlist = [NSArray array];
        if ([type isEqualToString:@"Cardiotocography"]) {//胎心
            strlist = [NSArray arrayWithObjects:@"默认缺省",@"本次监测有效数据不够，请重测后再上传",@"本次监测数据存在胎心减速，请复测或到院复诊",@"本次监测数据存在胎心加速，请复测或到院复诊",@"目前您的胎儿存在缺氧危险，请复测或到院吸氧",@"您的胎心正常，请继续保持监测并上传数据", nil];
        }else if([type isEqualToString:@"talk"]){
            strlist = [NSArray arrayWithObjects:@"默认缺省",@"感谢您对我的信任，希望我的回答能够帮助到您。如果对我的服务满意，请记得给好评哟~",@"不好意思，我需要暂时离开一会儿，请稍等片刻。",@"要按医嘱吃药，准时到我门诊复查，这对病情重要。",@"这个问题比较复杂，你最好来门诊做个检查比较好。",@"生活上一定要注意饮食、多运动，这对康复有好处。", nil];
        }
        for (int i = 0; i<strlist.count; i++) {
            QuickEntity * quick = [QuickEntity MR_createEntityInContext:context];
            quick.contentText = (NSString *)strlist[i];
            quick.userId = userId;
            quick.order = [NSNumber numberWithInt:i];
            quick.theType = type;
            [context MR_saveToPersistentStoreAndWait];
        }
        //重新查询一次
//        [self getQuickEntityList:userId andType:type];
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ and theType = %@ and order <> 0",userId,type];
    NSArray *  patientEntitys = [QuickEntity MR_findAllSortedBy:@"order" ascending:NO withPredicate:predicate];
    
    NSMutableArray * arrList = [NSMutableArray arrayWithCapacity:patientEntitys.count];
    
    for (int i = 0; i<patientEntitys.count; i++) {
        
    }
    
    return arrList;
                              
}


@end
