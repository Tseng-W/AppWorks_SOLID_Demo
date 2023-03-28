import UIKit

// MARK: Against OCP version.
enum Shape {
    case circle(radius: Double)
    case square(side: Double)
    case rectangle(width: Double, height: Double)
    case triangle(base: Double, height: Double)
    var area: Double {
        switch self {
        case let .circle(radius):
            return Double.pi * pow(radius, 2)
        case let .square(side):
            return pow(side, 2)
        case let .rectangle(width, height):
            return width * height
        case let .triangle(base, height):
            return 0.5 * base * height
        }
    }
}

func doSomething(shape: Shape) {
    switch shape {
    case .circle: break
    case .square: break
    case .rectangle: break
    case .triangle: break
    }
}

enum Shape_2 {
    case circle(radius: Double)
    case square(side: Double)
    case rectangle(width: Double, height: Double)
    case triangle(base: Double, height: Double)
    case trapezoid(topBase: Double, bottomBase: Double, height: Double)
    var area: Double {
        switch self {
        case let .circle(radius):
            return Double.pi * pow(radius, 2)
        case let .square(side):
            return pow(side, 2)
        case let .rectangle(width, height):
            return width * height
        case let .triangle(base, height):
            return 0.5 * base * height
        case let .trapezoid(topBase, bottomBase, height):
            return 0.5 * (topBase + bottomBase) * height
        }
    }
}

func doSomething_2(shape: Shape_2) {
    switch shape {
    case .circle: break
    case .square: break
    case .rectangle: break
    case .triangle: break
    case .trapezoid: break
    }
}


// MARK: Conform OCP version
protocol Shape_OCP {
    var area: Double { get }
}

struct Circle: Shape_OCP {
    let radius: Double

    var area: Double {
        return Double.pi * pow(radius, 2)
    }
}

struct Square: Shape_OCP {
    let side: Double

    var area: Double {
        return pow(side, 2)
    }
}

struct Rectangle: Shape_OCP {
    let width: Double
    let height: Double

    var area: Double {
        return width * height
    }
}

struct Triangle: Shape_OCP {
    let base: Double
    let height: Double

    var area: Double {
        return 0.5 * base * height
    }
}

struct Trapezoid: Shape_OCP {
    let topBase: Double
    let bottomBase: Double
    let height: Double

    var area: Double {
        return 0.5 * (topBase + bottomBase) * height
    }
}

func doSomething_2(shape: Shape_OCP) {
    print(shape.area)
}
