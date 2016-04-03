//
//  ViewController.m
//  TSoapRequest
//
//  Created by tikeyc on 16/4/3.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "ViewController.h"

#import "API/APISoapClient.h"


#import "sys/utsname.h"
//
#define kServerHostURL @"http://mobile.florens.com/PSIGW/PeopleSoftServiceListeningConnector/"
#define CFBundle_ShortVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
///////////Device Registration////////////////////////////

// /////////1.8. Get App Setting

#define Get_App_Setting_SoapAction @"FZ_RTP_MB_GET_APP_SETTING.v1"
#define Get_App_Setting_MethodName @"FZ_RTP_MB_GET_APP_SETTING"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - request 

- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"en_us" forKey:@"AppLang"];
    [params setValue:@"COUNTRY" forKey:@"Type"];
    
    APISoapClient *soapClient = [[APISoapClient alloc] init];
//    __weak typeof(self) weakSelf = self;
    [soapClient getDataAPIResultWithURL:kServerHostURL
                                 params:params
                            htttpMethod:@"POST"
                         withSOAPAction:Get_App_Setting_SoapAction
                         withMethodName:Get_App_Setting_MethodName
                        withResultBlock:^(id result, BOOL isDictionary,NSString *message) {
//                            [weakSelf ];
                            NSLog(@"%@",result);
                        }];
}



@end








