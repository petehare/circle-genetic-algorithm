//
//  Circle.h
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject

@property CGPoint position;
@property CGFloat radius;

- (BOOL)overlapsWithCircle:(Circle *)circle;

@end
