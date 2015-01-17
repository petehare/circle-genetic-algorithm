//
//  Algorithm.h
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/10/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgorithmResult.h"

@class Board;

@interface Algorithm : NSObject

@property Board *board;
@property (readonly) BOOL isRunning;

- (void)runWithCompletion:(void(^)(AlgorithmResult *result))completion progress:(void(^)(AlgorithmResult *result))progress;
- (void)stop;

@end
