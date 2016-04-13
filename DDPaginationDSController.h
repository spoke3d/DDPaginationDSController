//
//  DDPaginationDSController.h
//  VKGifs
//
//  Created by Dmitry Danilov on 10.04.16.
//  Copyright © 2016 Dmitry Danilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPaginationDSController : NSObject

@property (nonatomic, readonly) NSArray *dataSource;


- (instancetype)initWithPaginationCount:(NSInteger)count
                               loadData:(void (^)(NSInteger count, NSInteger offset,
                                                       void (^success)(NSArray *data, BOOL lastPage), void (^failure)(NSError *error)))loadData
                                 update:(void (^)(NSArray *newData, NSArray *dataSource))update;

- (void)loadFirstPage;
- (void)loadNextPageAtCurrentIndex:(NSInteger)index;

@end
