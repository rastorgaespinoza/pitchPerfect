//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Rodrigo Astorga on 2/25/16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioPlayer.delegate = self
        
        stopButton.enabled = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithDelay()
    }
    
    @IBAction func stopButton(sender: UIButton) {
        if audioPlayer.playing{
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
            stopButton.enabled = false
        }else {
            audioEngine.stop()
            audioEngine.reset()
            stopButton.enabled = false
        }
        
    }
    
    func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        stopButton.enabled = true
    }
    
    func playAudioWithVariablePitch(pitch : Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        stopButton.enabled = true
    }
    
    func playAudioWithReverb(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        changeReverbEffect.wetDryMix = 50
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        stopButton.enabled = true
    }
    
    
    func playAudioWithDelay(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeDelayEffect = AVAudioUnitDelay()
        changeDelayEffect.delayTime = NSTimeInterval(0.5)
        audioEngine.attachNode(changeDelayEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeDelayEffect, format: nil)
        audioEngine.connect(changeDelayEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        stopButton.enabled = true
    }
    
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            stopButton.enabled = false
        } else{
            stopButton.enabled = true
        }
    }

    

}
