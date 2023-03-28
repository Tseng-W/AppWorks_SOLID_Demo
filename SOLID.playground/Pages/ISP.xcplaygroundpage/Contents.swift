//: [Previous](@previous)

// 違反 ISP 的要求
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

class Motorcycle: Vehicle {
    func start() {}

    func stop() {}

    func refuel() {}

    func accelerate() {}

    func brake() {}
}

class Bicycle: Vehicle {
    func start() {}

    func stop() {}

    func refuel() {}

    func accelerate() {}

    func brake() {}
}

//: [Next](@next)
