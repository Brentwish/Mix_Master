//
//  MIDISampler.swift
//  MidiSamplerExample
//
//  Created by Eric Wishart on 4/17/17.
//  Copyright © 2017 DownSpiral. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MIDISampler: NSObject {
    var engine:AVAudioEngine!
    var playerNode:AVAudioPlayerNode!
    var mixer:AVAudioMixerNode!
    var sampler:AVAudioUnitSampler!
    /// soundbanks are either dls or sf2. see http://www.sf2midi.com/
    var soundbank:NSURL!
    let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
    /// general midi number for marimba
    let gmMarimba:UInt8 = 12
    let gmHarpsichord:UInt8 = 6
    let gmCello:UInt8 = 42
    let instruments:[String] = [ "Acoustic Grand Piano", "Bright Acoustic Piano", "Electric Grand Piano", "Honky-tonk Piano", "Electric Piano 1",
                        "Electric Piano 2", "Harpsichord", "Clavi", "Celesta", "Glockenspiel", "Music Box", "Vibraphone", "Marimba", "Xylophone", "Tubular Bells",
                        "Dulcimer", "Drawbar Organ", "Percussive Organ", "Rock Organ", "Church Organ", "Reed Organ", "Accordion", "Harmonica", "Tango Accordion",
                        "Acoustic Guitar (nylon)", "Acoustic Guitar (steel)", "Electric Guitar (jazz)", "Electric Guitar (clean)", "Electric Guitar (muted)",
                        "Overdriven Guitar", "Distortion Guitar", "Guitar harmonics", "Acoustic Bass", "Electric Bass (finger)", "Electric Bass (pick)", "Fretless Bass",
                        "Slap Bass 1", "Slap Bass 2", "Synth Bass 1", "Synth Bass 2", "Violin", "Viola", "Cello", "Contrabass", "Tremolo Strings", "Pizzicato Strings",
                        "Orchestral Harp", "Timpani", "String Ensemble 1", "String Ensemble 2", "SynthStrings 1", "SynthStrings 2", "Choir Aahs", "Voice Oohs",
                        "Synth Voice", "Orchestra Hit", "Trumpet", "Trombone", "Tuba", "Muted Trumpet", "French Horn", "Brass Section", "SynthBrass 1", "SynthBrass 2",
                        "Soprano Sax", "Alto Sax", "Tenor Sax", "Baritone Sax", "Oboe", "English Horn", "Bassoon", "Clarinet", "Piccolo", "Flute", "Recorder", "Pan Flute",
                        "Blown Bottle", "Shakuhachi", "Whistle", "Ocarina", "Lead 1 (square)", "Lead 2 (sawtooth)", "Lead 3 (calliope)", "Lead 4 (chiff)", "Lead 5 (charang)",
                        "Lead 6 (voice)", "Lead 7 (fifths)", "Lead 8 (bass + lead)", "Pad 1 (new age)", "Pad 2 (warm)", "Pad 3 (polysynth)", "Pad 4 (choir)", "Pad 5 (bowed)",
                        "Pad 6 (metallic)", "Pad 7 (halo)", "Pad 8 (sweep)", "FX 1 (rain)", "FX 2 (soundtrack)", "FX 3 (crystal)", "FX 4 (atmosphere)", "FX 5 (brightness)",
                        "FX 6 (goblins)", "FX 7 (echoes)", "FX 8 (sci-fi)", "Sitar", "Banjo", "Shamisen", "Koto", "Kalimba", "Bag pipe", "Fiddle", "Shanai", "Tinkle Bell",
                        "Agogo", "Steel Drums", "Woodblock", "Taiko Drum", "Melodic Tom", "Synth Drum", "Reverse Cymbal", "Guitar Fret Noise", "Breath Noise", "Seashore",
                        "Bird Tweet", "Telephone Ring", "Helicopter", "Applause", "Gunshot"
    ]
    
    let notes:[String:Int] = [
        "A" : 69,
        "B" : 71,
        "C" : 72,
        "D" : 74,
        "E" : 76,
        "F" : 77,
        "G" : 79
    ]
    
    override init() {
        super.init()
        initAudioEngine()
    }
    
    func initAudioEngine () {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        engine.attach(playerNode)
        mixer = engine.mainMixerNode
        engine.connect(playerNode, to: mixer, format: mixer.outputFormat(forBus: 0))
        
        // MIDI
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)
        
        soundbank = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2", subdirectory: "sounds")! as NSURL
        do {
            try engine.start()
        } catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
    }
    
    func start(note: UInt8, instrument: UInt8) {
        do {
            try sampler.loadSoundBankInstrument(at: soundbank as URL, program: instrument,
                bankMSB: melodicBank, bankLSB: 0)
        } catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
    
        self.sampler.sendProgramChange(instrument, bankMSB: 0x79, bankLSB: 0, onChannel: 0)
        self.sampler.startNote(note, withVelocity: 64, onChannel: 0)
    }
    
    
    
//    func cstart() {
//        do {
//            try sampler.loadSoundBankInstrument(at: soundbank as URL, program: gmCello,
//                                                bankMSB: melodicBank, bankLSB: 0)
//        } catch let error as NSError {
//            print("error \(error.localizedDescription)")
//        }
//        
//        self.sampler.sendProgramChange(gmCello, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
//        self.sampler.startNote(65, withVelocity: 64, onChannel: 0)
//    }

    
//    func mstop() {
//        self.sampler.sendProgramChange(gmMarimba, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
//        self.sampler.stopNote(60, onChannel: 0)
//    }
    
    func stop(note: UInt8, instrument: UInt8) {
        self.sampler.sendProgramChange(instrument, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
        self.sampler.stopNote(note, onChannel: 0)
    }
}
