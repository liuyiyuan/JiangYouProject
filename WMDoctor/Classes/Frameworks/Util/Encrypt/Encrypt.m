//
//  main.m
//  muxiaobo 2015-12-29
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Encrypt.h"
//#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import <Security/Security.h>

#import <CommonCrypto/CommonHMAC.h>

@implementation Encrypt

/**
 *  目前暂不使用该方法
 *
 *  @param plainText     需要加密的字符串
 *  @param needToReplace 注册的时候 是NO 其余都是   YES
 *
 *  @return 已经加密的字符串
 */
+ (NSString *)encryptUseDES:(NSString *)plainText needToReplace:(BOOL)needToReplace
{
//    NSData * desKey = [GTMBase64 decodeString:gkey];
//    NSData * desIvs = [GTMBase64 decodeString:gIv];
    
    NSData * desKey = [[NSData alloc] initWithBase64EncodedString:gkey options:0];
    NSData * desIvs = [[NSData alloc] initWithBase64EncodedString:gIv options:0];
    
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          [desKey bytes], kCCKeySize3DES,
                                          [desIvs bytes],
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        //ciphertext = [GTMBase64 stringByEncodingData:data];
        ciphertext = [data base64EncodedStringWithOptions:0];
    }
    if (needToReplace) {
        ciphertext = [ciphertext stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];//ss.Replace("+", "%2B");
        ciphertext = [ciphertext stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    }
    return ciphertext;
}

+ (NSString *)hmacsha1:(NSString *)str secret:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [str cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    //NSString *hash = [GTMBase64 stringByEncodingData:HMAC];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}

@end
