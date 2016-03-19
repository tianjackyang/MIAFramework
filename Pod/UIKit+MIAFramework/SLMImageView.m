#import "SLMImageView.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <CommonCrypto/CommonDigest.h>

@interface SLMImageView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSMutableData *imageData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString *urlString;

@end

@implementation SLMImageView

- (void)dealloc
{
    self.activityView = nil;
    self.imageData = nil;
    self.connection = nil;
    self.urlString = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.hidesWhenStopped = YES;
    self.activityView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:self.activityView];
#if !__has_feature(objc_arc)
    [self.activityView release];
#endif
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.activityView) {
        [self.activityView setCenter:CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2)];
    }
}

- (NSString *)cachePath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *pathname = [pathArray objectAtIndex:0];
    pathname = [pathname stringByAppendingPathComponent:@"ImageCache"];
    
    BOOL isDirectory;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:pathname isDirectory:&isDirectory];
    if (!isExist || (isExist && !isDirectory)) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:pathname withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            
        }
    }
    
    return pathname;
}

- (NSString *)cachedFileNameForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (UIImage *)imageWithLocalName:(NSString *)imageName
{
    NSString *path = [[self cachePath] stringByAppendingPathComponent:imageName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (!data) {
        return nil;
    }
    
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        return image;
    }
    return nil;
}

- (void)cancelPreviousLoadRequest
{
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    if (self.imageData) {
        self.imageData = nil;
    }
    
    if (self.activityView && self.activityView.isAnimating) {
        [self.activityView stopAnimating];
    }
}


#pragma mark -
#pragma mark -

- (void)setImageWithURLString:(NSString *)string
{
    self.urlString = string;
    [self loadImage];
}

- (void)loadImage
{
    [self cancelPreviousLoadRequest];
    
    NSString *localName = [self cachedFileNameForKey:self.urlString];
    
    UIImage *image = [self imageWithLocalName:localName];
    if (image) {
        self.image = image;
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView startAnimating];
    });
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                       delegate:self
                                               startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSRunLoopCommonModes];
    [self.connection start];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.imageData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
        [self cancelPreviousLoadRequest];
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *localName = [self cachedFileNameForKey:self.urlString];
    NSString *localPath = [[self cachePath] stringByAppendingPathComponent:localName];
    
    [self.imageData writeToFile:localPath atomically:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage imageWithData:self.imageData];
        [self.activityView stopAnimating];
        [self cancelPreviousLoadRequest];
    });
}

@end
