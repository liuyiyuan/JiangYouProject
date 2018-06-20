//
//  LoginModel.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/27.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.rongToken = [decoder decodeObjectForKey:@"rongToken"];
        self.sessionId = [decoder decodeObjectForKey:@"sessionId"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.userCode = [decoder decodeObjectForKey:@"userCode"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.loginFlag = [decoder decodeObjectForKey:@"loginFlag"];
        self.userType = [[decoder decodeObjectForKey:@"userType"] boolValue];
        self.certStatus = [decoder decodeObjectForKey:@"certStatus"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.rongToken forKey:@"rongToken"];
    [encoder encodeObject:self.sessionId forKey:@"sessionId"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.userCode forKey:@"userCode"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.loginFlag forKey:@"loginFlag"];
    [encoder encodeObject:[NSNumber numberWithBool:self.userType] forKey:@"userType"];
    [encoder encodeObject:self.certStatus forKey:@"certStatus"];
}



@end
