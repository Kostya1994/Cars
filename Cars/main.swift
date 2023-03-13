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

protocol Car {
    var model : String {set get}
    var year : UInt {set get}
    var doors : UInt {set get}
    var wheels : UInt {set get}
    var trunkVolume : UInt {set get}
    var baggage  : [UInt] {set get}
    var carSuspension : suspension {set get}
    var speedMax : UInt {set get}
    var navigation : navigationSystem {set get}
    var transmission : transmissionOption {set get}
    var autoBlockDoors: UInt {set get}
    var speed : UInt {set get}
    var doorsState : securityState {set get}
    var lights : lightsState {set get}
    var autoEngine : engineState {set get}
    var color : colors {set get}
}
extension Car{
    var freeVolumeInTrunk: UInt{
        get{
            return trunkVolume - baggageVolumSum
        }
    }
    var baggageVolumSum : UInt{
        get{
            var count: UInt = 0
            for i in 0..<baggage.count{
                count += baggage[i]
            }
            return count
        }
    }
    var isReadyToMove : Bool{
        get{
            return autoEngine == .started ? true : false
        }
    }
    var isReadyToStop : Bool{
        get{
            return speed == 0 ? true : false
        }
    }
    mutating func startAutoEngine(_ carLights: lightsState) {
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
    
    mutating func stoppedAutoEngine(_ carLights: lightsState) {
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
    
    mutating func slowDownForStop() {
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
    
    mutating func carIsMovingWithSpeed(speed: UInt) {
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
    
    mutating func isCarReadyToStop(){
        print("Is car ready to stop? Answer: \(isReadyToStop)")
    }
    
    mutating func doorsState(state: securityState){
        guard speed < self.autoBlockDoors else {
            return print("Too hight speed. Slow down to the \(autoBlockDoors - 1) speed")
        }
        self.doorsState = state
        print("The doors = \(self.doorsState)")
    }
    
    mutating func putInTrunk(newBag: UInt){
        guard newBag <= freeVolumeInTrunk else {
            return print("There is no free place for your bag. Free place = \(freeVolumeInTrunk)")
        }
        self.baggage.append(newBag)
        print("Your put something in the trank. Free place = \(freeVolumeInTrunk)")
    }
    
    mutating func getFromTrunk(myBag: UInt){
        guard self.baggageVolumSum > 0  else {
            return print("There is nothing in your trunk. Free place = \(freeVolumeInTrunk)")
        }
        let newArray = self.baggage
        var thing : Bool = false
        for i in (0..<newArray.count){
            if newArray[i] == myBag{
                self.baggage.remove(at: i)
                thing = true
                break
            }
        }
        printAboutBad(answer: thing, bag: myBag)
    }
    
    mutating func printAboutBad(answer : Bool, bag: UInt){
        if answer == true {
            print("Here you are = \(bag). Free place = \(freeVolumeInTrunk)")
        }else{
            print("There is no your bag = \(bag). Free place = \(freeVolumeInTrunk)")
        }
    }
}

enum turboOpt : UInt {
    case zero = 0
    case one = 10
    case two = 15
    case three = 25
}

class SportCar : Car {
    var model : String
    var year : UInt
    var doors : UInt
    var wheels : UInt
    var trunkVolume : UInt
    var baggage  : [UInt]
    var carSuspension : suspension
    var speedMax : UInt
    var navigation : navigationSystem
    var transmission : transmissionOption
    internal var autoBlockDoors: UInt = 20
    var speed : UInt{
        willSet (newSpeed){
            if newSpeed >= autoBlockDoors{
                self.doorsState = .blocked
                print("Doors \(self.doorsState) becouse speed are hight than \(autoBlockDoors)")
            }
            return
        }
    }
    internal var doorsState : securityState
    var lights : lightsState
    var autoEngine : engineState {
        didSet{
            print("Auto engine = \(autoEngine)")
        }
    }
    var color : colors
    var isReadyToMove : Bool {
        get{
            return autoEngine == .started ? true : false
        }
    }
    private var isReadyToStop : Bool {
        get{
            return speed == 0 ? true : false
        }
    }
    var myTurbo : Bool
    var turbo : turboOpt
    
    init(model: String, year: UInt, doors: UInt, wheels: UInt, trunkVolume: UInt, carSuspension: suspension, speedMax: UInt, navigation: navigationSystem, transmission: transmissionOption,  color: colors, myTurbo: Bool) {
        self.doorsState = .unblocked
        self.model = model
        self.year = year
        self.doors = doors
        self.wheels = wheels
        self.trunkVolume = trunkVolume
        self.baggage = []
        self.carSuspension = carSuspension
        self.speedMax = speedMax
        self.navigation = navigation
        self.transmission = transmission
        self.speed = 0
        self.lights = .turnedOff
        self.autoEngine = .stopped
        self.color = color
        self.turbo = .zero
        self.myTurbo = myTurbo
    }
    
    func carIsMovingWithSpeed(speed: UInt) {
        guard isReadyToMove == true else {
            return  print("Car is not ready to move. Start car.")
        }
        switch (Int(speed), self.myTurbo) {
        case (0, true || false ) :
            self.speed = speed
            print("Not enought speed for moving")
        case (1...Int(self.speedMax), false):
            self.speed = speed
            print("Car is moving with speed = \(self.speed)")
        case (1...Int(self.speedMax), true):
            if speed + self.turbo.rawValue > self.speedMax{
                self.speed = speed + self.turbo.rawValue
                print("Car is moving with speed = \(self.speed) for 5 sec, it is more than car's max = \(self.speedMax)")
                sleep(5)
                self.speed = self.speedMax - 1
                print("Car is moving with speed = \(self.speed)")
            }else{
                self.speed = speed + self.turbo.rawValue
                print("Car is moving with speed = \(self.speed)")
            }
        default:
            self.speed = self.speedMax - 1
            print("Car speed is \(self.speed) becouse car's max = \(self.speedMax)")
        }
    }
    
    func turnOnOffTurbo(opt: turboOpt){
        guard self.myTurbo == true else {
            return  print("Car without turbo")
        }
        self.turbo = opt
    }
}

extension SportCar{
    convenience init(model: String, year: UInt, trunkVolume: UInt, speedMax: UInt,  color: colors){
        self.init(model: model, year: year, doors: 4, wheels: 4, trunkVolume: trunkVolume, carSuspension: .helicalCoilSprings, speedMax: speedMax, navigation: .secondDriver, transmission: .automatic,  color: color, myTurbo: true)
    }
}
var firstSportCar : SportCar = SportCar(model: "Ford", year: 2004, doors: 4, wheels: 4, trunkVolume: 100, carSuspension: .helicalCoilSprings, speedMax: 300, navigation: .secondDriver, transmission: .automatic, color: .blue, myTurbo: true)

var secondSportCar: SportCar = SportCar(model: "Mazda", year: 2010, trunkVolume: 100, speedMax: 200, color: .white)

firstSportCar.startAutoEngine(.turnedOn)
firstSportCar.carIsMovingWithSpeed(speed: 200)
firstSportCar.carIsMovingWithSpeed(speed: 270)
firstSportCar.turnOnOffTurbo(opt: .three)
firstSportCar.carIsMovingWithSpeed(speed: 270)
firstSportCar.carIsMovingWithSpeed(speed: 290)


//final class TrunkCar : Car {
//    init(model: String, year: UInt, wheels: UInt, volumeForGoods: UInt, speedMax: UInt, transmission: transmissionOption, color: colors) {
//        super.init(model: model, year: year, doors: 2, wheels: wheels, trunkVolume: volumeForGoods, carSuspension: .longitudinalSprings, speedMax: speedMax, navigation: .gpsNavigator, transmission: transmission, color: color)
//    }
//
//}
//
//var firstTrunkCar : TrunkCar = TrunkCar(model: "Ford", year: 2004, wheels: 6, volumeForGoods: 300, speedMax: 160, transmission: .automatic, color: .yellow)
//
//firstTrunkCar.putInTrunk(newBag: 301)
//
//
//
//final class TrunkCar : Car {
//init(model: String, year: UInt, wheels: UInt, volumeForGoods: UInt, speedMax: UInt, transmission: transmissionOption, color: colors) {
//    super.init(model: model, year: year, doors: 2, wheels: wheels, trunkVolume: volumeForGoods, carSuspension: .longitudinalSprings, speedMax: speedMax, navigation: .gpsNavigator, transmission: transmission, color: color)
//}
//
//}
//
//var firstTrunkCar : TrunkCar = TrunkCar(model: "Ford", year: 2004, wheels: 6, volumeForGoods: 300, speedMax: 160, transmission: .automatic, color: .yellow)
//
//firstTrunkCar.putInTrunk(newBag: 301)
