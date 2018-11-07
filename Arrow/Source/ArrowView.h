//
//  ArrowView.h
//  Arrow
//
//  Created by Karl Johan Lemon-Drougge on 2018-11-07.
//  Copyright © 2018 Codefork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ArrowViewDelegate <NSObject>
@optional
- (void)arrowViewGestureRecognizerStateBegan:(UIPanGestureRecognizer *)recognizer;
- (void)arrowViewGestureRecognizerStateChanged:(UIPanGestureRecognizer *)recognizer;
- (void)arrowViewGestureRecognizerStateEnded:(UIPanGestureRecognizer *)recognizer;
@end

typedef NS_ENUM(NSUInteger, ArrowPosition) {
    ArrowPositionUp,
    ArrowPositionDown,
    ArrowPositionMiddle,
};

@interface ArrowView : UIView

@property (nonatomic, weak) id<ArrowViewDelegate> delegate;

- (void)updateToArrowPosition:(ArrowPosition)arrowPosition animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
