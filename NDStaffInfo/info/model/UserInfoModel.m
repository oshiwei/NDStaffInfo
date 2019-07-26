//
//  UserInfoModel.m
//  NDStaffInfo
//
//  Created by Linhz on 2019/7/25.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (UserInfoModel *)userInfoWithKey:(NSString *)key value:(NSString *)value {
    
    if (key.length == 0 || value.length == 0) {
        return nil;
    }
    
    NSString *title = [self keyTitleMap][key];
    if (title.length == 0) {
        return nil;
    }
    
    UserInfoModel *userInfo = [[UserInfoModel alloc] init];
    userInfo.title = title;
    userInfo.value = value; 
    return userInfo;
}

+ (NSArray *)defaultShowUserInfosWithData:(NSArray *)data {
    
    NSArray *defaultShowKeys = [self defaultShowKeysArray];
    if (!data || data.count < defaultShowKeys.count) {
        return nil;
    }
    
    NSMutableArray *defaultArray = [NSMutableArray array];
    for (int i = 0; i < defaultShowKeys.count; i++) {
        NSMutableArray *defaultSubArray = [NSMutableArray array];
        NSDictionary *dataDic = data[i];
        NSArray *defaultShowSubKeys = defaultShowKeys[i];
        for (int j = 0; j < defaultShowSubKeys.count; j++) {
            NSString *key = defaultShowSubKeys[j];
            NSString *value = dataDic[key];
            
            UserInfoModel *userInfo = [self userInfoWithKey:key value:value];
            if (userInfo) {
                [defaultSubArray addObject:userInfo];
            }
        }
        [defaultArray addObject:[defaultSubArray copy]];
    }
    
    return [defaultArray copy];
}

+ (NSDictionary *)keyTitleMap {
    
    static NSDictionary *keyTitleMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyTitleMap = @{
                        @"txt_sygcardcode_a5_cwperson" : @"身份证号码",
                        @"txt_sygphone_a5_cwperson" : @"住宅电话",
                        @"txt_sparty_a5_cwperson" : @"政治面貌",
                        @"txt_s024_a5_cwperson" : @"籍贯",
                        @"txt_s025_a5_cwperson" : @"手机号码",
                        @"txt_dctmbirthday_a5_cwperson" : @"个性化生日",
                        @"txt_lygheight_a5_cwperson" : @"身高",
                        @"txt_sygxzaddress_a5_cwperson" : @"居住地址",
                        @"txt_snoticeman_a5_cwperson" : @"紧急通知人",
                        @"txt_snoticeway_a5_cwperson" : @"紧急联系人电话",
                        @"txt_sygblood_a5_cwperson" : @"血型",
                        @"txt_shkcode_a5_cwperson" : @"户口性质",
                        @"txt_snationality_a5_cwperson" : @"国籍",
                        @"txt_dygbirthday_a5_cwperson" : @"出生日期",
                        @"txt_sygemail_a5_cwperson" : @"电子邮件",
                        @"txt_spersonname_a5_cwperson" : @"职员姓名",
                        @"txt_syghjaddress_a5_cwperson" : @"户籍地址",
                        @"txt_sygmarriage_a5_cwperson" : @"婚姻状态",
                        @"txt_s023_a5_cwperson" : @"档案所在地",
                        @"txt_sygnation_a5_cwperson" : @"民族",
                        @"txt_syghometown_a5_cwperson" : @"籍贯",
                        @"txt_sygmobile_a5_cwperson" : @"工作电话",
                        @"txt_sygsex_a5_cwperson" : @"性别",
                        
                        @"txt_dbytime_a5_wjyzk" : @"毕业时间",
                        @"txt_sbyschool_a5_wjyzk" : @"毕业学校",
                        @"txt_senglish_a5_wjyzk" : @"英语等级",
                        @"txt_smajor_a5_wjyzk" : @"专业",
                        @"txt_scomputer_a5_wjyzk" : @"计算机等级",
                        @"txt_swhgrade_a5_wjyzk" : @"学历",
                        @"txt_setpcode_a5_wjyzk" : @"学历类型",
                        @"txt_sdegree_a5_wjyzk" : @"学位",
                        
                        @"txt_lgwcode_a5_wzzzl" : @"职位",
                        @"txt_sptycode_a5_wzzzl" : @"任职类型",
                        @"txt_dsydate_a5_wzzzl" : @"转正日期",
                        @"txt_spersoncode_a5_wzzzl" : @"工号",
                        @"txt_sworkaddress_a5_wzzzl" : @"工作地点",
                        @"txt_s018_a5_wzzzl" : @"档案编号",
                        @"txt_sdeptcwcls_a5_wzzzl" : @"部门类别",
                        @"txt_shtgsdepcode_a5_wzzzl" : @"合同归属",
                        @"txt_dygjoin_a5_wzzzl" : @"入职日期",
                        @"txt_sgravalue_a5_wzzzl" : @"职级",
                        @"txt_sworkdepname_a5_wzzzl" : @"编制部门",
                        @"txt_splbcode_a5_wzzzl" : @"员工类型",
                        @"txt_sworkstaus_a5_wzzzl" : @"工作状态"
                        };
    });
    return keyTitleMap;
}

+ (NSArray *)defaultShowKeysArray {
    
    static NSArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[@[
                      @"txt_spersonname_a5_cwperson", //@"职员姓名",
                      @"txt_sygcardcode_a5_cwperson", //@"身份证号码",
                      @"txt_sygphone_a5_cwperson", //@"住宅电话",
                      @"txt_sparty_a5_cwperson", //@"政治面貌",
                      @"txt_s024_a5_cwperson", //@"籍贯",
                      @"txt_s025_a5_cwperson", //@"手机号码",
                      @"txt_dctmbirthday_a5_cwperson", //@"个性化生日",
                      @"txt_lygheight_a5_cwperson", //@"身高",
                      @"txt_sygxzaddress_a5_cwperson", //@"居住地址",
                      @"txt_snoticeman_a5_cwperson", //@"紧急通知人",
                      @"txt_snoticeway_a5_cwperson", //@"紧急联系人电话",
                      @"txt_sygblood_a5_cwperson", //@"血型",
                      @"txt_shkcode_a5_cwperson", //@"户口性质",
                      @"txt_snationality_a5_cwperson", //@"国籍",
                      @"txt_dygbirthday_a5_cwperson", //@"出生日期",
                      @"txt_sygemail_a5_cwperson" , //@"电子邮件",
                      @"txt_syghjaddress_a5_cwperson", //@"户籍地址",
                      @"txt_sygmarriage_a5_cwperson", //@"婚姻状态",
                      @"txt_s023_a5_cwperson", //@"档案所在地",
                      @"txt_sygnation_a5_cwperson", //@"民族",
                      @"txt_syghometown_a5_cwperson", //@"籍贯",
                      @"txt_sygmobile_a5_cwperson", //@"工作电话",
                      @"txt_sygsex_a5_cwperson", //@"性别"
                      ], @[
                      @"txt_lgwcode_a5_wzzzl", //@"职位",
                      @"txt_sptycode_a5_wzzzl", //@"任职类型",
                      @"txt_dsydate_a5_wzzzl", //@"转正日期",
                      @"txt_spersoncode_a5_wzzzl", //@"工号",
                      @"txt_sworkaddress_a5_wzzzl", //@"工作地点",
                      @"txt_s018_a5_wzzzl", //@"档案编号",
                      @"txt_sdeptcwcls_a5_wzzzl", //@"部门类别",
                      @"txt_shtgsdepcode_a5_wzzzl", //@"合同归属",
                      @"txt_dygjoin_a5_wzzzl", //@"入职日期",
                      @"txt_sgravalue_a5_wzzzl", //@"职级",
                      @"txt_sworkdepname_a5_wzzzl", //@"编制部门",
                      @"txt_splbcode_a5_wzzzl", //@"员工类型",
                      @"txt_sworkstaus_a5_wzzzl", //@"工作状态"
                      ], @[
                      @"txt_dbytime_a5_wjyzk", //@"毕业时间",
                      @"txt_sbyschool_a5_wjyzk", //@"毕业学校",
                      @"txt_senglish_a5_wjyzk", //@"英语等级",
                      @"txt_smajor_a5_wjyzk", //@"专业",
                      @"txt_scomputer_a5_wjyzk", //@"计算机等级",
                      @"txt_swhgrade_a5_wjyzk", //@"学历",
                      @"txt_setpcode_a5_wjyzk", //@"学历类型",
                      @"txt_sdegree_a5_wjyzk", //@"学位"
                      ]];
    });
    return array;
}

@end
