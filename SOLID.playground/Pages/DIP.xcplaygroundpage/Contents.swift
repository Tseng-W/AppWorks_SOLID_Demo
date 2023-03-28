//: [Previous](@previous)

protocol Vehicle {
    func start()
    func stop()
    func refuel()
    func accelerate()
    func brake()
}

class Car: Vehicle {
    func start() {}

    func stop() {}

    func refuel() {}

    func accelerate() {}

    func brake() {}
}

class Driver {
    func drive(_ vehicle: Vehicle) {
        vehicle.refuel()
        vehicle.start()
        vehicle.accelerate()
    }
}


//: [Next](@next)
