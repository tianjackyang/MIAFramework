#import <UIKit/UIKit.h>

@interface UIAlertView (SLMFramework)

+ (void)slm_showMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block;

@end
