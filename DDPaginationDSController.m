//
//  DDPaginationDSController.m
//  VKGifs
//
//  Created by Dmitry Danilov on 10.04.16.
//  Copyright © 2016 Dmitry Danilov. All rights reserved.
//

#import "DDPaginationDSController.h"

@interface DDPaginationDSController ()

@property (nonatomic, assign) NSInteger paginationCount;
@property (nonatomic, copy) void (^loadDataBlock)(NSInteger count, NSInteger offset, void (^success)(NSArray *data, BOOL lastPage), void (^failure)(NSError *error));
@property (nonatomic, copy) void (^updateBlock)(NSArray *newData, NSArray *dataSource);

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL pageIsLoading;
@property (nonatomic, assign) BOOL lasePageLoaded;

@end

@implementation DDPaginationDSController

- (instancetype)initWithPaginationCount:(NSInteger)count
                               loadData:(void (^)(NSInteger count, NSInteger offset,
                                                       void (^success)(NSArray *data, BOOL lastPage), void (^failure)(NSError *error)))loadData
                                 update:(void (^)(NSArray *newData, NSArray *dataSource))update {
    self = [super init];
    if (self) {
        [self setPaginationCount:count];
        [self setLoadDataBlock:loadData];
        [self setUpdateBlock:update];
        
        _currentPage = 0;
        _pageIsLoading = NO;
    }
    return self;
}

- (void)loadFirstPage {
    @synchronized(self) {
        if (!_pageIsLoading) {
            _pageIsLoading = YES;
            _dataSource = [[NSArray alloc] init];
            [self loadPage:0];
        }
    }
}
- (void)loadNextPageAtCurrentIndex:(NSInteger)index {
    @synchronized(self) {
        if (!_lasePageLoaded) {
            BOOL correctIndex = index >= _paginationCount*_currentPage && index <= _paginationCount*(_currentPage+1);
            if (correctIndex &&!_pageIsLoading) {
                _pageIsLoading = YES;
                [self loadPage:_currentPage+1];
            }
        }
    }
}

- (void)loadPage:(NSInteger)page {
    __weak typeof(self) wSelf = self;
    void (^successBlock)(NSArray *data, BOOL lastPage) = ^(NSArray *data, BOOL lastPage) {
        wSelf.currentPage = page;
        wSelf.pageIsLoading = NO;
        wSelf.lasePageLoaded = lastPage;
        [wSelf dataSourceAppendData:data];
        if (wSelf.updateBlock)
            wSelf.updateBlock(data, wSelf.dataSource);
    };
    
    void (^failureBlock)(NSError *error) = ^(NSError *error) {
        _pageIsLoading = NO;
    };
    
    if (_loadDataBlock) {
        _loadDataBlock(_paginationCount, _paginationCount*page, successBlock, failureBlock);
    }
}

- (void)dataSourceAppendData:(NSArray *)data {
    _dataSource = [_dataSource arrayByAddingObjectsFromArray:data];
}

@end
