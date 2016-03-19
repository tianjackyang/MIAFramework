#import "SLMFunctions.h"
#import <CoreGraphics/CoreGraphics.h>

NSString *slm_fileNameWithNoExtension(char *filePath)
{
    if (!filePath) {
        return nil;
    }
    
    char *lastSlash = NULL;
    char *lastDot = NULL;
    
    char *p = (char *)filePath;
    while (*p) {
        if (*p == '/') {
            lastSlash = p;
        }
        else if (*p == '.') {
            lastDot = p;
        }
        p++;
    }
    
    char *subStr = lastSlash ? lastSlash + 1 : (char *)filePath;
    NSUInteger subLength = (lastDot ? : p) - subStr;
    
#if __has_feature(objc_arc)
    return [[NSString alloc] initWithBytesNoCopy:subStr
                                          length:subLength
                                        encoding:NSUTF8StringEncoding
                                    freeWhenDone:NO];
#else
    return [[[NSString alloc] initWithBytesNoCopy:subStr
                                           length:subLength
                                         encoding:NSUTF8StringEncoding
                                     freeWhenDone:NO] autorelease];
#endif
}


UIImage *slm_image(NSString *imageName)
{
    return [UIImage imageNamed:imageName];
}

UIImage *slm_large_image(NSString *imageName)
{
    NSString *suffix = @"png";
    if ([imageName hasSuffix:@".png"]) {
        imageName = [imageName substringToIndex:imageName.length - 4];
    }
    else if ([imageName hasSuffix:@".jpg"]) {
        imageName = [imageName substringToIndex:imageName.length - 4];
        suffix = @"jpg";
    }
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:imageName ofType:suffix];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
#if __has_feature(objc_arc)
    return image;
#else
    return [image autorelease];
#endif
}

/*
 if the device is iPhone4, assuming one picture named "icon.png",
 and it's real pixel size is 40*40pixels,
 then imageSize is 40*40, imageScale is 1.0, screenScale is 2.0.
 
 if the device is iPhone4, assuming one picture named "icon@2x.png",
 and it's real pixel size is 40*40pixels,
 then imageSize is 20*20, imageScale is 2.0, screenScale is 2.0.
 
 if the device is iPhone6+, assuming one picture named "icon.png",
 and it's real pixel size is 60*60pixels,
 then imageSize is 60*60, imageScale is 1.0, screenScale is 3.0.
 
 if the device is iPhone6+, assuming one picture named "icon@3x.png",
 and it's real pixel size is 60*60pixels,
 then imageSize is 20*20, imageScale is 3.0, screenScale is 3.0.

 so this function uses the 1*1pixel of the image's center,
 to resize and return a new image.
 */
UIImage *slm_resizeImage(NSString *imageName)
{
    UIImage *image = slm_image(imageName);
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width - 1;
    CGFloat height = imageSize.height - 1;
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height / 2, width / 2, height / 2, width / 2)];
    return newImage;
}

void slm_alert(NSString *message)
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(slm_bundleName(), slm_bundleName())
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
    [alertView show];
#if !__has_feature(objc_arc)
    [alertView release];
    alertView = nil;
#endif
}

NSString *slm_UUIDString()
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
#if __has_feature(objc_arc)
        uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
#else
        uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
#endif
        CFRelease(uuid);
    }
    return uuidString;
}

NSString *slm_GUIDString()
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
#if __has_feature(objc_arc)
        uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
#else
        uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
#endif
        CFRelease(uuid);
    }
    return [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
}