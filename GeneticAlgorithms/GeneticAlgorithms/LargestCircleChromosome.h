//
//  Chromosome.h
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/10/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "Circle.h"

@interface LargestCircleChromosome : NSObject

@property (nonatomic, copy, readonly) NSString *chromosomeString;

@property (readonly) Circle *circle;

@property CGFloat fitness;

+ (instancetype)chromosomeWithString:(NSString *)aString;
+ (instancetype)randomChromosome;

@end
