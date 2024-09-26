//
//  ACDownload.h
//  ACThreads
//
//  Created by Abdullah on 23/03/1446 AH.
//

#import <UIKit/UIKit.h>
#import "Tweak.h"

@interface ACDownload : UIViewController
+ (void)downloadMediaFromURL:(NSURL *)mediaURL;
+ (BOOL)isImage:(NSString *)fileExtension;
+ (BOOL)isVideo:(NSString *)fileExtension;
+ (NSURL *)saveVideoToTemporaryFile:(NSData *)videoData;
+ (void)saveVideoToCameraRoll:(NSURL *)videoURL;
@end

