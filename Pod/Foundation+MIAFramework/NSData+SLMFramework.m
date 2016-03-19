#import "NSData+SLMFramework.h"

@implementation NSData (SLMFramework)

- (id)slm_JSONValue
{
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:self
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    
    if (!obj || error) {
        return nil;
    }
    return obj;
}

@end
