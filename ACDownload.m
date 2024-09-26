//
//  ACDownload.m
//  ACThreads
//
//  Created by Abdullah on 23/03/1446 AH.
//

#import "ACDownload.h"
#import <Photos/Photos.h>

static void Alert(float Timer,id Message, ...) {

    va_list args;
    va_start(args, Message);
    NSString *Formated = [[NSString alloc] initWithFormat:Message arguments:args];
    va_end(args);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Timer * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Formated message:nil preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"تمام" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];

        [alert addAction:action];

        [topMostController() presentViewController:alert animated:true completion:nil];
 
    });


}

@implementation ACDownload

+ (void)downloadMediaFromURL:(NSURL *)mediaURL {
    // تحقق من نوع الملف (صورة أو فيديو)
    NSString *fileExtension = [mediaURL pathExtension];
    
    // إنشاء جلسة لتحميل البيانات
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:mediaURL
                                                       completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSData *data = [NSData dataWithContentsOfURL:location];
            
            if ([self isImage:fileExtension]) {
                // إذا كان صورة
                UIImage *image = [UIImage imageWithData:data];
                [self saveImageToCameraRoll:image];
            } else if ([self isVideo:fileExtension]) {
                // إذا كان فيديو
                NSURL *fileURL = [self saveVideoToTemporaryFile:data];
                [self saveVideoToCameraRoll:fileURL];
            }
        } else {
            NSLog(@"خطأ في التحميل: %@", error.localizedDescription);
        }
    }];
    
    [downloadTask resume];
}

#pragma mark - Helper Methods

// التحقق إذا كان الملف صورة
+ (BOOL)isImage:(NSString *)fileExtension {
    NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"gif", @"bmp"];
    return [imageExtensions containsObject:[fileExtension lowercaseString]];
}

// التحقق إذا كان الملف فيديو
+ (BOOL)isVideo:(NSString *)fileExtension {
    NSArray *videoExtensions = @[@"mp4", @"mov", @"avi", @"m4v"];
    return [videoExtensions containsObject:[fileExtension lowercaseString]];
}

// حفظ الصورة في ألبوم الكاميرا
+ (void)saveImageToCameraRoll:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            Alert(0.1, [NSString stringWithFormat:@"تم حفظ الصوره بنجاح"]);
        } else {
            NSLog(@"فشل في حفظ الصورة: %@", error.localizedDescription);
        }
    }];
}

// حفظ الفيديو في ملف مؤقت
+ (NSURL *)saveVideoToTemporaryFile:(NSData *)videoData {
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ACThreads.mp4"];
    NSURL *tempURL = [NSURL fileURLWithPath:tempPath];
    [videoData writeToURL:tempURL atomically:YES];
    return tempURL;
}

// حفظ الفيديو في ألبوم الكاميرا
+ (void)saveVideoToCameraRoll:(NSURL *)videoURL {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            Alert(0.1, [NSString stringWithFormat:@"تم حفظ الفيديو بنجاح"]);
        } else {
            NSLog(@"فشل في حفظ الفيديو: %@", error.localizedDescription);
        }
    }];
}



@end
