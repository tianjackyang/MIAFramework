#import <UIKit/UIKit.h>

@interface SLMAlertView : UIAlertView

+ (void)showMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block;
+ (void)showMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles clickedAtIndex:(void (^)(NSInteger index))block;

@end
