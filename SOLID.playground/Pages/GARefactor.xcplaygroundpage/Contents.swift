//: [Previous](@previous)

import UIKit

// MARK: - Deprecated GA System

class GASender {
    static let shared: GASender = .init()

    func sendGAEvent(eventName: String, parameters: [String: String]) {
        print("GA evnet sent: eventName: ", eventName, " parameters: ", parameters)
    }

    func sendGAScreen(screenClass: String, name: String) {
        print("GA screen sent: screenClass: ", screenClass, " name: ", name)
    }
}

// MARK: Used to store GA parameters and provide send event interface
class GAManager {
    static let shared: GAManager = .init()

    private var dict: [String: String] = [:]

    func setVariable(key: String, value: String) {
        dict[key] = value
    }

    func sendEvent(eventName: String, formatString: String) {
        let separator = "/"
        let parameters = formatString.split(separator: separator).map(String.init)
        let replacedParameters = parameters.compactMap({ dict[$0] }).joined(separator: separator)
        GASender.shared.sendGAEvent(eventName: eventName, parameters: ["path": replacedParameters])
    }

    func sendScreen(screenClass: String, formatString: String) {
        let separator = "/"
        let parameters = formatString.split(separator: separator).map(String.init)
        let replacedParameters = parameters.compactMap({ dict[$0] }).joined(separator: separator)
        GASender.shared.sendGAScreen(screenClass: screenClass, name: replacedParameters)
    }
}

GAManager.shared.setVariable(key: "eventName", value: "SomeEvent")
GAManager.shared.setVariable(key: "linkTitle", value: "SomeWebTitle")
GAManager.shared.setVariable(key: "routeType", value: "DeepLink")

GAManager.shared.sendEvent(eventName: "SomeEvent", formatString: "routeType/eventName/linkTitle")
GAManager.shared.sendScreen(screenClass: "SomeViewClass", formatString: "routeType/linkTitle")

// MARK: - New GA system
extension SendableParameter {
    func parameter(_ type: Parameter, force: Bool = true) -> String {
        guard let value = parameterDict[type], let value else {
            // 預期 Parameter 為空，顯示軟性錯誤提示
            if force { fatalError() }
            return ""
        }
        return String(value)
    }
}

protocol SendableParameter<Parameter> {
    associatedtype Parameter: Hashable
    var parameterDict: [Parameter: LosslessStringConvertible?] { get }
    init(parameters: [Parameter: LosslessStringConvertible?])

    func parameter(_ type: Parameter, force: Bool) -> String
}

protocol TrackableFormatter<Parameter> {
    associatedtype Parameter: SendableParameter
    func format(parameters params: Parameter) -> Sendable
}

protocol FormatterProvider<Parameter> {
    associatedtype Parameter
    var formatter: any TrackableFormatter<Parameter> { get }
}

protocol Sender<SomeEvent>: AnyObject {
    associatedtype SomeEvent: FormatterProvider
    func send(event: SomeEvent)
}

extension Sender {
    func send(event: SomeEvent) {
        // 通過 Singleton 的泛型發送器將事件送出
        dump("Sender sent event: \(event)")
    }
}

protocol Sendable {
    var event: Event { get }
}

enum Event {
    case firebase(event: FirebaseEvent)
}

enum FirebaseEvent {
    case action(any FirebaseAction)
    case screen(any FirebaseScreen)
}

protocol FirebaseScreen {
    var screenClass: String? { get }
    var screenName: String { get }
}

protocol FirebaseAction {
    var action: String { get }
    var parameters: [String: LosslessStringConvertible] { get }
}

struct MockSendable: Sendable {
    private(set) var event: Event
    static func event(action: String, parameter: [String: LosslessStringConvertible]) -> Sendable {
        return MockSendable(event: .firebase(event: .action(MockFirebaseAction(action: action, parameters: parameter))))
    }

    static func screen(screenClass: String?, screenName: String) -> Sendable {
        return MockSendable(event: .firebase(event: .screen(MockFirebaseScreen(screenClass: screenClass, screenName: screenName))))
    }
}

struct MockFirebaseAction: FirebaseAction {
    var action: String
    var parameters: [String : LosslessStringConvertible]
}

struct MockFirebaseScreen: FirebaseScreen {
    var screenClass: String?
    var screenName: String
}

// MARK: - 新 GA System 使用
class View: UIViewController {
    typealias PresenterProtocol = Sender<Presenter.GAEvent>
    private let presenter: any PresenterProtocol

    init(presenter: any PresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fooAction() {
        presenter.send(event: .action(.fooAction))
    }
}

class Presenter {
    private var gaParameter: GAParameter
    init(gaParameter: GAParameter) {
        self.gaParameter = gaParameter
    }
}

// MARK: Sender
extension Presenter: Sender {
    typealias SomeEvent = GAEvent

    enum GAEvent: FormatterProvider {
        case action(Action)
        case screen(Screen)

        var formatter: any TrackableFormatter<GAParameter> {
            switch self {
            case .action(let action):
                switch action {
                case .fooAction: return FooActionFormatter()
                }
            case .screen(let screen):
                switch screen {
                case .fooScreen: return FooScreenFormatter()
                }
            }
        }
    }

    struct GAParameter: SendableParameter {
        enum Parameter {
            case foo, lol, doge
        }

        var parameterDict: [Parameter: LosslessStringConvertible?]

        init(parameters: [Parameter: LosslessStringConvertible?] = [:]) {
            self.parameterDict = parameters
        }
    }

    private struct FooActionFormatter: TrackableFormatter {
        func format(parameters params: GAParameter) -> Sendable {
            return MockSendable.event(
                action: "fooAction",
                parameter: [
                    "foo": params.parameter(.foo) + params.parameter(.doge, force: false)
                ])
        }
    }

    enum Action {
        case fooAction
    }

    enum Screen {
        case fooScreen
    }

    private struct FooScreenFormatter: TrackableFormatter {
        func format(parameters params: GAParameter) -> Sendable {
            return MockSendable.screen(
                screenClass: "FooScreenClass",
                screenName: params.parameter(.foo) + params.parameter(.doge, force: false)
            )
        }
    }
}

let view = View(presenter: Presenter(gaParameter: .init()))

view.fooAction()

//: [Next](@next)
