//
//  Algorithm.m
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/10/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "Algorithm.h"
#import "AlgorithmResult.h"
#import "LargestCircleChromosome.h"

#import "Board.h"

#import "NSArray+RHObjectAdditions.h"

static NSUInteger const kPopulationSize = 60;
static CGFloat const kCrossOverRate = 0.7;
static CGFloat const kMutationRate = 0.05;

@interface Algorithm ()

@property (copy) NSArray *population;
@property (readwrite) BOOL isRunning;

@end

@implementation Algorithm

- (instancetype)init {
    self = [super init];
    if (self) {
        srand48(time(0));
    }
    return self;
}

- (void)generateRandomPopulation {
    NSMutableArray *population = [NSMutableArray array];
    for (NSUInteger i = 0; i < kPopulationSize; i++) {
        [population addObject:[LargestCircleChromosome randomChromosome]];
    }
    self.population = population;
}

- (void)runWithCompletion:(void(^)(AlgorithmResult *result))completion progress:(void(^)(AlgorithmResult *result))progress {
    self.isRunning = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self generateRandomPopulation];
        
        __block NSUInteger generationCount = 0;
        
        while (self.isRunning == YES) {
            [self.population enumerateObjectsUsingBlock:^(LargestCircleChromosome *chromosome, NSUInteger idx, BOOL *stop) {
                chromosome.fitness = [self fitnessScoreForChromosome:chromosome];
            }];
            generationCount++;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AlgorithmResult *algorithmProgress = [AlgorithmResult resultWithChromosome:[self fittestChromosome] generations:generationCount];
                progress(algorithmProgress);
            });
            
            [self breedGeneration];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.isRunning = NO;
            
            AlgorithmResult *algorithmResult = [AlgorithmResult resultWithChromosome:[self fittestChromosome] generations:generationCount];
            completion(algorithmResult);
        });
    });
}

- (void)stop {
    self.isRunning = NO;
}

- (LargestCircleChromosome *)fittestChromosome {
    __block LargestCircleChromosome *fittestChromosome;
    [self.population enumerateObjectsUsingBlock:^(LargestCircleChromosome *chromosome, NSUInteger idx, BOOL *stop) {
        if (chromosome.fitness >= fittestChromosome.fitness) {
            fittestChromosome = chromosome;
        }
    }];
    return fittestChromosome;
}

- (CGFloat)fitnessScoreForChromosome:(LargestCircleChromosome *)chromosome {

    CGRect circleRect = CGRectMake(chromosome.circle.position.x - chromosome.circle.radius, chromosome.circle.position.y - chromosome.circle.radius, chromosome.circle.radius * 2.f, chromosome.circle.radius * 2.f);
    CGRect intersectWithBoard = CGRectIntersection(circleRect, CGRectMake(0.f, 0.f, kBoardSize.width, kBoardSize.height));
    
    // Out of bounds
    if (CGRectEqualToRect(intersectWithBoard, circleRect) == NO) return 0.f;
    
    // Overlaps with another circle
    NSUInteger numberOfOverlaps = [self.board numberOfOverlapsForCircle:chromosome.circle];
    if (numberOfOverlaps > 0) return 0.f;

    return powf(2.f, chromosome.circle.radius);
}

- (void)breedGeneration {
    NSMutableArray *newPopulation = [NSMutableArray array];
    while (newPopulation.count < kPopulationSize) {
        
        NSArray *chromosomePair = [self selectWeightedRandomChromosomes:2];
        
        NSArray *newChromosomePair;
        if (drand48() < kCrossOverRate && chromosomePair.count > 1) {
            newChromosomePair = [self crossOverChromosome:chromosomePair[0] withCromosome:chromosomePair[1]];
        } else {
            newChromosomePair = chromosomePair;
        }

        [newPopulation addObjectsFromArray:newChromosomePair];
    }
    self.population = newPopulation;
}

- (NSArray *)selectWeightedRandomChromosomes:(NSUInteger)numberToSelect {
    
    NSMutableArray *chromosomes = [NSMutableArray array];
    if (numberToSelect > 1) {
        [chromosomes addObjectsFromArray:[self selectWeightedRandomChromosomes:(numberToSelect - 1)]];
    }
    
    NSArray *remainingPopulation = [self.population arrayByRemovingObjectsFromArray:chromosomes];
    __block CGFloat totalFitness = 0;
    [remainingPopulation enumerateObjectsUsingBlock:^(LargestCircleChromosome *chromosome, NSUInteger idx, BOOL *stop) {
        totalFitness += chromosome.fitness;
    }];
    CGFloat selectedFitness = drand48() * totalFitness;
    
    __block CGFloat iteratingFitness = 0.f;
    [remainingPopulation enumerateObjectsUsingBlock:^(LargestCircleChromosome *chromosome, NSUInteger idx, BOOL *stop) {
        iteratingFitness += chromosome.fitness;
        if (iteratingFitness >= selectedFitness) {
            [chromosomes addObject:chromosome];
            *stop = YES;
        }
    }];

    return chromosomes;
}

- (NSArray *)crossOverChromosome:(LargestCircleChromosome *)chromosomeOne withCromosome:(LargestCircleChromosome *)chromosomeTwo {
    if (chromosomeOne.chromosomeString.length == 0 || chromosomeTwo.chromosomeString.length == 0) return nil;
    
    NSUInteger splitPoint = arc4random_uniform((UInt32)chromosomeOne.chromosomeString.length);

    NSMutableString *chromosomeStringOne = [[NSMutableString alloc] init];
    [chromosomeStringOne appendString:[chromosomeOne.chromosomeString substringWithRange:NSMakeRange(0, splitPoint)]];
    [chromosomeStringOne appendString:[chromosomeTwo.chromosomeString substringWithRange:NSMakeRange(splitPoint, chromosomeTwo.chromosomeString.length - splitPoint)]];
    
    NSMutableString *chromosomeStringTwo = [[NSMutableString alloc] init];
    [chromosomeStringTwo appendString:[chromosomeOne.chromosomeString substringWithRange:NSMakeRange(splitPoint, chromosomeOne.chromosomeString.length - splitPoint)]];
    [chromosomeStringTwo appendString:[chromosomeTwo.chromosomeString substringWithRange:NSMakeRange(0, splitPoint)]];
    
    [self mutateChromosomeString:chromosomeStringOne];
    [self mutateChromosomeString:chromosomeStringTwo];
    
    return @[[LargestCircleChromosome chromosomeWithString:chromosomeStringOne], [LargestCircleChromosome chromosomeWithString:chromosomeStringTwo]];
}

- (void)mutateChromosomeString:(NSMutableString *)chromosomeString {
    for (NSUInteger i = 0; i < chromosomeString.length; i++) {
        if (drand48() > kMutationRate) continue;
        NSString *currentValue = [chromosomeString substringWithRange:NSMakeRange(i, 1)];
        [chromosomeString replaceCharactersInRange:NSMakeRange(i, 1) withString:[currentValue isEqualToString:@"0"] ? @"1" : @"0"];
    }
}

@end
