//
//  APISoapClient.m
//  Florens
//
//  Created by tikeyc on 15/11/9.
//  Copyright © 2015年 tikeyc. All rights reserved.
//

#import "APISoapClient.h"


#import "XMLReader.h"


@interface APISoapClient ()<NSURLConnectionDelegate>


@end

@implementation APISoapClient

/*
 NSString *soapMessage =
 [NSString stringWithFormat:
 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
 "<soap:Body>"
 "<Save xmlns=\"http://www.myapp.com/\">"
 "<par1>%i</par1>"
 "<par2>%@</par2>"
 "<par3>%@</par3>"
 "</Save>"
 "</soap:Body>"
 "</soap:Envelope>", par1, par2, par3
 ];
 NSURL *url = [NSURL URLWithString:@"http://....asmx"];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 
 NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
 
 [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
 [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
 
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
 
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
 operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 if([self.delegate respondsToSelector:@selector(myAppHTTPClientDelegate:didUpdateWithWeather:)]){
 [self.delegate myAppHTTPClientDelegate:self didUpdateWithWeather:responseObject];
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 if([self.delegate respondsToSelector:@selector(myAppHTTPClientDelegate:self:didFailWithError:)]){
 [self.delegate myAppHTTPClientDelegate:self didFailWithError:error];
 }
 }];
 
 [operation start];
 */

/*
 
 <?xml version="1.0"?>
 <soap:Envelope
 xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
 soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">
 
 <soap:Header>
 ...
 ...
 </soap:Header>
 
 <soap:Body>
 ...
 ...
 <soap:Fault>
 ...
 ...
 </soap:Fault>
 </soap:Body>
 
 </soap:Envelope>
 
 */


- (NSURLConnection *)getDataAPIResultWithURL:(NSString *)url
                                      params:(NSMutableDictionary *)params
                                 htttpMethod:(NSString *)htttpMethod
                             withSOAPAction:(NSString *)soapAction
                             withMethodName:(NSString *)soapMethodName
                                withResultBlock:(ResultBlock)resultBock
{
    self.soapMethodName = soapMethodName;
    self.resultBlock = resultBock;
    
    ///////////
    //
    //    NSString *soapMessage = [NSString stringWithFormat:
    //                             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    //                             "<soapenv:Header/>"
    //                             "<soapenv:Body>"
    //                             "<FZ_MB_RSL_INV_LKP_SRVC_OP>"
    //                             "<OPRID>%@</OPRID>"
    //                             "<PWD>%@</PWD>"
    //                             "<PORT>%@</PORT>"
    //                             "<MKT>%@</MKT>"
    //                             "<DVC>%@</DVC>"
    //                             "</FZ_MB_RSL_INV_LKP_SRVC_OP>"
    //                             "</soapenv:Body>"
    //                             "</soapenv:Envelope>",
    //                             @"WRSLDEMO",@"FLABC123",@"CNCAN",@"CHN",@"APH"];
///////////soapMessage 拼接
    NSString *soapHtmlHead = [NSString stringWithFormat:
                              @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                              "<soapenv:Header/>"
                              "<soapenv:Body>"
                              "<%@>",soapMethodName];
    NSString *soapHtmlFoot = [NSString stringWithFormat:
                              @"</%@>"
                              "</soapenv:Body>"
                              "</soapenv:Envelope>",soapMethodName];
    
    NSMutableString *soapHtmlMiddle = [NSMutableString string];
//    for (NSString *key in params.allKeys) {
//        NSString *value = params[key];
//        NSString *bodyString = [NSString stringWithFormat:@"<%@>%@</%@>",key,value,key];
//        [soapHtmlMiddle appendString:bodyString];
//    } 当包含多层key-value时，此法存在问题，所以运用下面的递归调用
    [self appendSoapHtmlMiddle:&soapHtmlMiddle WithParams:params];
    
    NSString *soapMessage = [NSString stringWithFormat:@"%@%@%@",soapHtmlHead,soapHtmlMiddle,soapHtmlFoot];

    
    NSLog(@"soapMessage: \n%@",soapMessage);

    //请求发送到的路径
    NSURL *path = [NSURL URLWithString:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:path];
/////////////////
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:htttpMethod];
    [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
/////////////////
    //请求 iOS9.0后NSURLSession代替
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    //如果连接已经建好，则初始化data
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
    return theConnection;
}

/**
 *  Description  soap xml 拼接
 *
 *  @param soapHtmlMiddle soapHtmlMiddle description
 *  @param params         params description
 */
-(void)appendSoapHtmlMiddle:(NSMutableString **)soapHtmlMiddle WithParams:(NSMutableDictionary *)params
{
    for (NSString *key in params.allKeys) {
        
        [*soapHtmlMiddle appendString:[NSString stringWithFormat:@"<%@>",key]];
        
        id value = params[key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self appendSoapHtmlMiddle:&*soapHtmlMiddle WithParams:value];
        }else if ([value isKindOfClass:[NSArray class]]){
            for (id oneValue in value) {
                if ([oneValue isKindOfClass:[NSDictionary class]]) {
                    [self appendSoapHtmlMiddle:&*soapHtmlMiddle WithParams:oneValue];
                }
            }
        }else{
            [*soapHtmlMiddle appendString:[NSString stringWithFormat:@"%@",value]];
        }
        
        [*soapHtmlMiddle appendString:[NSString stringWithFormat:@"</%@>",key]];
    }
}
/*
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [webData setLength: 0];
    self.statusCode = [(NSHTTPURLResponse*)response statusCode];
//    NSLog(@"connection: didReceiveResponse:1------%@,statusCode:%ld",response,self.statusCode);

}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_webData appendData:data];
//    NSLog(@"connection: didReceiveData:2");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction----:%@",error);
    if (self.resultBlock) {
        NSString *message = error.description;
        self.resultBlock([NSNumber numberWithInteger:self.statusCode],NO,message);
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"3 DONE. Received Bytes: %lu", (unsigned long)[_webData length]);
    
    NSString *st = [[NSString alloc] initWithData:_webData encoding:NSUTF8StringEncoding];
//    NSLog(@"connectionDidFinishLoading----:%@",st);

//    NSLog(@"得到的XML=%@", st);
    
    NSError *error;
     
    id resultDic = [XMLReader dictionaryForXMLString:st error:&error];
    
//    NSLog(@"result---:%@",resultDic);
    
    BOOL isDic = [resultDic isKindOfClass:[NSDictionary class]];
    NSString *message;
    if (!error) {
        if (isDic) {
            resultDic = resultDic[@"soapenv:Envelope"][@"soapenv:Body"][@"RESPONSE"];
            NSInteger statusCode = [[NSString stringWithFormat:@"%@",resultDic[@"STATUS_CODE"][@"text"]] integerValue];
            message = resultDic[@"MSG"][@"text"];
            if (!message) {
                message = resultDic[@"Msg"][@"text"];
            }
            if (statusCode != 0) {
                if (statusCode == 200) {
                    //request valid   注册成功会返回200
                }else if (statusCode == 401){//user is not authenticated
                    resultDic = [NSNumber numberWithInteger:statusCode];
                    
                    
                }else if (statusCode == 500){//server error
                    resultDic = [NSNumber numberWithInteger:statusCode];
                }
                
            }
        }else{

            resultDic = [NSNumber numberWithInteger:110];
        }
         NSLog(@"%@ request end",self.soapMethodName);
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            isDic = YES;
        }else{
            isDic = NO;
        }
        if (self.resultBlock) {
            self.resultBlock(resultDic,isDic,message);
        }
        
       
    }else {
        NSLog(@"解析错误%@",error);
        if (self.resultBlock) {
            self.resultBlock([NSNumber numberWithInteger:110],isDic,error.description);
        }
    };
    
}


@end




