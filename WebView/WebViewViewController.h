//
//  WebViewViewController.h
//  WebView
//
//  Created by ZQP on 13-6-13.
//  Copyright (c) 2013年 ZQP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate>{
    UIWebView *webView;
    
    UINavigationBar *navigationBar;
    UINavigationItem *navigationItem;
    UITextField *urlField;
    
    UIToolbar *toolbar;
    UIBarButtonItem *stopButtonItem;
    UIBarButtonItem *backButtonItem;
    UIBarButtonItem *forwordButtonItem;

}


- (void) loadWebWithString:(NSString *)url;

@end
