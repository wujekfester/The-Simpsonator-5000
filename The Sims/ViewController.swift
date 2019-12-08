//
//  ViewController.swift
//  The Sims
//
//  Created by Aleksander Bernat on 05/03/2019.
//  Copyright © 2019 Aleksander Bernat. All rights reserved.
//
import Cocoa
class ViewController: NSViewController {

    @IBOutlet weak var happyNowLBL: NSTextField!
    @IBOutlet weak var energy: NSTextField!
    @IBOutlet weak var hunger: NSTextField!
    @IBOutlet weak var hygiene: NSTextField!
    @IBOutlet weak var bladder: NSTextField!
    @IBOutlet weak var hLabel: NSTextField!
    @IBOutlet weak var mLabel: NSTextField!
    @IBOutlet weak var energyIndicator: CustomNSLevelIndicator!
    @IBOutlet weak var hungerIndicator: CustomNSLevelIndicator!
    @IBOutlet weak var hygieneIndicator: CustomNSLevelIndicator!
    @IBOutlet weak var bladderIndicator: CustomNSLevelIndicator!
    @IBOutlet weak var happyIndicator: CustomNSLevelIndicator!
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    //ImageView outlets in stackView
    @IBOutlet weak var sofaIMG: NSImageView!
    @IBOutlet weak var fridgeIMG: NSImageView!
    @IBOutlet weak var toiletIMG: NSImageView!
    @IBOutlet weak var bedIMG: NSImageView!
    @IBOutlet weak var bathIMG: NSImageView!
    
    var sim: Sim
    var worldTimer: Timer
    required init?(coder aDecoder: NSCoder) {
        self.sim = Sim()
        worldTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (Timer) in
        })
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        segmentedControl.selectedSegment = 2
        setupAssets()

        configureTimerCauseItCantBeDoneNormalWayOMG()
    }
    func configureTimerCauseItCantBeDoneNormalWayOMG(){
        worldTimer = Timer.scheduledTimer(timeInterval: sim.timeIntervalLoop, target: self, selector: #selector(worldStart), userInfo: nil, repeats: true)
        
    }
    
    
    @IBAction func playPauseGameController(_ sender: Any) {
        switch segmentedControl.selectedSegment
        {
        case 0:
            worldTimer.invalidate()
        case 1:
            worldTimer.invalidate()
            sim.timeIntervalLoop = 0.5
            worldTimer = Timer.scheduledTimer(timeInterval: sim.timeIntervalLoop, target: self, selector: #selector(worldStart), userInfo: nil, repeats: true)
            worldTimer.fire()
        case 2:
            worldTimer.invalidate()
            sim.timeIntervalLoop = 0.1
            worldTimer = Timer.scheduledTimer(timeInterval: sim.timeIntervalLoop, target: self, selector: #selector(worldStart), userInfo: nil, repeats: true)
            worldTimer.fire()
            

        default:
            break
        }
    }
    @IBAction func goToWork(_ sender: NSButton) {
        sim.work()
    }


    @objc func worldStart(){
        updateLabels()
        sim.tick()
    }
    
    func updateLabels(){
        happyNowLBL.stringValue = String(format: "%.2f", sim.m.happyNow)
        energy.stringValue = String(format: "%.2f",sim.m.energy)
        hunger.stringValue = String(format: "%.2f",sim.m.hunger)
        hygiene.stringValue = String(format: "%.2f",sim.m.hygiene)
        bladder.stringValue = String(format: "%.2f",sim.m.bladder)
        hLabel.stringValue = String(sim.clockH)
        mLabel.stringValue = String(sim.clockM)
        
        energyIndicator.doubleValue = sim.m.energy
        hygieneIndicator.doubleValue = sim.m.hygiene
        bladderIndicator.doubleValue = sim.m.bladder
        hungerIndicator.doubleValue = sim.m.hunger
        happyIndicator.doubleValue = sim.m.happyNow
        updateAssets()
    }
    
    func updateAssets(){

        setupAssets()
        
        switch sim.device.name {
        case "toilet":
            toiletIMG.image = NSImage(named: "toiletC")

        case "fridge":
            fridgeIMG.image = NSImage(named: "refrigeratorC")

        case "shower":
            bathIMG.image = NSImage(named: "bathtubC")

        case "bed":
            bedIMG.image = NSImage(named: "bedC")

        case "nothing":
            sofaIMG.image = NSImage(named: "sofaC")

        default:
            break
        }
    }
    
    func setupAssets(){
        sofaIMG.image = NSImage(named: "sofa")
        fridgeIMG.image = NSImage(named: "refrigerator")
        toiletIMG.image = NSImage(named: "toilet")
        bedIMG.image = NSImage(named: "bed")
        bathIMG.image = NSImage(named: "bathtub")
    }
}

