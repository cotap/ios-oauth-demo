//
//  YMHTTPClient.m
//
// Copyright (c) 2013 Yammer, Inc. All rights reserved.
//

#import "YMLoginController.h"
#import "YMHTTPClient.h"
#import "AFNetworking.h"
#import "NSURL+YMQueryParameters.h"
#import <sys/utsname.h>

@interface YMHTTPClient ()

@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, strong) NSURL *baseURL;

@end

@implementation YMHTTPClient
{
    AFHTTPRequestOperationManager *_requestManager;
    NSString *_authToken;
}

- (void)setAuthToken:(NSString *)authToken
{
    _authToken = authToken;
    [self updateAuthToken];
}

- (NSString *)authToken
{
    return _authToken;
}

- (void)updateAuthToken
{
    NSString *headerField = @"Authorization";
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.authToken];
    [self.requestManager.requestSerializer setValue:value forHTTPHeaderField:headerField];
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    
    if (self) {
        _baseURL = baseURL;
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)baseURL authToken:(NSString *)authToken
{
    self = [self initWithBaseURL:baseURL];
    
    if (self) {
        _authToken = authToken;
    }
    
    return self;
}

- (AFHTTPRequestOperationManager *)requestManager
{
    if (_requestManager)
        return _requestManager;
    
    _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    [_requestManager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    if (self.authToken) {
        [self updateAuthToken];
    }
    
    return _requestManager;
}

//example: Yammer/4.0.0.141 (iPhone; iPhone OS 5.0.1; tr_TR; en)
- (NSString *)userAgent
{
    //Yammer/{app_version} ({Device type, eg: iPhone/iPad/iPod}; {iOS version}; {locale}; {language})
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    // Device Name (e.g. iPhone2,1 or iPad3,1 or x86_64 for simulator)
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *localeName = [[NSLocale currentLocale] localeIdentifier];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *userAgent = [NSString stringWithFormat:@"Yammer/%@ (%@; %@ %@; %@; %@)", appVersion, deviceModel, systemName, systemVersion, localeName, language];
    return userAgent;
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure
{
    NSLog(@"GET %@", path);
    [self.requestManager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSInteger statusCode, NSError *error))failure
{
    NSLog(@"POST %@", path);
    [self.requestManager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Forward the error
        NSHTTPURLResponse *response = [operation response];
        NSInteger statusCode = [response statusCode];
        failure(statusCode, error);
        
    }];
}

@end
