//
//  BoardViewModel.h
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@class Board;
@class Circle;

@interface BoardLayer : CALayer

@property (nonatomic) Circle *mainCircle;

- (instancetype)initWithBoard:(Board *)aBoard;

@end
