//
//  SimPerson.swift
//  The Sims
//
//  Created by Aleksander Bernat on 05/03/2019.
//  Copyright © 2019 Aleksander Bernat. All rights reserved.
//

import Foundation

class Sim {
    
    init() {
    }
    
    // Game timer controlls
    let DAY_TICKS: Double = 720
    let WEEK_TICKS: Double = 5040

    var timeIntervalLoop: Double = 0.1
    var clockH = 8
    var clockM = 0
    let maxValue = 100.0
    let gameTimeInterval: Int  = 2
    
    // Action indicators
    var ocupated: Bool = false
    var sleeping: Bool = false
    var usingTimer = 0

    var device = HomeStuff(deviceName: .nothing)
    var oldMotive = Motive(energy: 80, hunger: 80, hygiene: 80, bladder: 80)
    var m = Motive(energy: 80, hunger: 60, hygiene: 70, bladder: 30)
    var tempMood = Motive(energy: 0, hunger: 0, hygiene: 0, bladder: 0)
    
    enum Motives: Int {
        case hunger, bladder, hygiene, energy, nothing
    }
    
    func copy(from: Motive, to: Motive){
        to.happyNow = from.happyNow
        to.energy = from.energy
        to.hunger = from.hunger
        to.hygiene = from.hygiene
        to.bladder = from.bladder
    }
    
    //energy
    func energyCalculation(motive: Motive, oldMotive: Motive){
        
        // zmiana energii w funkcji czasu
        
        if (sleeping){
           
        }else{
            motive.energy -= (maxValue / DAY_TICKS)
        }
    }
    
    //hunger
    func hungerCalculation(motive: Motive, oldMotive: Motive){
        
        //zmiana glodu w funkcji czasu
        //zmiana glodu spowodowana zmniejszającą się energią
        
        if (sleeping){
            motive.hunger -= (maxValue / DAY_TICKS) / 2
        }else{
            motive.hunger -= (maxValue / DAY_TICKS)
            if (oldMotive.energy > motive.energy){
                motive.hunger -= oldMotive.energy - motive.energy // Im mniejszy poziom energii, tym bardziej chce się jeść
            }
            if (motive.hunger < 3) {
                print("You have starved to death")
                motive.hunger = 80
            }
        }
    }
    
    //hygiene
    func hygieneCalculation(motive: Motive, oldMotive: Motive){

        //zmiana higieny w funkcji czasu
        //zmiana higieny po wypróżnieniu się
        
        if (sleeping){
            motive.hygiene -= (maxValue / DAY_TICKS) / 2
        }else{
            motive.hygiene -= (maxValue / DAY_TICKS) * 2
            if (oldMotive.bladder < motive.bladder){
                motive.hygiene -= (motive.bladder - oldMotive.bladder) / 4  // Higiena spada gdy Sim skorzysta z toalety.
            }
            if (motive.hygiene < 3) { // LIMIT
                print("You smell very bad, mandatory bath")
            }
        }
    }
    
    // bladder
    func bladderCalculation(motive: Motive, oldMotive: Motive){
        //zmiana pecherza w funkcji czasu
        //zmiana pecherza po zjedzeniu
        //krytyczny stan pecherza, bardzo obniza higiene
        if (sleeping){
            motive.bladder -= (maxValue / DAY_TICKS) / 2
        }else{
            if (motive.hunger > oldMotive.hunger){
                motive.bladder -= (motive.hunger - oldMotive.hunger) / 4 // Jedzenie jest trawione, wzrasta potrzeba skorzystania z toalety.
            }
            
            motive.bladder -= (maxValue / DAY_TICKS) * 3
            
            if (motive.bladder < 3) { // hit limit, gotta go
                print("You have soiled the underwear")
                motive.bladder = 90//    m.bladder = 90;
                motive.hygiene = 10
            }
        }
    }
    
    func calcFactor(motive: Motive, oldMotive: Motive){
        energyCalculation(motive: motive, oldMotive: oldMotive)
        hungerCalculation(motive: motive, oldMotive: oldMotive)
        hygieneCalculation(motive: motive, oldMotive: oldMotive)
        bladderCalculation(motive: motive, oldMotive: oldMotive)
        calcHappiness(motive: motive)
        
        copy(from: motive, to: oldMotive)
        motive.clamp()
    }
    
    func calcHappiness(motive: Motive){
        motive.happyNow = {
            let x = (motive.energy + motive.hunger + motive.hygiene + motive.bladder)/4
            return x
        }()
    }
    
    func tick() {
        self.clockM += gameTimeInterval;
        if (self.clockM > 58) {
            self.clockM = 0
            self.clockH += 1
            if (self.clockH > 23){
                self.clockH = 0
            }
        }
        calcFactor(motive: m, oldMotive: oldMotive)
        whatToDo()
    }
    
    func percentCalc(curentMotive: Motive, newMotive: Motive ) -> Double {
        var percentageChange: Double = 0
        if (curentMotive.happyNow != 0  && newMotive.happyNow != 0){
            percentageChange = ((1 - (curentMotive.happyNow/newMotive.happyNow)) * 100)
        }
        return percentageChange
    }

    func work() {
        self.clockH += 9
        if (self.clockH > 24){self.clockH -= 24 }
        m.energy -= Double.random(in: 10...30)
        m.hunger += Double.random(in: 1...20)
        m.hygiene -= Double.random(in: 1...30)
        m.bladder += Double.random(in: 1...10)
        m.clamp()
    }

    func whatToDo(){
      
        var valuesArray: [Double] = []
        let hungerChange = hungerImpact() + (100 - m.hunger)
        let bladderChange = bladderImpact() + (100 - m.bladder)
        let hygieneChange = hygieneImpact() + (100 - m.hygiene)
        let energyChange = energyImpact() + (100 - m.energy)
        var deviceName: Motives
        
        valuesArray.insert(hungerChange, at: Motives.hunger.rawValue)
        valuesArray.insert(bladderChange, at: Motives.bladder.rawValue)
        valuesArray.insert(hygieneChange,at: Motives.hygiene.rawValue)
        valuesArray.insert(energyChange,at: Motives.energy.rawValue)
        if (valuesArray[Motives.energy.rawValue] < 80){
           valuesArray[Motives.energy.rawValue] = 0
        }

        if (ocupated == false){
            if (m.hunger > Double.random(in: 20...40) && m.hygiene > Double.random(in: 20...40) && m.bladder > Double.random(in: 20...40) && m.energy > Double.random(in: 10...15))  {
                device = HomeStuff(deviceName: .nothing)
                device.useItem(m: m)
                
            }else{
                if (valuesArray[Motives.energy.rawValue] > 90){
                    sleeping = true
                    deviceName = .energy
                    print("SLEEP SLEEP MY LITTLE PRINCESS")
                    
                }else{
                    deviceName = Motives(rawValue: valuesArray.firstIndex(of: valuesArray.max()!)!)!
                    device = HomeStuff(deviceName: deviceName)
                    usingTimer = Int(device.clockM)
                    if (deviceName == .energy){
                        sleeping = true
                    }
                    ocupated = true
                    device.useItem(m: m)
                    print("i used item \(device.name)")
                    usingTimer -= self.gameTimeInterval
                }
            }
        }else{
            if (usingTimer > 0){
                device.useItem(m: m)
                print("i used item \(device.name)\n")
                usingTimer -= self.gameTimeInterval
            }else{
                ocupated = false
                sleeping = false
            }
        }
    }
    
    //IMPACT FOR EACH MOTIVE
    
    func hungerImpact() -> Double {
        copy(from: m, to: tempMood)
        let device = HomeStuff(deviceName: .hunger)
        device.testHunger(m: tempMood)
        calcHappiness(motive: tempMood)
        let score = (1 / m.happyNow) - (1 / tempMood.happyNow)
        return score
    }
    
    func bladderImpact() -> Double{
        copy(from: m, to: tempMood)
        let device = HomeStuff(deviceName: .bladder)
        device.testBladder(m: tempMood)
        calcHappiness(motive: tempMood)
        let score = (1 / m.happyNow) - (1 / tempMood.happyNow)
        return score
    }
    
    func hygieneImpact() -> Double {
        copy(from: m, to: tempMood)
        let device = HomeStuff(deviceName: .hygiene)
        device.testHygiene(m: tempMood)
        calcHappiness(motive: tempMood)
        let score = (1 / m.happyNow) - (1 / tempMood.happyNow)
        return score
    }
    
    func energyImpact() -> Double {
        copy(from: m, to: tempMood)
        let device = HomeStuff(deviceName: .energy)
        device.testHygiene(m: tempMood)
        calcHappiness(motive: tempMood)
        let score = (1 / m.happyNow) - (1 / tempMood.happyNow)
        return score
    }
}


