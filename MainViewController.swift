//
//  MainViewController.swift
//  EmojiInkMessaging
//
//  Created by Harrison Wideman on 11/29/16.
//  Copyright © 2016 Tight. All rights reserved.
//

import UIKit
import Messages

protocol UserInterfaceFlowProtocol
{
    func setupInitialViewMode()
    func clearView()
    
    func handleTransitionToEmojiStickerSelectMode(sender:UIViewController)
    func handleTransitionToEmojiStickerMode(sender:EmojiPreSelectViewController)
    
    func handleTransitionToEmojiCanvasStickerMode(sender:UIViewController)
    func handleTransitionToEmojiCanvasPreSelectMode(sender:UIViewController)
    func handleTransitionToEmojiCanvasDrawMode(sender:EmojiPreSelectViewController)
    
    func switchToPreviousView(by steps:Int)
}

class MainViewController: UIViewController, UserInterfaceFlowProtocol {
    
    var mainPageViewController:MainPageViewController?
    var emojiImage:UIImage!
    
    /// Delegate for upward calls to MessagesViewController methods
    var MessagesAppIntegrationDelegate:MessagesAppIntegrationProtocol?
    /// Delegate for upward calls to MessagesViewController state management methods
    var EIMStateDelegate:EIMStateProtocol?
    
    ///INITIAL VIEW TRANSITION CALL
    internal func setupInitialViewMode() {
        /*EIMStateDelegate?.setEIMState(.InitApplication)
        let IVC = InitialViewController()
        IVC.UserInterfaceFlowDelegate = self*/
        
        
        EIMStateDelegate?.setEIMState(.EmojiCanvasStickerSelect)
        let ECSSV = EmojiCanvasStickerSelectorViewController()
        ECSSV.UserInterfaceFlowDelegate = self
        
        // setup UIPageViewController
        mainPageViewController = MainPageViewController()
        pushViewControllerContent(mainPageViewController!)
        mainPageViewController?.setViewController(ECSSV)

    }
    
    func clearView() {
        pullViewControllerContent(mainPageViewController!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CBColor.computer_gray()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(mainPageViewController != nil){
            pullViewControllerContent(mainPageViewController!)
        }
        setupInitialViewMode()
        
    }
    
    ///STICKER PRE SELECT TRANSITION CALL
    internal func handleTransitionToEmojiStickerSelectMode(sender:UIViewController){
        EIMStateDelegate?.setEIMState(.EmojiStickerSelect)
        let ESPS = EmojiPreSelectViewController()
        ESPS.EIMStateDelegate = self.EIMStateDelegate
        ESPS.UserInterfaceFlowDelegate = self
        mainPageViewController?.setViewController(ESPS)
    }
    
    ///STICKER MODE TRANSITION CALL
    internal func handleTransitionToEmojiStickerMode(sender:EmojiPreSelectViewController) {
        EIMStateDelegate?.setEIMState(.EmojiSticker)
        let ES = EmojiStickerViewController()
        ES.selectedEmoji = sender.selectedCellIndex
        ES.UserInterfaceFlowDelegate = self
        mainPageViewController?.setViewController(ES)
        
    }
    
    ///CANVAS STICKER MODE TRANSITION CALL
    internal func handleTransitionToEmojiCanvasStickerMode(sender: UIViewController) {
        EIMStateDelegate?.setEIMState(.EmojiCanvasStickerSelect)
        let ECSSV = EmojiCanvasStickerSelectorViewController()
        ECSSV.UserInterfaceFlowDelegate = self
        mainPageViewController?.setViewController(ECSSV)
        
    }
    
    ///CANVAS PRE SELECT MODE TRANSITION CALL
    internal func handleTransitionToEmojiCanvasPreSelectMode(sender: UIViewController) {
        EIMStateDelegate?.setEIMState(.EmojiCanvasPreSelect)
        let ECPS = EmojiPreSelectViewController()
        ECPS.EIMStateDelegate = self.EIMStateDelegate
        ECPS.UserInterfaceFlowDelegate = self
        mainPageViewController?.setViewController(ECPS)
        
    }
    
    /// CANVAS DRAW MODE TRANSITION CALL
    internal func handleTransitionToEmojiCanvasDrawMode(sender:EmojiPreSelectViewController) {
        if(MessagesAppIntegrationDelegate?.getApplicationPresentationStyle() == MSMessagesAppPresentationStyle.compact){
            emojiImage = sender.selectedImage!
            EIMStateDelegate?.setEIMState(.EmojiCanvas)
            MessagesAppIntegrationDelegate?.requestApplicationExpandedPresentation()
        } else {
            emojiImage = sender.selectedImage!
            EIMStateDelegate?.setEIMState(.EmojiCanvas)
            let EC = EmojiCanvasModeViewController()
            EC.UserInterfaceFlowDelegate = self
            mainPageViewController?.setViewController(EC)
            EC.setEmojiWithImage(emojiImage)
        }
    
    }
    
    internal func switchToPreviousView(by steps: Int) {
        mainPageViewController?.goBack(by: steps)
        EIMStateDelegate?.rollBackStateChain(by: steps)
    }
    
    /// Called by parent MessagesViewController when application presentation style will
    ///
    /// - parameter presentationStyle: MSMessagesAppPresentationStyle
    func presentationStyleWillChange(to presentationStyle: MSMessagesAppPresentationStyle) {
        /// Pull preSelectView in preparation for collapse into ApplicationInit
        if(presentationStyle == .compact && EIMStateDelegate?.getEIMState() == .EmojiCanvas){
            pullViewControllerContent( mainPageViewController! )
        }
        
    }
    
    /// Called by parent MessagesViewController after application presentation style changes
    ///
    /// - parameter presentationStyle: MSMessagesAppPresentationStyle
    func presentationStyleDidChange(to presentationStyle: MSMessagesAppPresentationStyle) {
        let EIMState = EIMStateDelegate?.getEIMState()
        ///
        switch presentationStyle{
        case .expanded:
            if (EIMState == .EmojiCanvas){
                let EC = EmojiCanvasModeViewController()
                EC.UserInterfaceFlowDelegate = self
                mainPageViewController?.setViewController(EC)
                EC.setEmojiWithImage(emojiImage)
            }
        case .compact:
            if( EIMState == .EmojiCanvas ){
                setupInitialViewMode()
            }
        }
        
    }
    
    /// "pushes" or adds a viewController and its content to *this* viewController
    ///
    /// - parameter content: UIViewController to push content from
    func pushViewControllerContent(_ content:UIViewController){
        self.addChildViewController(content)
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)
        
    }
    
    /// "pulls" or removes a viewController and its content from its parent, *this* view controller
    ///
    /// - parameter content: UIViewController to remove and purge content from parent
    func pullViewControllerContent(_ content:UIViewController){
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
        
    }

}
