// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "181481277e308ba5dff4d413a1a01572"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Note.self)
  }
}