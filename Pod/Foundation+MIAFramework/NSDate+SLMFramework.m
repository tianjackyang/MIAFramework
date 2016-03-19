#import "NSDate+SLMFramework.h"
#import "SLMFunctions.h"

@implementation NSDate (SLMFramework)

- (NSString *)slm_dayString
{
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dayString = [formatter stringFromDate:self];
#if !__has_feature(objc_arc)
    [formatter release];
#endif
    return dayString;
}

- (NSString *)slm_dateString
{
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [formatter stringFromDate:self];
#if !__has_feature(objc_arc)
    [formatter release];
#endif
	return dateString;
}


@end
