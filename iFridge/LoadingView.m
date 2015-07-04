//
//  LoadingView.m
//  ImageBlur
//
//  Created by Roman Utrata on 25.05.15.
//  Copyright (c) 2015 Roman Utrata. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()<UIGestureRecognizerDelegate>
@end


@implementation LoadingView

@synthesize loadIndicatorStyle;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (void)showWithView:(UIView*)superView {
    if (self.superview == superView) {
        return;
    }
    
    [self removeFromSuperview];
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.frame = [superView bounds];
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.userInteractionEnabled = YES;
    [superView addSubview:self];
    
//    UIActivityIndicatorView *indicator;
//    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:loadIndicatorStyle];
//    [self addSubview:indicator];
//    indicator.autoresizingMask =    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin;
//    [indicator startAnimating];
    
    CGRect rect = self.animImageView.frame;
    rect.origin.x = 0.5 * (self.frame.size.width - rect.size.width);
    rect.origin.y = 0.5 * (self.frame.size.height - rect.size.height);
    self.animImageView.frame = rect;
}

- (void)hideThreadSave {
    if ([NSThread isMainThread]) {
        [self removeFromSuperview];
    } else {
        [self performSelectorOnMainThread:@selector(removeFromSuperview)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

- (void)initGestureRecognizers {
    UIGestureRecognizer *recognizer = [UIGestureRecognizer new];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

- (id)init {
    return [self initWithLoadIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.loadIndicatorStyle = UIActivityIndicatorViewStyleGray;
        [self initGestureRecognizers];
    }
    return self;
}

- (id)initWithLoadIndicatorStyle:(UIActivityIndicatorViewStyle)aStyle {
    self = [super init];
    if (self != nil) {
        self.loadIndicatorStyle = aStyle;
        [self initGestureRecognizers];
    }
    return self;
}

@end
