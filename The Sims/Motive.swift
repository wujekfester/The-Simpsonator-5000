//
//  Motive.swift
//  The Sims
//
//  Created by Aleksander Bernat on 01/04/2019.
//  Copyright © 2019 Aleksander Bernat. All rights reserved.
//

import Foundation

class Motive {
    
    var happyNow: Double = 0
    var energy: Double = 0
    var hunger: Double = 0
    var hygiene: Double = 0
    var bladder: Double = 0
    
    init(energy: Double, hunger: Double, hygiene: Double, bladder: Double){
        self.energy = energy
        self.hunger = hunger
        self.hygiene = hygiene
        self.bladder = bladder
    }
    func clamp() {
        if happyNow <= 0{ happyNow = 0 }
        if happyNow >= 100{ happyNow = 100 }
        
        if energy <= 0{ energy = 0 }
        if energy >= 100{ energy = 100 }
        
        if hunger <= 0{ hunger = 0 }
        if hunger >= 100{ hunger = 100 }
        
        if hygiene <= 0{ hygiene = 0 }
        if hygiene >= 100{ hygiene = 100 }
        
        if bladder <= 0{ bladder = 0 }
        if bladder >= 100{ bladder = 100 }
    }
}
