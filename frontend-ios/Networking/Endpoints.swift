//
//  Endpoints.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.12.
//  This is suppose to help keep the URLs clean
//  Keeps all URLs in one place so I don’t hardcode strings all over the app.

import Foundation

enum Endpoints {
    static let baseURL = URL(string: "http://127.0.0.1:8000")!

    // MARK: - Health
    static func health() -> URL {
        baseURL.appendingPathComponent("api/v1/health")
    }

    // MARK: - Cards
    static func cardSearch(query: String) -> URL {
        var comps = URLComponents(
            url: baseURL.appendingPathComponent("api/v1/cards/search"),
            resolvingAgainstBaseURL: false
        )!
        comps.queryItems = [URLQueryItem(name: "q", value: query)]
        return comps.url!
    }

    static func cardDetail(id: String) -> URL {
        baseURL.appendingPathComponent("api/v1/cards/\(id)")
    }

    // MARK: - Binder
    static func binderAdd() -> URL {
        baseURL.appendingPathComponent("api/v1/binder/add")
    }
}

///My structure should be expect Centralizing URLs
