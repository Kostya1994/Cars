//
//  main.swift
//  Cars
//
//  Created by Константин Соловьев on 21.2.23..
//

import Foundation

enum securityState : String {
    case blocked = "Blocked"
    case unblocked = "Unblocked"
}
enum lightsState {
    case turnedOn
    case turnedOff
}
enum engineState {
    case started
    case stopped
}

enum suspension : String {
    case longitudinalSprings = "Продольные рессоры"
    case helicalCoilSprings = "Пружины"
}

enum navigationSystem {
    case secondDriver
    case gpsNavigator
}

enum transmissionOption {
    case manual
    case automatic
}

enum colors {
    case yellow
    case blue
    case white
    case black
}

class Car {
    let model : String
    let year : UInt
    let doors : UInt
    let wheels : UInt
    let trunk : Bool
    var trunkVolume : UInt
    let carSuspension : suspension
    let speedMax : UInt
    let navigation : navigationSystem
    let transmission : transmissionOption
    private let autoBlockDoors: UInt = 20
    private var speed : UInt{
        willSet (newSpeed){
            if newSpeed >= autoBlockDoors{
                self.doorsState = .blocked
                print("Doors \(self.doorsState) becouse speed are hight than \(autoBlockDoors)")
            }
            return
        }
    }
    private var doorsState : securityState
    var lights : lightsState
    var autoEngine : engineState {
        didSet{
            print("Auto engine = \(autoEngine)")
        }
    }
    var color : colors
    private var isReadyToMove : Bool {
        get{
            return autoEngine == .started ? true : false
        }
    }
    private var isReadyToStop : Bool {
        get{
            return speed == 0 ? true : false
        }
    }
    init(model: String, year: UInt, doors: UInt, wheels: UInt, trunk: Bool, carSuspension: suspension, speedMax: UInt, navigation: navigationSystem, transmission: transmissionOption, color: colors) {
        self.model = model
        self.year = year
        self.doors = doors
        self.wheels = wheels
        self.trunk = trunk
        self.trunkVolume = 0
        self.carSuspension = carSuspension
        self.speedMax = speedMax
        self.navigation = navigation
        self.transmission = transmission
        self.speed = 0
        self.doorsState = .unblocked
        self.lights = .turnedOff
        self.autoEngine = .stopped
        self.color = color
    }
    
    func startAutoEngine(_ carLights: lightsState) {
        switch carLights{
        case .turnedOn:
            autoEngine = .started
            self.lights = .turnedOn
            print("Is car ready to move? Answer: \(isReadyToMove == true ? "Yes" : "No")")
        case .turnedOff:
            autoEngine = .started
            self.lights = .turnedOn
            print("Is car ready to move? Answer: \(isReadyToMove == true ? "Yes" : "No")")
        }
        
    }
    
    func stoppedAutoEngine(_ carLights: lightsState) {
        guard isReadyToStop == true else {
          return  print("Car is not ready to stop. You need slow down the car and stopped.")
        }
        switch carLights{
        case .turnedOn:
            isCarReadyToStop()
            autoEngine = .stopped
            self.lights = .turnedOn
        case .turnedOff:
            isCarReadyToStop()
            autoEngine = .stopped
            self.lights = .turnedOff
        }
        
    }
    
    func slowDownForStop() {
        if self.speed > 20 {
            while self.speed > 20 {
                self.speed -= 15
                print("My speed is \(self.speed)")
                sleep(1)
            }
        }
        print("I'm ready to stopped. My speed is \(self.speed)")
        self.speed -= self.speed
        isCarReadyToStop()
        print("I've just stopped. My speed is \(self.speed).")
    }
    
    func carIsMovingWithSpeed(speed: UInt) {
        guard isReadyToMove == true else {
          return  print("Car is not ready to move. Start car.")
        }
        switch Int(speed){
        case 0:
            self.speed = speed
            print("Not enought speed for moving")
        case 1...Int(self.speedMax):
            self.speed = speed
            print("Car is moving with speed = \(self.speed)")
        default:
            self.speed = self.speedMax - 1
            print("Car speed is \(self.speed) becouse car's max = \(self.speedMax)")
            
        }
        
    }
    
    func isCarReadyToStop(){
        print("Is car ready to stop? Answer: \(isReadyToStop)")
    }
    
    func doorsState(state: securityState){
        guard speed < self.autoBlockDoors else {
            return print("Too hight speed. Slow down to the \(autoBlockDoors - 1) speed")
        }
        self.doorsState = state
        print("The doors = \(self.doorsState)")
    }
}
    

var myFirstCar : Car = Car(model: "Ford", year: 2001, doors: 5, wheels: 4, trunk: true, carSuspension: .helicalCoilSprings, speedMax: 180, navigation: .gpsNavigator, transmission: .automatic, color: .yellow)


myFirstCar.carIsMovingWithSpeed(speed: 100)
myFirstCar.startAutoEngine(.turnedOn)
myFirstCar.carIsMovingWithSpeed(speed: 220)
print(myFirstCar.lights)

print("----------------")

myFirstCar.stoppedAutoEngine(.turnedOn)
myFirstCar.doorsState(state: .unblocked)
print("----------------")
myFirstCar.carIsMovingWithSpeed(speed: 19)
myFirstCar.doorsState(state: .unblocked)
myFirstCar.carIsMovingWithSpeed(speed: 190)

//myFirstCar.slowDownForStop()

//myFirstCar.stoppedAutoEngine(.turnedOn)



