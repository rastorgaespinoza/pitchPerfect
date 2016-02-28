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

    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    @IBOutlet weak var modulacionSlider: UISlider!
    @IBOutlet weak var velocidadSlider: UISlider!
    @IBOutlet weak var labelVelocidad: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
//        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            _ = NSURL.fileURLWithPath(filePath)
//            
//            
//        }else{
//            print("the filePath is empty")
//        }
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioPlayer.delegate = self
        
        pauseButton.enabled = false
        stopButton.enabled = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudio(sender: UIButton) {
        audioPlayer.play()
        buttonActionPlay()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
//        buttonActionPlay()
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
//        buttonActionPlay()
    }
    
    @IBAction func stopButton(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        
        playButton.enabled = true
        
        pauseButton.enabled = false
        
        stopButton.enabled = false
    }
    
    
    @IBAction func pauseButtonAction(sender: UIButton) {
        if audioPlayer.playing == true{
            
            audioPlayer.stop()
            
            pauseButton.enabled = false
            
            playButton.enabled = true
        }
    }
    
    
    
    @IBAction func modulacionSlider(sender: UISlider) {
        variablePitch(sender.value)
    }
    
    @IBAction func velocidadSlider(sender: UISlider) {
        labelVelocidad.text = "Velocidad: \(sender.value)"
        audioPlayer.rate = sender.value
        
    }
    
    func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        buttonActionPlay()
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
    }
    
    func variablePitch(pitch : Float){
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
    }
    
    
    func buttonActionPlay(){
        playButton.enabled = false
        
        if !pauseButton.enabled  {
            pauseButton.enabled = true
        }
        if !stopButton.enabled {
            stopButton.enabled = true
        }
    }
    
    // AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
        successfully flag: Bool){
            if flag {
                playButton.enabled = true
                
                pauseButton.enabled = false
                
                stopButton.enabled = false
            }
            
            
    }
    

}
