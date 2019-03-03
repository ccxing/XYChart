//
//  NSArray+Map1.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "NSArray+XYChart.h"

@implementation NSArray (XYChart)

- (NSArray *)xy_map:(nonnull id (^)(id obj, NSUInteger idx))block
{
    NSAssert(block!=nil, @"block 不能为空, 但还是做了保护");
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        id value = block ? block(object, index) : [NSNull null];
        [result addObject:value];
    }];
    
    return [NSArray arrayWithArray:result];
}

- (id)xy_max:(NSComparisonResult (^)(id, id))block
{
    NSAssert(block!=nil, @"block 不能为空, 但还是做了保护");

    if (self.count==0) { return nil; }
    if (self.count==1) { return self.firstObject;}
    id max = self.firstObject;
    for (int i=1; i<self.count; i++) {
        if (block(max, self.xy_safeIdx(i)) == NSOrderedAscending) {
            max = self.xy_safeIdx(i);
        }
    }
    return max;
}

- (id)xy_min:(NSComparisonResult (^)(id, id))block
{
    NSAssert(block!=nil, @"block 不能为空, 但还是做了保护");

    if (self.count==0) { return nil; }
    if (self.count==1) { return self.firstObject;}
    id min = self.firstObject;
    for (int i=1; i<self.count; i++) {
        if (block(min, self.xy_safeIdx(i)) == NSOrderedDescending) {
            min = self.xy_safeIdx(i);
        }
    }
    return min;
}

- (NSArray *)xy_flatMap:(id (^)(id obj))block {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id _obj = block(obj);
        if ([_obj isKindOfClass:[NSArray class]]) {
            NSArray *_array = [_obj xy_flatMap:block];
            [mutableArray addObjectsFromArray:_array];
            return;
        }
        [mutableArray addObject:_obj];
    }];
    return [mutableArray copy];
}


- (id  _Nonnull (^)(NSUInteger))xy_safeIdx
{
    __weak typeof(self) weakSelf = self;
    id (^block)(NSUInteger index) = ^(NSUInteger index) {
        return (weakSelf.count-1)<index ? nil : weakSelf[index];
    };
    return block;
}

@end


@implementation NSMutableArray (XYChart)

- (void (^)(id _Nonnull))xy_safeAdd
{
    __weak typeof(self) weakSelf = self;
    void (^block)(id obj) = ^(id obj) {
        if (obj) {
            [weakSelf addObject:obj];
        }
    };
    return block;
}

@end
