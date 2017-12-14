import UIKit

class FilterPicker : UIView {
    let filterInfo = FaceFilter.all.map({ $0.info })
    let focusPicker = FocusPicker()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if focusPicker.superview == nil {
            // do initial setup:
            addSubview(focusPicker)
            focusPicker.views = filterInfo.map({ (info) -> UILabel in
                let l = UILabel()
                l.text = info.emoji
                l.textAlignment = .center
                l.font = UIFont.systemFont(ofSize: 30)
                l.sizeToFit()
                l.bounds = CGRect(x: 0, y: 0, width: l.bounds.width + 6, height: l.bounds.height + 6)
                return l
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        focusPicker.frame = bounds
    }
}
