//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Rodrigo Astorga on 2/24/16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //MARK: variables
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        tapLabel.hidden = false
        tapLabel.text = "Tap to record"
        resumeLabel.hidden = true
        stopLabel.hidden = true
        pauseLabel.hidden = true
    }

    //MARK: functions
    @IBAction func recordAudio(sender: UIButton) {
        //config Buttons and Label:
        recordingInProgress.hidden = false
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        resumeButton.hidden = false
        resumeButton.enabled = false
        tapLabel.hidden = true
        resumeLabel.hidden = false
        stopLabel.hidden = false
        pauseLabel.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func resumeAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        recordButton.enabled = false
        resumeButton.enabled = false
        pauseButton.enabled = true
        audioRecorder.record()
        tapLabel.hidden = true
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        recordButton.enabled = true
        resumeButton.enabled = true
        pauseButton.enabled = false
        audioRecorder.pause()
        tapLabel.text = "touch the microphone again if you want to start a new recording"
        tapLabel.hidden = false
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        resumeLabel.hidden = true
        stopLabel.hidden = true
        pauseLabel.hidden = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            recordButton.enabled = true
            stopButton.hidden = true
            resumeButton.hidden = true
            pauseButton.hidden = true
        }
    }
    
    //MARK: navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC : PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
}
