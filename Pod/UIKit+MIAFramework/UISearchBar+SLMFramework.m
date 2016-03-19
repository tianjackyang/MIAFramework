#import "UISearchBar+SLMFramework.h"
#import "SLMFunctions.h"

@implementation UISearchBar (SLMFramework)

- (void)slm_setCancelButtonTitle:(NSString *)title
{
    UIButton *cancelButton = nil;
    
    if (slm_iOS7OrLater()) {
        UIView *topView = self.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    else {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    if (cancelButton){
        [cancelButton.superview sendSubviewToBack:cancelButton];
        [cancelButton setTitle:title forState:UIControlStateNormal];
    }
    
//    if (slm_iOS8OrLater()) {
        [self insertSubview:cancelButton atIndex:1];
//    }
}

@end
