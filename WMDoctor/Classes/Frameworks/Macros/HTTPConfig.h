//
//  HTTPConfig.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/27.
//  Copyright © 2016年 Choice. All rights reserved.
//

#ifndef HTTPConfig_h
#define HTTPConfig_h


#endif /* HTTPConfig_h */


/*---------*< 微脉主页接口 >*---------*/

/**
 * 微脉系统消息
 */

#define URL_GET_MESSAGETYPE       @"/message/type"
/**
 * 微脉系统消息详情
 */

#define URL_GET_MESSAGELIST       @"/message/list"

/**
 * 微脉患者消息状态接口-获取健康档案状态
 */
#define URL_GET_PATINENTSTYPE       @"/patients/type"

/**
 * 微脉患者消息状态接口-用户信息
 */
#define URL_GET_PATINENTSINFO      @"/patient_user/information_of_doctor_patient"// @"/patients/info"

/**
 * 微脉患者消息状态接口-关闭回话
 */
#define URL_GET_PATINENTSCLOSE       @"/patients/close"

/**
 * 微脉患者消息状态接口-关闭回话
 */
#define URL_GET_PATINENTUPHUIFUBZ       @"/patients/upHuifubz"
/**
 * 患者消息接口-获取健康档案接口
 */
#define URL_GET_PATINENTHEALTH       @"/patients/health"

/**
 * 患者消息接口-随访
 */
#define URL_POST_FLUP_SAVEORDER       @"/flup/saveOrder"

/**
 * 患者消息接口-名片-获取当前机构下的科室信息
 */
#define URL_GET_PATIENTS_DOCTOR_OFFICES      @"/patients/doctor/offices"
/**
 * 患者消息接口-名片-获取当前科室下的医生
 */
#define URL_GET_PATIENTS_DOCTOR_DOCTORCARDS      @"/patients/doctor/doctor_cards"
/**
 * 医生资讯详情
 */
#define URL_GET_DOCTOR_NEWS_RECORD          @"/doctor/doctor_news_record"

/**
 * 患者消息接口-名片-发送名片后台保存记录接口
 */
//#define URL_PUT_CLEARCUSTOMERDOCTORCONFIRM(customerRegisterId)      [NSString stringWithFormat:@"wenzhen/api/customer/doctor/confirm?customerRegisterId=%@&type=2",customerRegisterId]

#define URL_PUT_PATIENTS_CORD_SEND      @"/patients/doctor/send_card"



/*---------*< 微脉圈子接口 >*---------*/

/**
 * 圈子接口-获取健康档案接口
 */

#define URL_GET_CIRCLES_GROUPS_PATIENTS_ACCEPT    @"/circles/groups/patients/accept"
/**
 * 圈子接口-获取所有患者接口
 */

#define URL_GET_CIRCLES_NEW_TOTALPATIENTS    @"/circles/new/totalPatients"

#define URL_GET_CIRCLES_VIP_PATIENTS    @"/circles/vip_patients"


/*---------*< 登录 >*---------*/
#define URL_POST_CERTIFICATION_SAVEINFORMATION    @"/certification/save_information"

/**
 * 获取区域医院组合数据
 */
#define URL_GET_HOSPITAL_REGION_AND_HOSPITAL   @"/hospital/region_and_hospital"
/**
 * 获取科室组合数据
 */
#define URL_GET_HOSPITAL_DEPARTMENTS   @"/hospital/departments"

/**
 * 获取职业列表
 */
#define URL_GET_HOSPITAL_JOB_LEVELS   @"/hospital/job_levels"

/**
 * 获取职业列表
 */
#define URL_POST_USER_DOCTOR_REGISTER_SERVICE   @"/users/doctor_register_service"






/*---------*< 胎心监护 >*---------*/

/**
 获取报告列表
 */
#define URL_GET_TAIXIN_REPORTLIST   @"/product/cardiac_report"


/**
 获取报告详情
 */
#define URL_GET_TANXIN_REPORTDETAIL @"/product/cardiac_details"

/**
 获取所有报告
 */
#define URL_GET_TANXIN_ALLREPORT @"/product/cardiac_all_reports"


/**
 提交医生建议
 */
#define URL_GET_TANXIN_PUTADVICE @"/product/cardiac_advice"



