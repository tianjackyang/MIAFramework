#import "NSString+SLMFramework.h"
#import "SLMFramework.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SLMFramework)

- (BOOL)slm_isMobilePhoneNumber
{
    NSString *string = @"^1\\d{10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    
    if (([predicate evaluateWithObject:self] == YES)) {
        return YES;
    }
        
    return NO;
//    if ([self isEqualToString:@"11111111111"]) {    //测试账号
//        return YES;
//    }
//
///**
// * 手机号码
// * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
// * 联通：130,131,132,152,155,156,185,186
// * 电信：133,1349,153,180,189
// */
//    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
///**
// * 中国移动：China Mobile
// * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//*/
//    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
///**
// * 中国联通：China Unicom
// * 130,131,132,152,155,156,185,186
//*/
//    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
///**
// * 中国电信：China Telecom
// * 133,1349,153,180,189,170
//*/
//    NSString *CT = @"^1((33|53|7[06-8]|8[09])[0-9]|349)\\d{7}$";
///**
// * 大陆地区固话及小灵通
// * 区号：010,020,021,022,023,024,025,027,028,029
// * 号码：七位或八位
// */
//// NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//
//    if (([regextestmobile evaluateWithObject:self] == YES)
//        || ([regextestcm evaluateWithObject:self] == YES)
//        || ([regextestct evaluateWithObject:self] == YES)
//        || ([regextestcu evaluateWithObject:self] == YES)) {
//        return YES;
//    }
//    else {
//        return NO;
//    }
}

- (NSDate *)slm_date
{
    if (self.length <= 0) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self];
#if !__has_feature(objc_arc)
    [formatter release];
#endif
    return date;
}

- (id)slm_JSONValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    
    if (!obj || error) {
        return nil;
    }
    return obj;
}

- (NSString *)slm_md5
{
    if (!self || self.length <= 0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
#if __has_feature(objc_arc)
    return outputString;
#else
    return [outputString autorelease];
#endif
}

- (int)slm_chineseLength
{
    NSUInteger strlength = 0;
    const char *p = [self cStringUsingEncoding:NSUnicodeStringEncoding];
    int length = (int)[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    int i;
    for (i = 0; i < length; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (int)(strlength + 1) / 2;
}

- (NSString *)slm_underlineToDump
{
    const char *src = [self UTF8String];
    unsigned long len = strlen(src) + 1;
    char *desc = (char *)malloc(sizeof(char) * len);
    memset(desc, 0, sizeof(char) * len);
    BOOL flag = NO;
    char *temp = (char *)desc;
    char c;
    while ((c = *src++) != '\0') {
        if (c == '_') {
            flag = YES;
            continue;
        }
        if (flag && (c > 'a') && (c < 'z')) {
            *temp++ = c - 32;
        }
        else {
            *temp++ = c;
        }
        flag = NO;
    }
    NSString *result = [[NSString alloc] initWithCString:desc
                                                encoding:NSUTF8StringEncoding];
    free(desc);
#if __has_feature(objc_arc)
    return result;
#else
    return [result autorelease];
#endif
}

@end
