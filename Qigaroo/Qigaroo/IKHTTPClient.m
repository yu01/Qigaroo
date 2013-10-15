//
//  IKHTTPClient.m
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/16.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKHTTPClient.h"

@interface IKHTTPClient()
@property (strong, nonatomic) NSURL *baseURL;
@end


@implementation IKHTTPClient

+(IKHTTPClient *) sharedClient {
    static IKHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[IKHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMTLBaseURLString]];
    });
    
    return _sharedClient;
}

-(id) initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if(self){
        self.baseURL = url;
        [[self operationQueue] setMaxConcurrentOperationCount:8];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (NSURL*)relativeURLWithPathComponent:(NSString*)pathComponent
{
    return [self.baseURL URLByAppendingPathComponent:pathComponent];
}
@end
