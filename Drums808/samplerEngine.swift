//
//  samplerEngine.swift
//  Drums808
//
//  Created by Jonathan Bones on 18/10/2016.
//  Copyright © 2016 Jonathan Bones. All rights reserved.
//
//  TR808 samples sourced from http://smd-records.com/tr808/?page_id=14 [Accessed 18th October 2016]
//  with many thanks to Michael Fischer of Technopolis for recording the samples
//

import Foundation
import AudioKit

open class SamplerEngine {
    
    //MARK: Sampler Engine class variables
    enum LoadingError: Error {
        case fileNotFound(String)
    }
    //Sampler instruments
    var kick: AKSampler!
    var rim: AKSampler!
    var snare: AKSampler!
    var clap: AKSampler!
    var closedHiHat: AKSampler!
    var openHiHat: AKSampler!
    var hiTom: AKSampler!
    var midTom: AKSampler!
    var loTom: AKSampler!
    
    //Mixer for mixing together sampler instruments
    var mixer: AKMixer!
    
    //Variable for keeping track of selected sampler instrument for sequencing
    var selectedSequence: Int
    
    //MARK: Init method
    //Method run upon instantiation of Sampler Engine class
    init () {
        
        //Initialise the samplers which correspond to each of the drum pads on the 3x3 grid
        kick = AKSampler()
        rim = AKSampler()
        snare = AKSampler()
        clap = AKSampler()
        closedHiHat = AKSampler()
        openHiHat = AKSampler()
        hiTom = AKSampler()
        midTom = AKSampler()
        loTom = AKSampler()
        
        //Load the wav files into the respective samplers
        //N.B. Wav files aren't allowed to have capitals!
        do {
            try kick.loadWav("bd7575")
            try rim.loadWav("rs")
            try snare.loadWav("sd7575")
            try clap.loadWav("cp")
            try closedHiHat.loadWav("ch")
            try openHiHat.loadWav("oh75")
            try hiTom.loadWav("ht75")
            try midTom.loadWav("mt75")
            try loTom.loadWav("lt75")
        }
        catch let error {
            print(error)
        }
        
        
        //Mix all the sampler instruments through a mixer to allow for polyphonic output
        mixer = AKMixer(kick, rim, snare, clap, closedHiHat, openHiHat, hiTom, midTom, loTom)
        
        //Assign the mixer to the audio output
        AudioKit.output = mixer
        
        //Start the audio engine
        AudioKit.start()
        
        //Initialise the selected sequence to the kick drum (see the segmented control in the main storyboard)
        selectedSequence = 0
    }
    
    //MARK: Sampling
    //Function for playing sampler instruments according to drum pad pressed by user
    func playSample(_ sampleIdentifier: Int) {
        switch sampleIdentifier {
        case 0:
            kick.play()
        case 1:
            rim.play()
        case 2:
            snare.play()
        case 3:
            clap.play()
        case 4:
            closedHiHat.play()
        case 5:
            openHiHat.play()
        case 6:
            hiTom.play()
        case 7:
            midTom.play()
        case 8:
            loTom.play()
        default:
            print("Sample pad not recognised \(sampleIdentifier)")
        }
    }
    
    //MARK: Sequencing
    //Arrays to store the sequences for each sampler instrument
    var kickSequence = Array(repeating: false, count: 16)
    var snareSequence = Array(repeating: false, count: 16)
    var hiHatSequence = Array(repeating: false, count: 16)
    
    //Counter variable to keep track of sequence step
    var sequenceStep = 0
    
    //Function for triggering sampler instruments according to the user input sequence
    func playStep() {
        //If the sampler instrument sequence array returns true at a particular sequence step,
        //play the respective sampler instrument
        if kickSequence[sequenceStep % 16] {
            kick.play()
        }
        if snareSequence[sequenceStep % 16] {
            snare.play()
        }
        if hiHatSequence[sequenceStep % 16] {
            closedHiHat.play()
        }
        //Increment the sequence step
        sequenceStep += 1
    }
    
    //Function for determining which sequence buttons to illuminate
    func illuminate(sequenceStepId: Int) -> Bool {
        
        //Variable for toggling the sequence step buttons
        var illuminate = false
        
        //Check which sampler instument is currently selected
        switch selectedSequence {
        
        //Kick drum
        case 0:
            //If the kick drum sequence step has not been highlighted previously,
            //set the kick sequence array at the respective sequence position to true
            //and then set the illuminate variable to true to illuminate the sequence step button
            //at the respective sequence step index
            if !kickSequence[sequenceStepId] {
                kickSequence[sequenceStepId] = true
                illuminate = true
            }
            //If the kick drum sequence has been highlighted in this position, toggle off the sequence
            //step button and set the kick drum sequence at this index to false
            else {
                kickSequence[sequenceStepId] = false
                illuminate = false
            }
            
        //Snare drum
        case 1:
            //If the snare drum sequence step has not been highlighted previously,
            //set the snare sequence array at the respective sequence position to true
            //and then set the illuminate variable to true to illuminate the sequence step button
            //at the respective sequence step index
            if !snareSequence[sequenceStepId] {
                snareSequence[sequenceStepId] = true
                illuminate = true
            }
            //If the snare drum sequence has been highlighted in this position, toggle off the sequence
            //step button and set the snare drum sequence at this index to false
            else {
                snareSequence[sequenceStepId] = false
                illuminate = false
            }
        
        //Hi hat
        case 2:
            //If the hi hat sequence step has not been highlighted previously,
            //set the hi hat sequence array at the respective sequence position to true
            //and then set the illuminate variable to true to illuminate the sequence step button
            //at the respective sequence step index
            if !hiHatSequence[sequenceStepId] {
                hiHatSequence[sequenceStepId] = true
                illuminate = true
            }
            //If the hi hat sequence has been highlighted in this position, toggle off the sequence
            //step button and set the hi hatsequence at this index to false
            else {
                hiHatSequence[sequenceStepId] = false
                illuminate = false
            }
            
        default:
            print("Sequencer step ID not recognised")
        }
        
        //Return the illuminate variable
        return illuminate
    }
    
    //MARK: Tempo
    //Function for calculating the sequence step interval
    func getInterval(tempo: Float) -> Double{
        var interval: Double
        //Sequence step interval is 60(seconds in minute)/(4*tempo(bpm)) for a 16th (quarter) step sequencer
        interval = Double(15/Double(tempo))
        return interval
    }
}
