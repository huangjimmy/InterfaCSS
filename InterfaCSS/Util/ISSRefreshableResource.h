//
//  ISSRefreshableResource.h
//  Part of InterfaCSS - http://www.github.com/tolo/InterfaCSS
//
//  Copyright (c) Tobias Löfstrand, Leafnode AB.
//  License: MIT (http://www.github.com/tolo/InterfaCSS/LICENSE)
//

#import <Foundation/Foundation.h>


extern NSString* const ISSRefreshableResourceErrorDomain;


typedef void (^ISSRefreshableResourceLoadCompletionBlock)(BOOL success, NSString* responseString, NSError* error);


@interface ISSRefreshableResource : NSObject

@property (nonatomic, readonly) NSURL* resourceURL;
@property (nonatomic, readonly) BOOL usingLocalFileChangeMonitoring;
@property (nonatomic, readonly) BOOL hasErrorOccurred;
@property (nonatomic, readonly) NSError* lastError;


- (instancetype) initWithURL:(NSURL*)url;

- (void) startMonitoringLocalFileChanges:(void (^)(ISSRefreshableResource*))callbackBlock;
- (void) endMonitoringLocalFileChanges;

- (void) refreshWithCompletionHandler:(ISSRefreshableResourceLoadCompletionBlock)completionHandler force:(BOOL)force;

@end
