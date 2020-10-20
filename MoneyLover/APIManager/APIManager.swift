//
//  APIManager.swift
//  MoneyLover
//
//  Created by Interns on 8/25/20.
//  Copyright © 2020 Interns. All rights reserved.
//

import UIKit
import Alamofire

class APIManager {
	var transactionId: Int?
	var selectedMonth: String?
	static let shareInstance = APIManager()

	private func post<T: Encodable>(url: String, params: T, headers: HTTPHeaders) -> DataRequest {
		return AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
	}
	private func get<T: Encodable>(url: String, params: T, headers: HTTPHeaders) -> DataRequest {
		return AF.request(url, method: .get, parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
	}
	private func put<T: Encodable>(url: String, queryParams: [String: String]? = nil, params: T, headers: HTTPHeaders) -> DataRequest {
		var urlComponents = URLComponents(string: url)
		if let queryParams = queryParams {
			let queryItems = queryParams.map({return URLQueryItem(name: $0.key, value: $0.value)})
			urlComponents?.queryItems = queryItems
		}

		let url = urlComponents?.url?.absoluteString ?? ""

		return AF.request(url, method: .put, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
	}
	private func delete(url: String, queryParams: [String: String]? = nil, params: String? = nil, headers: HTTPHeaders) -> DataRequest {
		var urlComponents = URLComponents(string: url)
		if let queryParams = queryParams {
			let queryItems = queryParams.map({return URLQueryItem(name: $0.key, value: $0.value)})
			urlComponents?.queryItems = queryItems
		}

		let url = urlComponents?.url?.absoluteString ?? ""

		return AF.request(url, method: .delete, parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
	}

	func callingSignUpAPI(signup: SignUpModel, completionHandler: @escaping ((UserModel.User?, String?) -> Void)) {
		let headers = headersHTTP(isContent: true, isAuth: false)
		post(url: Constant.signup_url, params: signup, headers: headers).responseJSON {[weak self] response in
				if response.response?.statusCode == 200 {
					// Success
					self?.castResponseObject(UserModel.User.self, data: response.data) { model, errorStr in
						completionHandler(model, errorStr)
					}
				} else {
					// Failure
					self?.reponseFail(response: response, completionHandler: completionHandler)
			}
		}
	}
	
	func callingSignInAPI(signin: SignInModel, completionHandler: @escaping ((UserModel?, String?) -> Void)) {
		let headers = headersHTTP(isContent: true, isAuth: false)
		post(url: Constant.signin_url, params: signin, headers: headers)
			.responseJSON {[weak self] response in
				if response.response?.statusCode == 200 {
					// Success
					self?.castResponseObject(UserModel.self, data: response.data) { model, errorStr in
						completionHandler(model, errorStr)
					}
				} else {
					// Failure
					self?.reponseFail(response: response, completionHandler: completionHandler)
				}
		}
	}

	func callingGetTransactionAPI(monthYearStr: String, completionHandler: @escaping (([TransactionModel]?, String?) -> Void)) {
		let headers = headersHTTP(isContent: false, isAuth: true)
		guard let date = DateFormatter(format: .monthYear).date(from: monthYearStr), let startDate = date.getFirstLastDay().start, let endDate = date.getFirstLastDay().end else { return }
		let fromString = DateFormatter(format: .serverDate).string(from: startDate)
		let toString = DateFormatter(format: .serverDate).string(from: endDate)
		let params: [String: String] = ["dateFrom": fromString, "dateTo": toString]
		get(url: Constant.transactionsPath, params: params, headers: headers).responseJSON {[weak self] response in

			if let data = response.data, let string = String(data: data, encoding: .utf8) {
				print("db - response \(string)")
			}
			if response.response?.statusCode == 200 {
				// Success
				self?.castResponseObject([TransactionModel].self, data: response.data, completionHandler: { model, errorStr in
					completionHandler(model ?? [], errorStr)
				})
			} else {
				// Failure
				self?.reponseFail(response: response, completionHandler: completionHandler)
			}
		}
	}
	func callingCreateTransactionAPI(create: CreateModel, completionHandler: @escaping ((TransactionModel?, String?) -> Void)) {
		let headers = headersHTTP(isContent: true, isAuth: true)
		post(url: Constant.transactionsPath, params: create, headers: headers).responseJSON {[weak self] response in
			if response.response?.statusCode == 200 {
				// Success
				self?.castResponseObject(TransactionModel.self, data: response.data) { model, errorStr in
					completionHandler(model, errorStr)
				}
			} else {
				// Failure
				self?.reponseFail(response: response, completionHandler: completionHandler)
			}
		}
	}
	func callingUpdateTransactionAPI(id: Int, update: CreateModel, completionHandler: @escaping((Bool?, String?) -> Void)) {
		let headers = headersHTTP(isContent: true, isAuth: true)
		put(url: Constant.transactionsPath + "/\(id)", params: update, headers: headers).responseJSON {[weak self] response in
			if response.response?.statusCode == 200 {
				// Success
				completionHandler(true, nil)
			} else {
				// Failure
				self?.reponseFail(response: response, completionHandler: completionHandler)
			}
		}
	}
	func callingDeleteTransactionAPI(id: Int, completionHandler: @escaping((Bool?, String?) -> Void)) {
		let headers = headersHTTP(isContent: true, isAuth: true)
		delete(url: Constant.transactionsPath + "/\(id)", headers: headers).responseJSON {[weak self] response in
			if response.response?.statusCode == 200 {
				// Success
				completionHandler(true, nil)
			} else {
				// Failure
				self?.reponseFail(response: response, completionHandler: completionHandler)
			}
		}
	}
	private func castResponseObject<T: Decodable>(_ type: T.Type, data: Data?, completionHandler: @escaping ((T?, String?) -> Void)) {
		guard let data = data else { return }
		let decoder = JSONDecoder()
		do {
			let model = try decoder.decode(T.self, from: data)
			completionHandler(model, nil)
		} catch {
			completionHandler(nil, "Cannot decode \(T.self)")
		}
	}
	private func reponseFail<T: Decodable>(response: AFDataResponse<Any>, completionHandler: @escaping((T?, String?) -> Void)) {
		if response.response?.statusCode == 401 {
			UserDefaultToken.tokenInstance.forceLoggout()
		} else {
			castResponseObject(MLError.self, data: response.data) { model, _ in
				guard let mlerror = model else { return }
				completionHandler(nil, mlerror.message)
			}
		}
	}
	private func headersHTTP(isContent: Bool, isAuth: Bool) -> HTTPHeaders {
		var headers: HTTPHeaders = []
		if isContent {
			headers.add(.contentType("application/json"))
		}
		if isAuth {
			headers.add(.authorization(bearerToken: UserDefaultToken.tokenInstance.getToken()))
		}
		return headers
	}
}
