//
//  AlgorithmResult.h
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/10/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LargestCircleChromosome.h"

@interface AlgorithmResult : NSObject

@property LargestCircleChromosome *chromosome;
@property NSUInteger numberOfGenerations;

+ (instancetype)resultWithChromosome:(LargestCircleChromosome *)chromosome generations:(NSUInteger)generations;

@end
