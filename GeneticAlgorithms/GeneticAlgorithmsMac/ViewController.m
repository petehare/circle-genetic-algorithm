//
//  ViewController.m
//  GeneticAlgorithmsMac
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "ViewController.h"

#import "Algorithm.h"
#import "Board.h"
#import "BoardLayer.h"

@interface ViewController ()

@property Algorithm *algorithm;
@property Board *board;
@property BoardLayer *boardLayer;

@property (weak) IBOutlet NSTextField *generationCountLabel;
@property (weak) IBOutlet NSTextField *chromosomeLabel;
@property (weak) IBOutlet NSTextField *centerChromosomeLabel;
@property (weak) IBOutlet NSTextField *radiusChromosomeLabel;

@property (weak) IBOutlet NSProgressIndicator *activityIndicator;
@property (weak) IBOutlet NSView *boardView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _algorithm = [[Algorithm alloc] init];
        [self newBoard];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.boardView.layer = self.boardLayer;
    self.boardView.wantsLayer = YES;
}

- (void)newBoard {
    self.board = [Board boardWithNumberOfCircles:20];
    self.boardLayer = [[BoardLayer alloc] initWithBoard:_board];
    
    self.boardLayer.shouldRasterize = YES;
    self.boardView.layer = self.boardLayer;
    self.boardView.wantsLayer = YES;
    [self.boardLayer setNeedsDisplay];
    
    self.algorithm.board = self.board;
}

- (IBAction)newBoardButtonPressed:(id)sender {
    [self newBoard];
}

- (IBAction)startButtonPressed:(id)sender {
    
    if (self.algorithm.isRunning) {
        [self.algorithm stop];
        return;
    }
    
    [self.activityIndicator startAnimation:sender];
    
    [self.algorithm runWithCompletion:^(AlgorithmResult *result) {
        self.generationCountLabel.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)result.numberOfGenerations];
        self.chromosomeLabel.stringValue = result.chromosome.chromosomeString;
        self.centerChromosomeLabel.stringValue = NSStringFromPoint(result.chromosome.circle.position);
        self.radiusChromosomeLabel.stringValue = [@(result.chromosome.circle.radius) stringValue];
        
        self.boardLayer.mainCircle = result.chromosome.circle;
        [self.activityIndicator stopAnimation:sender];
        
    } progress:^(AlgorithmResult *result) {
        self.generationCountLabel.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)result.numberOfGenerations];
        self.chromosomeLabel.stringValue = result.chromosome.chromosomeString;
        self.centerChromosomeLabel.stringValue = NSStringFromPoint(result.chromosome.circle.position);
        self.radiusChromosomeLabel.stringValue = [@(result.chromosome.circle.radius) stringValue];
        
        self.boardLayer.mainCircle = result.chromosome.circle;
    }];
}

@end
