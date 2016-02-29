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
    
    private var audioPlayer: AVAudioPlayer!
    internal var receivedAudio: RecordedAudio!
    
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile!

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
        playAudioWith(.Pitch, value: 1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWith(.Pitch, value: -1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWith(.Reverb, value: 50)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWith(.Delay, value: 0.5)
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
    
    private func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        stopButton.enabled = true
    }
    
    /**
     Permite reproducir un audio con distintos efectos
     - parameters:
       - effect: El efecto deseado. Puede ser: `.Delay`, `.Pitch` o `.Reverb`
       - value: el valor asignado al efecto
     - returns: la reproducción del audio con el efecto deseado.
     */
    func playAudioWith(effect: Effect, value: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        //this block of code I don't understand very much.
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        switch effect {
        case .Delay:
            let changeDelayEffect = AVAudioUnitDelay()
            changeDelayEffect.delayTime = NSTimeInterval(value)
            audioEngine.attachNode(changeDelayEffect)
            
            audioEngine.connect(audioPlayerNode, to: changeDelayEffect, format: nil)
            audioEngine.connect(changeDelayEffect, to: audioEngine.outputNode, format: nil)
        case .Pitch:
            let changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = value
            audioEngine.attachNode(changePitchEffect)
            
            audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
            audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        case .Reverb:
            let changeReverbEffect = AVAudioUnitReverb()
            changeReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            changeReverbEffect.wetDryMix = value
            audioEngine.attachNode(changeReverbEffect)
            
            audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
            audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        }
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        stopButton.enabled = true
        //end of block of code
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            stopButton.enabled = false
        } else{
            stopButton.enabled = true
        }
    }
    
    enum Effect {
        case Delay, Pitch, Reverb
    }

    

}
