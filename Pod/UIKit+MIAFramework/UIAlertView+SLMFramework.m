#import "UIAlertView+SLMFramework.h"
#import "SLMFunctions.h"
#import <objc/runtime.h>

static char blockKey;

typedef void (^SLMAlertViewBlock)(NSInteger index);

@implementation UIAlertView (SLMFramework)

+ (void)slm_showMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setTitle:NSLocalizedString(slm_bundleName(), slm_bundleName())];
    [alertView setMessage:message];
    [alertView setDelegate:alertView];
    for (NSString *buttonTitle in buttonTitles) {
        [alertView addButtonWithTitle:buttonTitle];
    }
    objc_setAssociatedObject(alertView, &blockKey, [block copy], OBJC_ASSOCIATION_ASSIGN);
    [alertView show];
#if !__has_feature(objc_arc)
    [alertView release];
#endif
}

+ (void)slm_showMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setTitle:NSLocalizedString(slm_bundleName(), slm_bundleName())];
    [alertView setMessage:message];
    [alertView setDelegate:alertView];
    for (NSString *buttonTitle in buttonTitles) {
        [alertView addButtonWithTitle:buttonTitle];
    }
    objc_setAssociatedObject(alertView, &blockKey, [block copy], OBJC_ASSOCIATION_ASSIGN);
    [alertView show];
#if !__has_feature(objc_arc)
    [alertView release];
#endif
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SLMAlertViewBlock block = objc_getAssociatedObject(alertView, &blockKey);
    block(buttonIndex);
#if !__has_feature(objc_arc)
    [block release];
#endif
}
@end
