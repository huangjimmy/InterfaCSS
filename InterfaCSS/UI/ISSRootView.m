//
//  ISSRootView.m
//  Part of InterfaCSS - http://www.github.com/tolo/InterfaCSS
//
//  Copyright (c) Tobias Löfstrand, Leafnode AB.
//  License: MIT (http://www.github.com/tolo/InterfaCSS/LICENSE)
//

#import "ISSRootView.h"

#import "UIView+InterfaCSS.h"
#import "ISSRectValue.h"


@implementation ISSRootView

- (void) commonInitWithView:(UIView*)view {
    self.wrappedRootView = view;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (id) init {
    if ( self = [super init] ) {
        [self commonInitWithView:nil];
        self.frame = [[ISSRectValue windowRect] rectForView:self];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame] ) {
        [self commonInitWithView:nil];
    }
    return self;
}

- (id) initWithView:(UIView*)view {
    if ( self = [super init] ) {
        [self commonInitWithView:view];
        self.frame = [[ISSRectValue windowRect] rectForView:self];
    }
    return self;
}

- (void) setWrappedRootView:(UIView*)wrappedRootView {
    if( wrappedRootView == _wrappedRootView ) return;
    [_wrappedRootView removeFromSuperview];
    _wrappedRootView = wrappedRootView;
    if( _wrappedRootView ) [self addSubview:_wrappedRootView];
}

- (void) setFrame:(CGRect)frame {
    BOOL frameModified = !CGRectEqualToRect(self.frame, frame);
    [super setFrame:frame];
    _wrappedRootView.frame = self.bounds;
    if( frameModified && ![InterfaCSS sharedInstance].useManualStyling ) [self scheduleApplyStylingISS]; // Note: This is only really needed if element contains relative ISSRectValue/ISSPointValue
}

- (void) didMoveToSuperview {
    [super didMoveToSuperview];
    if( self.superview && ![InterfaCSS sharedInstance].useManualStyling ) [self scheduleApplyStylingISS];
}

- (void) didMoveToWindow {
    [super didMoveToWindow];
    if( self.window && ![InterfaCSS sharedInstance].useManualStyling ) [self applyStylingISS];
}

@end
