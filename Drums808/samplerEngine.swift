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

enum SamplerEngineError: Error {
    case soundfilesNotFound
}

open class SamplerEngine {
    
    //MARK: Sampler Engine class variables
    enum LoadingError: Error {
        case fileNotFound(String)
    }
    //Sampler instruments
    var kick: AKAudioPlayer!
    var rim: AKAudioPlayer!
    var snare: AKAudioPlayer!
    var clap: AKAudioPlayer!
    var closedHiHat: AKAudioPlayer!
    var openHiHat: AKAudioPlayer!
    var hiTom: AKAudioPlayer!
    var midTom: AKAudioPlayer!
    var loTom: AKAudioPlayer!
    
    //Mixer for mixing together sampler instruments
    var mixer: AKMixer!
    
    //Variable for keeping track of selected sampler instrument for sequencing
    var selectedSequence: Int
    
    //MARK: Init method
    //Method run upon instantiation of Sampler Engine class
    init () throws {
        
        //Initialise the audio player instances which correspond to each of the drum pads on the 3x3 grid
        guard let kickSoundFile = try? AKAudioFile(readFileName: "bd7575.wav"),
            let rimSoundFile = try? AKAudioFile(readFileName: "rs.wav"),
            let snareSoundFile = try? AKAudioFile(readFileName: "sd7575.wav"),
            let clapSoundFile = try? AKAudioFile(readFileName: "cp.wav"),
            let closedHiHatSoundFile = try? AKAudioFile(readFileName: "ch.wav"),
            let openHiHatSoundFile = try? AKAudioFile(readFileName: "oh75.wav"),
            let hiTomSoundFile = try? AKAudioFile(readFileName: "ht75.wav"),
            let midTomSoundFile = try? AKAudioFile(readFileName: "mt75.wav"),
            let loTomSoundFile = try? AKAudioFile(readFileName: "lt75.wav") else {
                throw SamplerEngineError.soundfilesNotFound
        }
        
        //Load the audio files into the respective player instances
        //N.B. Wav files aren't allowed to have capitals!
        do {
            kick = try AKAudioPlayer(file: kickSoundFile)
            rim = try AKAudioPlayer(file: rimSoundFile)
            snare = try AKAudioPlayer(file: snareSoundFile)
            clap = try AKAudioPlayer(file: clapSoundFile)
            closedHiHat = try AKAudioPlayer(file: closedHiHatSoundFile)
            openHiHat = try AKAudioPlayer(file: openHiHatSoundFile)
            hiTom = try AKAudioPlayer(file: hiTomSoundFile)
            midTom = try AKAudioPlayer(file: midTomSoundFile)
            loTom = try AKAudioPlayer(file: loTomSoundFile)
        } catch let error {
            debugPrint(error)
        }
        
        
        //Mix all the sampler instruments through a mixer to allow for polyphonic output
        mixer = AKMixer(kick, rim, snare, clap, closedHiHat, openHiHat, hiTom, midTom, loTom)
        
        //Assign the mixer to the audio output
        AudioKit.output = mixer
        
        //Start the audio engine
        try? AudioKit.start()
        
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
