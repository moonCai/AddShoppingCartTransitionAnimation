//
//  ViewController.swift
//  AddShoppingCartTransitionAnimation
//
//  Created by 蔡钰 on 2018/4/5.
//  Copyright © 2018年 moonCai. All rights reserved.
//

import UIKit

enum MNAnimatorType {
    case modal
    case dismiss
}

class ViewController: UIViewController {
    // 转场类型
    private var type: MNAnimatorType = .modal
    // 加入购物车按钮高度
    private let addShoppingCartBtnWidth: CGFloat = 165.0
    // 加入购物车按钮宽度
    private let addShoppingCartBtnHeight: CGFloat = 50.0
    // 可供选择商品规格视图y
    private let bottomViewY: CGFloat = UIScreen.main.bounds.height * 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.contents = UIImage(named: "watch")?.cgImage
        
        let addShoppingCartBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - addShoppingCartBtnWidth, y: UIScreen.main.bounds.size.height - addShoppingCartBtnHeight, width: addShoppingCartBtnWidth, height: addShoppingCartBtnHeight))
        addShoppingCartBtn.backgroundColor = .purple
        view.addSubview(addShoppingCartBtn)
        addShoppingCartBtn.addTarget(self, action: #selector(addShoppingCartButtonAction), for: .touchUpInside)
    }
    
    @objc private func addShoppingCartButtonAction() {
        let vc = UIViewController()
        vc.view.backgroundColor = .orange
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}


extension ViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .modal
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .dismiss
        return self
    }
    
}

extension ViewController: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        transitionContext.containerView.addSubview(dimmingView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismmingTapAction))
        dimmingView.addGestureRecognizer(tap)
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        transitionContext.containerView.addSubview(toView!)
        
        var imageView: UIImageView = UIImageView()
        
        switch type {
        case .modal:
            var tran = CATransform3DIdentity
            tran.m34 = -1 / 1000.0
            tran = CATransform3DRotate(tran, CGFloat(Double.pi / 16), 1, 0, 0)
            tran = CATransform3DTranslate(tran, 0, 0, -100)
            
            toView?.frame = CGRect(x: 0, y: bottomViewY, width: (toView?.bounds.size.width)!, height: (toView?.bounds.size.height)! - bottomViewY)
            toView?.transform = CGAffineTransform(translationX: 0, y: (toView?.bounds.size.height)!)
            UIView.animate(withDuration:transitionDuration(using: nil) * 0.5, animations: {
                fromView?.layer.transform = tran
                toView?.transform = .identity
            }, completion: { (_) in
                UIView.animate(withDuration: self.transitionDuration(using: nil) * 0.5, animations: {
                    fromView?.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
                }, completion: { (_) in
                    let image = fromView?.toRetinaImage()
                    imageView = UIImageView(image: image)
                    imageView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
                    transitionContext.containerView.insertSubview(imageView, at: 0)
                    transitionContext.completeTransition(true)
                })
            })
            
        case .dismiss:
            transitionContext.containerView.insertSubview(toView!, belowSubview: fromView!)
            UIView.animate(withDuration: self.transitionDuration(using: nil) * 0.5, animations: {
                dimmingView.alpha = 0
                toView?.layer.transform = CATransform3DIdentity
                fromView?.transform = CGAffineTransform(translationX: 0, y: (fromView?.bounds.size.height)!)
            }, completion: { (_) in
                dimmingView.removeFromSuperview()
                imageView.removeFromSuperview()
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
    
    @objc private func dismmingTapAction() {
        dismiss(animated: true, completion: nil)
    }
}

