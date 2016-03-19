#import "UIImage+SLMFramework.h"

@implementation UIImage (SLMFramework)

- (UIImage *)slm_scaleToSize:(CGFloat)size
{
    CGImageRef imageRef = [self CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone) {
        alphaInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGFloat width, height;
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    if ((imageWidth > imageHeight ? imageWidth : imageHeight) > size) {
        if (imageWidth > imageHeight) {
            width = size;
            height = size * imageHeight / imageWidth;
        }
        else {
            height = size;
            width = size * imageWidth / imageHeight;
        }
    }
    else {
        width = imageWidth;
        height = imageHeight;
    }
    
    CGContextRef bitmap;
    if (self.imageOrientation == UIImageOrientationUp | self.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL,
                                       width,
                                       height,
                                       CGImageGetBitsPerComponent(imageRef),
                                       CGImageGetBytesPerRow(imageRef),
                                       colorSpaceInfo,
                                       (CGBitmapInfo)alphaInfo);
    }
    else {
        CGFloat tmp = width;
        width = height;
        height = tmp;
        
        bitmap = CGBitmapContextCreate(NULL,
                                       height,
                                       width,
                                       CGImageGetBitsPerComponent(imageRef),
                                       CGImageGetBytesPerRow(imageRef),
                                       colorSpaceInfo,
                                       (CGBitmapInfo)alphaInfo);
    }
    
    if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2);
        CGContextTranslateCTM (bitmap, 0, -height);
    }
    else if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2);
        CGContextTranslateCTM (bitmap, -width, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp) {
        
    }
    else if (self.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, width,height);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGColorSpaceRelease(colorSpaceInfo);
    CGImageRelease(ref);
    
    return result;
}

@end
