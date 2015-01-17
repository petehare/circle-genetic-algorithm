//
//  AlgorithmResult.m
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/10/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "AlgorithmResult.h"

@implementation AlgorithmResult

+ (instancetype)resultWithChromosome:(LargestCircleChromosome *)chromosome generations:(NSUInteger)generations {
    AlgorithmResult *result = [[self alloc] init];
    result.chromosome = chromosome;
    result.numberOfGenerations = generations;
    return result;
}

@end
