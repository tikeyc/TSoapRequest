//
//  APISoapClient.h
//  Florens
//
//  Created by tikeyc on 15/11/9.
//  Copyright © 2015年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ResultBlock) (id result,BOOL isDictionary,NSString *message);

@interface APISoapClient : NSObject

{
    NSMutableData *_webData;
    
}

@property (nonatomic,copy) ResultBlock resultBlock;
@property (nonatomic,assign) NSInteger statusCode;

@property (nonatomic, copy) NSString *soapMethodName;

- (NSURLConnection *)getDataAPIResultWithURL:(NSString *)url
                                      params:(NSMutableDictionary *)params
                                 htttpMethod:(NSString *)htttpMethod
                              withSOAPAction:(NSString *)soapAction
                              withMethodName:(NSString *)soapMethodName
                                withResultBlock:(ResultBlock)resultBock;

@end












