#import "SLMAlertView.h"
#import "SLMFunctions.h"
@interface SLMAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) void (^block)(NSInteger index);

@end

@implementation SLMAlertView

- (void)dealloc
{
    self.block = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (void)showMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block
{
    SLMAlertView *alertView = [[SLMAlertView alloc] init];
    [alertView setTitle:NSLocalizedString(slm_bundleName(), slm_bundleName())];
    [alertView setMessage:message];
    [alertView setDelegate:alertView];
    for (NSString *buttonTitle in buttonTitles) {
        [alertView addButtonWithTitle:buttonTitle];
    }
    [alertView setBlock:block];
    [alertView show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

+ (void)showMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block
{
    SLMAlertView *alertView = [[SLMAlertView alloc] init];
    [alertView setTitle:NSLocalizedString(slm_bundleName(), slm_bundleName())];
    [alertView setMessage:message];
    [alertView setDelegate:alertView];
    for (NSString *buttonTitle in buttonTitles) {
        [alertView addButtonWithTitle:buttonTitle];
    }
    [alertView setBlock:block];
    [alertView show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block) {
        self.block(buttonIndex);
    }
}

@end
