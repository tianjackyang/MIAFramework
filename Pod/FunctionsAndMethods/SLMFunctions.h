#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define SLMAllocAndAutoReleaseObject(class)     [[class alloc] init];
#define SLMAutoRelease(obj)                     obj;
#define SLMRelease(obj)
#define SLMReleaseSafely(obj)
#else
#define SLMAllocAndAutoReleaseObject(class)     [[class alloc] init] autorelease];
#define SLMAutoRelease(obj)                     [obj autorelease];
#define SLMRelease(obj)                         [obj release];
#define SLMReleaseSafely(obj)                   [obj release]; obj = nil;
#endif

#if DEBUG
#define SLMLog(frmt, ...)                       DDLogDebug((frmt), ##__VA_ARGS__);
#define SLMLogObject(obj)                       DDLogDebug(@"%s = %@", #obj, obj);
#else
#define SLMLog(frmt, ...)
#define SLMLogObject(obj)
#endif

//system version
static inline BOOL slm_iOS5OrLater();
static inline BOOL slm_iOS6OrLater();
static inline BOOL slm_iOS7OrLater();
static inline BOOL slm_iOS8OrLater();

//device type
static inline BOOL slm_isiPhone4Or4S();
static inline BOOL slm_isiPhone5();
static inline BOOL slm_isiPhone6();
static inline BOOL slm_isiPhone6Plus();

//common app frame size
static inline CGFloat slm_appFrameWidth();
static inline CGFloat slm_appFrameHeight();

//method name && file name
#define SLM_Method_Name             (NSStringFromSelector(_cmd))
#define SLM_File_Name               (slm_fileNameWithNoExtension(__FILE__))
extern NSString *slm_fileNameWithNoExtension(char *filePath);

//bundle name && so on
static inline NSString *slm_bundleName();
static inline NSString *slm_bundleVersion();
static inline NSString *slm_bundleIdentifier();

//easy way to load image
extern UIImage *slm_image(NSString *imageName);
extern UIImage *slm_large_image(NSString *imageName);
//easy way for resizableImageWithCapInsets, default from center of the origin image.
extern UIImage *slm_resizeImage(NSString *imageName);

//easy way to get UIColor object
static inline UIColor *slm_rgbColor(float red, float green, float blue);

//easy way to show alert
extern void slm_alert(NSString *message);

//easy way to get paths
static inline NSString *slm_documentsPath();
static inline NSString *slm_libraryPath();
static inline NSString *slm_cachesPath();

extern NSString *slm_UUIDString();
extern NSString *slm_GUIDString();

/*** Definitions of inline functions. ***/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

BOOL slm_iOS5OrLater() {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) ? : NO;
}

BOOL slm_iOS6OrLater() {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) ? : NO;
}

BOOL slm_iOS7OrLater() {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? : NO;
}

BOOL slm_iOS8OrLater() {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? : NO;
}

BOOL slm_isiPhone4Or4S()
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect iphone4Or4s = CGRectMake(0, 0, 320, 480);
    return (CGRectEqualToRect(bounds, iphone4Or4s)) ? YES : NO;
}

BOOL slm_isiPhone5()
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect iphone5 = CGRectMake(0, 0, 320, 568);
    return (CGRectEqualToRect(bounds, iphone5)) ? YES : NO;
}

BOOL slm_isiPhone6()
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect iphone5 = CGRectMake(0, 0, 375, 667);
    return (CGRectEqualToRect(bounds, iphone5)) ? YES : NO;
}

BOOL slm_isiPhone6Plus()
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect iphone5 = CGRectMake(0, 0, 414, 736);
    return (CGRectEqualToRect(bounds, iphone5)) ? YES : NO;
}

CGFloat slm_appFrameWidth()
{
    return [[UIScreen mainScreen] applicationFrame].size.width;
}

CGFloat slm_appFrameHeight()
{
    return slm_iOS7OrLater() ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] applicationFrame].size.height;
}

NSString *slm_bundleName()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

NSString *slm_bundleVersion()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

NSString *slm_bundleIdentifier()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

UIColor *slm_rgbColor(float red, float green, float blue)
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

NSString *slm_documentsPath()
{
    //because in simulator, the correct library path is the first one, so we use "objectAtIndex:0" instead of "lastObject"
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) objectAtIndex:0];
}

NSString *slm_libraryPath()
{
    //same as above
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, YES) objectAtIndex:0];
}

NSString *slm_cachesPath()
{
    //same as above
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSAllDomainsMask, YES) objectAtIndex:0];
}

#pragma clang diagnostic pop
