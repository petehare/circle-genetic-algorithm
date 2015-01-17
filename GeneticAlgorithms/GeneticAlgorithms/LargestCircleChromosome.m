//
//  Chromosome.m
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/10/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "LargestCircleChromosome.h"

/** Chromosome is divided up into 3 genes of length 10: centerX, centerY, and radius
 */
static NSInteger const kGeneLength = 10;
static NSInteger const kChromosomeLength = 3 * kGeneLength;

@interface LargestCircleChromosome ()

@property (copy, readwrite) NSString *chromosomeString;

@property (readwrite) Circle *circle;

@end

@implementation LargestCircleChromosome

+ (instancetype)chromosomeWithString:(NSString *)aString {
    LargestCircleChromosome *chromosome = [[self alloc] init];
    chromosome.chromosomeString = aString;
    return chromosome;
}

+ (instancetype)randomChromosome {
    LargestCircleChromosome *chromosome = [[self alloc] init];

    NSMutableString *chromosomeString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < kChromosomeLength; i++) {
        [chromosomeString appendString:[NSString stringWithFormat:@"%d", arc4random_uniform(2)]];
    }
    chromosome.chromosomeString = chromosomeString;
    return chromosome;
}

- (NSNumber *)numberFromBinaryString:(NSString *)binaryString {
    NSUInteger totalValue = 0;
    for (int i = 0; i < binaryString.length; i++) {
        totalValue += (int)([binaryString characterAtIndex:(binaryString.length - 1 - i)] - 48) * pow(2, i);
    }
    return @(totalValue);
}

- (void)setChromosomeString:(NSString *)chromosomeString {
    _chromosomeString = chromosomeString;
    
    NSString *centerXGene = [self.chromosomeString substringWithRange:NSMakeRange(0, kGeneLength)];
    NSNumber *centerX = [self numberFromBinaryString:centerXGene];
    NSString *centerYGene = [self.chromosomeString substringWithRange:NSMakeRange(kGeneLength, kGeneLength)];
    NSNumber *centerY = [self numberFromBinaryString:centerYGene];
    
    _circle = [[Circle alloc] init];
    _circle.position = CGPointMake([centerX floatValue], [centerY floatValue]);
    
    NSString *radiusGene = [self.chromosomeString substringWithRange:NSMakeRange(kGeneLength * 2, kGeneLength)];
    NSNumber *radius = [self numberFromBinaryString:radiusGene];
    _circle.radius = [radius floatValue];
}

@end
