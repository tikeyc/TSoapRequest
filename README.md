# TSoapRequest

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





