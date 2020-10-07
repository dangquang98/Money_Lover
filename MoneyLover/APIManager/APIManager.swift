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
	static let shareInstance = APIManager()

	private func post<T: Encodable>(url: String, params: T, headers: HTTPHeaders) -> DataRequest {
		return AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
	}
	private func get<T: Encodable>(url: String, params: T, headers: HTTPHeaders) -> DataRequest {
		return AF.request(url, method: .get, parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
	}

	func callingSignUpAPI(signup: SignUpModel, completionHandler: @escaping ((UserModel.User?, String?) -> Void)) {
		let headers: HTTPHeaders = [
			.contentType("application/json")
		]
		post(url: Constant.signup_url, params: signup, headers: headers).responseJSON {[weak self] response in
				if response.response?.statusCode == 200 {
					// Success
					self?.castResponseObject(UserModel.User.self, data: response.data) { model, errorStr in
						completionHandler(model, errorStr)
					}
				} else {
					// Failure
					self?.castResponseObject(MLError.self, data: response.data) { model, _ in
						guard let mlerror = model else { return }
						completionHandler(nil, mlerror.message)
					}
			}
		}
	}
	func callingSignInAPI(signin: SignInModel, completionHandler: @escaping ((UserModel?, String?) -> Void)) {
		let headers: HTTPHeaders = [
			.contentType("application/json")
		]
		post(url: Constant.signin_url, params: signin, headers: headers)
			.responseJSON {[weak self] response in
				if response.response?.statusCode == 200 {
					// Success
					self?.castResponseObject(UserModel.self, data: response.data) { model, errorStr in
						completionHandler(model, errorStr)
					}
				} else {
					// Failure
					self?.castResponseObject(MLError.self, data: response.data) { model, _ in
						guard let mlerror = model else { return }
						completionHandler(nil, mlerror.message)
					}
				}
		}
	}
	func callingGetTransactionAPI(dateFrom: String, dateTo: String, completionHandler: @escaping (([TransactionModel], String?) -> Void)) {
		let headers: HTTPHeaders = [
		.contentType("applicaton/json"),
		.authorization(bearerToken: UserDefaultToken.tokenInstance.getToken())
		]
		let params: [String: String] = ["dateFrom": dateFrom, "dateTo": dateTo]
		get(url: Constant.transactionsPath, params: params, headers: headers).responseJSON {[weak self] response in

			if let data = response.data, let string = String(data: data, encoding: .utf8) {
				print("db - response \(string)")
			}
			if response.response?.statusCode == 200 {
				// Success
				self?.castResponseObject([TransactionModel].self, data: response.data, completionHandler: { model, errorStr in
					completionHandler(model ?? [], errorStr)
					print(model ?? [])
				})
			} else {
				// Failure
				self?.castResponseObject(MLError.self, data: response.data) { model, _ in
					guard let mlerror = model else { return }
					completionHandler([], mlerror.message)
				}
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
}
