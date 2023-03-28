//: [Previous](@previous)

import Foundation

// MARK: Against SRP versions.
struct Product {
    private(set) var title: String
    private(set) var price: Double
    private(set) var taxRate: Double

    init(title: String, price: Double, taxRate: Double) {
        self.title = title
        self.price = price
        self.taxRate = taxRate
    }

    func calculateTax() -> Double {
        return price * taxRate
    }
}

struct Product_2 {
    private(set) var title: String
    private(set) var price: Double
    private(set) var taxRate: Double

    init(title: String, price: Double, taxRate: Double) {
        self.title = title
        self.price = price
        self.taxRate = taxRate
    }

    // Extend exemptedAmount
    func calculateTax(exemptedAmount: Double) -> Double {
        return max(price * taxRate - exemptedAmount, 0)
    }
}

struct Product_3 {
    private(set) var title: String
    private(set) var price: Double
    private(set) var taxRate: Double
    private(set) var exchangeRate: Double

    init(title: String, price: Double, taxRate: Double, exchangeRate: Double) {
        self.title = title
        self.price = price
        self.taxRate = taxRate
        self.exchangeRate = exchangeRate
    }

    // Extend exemptedAmount
    func calculateTax(exemptedAmount: Double) -> Double {
        return max(price * taxRate * exchangeRate - exemptedAmount, 0)
    }
}

// MARK: Refactor to conform SPR
struct Product_SRP {
    private(set) var title: String
    private(set) var price: Double
    private(set) var exchangeRate: Double

    init(title: String, price: Double, exchangeRate: Double) {
        self.title = title
        self.price = price
        self.exchangeRate = exchangeRate
    }
}

struct TaxCalculator {
    private var taxRate: Double

    init(taxRate: Double) {
        self.taxRate = taxRate
    }

    func calculateTax(product: Product_SRP, exemptedAmount: Double) -> Double {
        return max(product.price * taxRate * product.exchangeRate - exemptedAmount, 0)
    }
}
let product = Product_SRP(title: "SRP", price: 100, exchangeRate: 1)
TaxCalculator(taxRate: 0.1).calculateTax(product: product, exemptedAmount: 3)

//: [Next](@next)
