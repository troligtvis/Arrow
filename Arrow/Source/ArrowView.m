//
//  ArrowView.m
//  Arrow
//
//  Created by Karl Johan Lemon-Drougge on 2018-11-07.
//  Copyright © 2018 Codefork. All rights reserved.
//

#import "ArrowView.h"

CGFloat const kArrowAnimationDuration = 0.30;

@implementation ArrowView {
    ArrowPosition arrowPosition;
    CAShapeLayer *arrowLayer;
    BOOL isDragging;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.layer.frame = self.bounds;
    self.backgroundColor = UIColor.clearColor;
    arrowPosition = ArrowPositionMiddle;

    arrowLayer = [CAShapeLayer layer];
    [arrowLayer setFillColor:UIColor.darkGrayColor.CGColor];
    [arrowLayer setFrame:self.bounds];
    [self.layer addSublayer:arrowLayer];

    [self updateToArrowPosition:arrowPosition animated:NO];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [_delegate arrowViewGestureRecognizerStateBegan:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [_delegate arrowViewGestureRecognizerStateEnded:recognizer];
            [self updateToArrowPosition:ArrowPositionMiddle animated:YES];
            isDragging = NO;
            break;
        case UIGestureRecognizerStateChanged:
            [_delegate arrowViewGestureRecognizerStateChanged:recognizer];
            if (!isDragging) {
                isDragging = YES;
                [self updateToArrowPosition:ArrowPositionDown animated:YES];
            }

            break;
        default: break;
    }
}

- (CGFloat)getArrowPosition:(ArrowPosition)arrowPosition {
    switch (arrowPosition) {
        case ArrowPositionUp: return -0.15625;
        case ArrowPositionDown: return 0.15625;
        case ArrowPositionMiddle: return 0.0;
    }
}

- (void)updateToArrowPosition:(ArrowPosition)arrowPosition animated:(BOOL)animated {
    CGPathRef oldPath = arrowLayer.path;
    CGPathRef newPath = [self arrowPathWithValue: [self getArrowPosition:arrowPosition]].CGPath;

    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];

        [animation setFromValue:(__bridge id)(oldPath)];
        [animation setToValue:(__bridge id)(newPath)];
        [animation setDuration:kArrowAnimationDuration];
        [animation setBeginTime:CACurrentMediaTime()];
        [animation setFillMode: kCAFillModeBackwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [arrowLayer addAnimation:animation forKey:animation.keyPath];
    }

    arrowLayer.path = newPath;
    self->arrowPosition = arrowPosition;
}

- (UIBezierPath *)arrowPathWithValue:(CGFloat)value {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    [path moveToPoint:CGPointMake(minX + 0.8330 * width,
                                  minY + (0.43631 * height))];

    // Up
    [path addLineToPoint: CGPointMake(minX + 0.50000 * width,
                                      minY + (0.43631 + value) * height)];
    [path addLineToPoint: CGPointMake(minX + 0.16702 * width,
                                      minY + 0.43631 * height)];
    [path addCurveToPoint:CGPointMake(minX + 0.14545 * width,
                                      minY + 0.51972 * height)
            controlPoint1:CGPointMake(minX + 0.14754 * width,
                                      minY + 0.45044 * height)
            controlPoint2:CGPointMake(minX + 0.13788 * width,
                                      minY + 0.48781 * height)];
    [path addCurveToPoint:CGPointMake(minX + 0.16696 * width,
                                      minY + 0.56781 * height)
            controlPoint1:CGPointMake(minX + 0.15302 * width,
                                      minY + 0.55169 * height)
            controlPoint2:CGPointMake(minX + 0.16696 * width,
                                      minY + 0.56781 * height)];

    // Down
    [path addLineToPoint: CGPointMake(minX + 0.50000 * width,
                                      minY + (0.56791 + value) * height)];
    [path addLineToPoint: CGPointMake(minX + 0.83304 * width,
                                      minY + 0.56781 * height)];
    [path addCurveToPoint:CGPointMake(minX + 0.85457 * width,
                                      minY + 0.51972 * height)
            controlPoint1:CGPointMake(minX + 0.83304 * width,
                                      minY + 0.56781 * height)
            controlPoint2:CGPointMake(minX + 0.84698 * width,
                                      minY + 0.55166 * height)];
    [path addCurveToPoint:CGPointMake(minX + 0.83300 * width,
                                      minY + 0.43631 * height)
            controlPoint1:CGPointMake(minX + 0.86212 * width,
                                      minY + 0.48781 * height)
            controlPoint2:CGPointMake(minX + 0.85246 * width,
                                      minY + 0.45044 * height)];

    [path closePath];
    [path setMiterLimit:4];
    return path;
}

@end
