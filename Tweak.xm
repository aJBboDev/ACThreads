// By @aJBboCydia

#import "Tweak.h"


// تحميل الفيديوهات
%hook _TtC11IGVideoView11IGVideoView
-(void)layoutSubviews {
    %orig; 

    UILongPressGestureRecognizer *ACThreadsLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(initDown:)];

    ACThreadsLongPress.numberOfTouchesRequired = 1;
    ACThreadsLongPress.minimumPressDuration = 0.2;
    [self addGestureRecognizer:ACThreadsLongPress];

}
%new
- (void)initDown:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Hi");

        NSSet *GetVideoURL = self.video.allVideoURLs;
        NSArray *array = [GetVideoURL allObjects];
        NSArray *SetURLVideos = [array objectAtIndex:0];
        NSString *SetURLString = [NSString stringWithFormat:@"%@",SetURLVideos];
        NSURL *videoURL = [NSURL URLWithString:SetURLString];
        NSLog(@"URL = %@",videoURL);

        

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ACThreads"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    

        UIAlertAction *DL = [UIAlertAction actionWithTitle:@"Download Video"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [ACDownload downloadMediaFromURL:videoURL];
                                                        }];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleCancel
                                                handler:nil];
        

        [alert addAction:DL];
        [alert addAction:cancel];
        
        [topMostController() presentViewController:alert animated:true completion:nil];
        
    }
}
%end

%hook UIApplication
-(void)finishedTest:(id)arg1 extraResults:(id)arg2 {

  %orig;
  if (![[NSUserDefaults standardUserDefaults] objectForKey:@"ACThreads_FirstLaunch"]) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"تنبيه - Alert" message:@"لتحميل الفيديوهات قم بالضغط المطول عالفيديو \n\n\n To download videos, long press on the video" preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction *ACThreads = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [[NSUserDefaults standardUserDefaults] setValue:@"AlreadyLaunch" forKey:@"ACThreads_FirstLaunch"];
      [[NSUserDefaults standardUserDefaults] synchronize];
     }];

    [alert addAction:ACThreads];

    [topMostController() presentViewController:alert animated:true completion:nil];

  }
 }

%end
