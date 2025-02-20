//
//  NetworkError.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

enum NetworkError: LocalizedError {
    case invalidAPIKey
    case suspendedAPIKey
    case authenticationFailed
    case accessDenied
    case invalidURL
    
    case invalidParameters
    case invalidDateRange
    case invalidPage
    case invalidDate
    case tooManyRequests(limit: Int)
    case tooManyAppendResponses
    case invalidTimezone
    case confirmationRequired
    
    case invalidResponse
    case resourceNotFound
    case duplicateEntry
    case serviceOffline
    case maintenanceMode
    case timeout
    case invalidFormat
    case backendConnectionError
    
    case invalidToken
    case sessionNotFound
    case emailNotVerified
    case accountDisabled
    case userSuspended
    
    case decodingError(Error)
    case networkError(Error)
    case unknown(statusCode: Int, message: String?)
    
    var errorDescription: String? {
            switch self {
            case .invalidAPIKey:
                return "Invalid API key. Please check your API key."
            case .suspendedAPIKey:
                return "Your API key has been suspended. Please contact TMDB."
            case .authenticationFailed:
                return "Authentication failed. Please check your credentials."
            case .accessDenied:
                return "You don't have permission to access this resource."
                
            case .invalidParameters:
                return "Invalid parameters provided in the request."
            case .invalidDateRange:
                return "Invalid date range. Date range should not exceed 14 days."
            case .invalidPage:
                return "Invalid page number. Pages should be between 1 and 500."
            case .invalidDate:
                return "Invalid date format. Use YYYY-MM-DD format."
            case .tooManyRequests(let limit):
                return "Rate limit exceeded. Maximum requests allowed: \(limit)"
            case .tooManyAppendResponses:
                return "Too many append to response objects. Maximum is 20."
            case .invalidTimezone:
                return "Invalid timezone provided."
            case .confirmationRequired:
                return "Action needs confirmation. Please provide confirm=true parameter."
                
            case .invalidResponse:
                return "Received invalid response from the server."
            case .resourceNotFound:
                return "The requested resource could not be found."
            case .duplicateEntry:
                return "The data you tried to submit already exists."
            case .serviceOffline:
                return "Service is temporarily offline. Please try again later."
            case .maintenanceMode:
                return "The API is currently under maintenance. Please try again later."
            case .timeout:
                return "Request timed out. Please try again."
            case .invalidFormat:
                return "The requested format is not supported."
            case .backendConnectionError:
                return "Could not connect to the backend server."
                
            case .invalidToken:
                return "The provided token is invalid or expired."
            case .sessionNotFound:
                return "The requested session could not be found."
            case .emailNotVerified:
                return "Please verify your email address."
            case .accountDisabled:
                return "Your account has been disabled. Please contact TMDB."
            case .userSuspended:
                return "This user account has been suspended."
                
            case .decodingError(let error):
                return "Failed to decode response: \(error.localizedDescription)"
            case .networkError(let error):
                return "Network error occurred: \(error.localizedDescription)"
            case .unknown(let statusCode, let message):
                return "Unknown error occurred (Status: \(statusCode)): \(message ?? "No additional information")"
            case .invalidURL:
                return "Wrong URL Access"
            }
        }
    
    
    static func from(statusCode: Int, message: String?) -> NetworkError {
            switch statusCode {
            case 401:
                if message?.contains("API key") ?? false {
                    return .invalidAPIKey
                } else if message?.contains("suspended") ?? false {
                    return .suspendedAPIKey
                } else {
                    return .authenticationFailed
                }
            case 404:
                return .resourceNotFound
            case 422:
                if message?.contains("date range") ?? false {
                    return .invalidDateRange
                } else {
                    return .invalidParameters
                }
            case 429:
                return .tooManyRequests(limit: 40)
            case 503:
                if message?.contains("maintenance") ?? false {
                    return .maintenanceMode
                } else {
                    return .serviceOffline
                }
            case 504:
                return .timeout
            default:
                return .unknown(statusCode: statusCode, message: message)
            }
        }
}

