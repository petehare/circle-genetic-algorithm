//
//  Circle.m
//  GeneticAlgorithms
//
//  Created by Pete Hare on 1/11/15.
//  Copyright (c) 2015 PJHare. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (BOOL)overlapsWithCircle:(Circle *)circle {
    CGPoint distance = CGPointMake(self.position.x - circle.position.x, self.position.y - circle.position.y);
    CGFloat distanceSquare = [self dotProduct:distance rightPoint:distance];
    
    if(distanceSquare > ((self.radius + circle.radius) * (self.radius + circle.radius))) {
        return false;
    }
    
    return true;
}

- (CGFloat)dotProduct:(CGPoint)leftPoint rightPoint:(CGPoint)rightPoint {
    return leftPoint.x * rightPoint.x + leftPoint.y * rightPoint.y;
}

@end
