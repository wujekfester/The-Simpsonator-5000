//
//  HomeStuff.swift
//  The Sims
//
//  Created by Aleksander Bernat on 20/05/2019.
//  Copyright © 2019 Aleksander Bernat. All rights reserved.
//
struct HomeStuff {
    fileprivate var energy: Double = 0
    fileprivate var hunger: Double = 0
    fileprivate var bladder: Double = 0
    fileprivate var hygiene: Double = 0
    var name: String
    var clockM: Double
    
    
    
    /*
 
     self.something = { return MAX VALUE / (TIME (minutes)  / GAME TIME INTERVAL) }()
     
     
     */
    init(deviceName: Sim.Motives) {
        switch deviceName {
        case .bladder:
            self.name = "toilet"
            self.energy = { return -1 / (10 / 2) }()
            self.bladder = { return 60.0 / (10 / 2) }()
            self.hunger = { return -2.5 / (10 / 2) }()
            self.hygiene = { return -5.0 / (10 / 2) }()
            self.clockM = 10
        case .hunger:
            self.name = "fridge"
            self.energy = { return -1 / (30 / 2) }()
            self.bladder = { return -2.5 / (30 / 2) }()
            self.hunger = { return 60.0 / (30 / 2) }()
            self.hygiene = { return -5  / (30 / 2) }()
            self.clockM = 30
        case .hygiene:
            self.name = "shower"
            self.energy = { return -1 / (20 / 2) }()
            self.bladder = { return -0.5 / (20 / 2) }()
            self.hunger = { return -1 / (20 / 2) }()
            self.hygiene = { return 60.0 / (20 / 2) }()
            self.clockM = 20
        case .energy:
            self.name = "bed"
            self.energy = { return 80 / (540 / 2) }()
            self.bladder = { return -1 / (540 / 2) }()
            self.hunger = { return -1 / (540 / 2) }()
            self.hygiene = { return -1 / (540 / 2) }()
            self.clockM = 540
        case .nothing:
            self.name = "nothing"
            self.energy = 0
            self.bladder = 0
            self.hunger = 0
            self.hygiene = 0
            self.clockM = 0
        default:
            break
        }
        
    }

    
    
    /**
     Funkja przyjmuje obiekt klasy Motive, dokonuje zmian wymaganych przez użycie przedmiotu oraz zwraca ilość minut w jakiej została wykonana dana czynność.
     - parameter m: Obiekt klasy Motive
     */
    func useItem(m: Motive){
        m.hunger +=  hunger
        m.bladder += bladder
        m.energy += energy
        m.hygiene += hygiene 
        m.clamp()
    }
    
    func testHunger(m: Motive){
        m.hunger += self.hunger * (self.clockM / 2)

    }
    func testBladder(m: Motive){
        m.bladder += self.bladder * (self.clockM / 2)
    }
    
    func testHygiene(m: Motive){
     
        m.hygiene += self.hygiene * (self.clockM / 2)
    }
    func testEnergy(m: Motive){
        
        m.energy += self.energy * (self.clockM / 2)
    }
    
    
}
