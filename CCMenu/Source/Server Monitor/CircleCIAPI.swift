/*
 *  Copyright (c) Erik Doernenburg and contributors
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use these files except in compliance with the License.
 */

import Foundation
import Combine


class CircleCIAPI {
    
    static let clientId = "4eafcf49451c588fbeac"

    // MARK: - repositories, workflows, and branches

    static func requestForWorkflow(pipeline: String, token: String?) -> URLRequest {
        let path = String(format: "/pipeline/%@/workflow", pipeline)
        let queryParams = [
            "per_page": "100",
        ];
        return makeRequest(baseUrl: baseURL(forAPI: true), path: path, params: queryParams, token: token)
    }
    
    static func requestForPipelines(org: String, token: String?) -> URLRequest {
        let path = String(format: "pipeline?org-slug=%@", org)
        let queryParams = [
            "per_page": "100",
        ];
        return makeRequest(baseUrl: baseURL(forAPI: true), path: path, params: queryParams, token: token)
    }



    // MARK: - device flow and applications

    static func requestForDeviceCode() -> URLRequest {
        let path = "/login/device/code"
        let queryParams = [
            "client_id": clientId,
            "scope": "repo",
        ];
        return makeRequest(method: "POST", baseUrl: baseURL(forAPI: false), path: path, params: queryParams)
    }

    // MARK: - helper functions

    private static func baseURL(forAPI: Bool) -> String {
        if let defaultsBaseURL = UserDefaults.active.string(forKey: "CircleCIBaseURL") {
            return defaultsBaseURL
        }
        return forAPI ? "https://circleci.com/api/v2" : "https://circleci.com"
    }

    private static func makeRequest(method: String = "GET", baseUrl: String, path: String, params: Dictionary<String, String>, token: String? = nil) -> URLRequest {
        var components = URLComponents(string: baseUrl)!
        components.path = path
        components.queryItems = params.map({ URLQueryItem(name: $0.key, value: $0.value) })
        // TODO: Consider filtering token when the URL is overwritten via defaults
        return makeRequest(method: method, url: components.url!, token: token)
    }

    private static func makeRequest(method: String = "GET", url: URL, token: String?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let token, !token.isEmpty {
            request.setValue(URLRequest.bearerAuthValue(token: token), forHTTPHeaderField: "Circle-Token")
        }
        return request
    }

}
