import UIKit

class FocusPicker : UIView, UIScrollViewDelegate {
    // MARK: Public API
    var views = [UIView()] {
        didSet(old) {
            setup()
            updateViews(oldViews: old)
        }
    }
    let centerButton = UIButton()
    // MARK: Internal views
    let scrollView = UIScrollView()
    let scrollButtonsContainer = UIView()
    let focusContainer = UIView()
    let focusMirrorView = UIView()
    
    var setupYet = false
    func setup() {
        if !setupYet {
            setupYet = true
            addSubview(scrollView)
            addSubview(focusContainer)
            focusContainer.addSubview(focusMirrorView)
            scrollView.addSubview(scrollButtonsContainer)
            scrollView.addSubview(centerButton)
            // addGestureRecognizer(scrollView.panGestureRecognizer)
            
            scrollView.delegate = self
            scrollView.decelerationRate = UIScrollViewDecelerationRateFast
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.canCancelContentTouches = true
            scrollView.clipsToBounds = false
            
            let tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedOnButton(tapRec:)))
            scrollButtonsContainer.addGestureRecognizer(tapRec)
            
            scrollView.layer.cornerRadius = cornerRadius
            focusContainer.layer.cornerRadius = cornerRadius
            focusContainer.isUserInteractionEnabled = false
            focusContainer.clipsToBounds = true
            focusContainer.backgroundColor = UIColor(white: 1, alpha: 0.4)
        }
    }
    
    func updateViews(oldViews: [UIView]) {
        // clean up prev views:
        for view in oldViews {
            view.removeFromSuperview()
        }
        for view in focusMirrorView.subviews {
            view.removeFromSuperview()
        }
        // add new views:
        for view in views {
            scrollButtonsContainer.addSubview(view)
            let snap = view.snapshotView(afterScreenUpdates: true)!
            snap.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            focusMirrorView.addSubview(snap)
        }
        setNeedsLayout()
    }
    
    // MARK: Layout
    let cornerRadius: CGFloat = 6
    let minViewWidth: CGFloat = 60
    var viewsToShowPerScreen: Int {
        let count = Int(floor(bounds.width / minViewWidth))
        return count % 2 == 0 ? count - 1 : count // ensure an odd number, so there's a center element
    }
    
    var realViewWidth: CGFloat {
        let width = bounds.width / CGFloat(viewsToShowPerScreen)
        return round(width * UIScreen.main.scale) / UIScreen.main.scale
    }
    
    var focusedViewOffsetX: CGFloat {
        return CGFloat(viewsToShowPerScreen - 1) / 2 * realViewWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        let viewWidth = realViewWidth
        let focusedViewX = focusedViewOffsetX
        
        var x = focusedViewX + viewWidth / 2
        for (view, mirrored) in zip(views, focusMirrorView.subviews) {
            view.center = CGPoint(x: x, y: bounds.height/2)
            mirrored.center = view.center
            x += viewWidth
        }
        scrollButtonsContainer.frame = CGRect(x: 0, y: 0, width: x + focusedViewX - viewWidth / 2, height: bounds.height)
        scrollView.contentSize = scrollButtonsContainer.frame.size
        
        focusContainer.frame = CGRect(x: focusedViewX, y: 0, width: viewWidth, height: bounds.height)
        focusMirrorView.center = CGPoint(x: -focusedViewX, y: 0)
        
        centerButton.bounds = CGRect(x: 0, y: 0, width: viewWidth, height: bounds.height)
        updateCenterButtonPos()
    }
    
    func updateCenterButtonPos() {
        centerButton.center = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2, y: scrollView.bounds.height / 2)
    }
    
    // MARK: Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        focusMirrorView.transform = CGAffineTransform(translationX: -scrollView.contentOffset.x, y: 0)
        updateCenterButtonPos()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        targetContentOffset.pointee = CGPoint(x: round(x / realViewWidth) * realViewWidth, y: targetContentOffset.pointee.y)
    }
    
    @objc func tappedOnButton(tapRec: UITapGestureRecognizer) {
        for view in views {
            if view.point(inside: tapRec.location(in: view), with: nil) {
                // scroll to this view:
                let offset = view.center.x - realViewWidth / 2 - focusedViewOffsetX
                scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            }
        }
    }
}
