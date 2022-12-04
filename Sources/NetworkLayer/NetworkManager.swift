import Foundation
import Combine
import CombineMoya
import Moya

@available(iOS 13.0, *)
public protocol NetworkManager {

	func makeRequest<Response: Codable>(_ target: TargetType) -> AnyPublisher<Response, Error>
}
public class DefaultNetworkManager<T: TargetType>: NetworkManager {
	
	private let provider: MoyaProvider<T>
	
	init() {
		let commonPlugins: [PluginType] = [
			CustomLogger(),
		].compactMap { $0 }
		
		provider = MoyaProvider( plugins: commonPlugins)
	}
	
	public func makeRequest<Response: Codable>(_ target: TargetType) -> AnyPublisher<Response, Error> {
		guard let target = target as? T else {
		  fatalError("Unexpected target sent to \(#function)")
		}
		return provider.requestPublisher(target, callbackQueue: DispatchQueue.main).tryMap { result -> Response in
			let apiResponse = try JSONDecoder().decode(Response.self, from: result.data)
			return apiResponse
		} .receive(on: DispatchQueue.main)
		  .eraseToAnyPublisher()
	}
}
