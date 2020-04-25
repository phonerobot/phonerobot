/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit


class MarkerFollowViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var timer: Foundation.Timer!
    var command:String = ""
    var currentNode: SCNNode? = nil
    
    var x:Float = 0.0
    var y:Float = 0.0
    var z:Float = 0.0
    
    
    @objc
    func imageLost(_ sender: Foundation.Timer){

        if let delegate = self.delegate {
                                delegate.onSendControllerPadButtonStatus(tag: 5, isPressed: false)
                            }
    }
    
    
    weak var delegate: ControllerPadViewControllerDelegate?

   
        override func viewDidLoad() {
            super.viewDidLoad()
            
            UIApplication.shared.isIdleTimerDisabled = true
            
            // Set the view's delegate
            sceneView.delegate = self
            
            // Create a new scene
            let scene = SCNScene(named: "art.scnassets/ship.scn")!
            
            // Set the scene to the view
            sceneView.scene = scene
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARImageTrackingConfiguration()
            
            guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
            configuration.trackingImages = arImages
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
        
        

        // MARK: - Session management (Image detection setup)
        
        /// Prevents restarting the session while a restart is in progress.
    //    var isRestartAvailable = true
    //
    //    /// Creates a new AR configuration to run on the `session`.
    //    /// - Tag: ARReferenceImage-Loading
    //    func resetTracking() {
    //
    //        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
    //            fatalError("Missing expected asset catalog resources.")
    //        }
    //
    //        let configuration = ARWorldTrackingConfiguration()
    //        configuration.detectionImages = referenceImages
    //        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    //
    //        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    //    }
        
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

            DispatchQueue.main.async {
                      if(self.timer != nil){
                          self.timer.invalidate()
                      }
                      self.timer = Timer.scheduledTimer(timeInterval: 0.3 , target: self, selector: #selector(self.imageLost(_:)), userInfo: nil, repeats: false)
                  }
            
            
            let cameraPosition = self.sceneView.pointOfView?.position
            let anchorPosition = anchor.transform[3]


            guard anchor is ARImageAnchor else { return }
            
            let anchorX = anchorPosition[0]
            let anchorY = anchorPosition[1]
            let anchorZ = anchorPosition[2]

            let cameraX = cameraPosition?.x ?? 0
            let cameraZ = cameraPosition?.y ?? 0
            let cameraY = cameraPosition?.z ?? 0
            
            self.x = cameraX - cameraX - anchorX
            self.y = cameraY - cameraY - anchorY
            self.z = cameraZ - cameraZ - anchorZ
                
            

      
            
            
            if (self.x > 0.02) {
                command = "LEFT"
         
                  
                
                if let delegate = self.delegate {
                    delegate.onSendControllerPadButtonStatus(tag: 7, isPressed: true)
                }
                
                
            }else if (self.x < -0.13){
                command = "RIGHT"
   
                 
                             
                if let delegate = self.delegate {
                    delegate.onSendControllerPadButtonStatus(tag: 8, isPressed: true)
                }
                
                
            }else{
          
     
                
                
                if (self.z > 0.2){
                    command = "FORWARD"

                      if let delegate = self.delegate {
                                       delegate.onSendControllerPadButtonStatus(tag: 5, isPressed: true)
                                   }
                      
                  }else{
                      if let delegate = self.delegate {
                        command = "STOP"
                        delegate.onSendControllerPadButtonStatus(tag: 5, isPressed: false)
                    }
                  }
                         
                
                
            }
            
             
          DispatchQueue.main.async {
            self.statusLabel.text = "[\(self.command)] \(String(format: "%.2f", cameraX)), \(String(format: "%.2f", cameraY)), \(String(format: "%.2f", cameraZ))"

          }
             
             
            
            
            
                print(x,y,z)
                

            

        }

        // MARK: - ARSCNViewDelegate (Image detection results)
        /// - Tag: ARImageAnchor-Visualizing
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            let referenceImage = imageAnchor.referenceImage

                // Create a plane to visualize the initial position of the detected image.
                let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                     height: referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents  = UIColor(red: 30.0 / 255.0, green: 150.0 / 255.0, blue: 30.0 / 255.0, alpha: 1)

                let planeNode = SCNNode(geometry: plane)
                
                planeNode.opacity = 0.8
                /*
                 `SCNPlane` is vertically oriented in its local coordinate space, but
                 `ARImageAnchor` assumes the image is horizontal in its local space, so
                 rotate the plane to match.
                 */
                planeNode.eulerAngles.x = -.pi / 2

                /*
                 Image anchors are not tracked after initial detection, so create an
                 animation that limits the duration for which the plane visualization appears.
                 */
                self.currentNode = planeNode
                // Add the plane visualization to the scene.
                node.addChildNode(planeNode)
            

        }

}
