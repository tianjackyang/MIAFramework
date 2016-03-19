#import "UIView+SLMFramework.h"

@implementation UIView (SLMFramework)

- (void)slm_shake
{
    CGFloat t = 4;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    self.transform = translateLeft;
    
    [UIView animateWithDuration:0.07
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         [UIView setAnimationRepeatCount:2.0];
                         self.transform = translateRight;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             [UIView animateWithDuration:0.05
                                                   delay:0.0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.transform = CGAffineTransformIdentity;
                                              }
                                              completion:NULL];
                         }
                     }];
}

- (CGFloat)slm_left
{
    return self.frame.origin.x;
}

- (void)setSlm_left:(CGFloat)slm_left
{
    CGRect rect = self.frame;
    rect.origin.x = slm_left;
    self.frame = rect;
}

- (CGFloat)slm_right
{
    return self.slm_left + self.slm_width;
}

- (CGFloat)slm_top
{
    return self.frame.origin.y;
}

- (void)setSlm_top:(CGFloat)slm_top
{
    CGRect rect = self.frame;
    rect.origin.y = slm_top;
    self.frame = rect;
}

- (CGFloat)slm_bottom
{
    return self.slm_top + self.slm_height;
}

- (CGFloat)slm_width
{
    return self.frame.size.width;
}

- (void)setSlm_width:(CGFloat)slm_width
{
    CGRect rect = self.frame;
    rect.size.width = slm_width;
    self.frame = rect;
}

- (CGFloat)slm_height
{
    return self.frame.size.height;
}

- (void)setSlm_height:(CGFloat)slm_height
{
    CGRect rect = self.frame;
    rect.size.height = slm_height;
    self.frame = rect;
}

- (CGPoint)slm_origin
{
    return self.frame.origin;
}

- (void)setSlm_origin:(CGPoint)slm_origin
{
    CGRect rect = self.frame;
    rect.origin.x = slm_origin.x;
    rect.origin.y = slm_origin.y;
    self.frame = rect;
}

- (CGSize)slm_size
{
    return self.frame.size;
}

- (void)setSlm_size:(CGSize)slm_size
{
    CGRect rect = self.frame;
    rect.size.width = slm_size.width;
    rect.size.height = slm_size.height;
    self.frame = rect;
}
- (CGFloat)slm_centerX
{
    return self.center.x;
}

- (void)setSlm_centerX:(CGFloat)slm_centerX
{
    self.center = CGPointMake(slm_centerX, self.center.y);
}

- (CGFloat)slm_centerY
{
    return self.center.y;
}

- (void)setSlm_centerY:(CGFloat)slm_centerY
{
    self.center = CGPointMake(self.center.x, slm_centerY);
}

- (UITableViewCell *)slm_superTableViewCell
{
    UIView *currentView = self;
    UIView *superview = currentView.superview;
    while (superview && ![superview isKindOfClass:[UITableViewCell class]]) {
        currentView = superview;
        superview = currentView.superview;
    }
    return (UITableViewCell *)superview;
}

@end
