//
//  WebViewViewController.m
//  WebView
//
//  Created by ZQP on 13-6-13.
//  Copyright (c) 2013年 ZQP. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // navigationBar
    urlField = [[UITextField alloc] initWithFrame:CGRectMake(10, 4, 280, 32)];
    urlField.delegate = self;
    urlField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    urlField.borderStyle = UITextBorderStyleRoundedRect;
    urlField.font = [UIFont fontWithName:@"Helvetica" size:16];
    urlField.keyboardType = UIKeyboardTypeURL;
    urlField.returnKeyType = UIReturnKeyGo;
    urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    urlField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    navigationItem.titleView = urlField;
    
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
    [self.view addSubview:navigationBar];
    
    // toolbar
    NSMutableArray *toolButttons = [NSMutableArray arrayWithCapacity:3];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    stopButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                   target:self
                                                                   action:@selector(reloadOrStop:)];
    
    backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browserBack.png"]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(goBack:)];
    
    forwordButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browserForward"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(goForward:)];
    
    [toolButttons addObject:flexibleSpaceItem];
    [toolButttons addObject:backButtonItem];
    [toolButttons addObject:flexibleSpaceItem];
    [toolButttons addObject:forwordButtonItem];
    [toolButttons addObject:flexibleSpaceItem];
    [toolButttons addObject:stopButtonItem];
    [toolButttons addObject:flexibleSpaceItem];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [toolbar sizeToFit];
    toolbar.autoresizesSubviews = NO;
    toolbar.frame = CGRectMake(0,
                               self.view.frame.size.height-toolbar.frame.size.height,
                               self.view.frame.size.width,
                               toolbar.frame.size.height);
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [toolbar setItems:toolButttons];
    [self.view addSubview:toolbar];
    
    // webview
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - navigationBar.frame.size.height - toolbar.frame.size.height)];
    webView.scalesPageToFit = YES;
    webView.contentMode = UIViewContentModeScaleToFill;
    webView.multipleTouchEnabled = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadWebWithString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark -
#pragma mark URL

- (void)loadURL:(NSURL *)url
{
    if (!url) return;
        
    urlField.text = url.absoluteString;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) updateUrlField {
    NSString *url = webView.request.URL.absoluteString;
    if (url.length) {
        urlField.text = webView.request.URL.absoluteString;
    }
}

- (void)goBack:(id)sender
{
    [webView goBack];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUrlField) object:nil];
    [self performSelector:@selector(updateUrlField) withObject:nil afterDelay:1.];
}

- (void)goForward:(id)sender
{
    [webView goForward];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUrlField) object:nil];
    [self performSelector:@selector(updateUrlField) withObject:nil afterDelay:1.];
}

- (void)reloadOrStop:(id)sender
{
    if (webView.loading) {
        [webView stopLoading];
    } else {
        [webView reload];
    }
}

#pragma mark -
#pragma mark UITextFiled delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSURL *url = [[NSURL alloc] initWithString:urlField.text];
    
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:urlField.text]];
    }
    
    [self loadURL:url];
    [urlField resignFirstResponder];
    
    return YES;
}

@end
