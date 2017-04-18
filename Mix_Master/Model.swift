//
//  Model.swift
//  Mix_Master
//
//  Created by Brent Wishart on 4/17/17.
//  Copyright © 2017 Brent Wishart. All rights reserved.
//

import UIKit
import Foundation
//import CoreMIDI
//import CoreAudio
//import AudioToolbox

import AVFoundation


class Model {
    let engine:AVAudioEngine = AVAudioEngine()
    let sampler:AVAudioUnitSampler = AVAudioUnitSampler()
    
    
    init() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
    }
    
    
    // instance variables
    let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    let gmMarimba = UInt8(12)
    let gmHarpsichord = UInt8(6)
    
    func loadPatch(gmpatch:UInt8, channel:UInt8 = 0) {
        
        guard let soundbank =
            Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2", subdirectory: "sounds")
            else {
                print("could not read sound font")
                return
        }
        
        do {
            try sampler.loadSoundBankInstrument(at: soundbank, program:gmpatch,
                                                     bankMSB: melodicBank, bankLSB: defaultBankLSB)
            
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return
        }
        
//        do {
//            try self.sampler.sendProgramChange(gmpatch, bankMSB: self.melodicBank, bankLSB: self.defaultBankLSB, onChannel: channel)
//            print("We did it!")
//        } catch let error as NSError {
//            print("\(error.localizedDescription)")
//            return
//        }
    }
}
