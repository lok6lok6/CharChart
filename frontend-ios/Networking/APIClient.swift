//
//  APIClient.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.12.
//
//  This is like my one door for network calls. i’ll start with a simple GET /health using URLSession and Swift’s async/await.
//

// APIClient.swift
import Foundation

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init(session: URLSession = .shared) {
        self.session = session

        let dec = JSONDecoder()
        // If your backend uses snake_case, keep this. If camelCase, change to .useDefaultKeys
        dec.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = dec

        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .convertToSnakeCase
        self.encoder = enc
    }

    // MARK: - Public
    func get<T: Decodable>(_ url: URL) async throws -> T {
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        attachCommonHeaders(&req)
        return try await execute(req)
    }

    func post<T: Decodable, U: Encodable>(_ url: URL, body: U) async throws -> T {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try encoder.encode(body)
        attachCommonHeaders(&req)
        return try await execute(req)
    }

    // MARK: - Health
    struct HealthResponse: Decodable { let status: String }

    func fetchHealth() async throws -> String {
        let resp: HealthResponse = try await get(Endpoints.health())
        return resp.status   // <-- returns a String like "ok"
    }

    // MARK: - Core executor
    private func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        #if DEBUG
        if let m = request.httpMethod, let u = request.url?.absoluteString {
            print("➡️ \(m) \(u)")
        }
        #endif

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpStatus(code: http.statusCode, body: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    // MARK: - Headers
    private func attachCommonHeaders(_ request: inout URLRequest) {
        // If you wired AuthInterceptor.shared.accessToken, set it here:
        // if let token = AuthInterceptor.shared.accessToken {
        //     request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
}

// MARK: - Errors
enum APIError: Error {
    case invalidResponse
    case httpStatus(code: Int, body: Data)
    case decoding(Error)
}
