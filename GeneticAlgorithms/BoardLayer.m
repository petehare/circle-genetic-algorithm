//
//  BoardViewModel.m
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "BoardLayer.h"

#import "Board.h"
#import "Circle.h"

@interface BoardLayer ()

@property Board *board;

@end

@implementation BoardLayer

- (instancetype)initWithBoard:(Board *)aBoard {
    self = [super init];
    if (self) {
        self.board = aBoard;
        self.needsDisplayOnBoundsChange = YES;
    }
    return self;
}

- (void)setMainCircle:(Circle *)mainCircle {
    _mainCircle = mainCircle;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    CGColorRef backgroundColor = CGColorCreateGenericGray(0.3f, 1.f);
    CGContextSetFillColorWithColor(ctx, backgroundColor);
    CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kBoardSize.width, kBoardSize.height));
    
    CGColorRef circleColor = CGColorCreateGenericGray(1.f, 1.f);
    CGContextSetFillColorWithColor(ctx, circleColor);
    [self.board.circles enumerateObjectsUsingBlock:^(Circle *circle, NSUInteger idx, BOOL *stop) {
        CGContextAddEllipseInRect(ctx, CGRectMake(circle.position.x - circle.radius, circle.position.y - circle.radius, circle.radius * 2.f, circle.radius * 2.f));
        
    }];
    CGContextFillPath(ctx);
    
    if (self.mainCircle == nil) return;
    
    CGColorRef mainCircleColor = CGColorCreateGenericRGB(1.f, 0.2f, 0.2f, 1.f);
    CGContextSetFillColorWithColor(ctx, mainCircleColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(self.mainCircle.position.x - self.mainCircle.radius, self.mainCircle.position.y - self.mainCircle.radius, self.mainCircle.radius * 2.f, self.mainCircle.radius * 2.f));
    CGContextFillPath(ctx);
    
    CGColorRelease(backgroundColor);
    CGColorRelease(circleColor);
    CGColorRelease(mainCircleColor);
}

@end
