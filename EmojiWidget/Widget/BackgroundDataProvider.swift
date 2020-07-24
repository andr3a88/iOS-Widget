//
//  WidgetDataProvider.swift
//  iOS14-Widget
//
//  Created by Andrea Stevanato on 14/07/2020.
//

import WidgetKit
import Foundation

class BackgroundDataProvider: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "widget_image_downloader")
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    var completionHandler: (() -> ())?

    func performRequest() {
        print("performRequest")
        let backgroundTask = urlSession.downloadTask(with: URL(string: "https://via.placeholder.com/150")!)
        backgroundTask.earliestBeginDate = Date().addingTimeInterval(5)
        backgroundTask.countOfBytesClientExpectsToSend = 200
        backgroundTask.countOfBytesClientExpectsToReceive = 250 * 1024
        backgroundTask.resume()
    }


    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishDownloadingTo")
    }

    /// When all events have been delivered, the system calls urlSessionDidFinishEvents
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        self.completionHandler?()
        WidgetCenter.shared.reloadTimelines(ofKind: "com.as.ios14.widget.iOS14-Widget.Widget")
        print("completionHandler")
    }

}


