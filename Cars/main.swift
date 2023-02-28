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
    let trunkVolume : UInt
    var freeVolumeInTrunk: UInt{
        get{
            return trunkVolume - baggageVolumSum
        }
    }
    var baggage  : [UInt]
    {
        willSet{
            print("The baggage will update. \(baggage) and \(freeVolumeInTrunk)")
           }
        didSet{
            print("The baggage was updated. \(baggage) and \(freeVolumeInTrunk)")
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

    let carSuspension : suspension
    let speedMax : UInt
    let navigation : navigationSystem
    let transmission : transmissionOption
    private let autoBlockDoors: UInt = 20
    var speed : UInt{
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
    init(model: String, year: UInt, doors: UInt, wheels: UInt, trunkVolume: UInt, carSuspension: suspension, speedMax: UInt, navigation: navigationSystem, transmission: transmissionOption, color: colors) {
        self.model = model
        self.year = year
        self.doors = doors
        self.wheels = wheels
        self.baggage = []
        self.trunkVolume = trunkVolume
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
    
    func putInTrunk(newBag: UInt){
        guard newBag <= freeVolumeInTrunk else {
            return print("There is no free place for your bag. Free place = \(freeVolumeInTrunk)")
        }
        self.baggage.append(newBag)
        print("Your put something in the trank. Free place = \(freeVolumeInTrunk)")
    }
    
    func getFromTrunk(myBag: UInt){
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
    func printAboutBad(answer : Bool, bag: UInt){
        if answer == true {
            print("Here you are = \(bag). Free place = \(freeVolumeInTrunk)")
        }else{
            print("There is no your bag = \(bag). Free place = \(freeVolumeInTrunk)")
        }
    }
}
    
    
var myFirstCar : Car = Car(model: "Ford", year: 2001, doors: 5, wheels: 4, trunkVolume: 200, carSuspension: .helicalCoilSprings, speedMax: 180, navigation: .gpsNavigator, transmission: .automatic, color: .yellow)


//myFirstCar.carIsMovingWithSpeed(speed: 100)
//myFirstCar.startAutoEngine(.turnedOn)
//myFirstCar.carIsMovingWithSpeed(speed: 220)
//print(myFirstCar.lights)
//
//print("----------------")
//
//myFirstCar.stoppedAutoEngine(.turnedOn)
//myFirstCar.doorsState(state: .unblocked)
//print("----------------")
//myFirstCar.carIsMovingWithSpeed(speed: 19)
//myFirstCar.doorsState(state: .unblocked)
//myFirstCar.carIsMovingWithSpeed(speed: 190)

//myFirstCar.slowDownForStop()

//myFirstCar.stoppedAutoEngine(.turnedOn)
//myFirstCar.putInTrunk(newBag: 20)
//myFirstCar.putInTrunk(newBag: 20)
//myFirstCar.putInTrunk(newBag: 19)
//myFirstCar.putInTrunk(newBag: 161)
//myFirstCar.putInTrunk(newBag: 1)
//
//print("----------------")
//myFirstCar.getFromTrunk(myBag: 19)
//myFirstCar.getFromTrunk(myBag: 20)

enum turboOpt : UInt {
    case zero = 0
    case one = 10
    case two = 15
    case three = 25
}

final class SportCar : Car {
    let myTurbo : Bool
    var turbo : turboOpt
    init(model: String, year: UInt, doors: UInt, speedMax: UInt, color: colors, myTurbo: Bool) {
        self.turbo = .zero
        self.myTurbo = myTurbo
        super.init(model: model, year: year, doors: doors, wheels: 4, trunkVolume: 0, carSuspension: .helicalCoilSprings, speedMax: speedMax, navigation: .secondDriver, transmission: .manual, color: color)
    }
    
    override func carIsMovingWithSpeed(speed: UInt) {
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

var firstSportCar : SportCar = SportCar(model: "ford", year: 200, doors: 2, speedMax: 280, color: .white, myTurbo: true)

firstSportCar.startAutoEngine(.turnedOn)
firstSportCar.carIsMovingWithSpeed(speed: 200)
firstSportCar.carIsMovingWithSpeed(speed: 270)
firstSportCar.turnOnOffTurbo(opt: .three)
firstSportCar.carIsMovingWithSpeed(speed: 270)
firstSportCar.carIsMovingWithSpeed(speed: 290)

final class TrunkCar : Car {
    init(model: String, year: UInt, wheels: UInt, volumeForGoods: UInt, speedMax: UInt, transmission: transmissionOption, color: colors) {
        super.init(model: model, year: year, doors: 2, wheels: wheels, trunkVolume: volumeForGoods, carSuspension: .longitudinalSprings, speedMax: speedMax, navigation: .gpsNavigator, transmission: transmission, color: color)
    }
    
}

var firstTrunkCar : TrunkCar = TrunkCar(model: "Ford", year: 2004, wheels: 6, volumeForGoods: 300, speedMax: 160, transmission: .automatic, color: .yellow)

firstTrunkCar.putInTrunk(newBag: 301)
