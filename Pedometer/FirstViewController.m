//
//  FirstViewController.m
//  Pedometer
//
//  Created by Takeshi Bingo on 2013/08/03.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
   
    AccelerometerFilter *filter;
 
    BOOL stepFlag;
    //歩数の合計
    int stepCount;
    //歩数を表示するラベル
    IBOutlet UILabel *stepCountLabel;
}
//加速度計をスタート
-(void)initAccel {
    //加速度計の分解能
    double updateFrequency = 60.0;
    
    //加速度計のフィルターを設定
    filter = [[LowpassFilter alloc] initWithSampleRate:updateFrequency cutoffFrequency:5.0];
    
    //加速度計のスタート
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / updateFrequency];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

//加速度の値取得時に呼ばれるメソッド
//現在の設定では、1/60秒に一回、加速度が取得され、メソッドがよばれる
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    //値にフィルターを適用し
    [filter addAcceleration:acceleration];
    //歩行を検知するメソッドへ値を渡す
    [self analyzeWalk:filter.x:filter.y:filter.z];
}
//歩行を検知するメソッド
-(void)analyzeWalk:(UIAccelerationValue)x :(UIAccelerationValue)y :(UIAccelerationValue)z {
    //「山」の閾値
    UIAccelerationValue hiThreshold = 1.1;
    //「谷」の閾値
    UIAccelerationValue lowThreshold = 0.9;
    //合成加速度を算出
    UIAccelerationValue composite;
    composite = sqrt(pow(x,2)+pow(y,2)+pow(z,2));
    //「山」の後に「谷」を検知すると1歩進んだと認識
    if ( stepFlag == TRUE ) {
        if ( composite < lowThreshold ) {
            stepCount++;
            stepFlag = FALSE;
        }
    } else {
        if ( composite > hiThreshold ){
            stepFlag = TRUE;
        }
    }
    NSLog(@"%f  %f  %f  %f", x, y ,z, composite);
    //現在の歩数をラベルに表示
    stepCountLabel.text = [NSString stringWithFormat:@"%d", stepCount];
}
//メール送信ボタンが押されたときの処理
-(IBAction)sendMail:(id)sender {
    //件名と本文の内容
    NSString *subject = @"歩きました！";
    NSString *message = [NSString stringWithFormat:@"たった今、私は %d 歩きました！", stepCount];
    //MFMailComposeViewControllerを生成
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    //MFMailComposeViewControllerからのDelegate通知を受け取り
    mailPicker.mailComposeDelegate = self;
    //件名を指定
    [mailPicker setSubject:subject];
    //本文を指定
    [mailPicker setMessageBody:message isHTML:false];
    //MailPicker（メール送信画面）を呼び出し
    [self presentViewController:mailPicker animated:YES completion:nil];
}
//メール送信画面終了時に呼び出される
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    //メール画面を閉じる
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
//リセットボタンが押された時の処理
-(IBAction)resetButtonAction:(id)sender {
    [self reset];
}

//リセット処理
-(void)reset {
    //各変数をリセット
    stepFlag = FALSE;
    stepCount = 0;
    
    //ラベルの値をリセット
    stepCountLabel.text = [NSString stringWithFormat:@"%d", stepCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //歩数をリセット
    [self reset];
    //加速度計をスタート
    [self initAccel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
