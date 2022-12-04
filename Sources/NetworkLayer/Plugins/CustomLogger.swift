//
//  CustomLogger.swift
//  
//
//  Created by Mohaned Yossry on 04/12/2022.
//

import Foundation
import Moya

class CustomLogger: PluginType {
	func willSend(_ request: RequestType, target: TargetType) {
		#if DEBUG
		var headers = ""
		request.request?.headers.forEach({ header in
			headers += "| \(header.name): \(header.value)\n"
		})
		let strUrl = request.request?.url?.absoluteString ?? ""
		let body = request.request?.httpBody != nil ? String(data: request.request!.httpBody!, encoding: .utf8) : "{}"
		print("┌🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀")
		print("""
| Time: \(Date())
| Request: \(request.request?.method?.rawValue ?? "") \(strUrl)
| Request Body: \(body ?? "")
| Headers:\n\(headers)
""")
		print("└🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀")
		#endif
	}
	
	func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
		#if DEBUG
		switch result {
		case .success(let response):
			let strUrl = response.request?.url?.absoluteString ?? ""
			let data = String(data: response.data, encoding: .utf8)
			let method = response.request?.method?.rawValue ?? ""
			if (200...299).contains(response.statusCode) {
			print(
				"┌✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
			print(
			   """
			   | Time: \(Date())
			   | Endpoint: \(method) \(strUrl)
			   | Response Body [code: \(response.statusCode)]: \(data ?? "")
			   """
			)
			print(
				"└✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
			} else {
				logError(body: data ?? "", statusCode: response.statusCode, method: method, url: strUrl)
			}
			
		case .failure(let error):
			let strUrl = error.response?.request?.url?.absoluteString ?? ""
			let method = error.response?.request?.method?.rawValue ?? ""

			logError(body: error.failureReason ?? "", statusCode: error.errorCode, method: method, url: strUrl)
		}
		#endif
	}
	
	private func logError(body: String, statusCode: Int, method: String, url: String) {
		print(
			"┌🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬")
		print(
		   """
		   | Time: \(Date())
		   | Endpoint: \(method) \(url)
		   | Error [code: \(statusCode)]: \(body)
		   """
		)
		print(
			"└🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬")
	}
}
