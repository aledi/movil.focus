//
//  MoviePlayerViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 09/09/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import MediaPlayer

class MoviePlayerViewController: UIViewController {
    
    var moviePlayer: MPMoviePlayerController!
    var videoName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let video = self.videoName, url = NSURL(string: Controller.videosURL + video) {
            moviePlayer = MPMoviePlayerController(contentURL: url)
            
            moviePlayer.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)
            self.view.addSubview(moviePlayer.view)
            
            moviePlayer.fullscreen = true
            moviePlayer.controlStyle = .Fullscreen
        } else {
            self.presentAlertWithTitle("Video no disponible", withMessage: "No hemos podido cargar el video. Por favor, póngase en contacto con el servicio de soporte.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
            self.performSegueWithIdentifier("exit", sender: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.moviePlayer.stop()
    }
    
}
