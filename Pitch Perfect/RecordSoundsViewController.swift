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

    //MARK: - Variables
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    
    private var audioRecorder : AVAudioRecorder!
    internal var recordedAudio : RecordedAudio!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        tapLabel.text = "Tap to record"
        tapLabel.hidden = false
        hideButtons(true)
        recordButton.enabled = true
        pauseButton.enabled = true
    }

    //MARK: - Functions
    @IBAction func recordAudio(sender: UIButton) {
        hideButtons(false)
        enableButtons(false)
        tapLabel.hidden = true
        
        //this line I don't undestand very much. recuperado de Udacity.(sorry for my english.)
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
        audioRecorder.record()
        
        enableButtons(false)
        pauseButton.enabled = true
        tapLabel.hidden = true
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        audioRecorder.pause()
        
        enableButtons(true)
        tapLabel.text = "touch the microphone again if you want to start a new recording"
        pauseButton.enabled = false
        tapLabel.hidden = false
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        
        hideButtons(false)
        tapLabel.hidden = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            recordButton.enabled = true
            hideButtons(true)
        }
    }
    
    func enableButtons(value: Bool){
        recordingInProgress.hidden = value
        recordButton.enabled = value
        resumeButton.enabled = value
    }
    
    func hideButtons(value: Bool){
        recordingInProgress.hidden = value
        resumeButton.hidden = value
        resumeLabel.hidden = value
        stopButton.hidden = value
        stopLabel.hidden = value
        pauseButton.hidden = value
        pauseLabel.hidden = value
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}
