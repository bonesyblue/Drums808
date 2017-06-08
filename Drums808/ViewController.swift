//
//  ViewController.swift
//  Drums808
//
//  Created by Jonathan Bones on 18/10/2016.
//  Copyright © 2016 Jonathan Bones. All rights reserved.
//
//  TR808 samples sourced from http://smd-records.com/tr808/?page_id=14 [Accessed 18th October 2016]
//  with many thanks to Michael Fischer of Technopolis for recording the samples
//

import UIKit
import AudioKit

//Declare the sampler engine variable for instantiating the sampler engine class
var samplerEngine: SamplerEngine!

class ViewController: UIViewController {
    
    //MARK: 3x3 Drum Trigger Pads
    @IBOutlet weak var kickPad: UIButton!
    @IBOutlet weak var rimShotPad: UIButton!
    @IBOutlet weak var snarePad: UIButton!
    @IBOutlet weak var clapPad: UIButton!
    @IBOutlet weak var closedHatPad: UIButton!
    @IBOutlet weak var openHatPad: UIButton!
    @IBOutlet weak var hiTomPad: UIButton!
    @IBOutlet weak var midTomPad: UIButton!
    @IBOutlet weak var loTomPad: UIButton!
    
    //MARK: Drum Sequencer buttons
    @IBOutlet weak var seqZero: UIButton!
    @IBOutlet weak var seqOne: UIButton!
    @IBOutlet weak var seqTwo: UIButton!
    @IBOutlet weak var seqThree: UIButton!
    @IBOutlet weak var seqFour: UIButton!
    @IBOutlet weak var seqFive: UIButton!
    @IBOutlet weak var seqSix: UIButton!
    @IBOutlet weak var seqSeven: UIButton!
    @IBOutlet weak var seqEight: UIButton!
    @IBOutlet weak var seqNine: UIButton!
    @IBOutlet weak var seqTen: UIButton!
    @IBOutlet weak var seqEleven: UIButton!
    @IBOutlet weak var seqTwelve: UIButton!
    @IBOutlet weak var seqThirteen: UIButton!
    @IBOutlet weak var seqFourteen: UIButton!
    @IBOutlet weak var seqFifteen: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sequenceSelector: UISegmentedControl!
    
    //Dictionary for storing indexed step sequence buttons
    var seqButtonDict: [Int:UIButton]!

    
    //MARK: Tempo Slider & Label
    @IBOutlet weak var tempoSlider: UISlider!
    @IBOutlet weak var tempoLabel: UILabel!
    
    //MARK: Sequencer Timer
    //Timer to handle timing events for sequencing
    var sequenceTimer: Timer!
    
    //MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Run the init() function of the SamplerEngine class
        samplerEngine = SamplerEngine()
        
        //Instantiate a timer for sequencing tasks
        sequenceTimer = Timer()
        
        //Initialise the tempoLabel to the value of the tempoSlider
        tempoLabel.text = String(format: "%0.0f", tempoSlider.value)
        
        seqButtonDict = [0:seqZero, 1: seqOne, 2: seqTwo, 3:seqThree, 4: seqFour, 5: seqFive, 6: seqSix, 7:seqSeven, 8: seqEight, 9: seqNine, 10:seqTen, 11:seqEleven, 12: seqTwelve, 13: seqThirteen, 14: seqFourteen, 15: seqFifteen]
    }
    
    //MARK: Tempo Functions
    @IBAction func changeTempo(_ sender: Any) {
        
        //Update the label text with the current bpm value from the tempoSlider
        tempoLabel.text = String(format: "%0.0f", tempoSlider.value)
    }
    
    //MARK: Sample Trigger Function
    @IBAction func triggerSample(_ sender: UIButton) {
        
        //When a drum trigger pad is pressed, play the associated sample
        samplerEngine.playSample(sender.tag)
    }
    
    //MARK: Sequencer Functions
    var startButtonSelected = true //Variable used to determine button state
    
    //Function to handle sequencer start and pause events
    @IBAction func handleTimer(_ sender: UIButton) {
        
        if startButtonSelected {
            //If play button is pressed change title text to pause
            playButton.setTitle("Pause", for: .normal)
            startButtonSelected = false //Set start button toggle to false
            
            //Calculate timing interval based on value of the tempo slider
            let interval = samplerEngine.getInterval(tempo: tempoSlider.value)
            
            //Create a timer that will repeat the begin sequence function every interval
            sequenceTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(stepSequence), userInfo: nil, repeats: true)
        }
            
        else if !startButtonSelected {
            
            //Stop the run loop of the sequencer timer
            sequenceTimer.invalidate()
            
            //Set the pause button title to "Play"
            playButton.setTitle("Play", for: .normal)
            
            startButtonSelected = true //Set start button toggle to true
        }
    }
    
    var stepCounter = 0 //Variable used to index sequencer step position
    
    //Function to play sequence and illuminate sequencer step buttons to indicate current position
    func stepSequence(){
        
        //Play the information in the current sequence step
        samplerEngine.playStep()
        
        //For each step, highlight the sequencer play location
        switch stepCounter % 16 {
        case 0: sequenceRing(button: seqZero)
        case 1: sequenceRing(button: seqOne)
        case 2: sequenceRing(button: seqTwo)
        case 3: sequenceRing(button: seqThree)
        case 4: sequenceRing(button: seqFour)
        case 5: sequenceRing(button: seqFive)
        case 6: sequenceRing(button: seqSix)
        case 7: sequenceRing(button: seqSeven)
        case 8: sequenceRing(button: seqEight)
        case 9: sequenceRing(button: seqNine)
        case 10: sequenceRing(button: seqTen)
        case 11: sequenceRing(button: seqEleven)
        case 12: sequenceRing(button: seqTwelve)
        case 13: sequenceRing(button: seqThirteen)
        case 14: sequenceRing(button: seqFourteen)
        case 15: sequenceRing(button: seqFifteen)
        default:
            print("Unrecognised sequencer index")
        }
        
        //Increment the sequence step by 1
        stepCounter += 1
    }
    
    //Function to illuminate the current sequencer position
    func sequenceRing(button: UIButton){
        
        //Add a red border to the sequence button which lies at the current sequencer position
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        
        //Remove the red sequencer position ring from previous sequencer steps
        switch button {
        case seqZero: removeBorder(seqFifteen)
        case seqOne: removeBorder(seqZero)
        case seqTwo: removeBorder(seqOne)
        case seqThree: removeBorder(seqTwo)
        case seqFour: removeBorder(seqThree)
        case seqFive: removeBorder(seqFour)
        case seqSix: removeBorder(seqFive)
        case seqSeven: removeBorder(seqSix)
        case seqEight: removeBorder(seqSeven)
        case seqNine: removeBorder(seqEight)
        case seqTen: removeBorder(seqNine)
        case seqEleven: removeBorder(seqTen)
        case seqTwelve: removeBorder(seqEleven)
        case seqThirteen: removeBorder(seqTwelve)
        case seqFourteen: removeBorder(seqThirteen)
        case seqFifteen: removeBorder(seqFourteen)
        default: print("sequence button not recognised")
        }
    }
    
    //Function to remove button border
    func removeBorder(_ targetButton: UIButton){
        targetButton.layer.borderWidth = 0 //set button border width to zero
    }
    
    //Function to handle illumination of sequencer buttons
    @IBAction func buttonEnabled(_ sender: UIButton) {
        //When Determine using illuminate() function whether sequencer button is to be illuminated
        if samplerEngine.illuminate(sequenceStepId: sender.tag) {
            //Highlight sequencer button green to play associated sample (on state)
            sender.backgroundColor = UIColor.green
        }
        else {
            //If the button has previously been selected then toggle the sequence button off
            //and return to the original grey colour (off state)
            sender.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        }
    }
    
    //Function to indicate to the Sampler Engine which sequence is currently being edited
    @IBAction func sequenceSelect(_ sender: UISegmentedControl) {
        
        //Update the selected sequencer variable in the sampler engine class with the selected sampler index
        samplerEngine.selectedSequence = sequenceSelector.selectedSegmentIndex
        
        //Update the sequencer buttons to reflect the change in selected sampler instrument
        updateSequenceButtons(sequence: sequenceSelector.selectedSegmentIndex)
    }
    
    //Function to update the sequencer buttons when the sequence is changed
    func updateSequenceButtons(sequence: Int){
        
        switch sequence {
            
        //Kick drum
        case 0:
            //Loop once through the kick drum sequence array
            for i in 0..<16 {
                //Illuminate the respective sequence step for steps where the kick drum has been set to trigger
                if samplerEngine.kickSequence[i]{
                    seqButtonDict[i]!.backgroundColor = UIColor.green
                }
                //Otherwise set the sequence steps to grey
                else {
                    seqButtonDict[i]!.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                }
            }
            
        //Snare drum
        case 1:
            //Loop once through the snare drum sequence array
            for i in 0..<16 {
                //Illuminate the respective sequence step for steps where the snare drum has been set to trigger
                if samplerEngine.snareSequence[i]{
                    seqButtonDict[i]!.backgroundColor = UIColor.green
                }
                //Otherwise set the sequence steps to grey
                else {
                    seqButtonDict[i]!.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                }
            }
            
        //Hi hat
        case 2:
            //Loop once through the hi hat drum sequence array
            for i in 0..<16 {
                //Illuminate the respective sequence step for steps where the hi hat has been set to trigger
                if samplerEngine.hiHatSequence[i]{
                    seqButtonDict[i]!.backgroundColor = UIColor.green
                }
                //Otherwise set the sequence steps to grey
                else {
                    seqButtonDict[i]!.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                }
            }
        default:
            print("Step index not recognised")
        }
    }
}
