//
//  UploadPostController.swift
//  Collect
//
//  Created by Patrick Ortell on 2/1/21.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost (_ controller: UploadPostController)
}
class UploadPostController: UIViewController {
    
    
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        return iv
        
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter caption... "
        tv.delegate = self
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.placeHolderShouldCenter = false

        return tv
    }()
    private let charCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapDone(){
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return}
        guard let user = currentUser else { return }
        showLoader(true)
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)

            if let error = error {
                print("DEBUG: failed to upload post \(error.localizedDescription)")
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    func checkMaxLength (_ textView: UITextView) {
        if (textView.text.count) > 100{
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 280, width: 280)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        view.addSubview(charCountLabel)
        charCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -8, paddingRight: 12)
    }
}



extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        charCountLabel.text = "\(count)/100"
    }
}
