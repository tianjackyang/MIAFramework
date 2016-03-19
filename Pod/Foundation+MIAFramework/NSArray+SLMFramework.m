#import "NSArray+SLMFramework.h"

@implementation NSArray (SLMFramework)

- (NSString *)slm_JSONRepresentation
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    

    if (!data || error) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
#if __has_feature(objc_arc)
    return string;
#else
    return [string autorelease];
#endif
}

- (NSMutableArray *)slm_mutableDeepCopy
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];
    int i;
    for (i = 0; i < self.count; i++) {
        id object = [self objectAtIndex:i];
        id copyObject = nil;
        if ([object respondsToSelector:@selector(slm_mutableDeepCopy)]) {
            copyObject = [object slm_mutableDeepCopy];
        }
        else if ([object respondsToSelector:@selector(mutableCopy)]) {
            copyObject = [object mutableCopy];
        }
        else {
            copyObject = [object copy];
        }
        [results addObject:copyObject];
    }
    return results;
}

@end
