//
//  Board.h
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Circle;

extern CGSize const kBoardSize;

@interface Board : NSObject

@property (copy, readonly) NSArray *circles;

+ (instancetype)boardWithNumberOfCircles:(NSUInteger)numberOfCircles;

- (NSUInteger)numberOfOverlapsForCircle:(Circle *)circle;

@end
