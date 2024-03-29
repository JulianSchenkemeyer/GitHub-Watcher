//
//  RequestManager.swift
//  GitHub-Watcher
//
//  Created by Julian Schenkemeyer on 27.11.22.
//

import Foundation


protocol RequestManagerProtocol {
	func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
	func loadData(from url: String) async throws -> Data
}

class RequestManager: RequestManagerProtocol {
	let apiManager: APIManagerProtocol
	let assetManager: AssetManagerProtocol
	let parser: DataParserProtocol


	init(apiManager: APIManagerProtocol = APIManager(), parser: DataParserProtocol = DataParser(), assetManager: AssetManagerProtocol = AssetManager()) {
		self.apiManager = apiManager
		self.assetManager = assetManager
		self.parser = parser
	}

	func perform<T>(_ request: RequestProtocol) async throws -> T where T : Decodable {
		let data = try await apiManager.perform(request)
		let decoded: T = try parser.parse(data: data)

		return decoded
	}

	func loadData(from url: String) async throws -> Data {
		let request = AssetRequest(urlString: url)

		let data = try await assetManager.perform(request)
		return data
	}
}
