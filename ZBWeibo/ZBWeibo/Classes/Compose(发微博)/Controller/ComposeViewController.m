//
//  ComposeViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/8/18.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "ComposeViewController.h"
#import "AccountTool.h"
#import "EmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ComposeToolbar.h"
#import "ComposePhotosView.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"

@interface ComposeViewController () <UITextViewDelegate, ComposeToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) EmotionTextView *textView;
@property (nonatomic, weak) ComposeToolbar *toolbar;
@property (nonatomic, weak) ComposePhotosView *photosView;
@property (nonatomic, strong) EmotionKeyboard *emotionKeyboard;
@property (nonatomic, assign) BOOL switchingKeyboard;
@end

@implementation ComposeViewController

- (EmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[EmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 添加输入控件
    [self setupTextView];
    
    // 添加工具条
    [self setupToolbar];
    
    // 添加相册
    [self setupPhotosView];
    
    }

- (void)setupPhotosView
{
    ComposePhotosView *photosView = [[ComposePhotosView alloc] init];
    
    photosView.y = 100;
    photosView.width = self.view.width;
    photosView.height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

- (void)setupToolbar
{
    ComposeToolbar *toolbar = [[ComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    toolbar.delegate = self;
    //inputAccessoryView设置显示在键盘顶部的内容
//    self.textView.inputAccessoryView = toolbar;
    
}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *name = [AccountTool account].name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.numberOfLines = 0;

        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        
        // 创建一个带属性的字符串
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else {
        self.title = prefix;
    }
} 

- (void)setupTextView
{
    EmotionTextView *textView = [[EmotionTextView alloc] init];
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
    textView.placeholder = @"分享新鲜事...";
//    textView.placeholderColor = [UIColor redColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 监听文字通知
    [ZBWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 监听键盘通知
    [ZBWNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 监听表情选中的通知
    [ZBWNotificationCenter addObserver:self selector:@selector(emotonDidSelect:) name:ZBWEmotionDidSelectNotification object:nil];
    
    // 监听删除按钮的通知
    [ZBWNotificationCenter addObserver:self selector:@selector(emotonDidDelete) name:ZBWEmotionDidDeleteNotification object:nil];
}

#pragma mark - 监听方法

- (void)emotonDidDelete
{
    [self.textView deleteBackward];
}

- (void)emotonDidSelect:(NSNotification *)notification
{
    Emotion *emotion = notification.userInfo[ZBWSelectEmotionKey];
    // 插入表情
    [self.textView insertEmotion:emotion];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会调出键盘）
    [self.textView becomeFirstResponder];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (self.switchingKeyboard) return;
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

- (void)dealloc
{
    [ZBWNotificationCenter removeObserver:self];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    if (self.photosView.photos.count) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
    // dissmiss
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)sendWithImage
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

- (void)sendWithoutImage
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"发送失败"];
    }];
}

- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - ComposeToolbarDelegate
- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButton:(ComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ComposeToolbarButtonTypeCamera:
            [self openCamera];
            break;
        case ComposeToolbarButtonTypePicture:
            [self openAlbum];
            break;
        case ComposeToolbarButtonTypeMention:
            
            break;
        case ComposeToolbarButtonTypeTrend:
            
            break;
        case ComposeToolbarButtonTypeEmotion:
            [self switchKeyboard];
            break;

        default:
            break;
    }
}

- (void)switchKeyboard
{
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
    
        self.textView.inputView = self.emotionKeyboard;
        
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    // 开始切换键盘
    self.switchingKeyboard = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];
    
    // 结束切换键盘
    self.switchingKeyboard = NO;
    
    // 弹出键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.textView becomeFirstResponder];
       
    });
}

- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.photosView addPhoto:image];
}

@end
