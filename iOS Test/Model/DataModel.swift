//
//  DataModel.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import Foundation

class DataModel: Codable {
    let id, title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String?
    let backupDetails: BackupDetails?

    init(id: String, title: String, language: String, thumbnail: Thumbnail, mediaType: Int, coverageURL: String, publishedAt: String?, publishedBy: String?, backupDetails: BackupDetails?) {
        self.id = id
        self.title = title
        self.language = language
        self.thumbnail = thumbnail
        self.mediaType = mediaType
        self.coverageURL = coverageURL
        self.publishedAt = publishedAt
        self.publishedBy = publishedBy
        self.backupDetails = backupDetails
    }
}

class BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String

    init(pdfLink: String, screenshotURL: String) {
        self.pdfLink = pdfLink
        self.screenshotURL = screenshotURL
    }
}


class Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Double

    init(id: String, version: Int, domain: String, basePath: String, key: String, qualities: [Int], aspectRatio: Double) {
        self.id = id
        self.version = version
        self.domain = domain
        self.basePath = basePath
        self.key = key
        self.qualities = qualities
        self.aspectRatio = aspectRatio
    }
    
    func getImageUrl() -> String{
        return self.domain + "/" + self.basePath + "/0/" + self.key
    }
}
