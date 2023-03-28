//: [Previous](@previous)

import Foundation

class Rectangle {
    private var width: Double = 0
    private var height: Double = 0

    func setWidth(_ width: Double) {
        self.width = width
    }

    func setHeight(_ height: Double) {
        self.height = height
    }

    func getArea() -> Double {
        return width * height
    }
}

class Square: Rectangle {
    override func setWidth(_ width: Double) {
        super.setWidth(width)
        super.setHeight(width)
    }

    override func setHeight(_ height: Double) {
        super.setWidth(height)
        super.setHeight(height)
    }
}

let rect = Rectangle()
rect.setWidth(4)
rect.setHeight(5)
rect.getArea() == 20 // Output: true

let square = Square()
square.setWidth(4)
square.setWidth(5)
square.getArea() == 25  // Output: true

func usingRectangle(rect: Rectangle) {
    rect.setWidth(4)
    rect.setHeight(5)
    assert(rect.getArea() == 20)
}

usingRectangle(rect: Rectangle())
usingRectangle(rect: Square()) // Assert failed

//: [Next](@next)
