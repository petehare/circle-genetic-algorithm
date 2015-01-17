//
//  Board.m
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "Board.h"
#import "Circle.h"

CGSize const kBoardSize = (CGSize){800.f, 600.f};

static CGFloat const kMinimumCircleRadius = 10.f;
static CGFloat const kMaximumCircleRadius = 60.f;

@interface Board ()

@property (copy, readwrite) NSArray *circles;

@end

@implementation Board

+ (instancetype)boardWithNumberOfCircles:(NSUInteger)numberOfCircles {
    Board *board = [[self alloc] init];
    
    NSMutableArray *circles = [NSMutableArray array];
    for (NSUInteger i = 0; i < numberOfCircles; i++) {

        Circle *circle;
        while (circle == nil || [self numberOfOverlapsForCircle:circle withCirclesArray:circles] > 0) {
            circle = [[Circle alloc] init];
            circle.radius = (CGFloat)arc4random_uniform(kMaximumCircleRadius - kMinimumCircleRadius) + kMinimumCircleRadius;
            CGFloat centerX = arc4random_uniform(kBoardSize.width - 2 * circle.radius) + circle.radius;
            CGFloat centerY = arc4random_uniform(kBoardSize.height - 2 * circle.radius) + circle.radius;
            circle.position = CGPointMake(centerX, centerY);
        }
        
        [circles addObject:circle];
    }
    board.circles = circles;
    
    return board;
}

+ (NSUInteger)numberOfOverlapsForCircle:(Circle *)circle withCirclesArray:(NSArray *)circles {
    __block NSUInteger overlapsFound = 0;
    [circles enumerateObjectsUsingBlock:^(Circle *existingCircle, NSUInteger idx, BOOL *stop) {
        if ([existingCircle overlapsWithCircle:circle]) {
            overlapsFound++;
        }
    }];
    return overlapsFound;
}

- (NSUInteger)numberOfOverlapsForCircle:(Circle *)circle {
    return [[self class] numberOfOverlapsForCircle:circle withCirclesArray:self.circles];
}

@end
