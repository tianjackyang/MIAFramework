#import <UIKit/UIKit.h>

@interface UIButton (SLMFramework)

+ (UIButton *)slm_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font frame:(CGRect)frame backgroundImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target sel:(SEL)sel;
+ (UIButton *)slm_buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target sel:(SEL)sel;

@end
