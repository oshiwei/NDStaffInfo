//
//  DataBaseManager.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/17.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "DataBaseManager.h"
#import "UserInfoModel.h"

@interface DataBaseManager ()
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation DataBaseManager

#pragma mark - 单例标准写法

+ (DataBaseManager *)instance {
    static DataBaseManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self instance];
}

// NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

#pragma mark - 数据库初始化

- (instancetype)init {
    self = [super init];
    if (self) {
        [self dataBaseInit];
    }
    return self;
}

- (void)dataBaseInit {
    NSString *dbFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.dbPath = [dbFolder stringByAppendingPathComponent:@"staffinfo.db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.dbPath]) {
        NSString *resPath = [[NSBundle mainBundle] pathForResource:@"staffinfo" ofType:@"db"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:resPath]) {
            // 如果res存在数据库，则拷贝到doc
            [[NSFileManager defaultManager] copyItemAtPath:resPath toPath:self.dbPath error:NULL];
        }
    }
    // 如果staffinfo.db不存在，会自动创建
    self.queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    // 如果表不存在，则创建表
    [self executeUpdate:@"create table if not exists UserInfo(userid text primary key not null,name text null,pinyin text null,firstpy text null,info text null);"];
}

#pragma mark - 数据库基本操作

- (FMResultSet *)executeQuery:(NSString *)query {
    __block FMResultSet *rs = nil;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        rs = [db executeQuery:query];
        // 通常FMResultSet不用手动close，被释放或数据库close会自动close
    }];
    return rs;
}

- (NSArray *)query:(NSString *)query {
    __block NSMutableArray *array = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:query];
        while ([rs next]) {
            NSDictionary *dic = rs.resultDictionary;
            [array addObject:dic];
        }
        
        // [rs close];
        // 通常FMResultSet不用手动close，被释放或数据库close会自动close
    }];
    return array;
}

- (BOOL)executeUpdate:(NSString *)update {
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db executeUpdate:update];
    }];
    return result;
}

#pragma mark - 数据库业务逻辑

- (BOOL)userInfoIsExist:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"select count(*) from UserInfo where userid='%@'", uid];
    FMResultSet *result = [self executeQuery:sql];
    if ([result next]) {
        return ([result intForColumnIndex:0] > 0);
    }
    return NO;
}

- (NSString *)getUserInfoXMLString:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"select info from UserInfo where userid='%@'", uid];
    FMResultSet *result = [self executeQuery:sql];
    if ([result next]) {
        return [result stringForColumn:@"info"];
    }
    return nil;
}

- (BOOL)saveUserInfoXMLString:(NSString *)xmlString uid:(NSString *)uid name:(NSString *)name pinyin:(NSString *)pinyin firstpy:(NSString *)firstpy {
    NSString *sql = [NSString stringWithFormat:@"replace into UserInfo(userid,name,pinyin,firstpy,info) values('%@','%@','%@','%@','%@')", uid, name, pinyin, firstpy, xmlString];
    return [self executeUpdate:sql];
}

- (NSArray *)searchUser:(NSString *)text {
    NSString *sql = [NSString stringWithFormat:@"select userid, name from UserInfo where userid like '%%%@%%' or name like '%%%@%%' or pinyin like '%%%@%%' or firstpy like '%%%@%%'", text, text, text, text];
    __block NSMutableArray *array = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *userid = [rs stringForColumn:@"userid"];
            NSString *name = [rs stringForColumn:@"name"];
            UserInfoModel *model = [UserInfoModel new];
            model.title = name;
            model.value = userid;
            [array addObject:model];
        }
        [rs close];
    }];
    return [array copy];
}

@end
