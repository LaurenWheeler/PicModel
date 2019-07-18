//
//  ViewController.swift
//

import UIKit

class PictureModelClipsViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let shapeCollection : NSMutableArray = NSMutableArray()


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!

    @IBOutlet weak var shapesCollectionView: UICollectionView!



    override func viewDidLoad() {
        super.viewDidLoad()
        shapeCollection.addObjects(from: ["sunshine_01", "sunshine_02","sunshine_03", "sunshine_04","sunshine_05","sunshine_06","sunshine_07","baoyu-sunshine","bingbao-sunshine","chuan-sunshine","chuan02-sunshine","leizhenyu-sunshine","lunchuan-sunshine","mojing-sunshine", "moon-sunshine", "richu-sunshine","shan-sunshine","shandian-sunshine", "taiyangfushe-sunshine", "tuzi-sunshine","xiayu-sunshine","yangguang-sunshine","yusan-sunshine","ziyuan-sunshine"])

        shapesCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    @IBAction func galleryImageViewTapped(_ sender: UITapGestureRecognizer){
        openPicker()
    }

    func openPicker(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary

        present(pickerController, animated: true) {

        }

    }

    @IBAction func downloadImageViewTapped(_ sender: UITapGestureRecognizer){
        if(self.imageView.image == nil){
            openPicker()
            return
        }

        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = getStringFromDate(date: Date(), format: "yyyy-MM-dd-HH:mm:ss") + ".png"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = imageView.asImage().pngData(),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }

        //UIImageWriteToSavedPhotosAlbum(imageView.asImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }


    @IBAction func shareImageViewTapped(_ sender: UITapGestureRecognizer){
        if(self.imageView.image == nil){
            openPicker()
            return
        }

        let shareText = "Shaped with Selfie Shaper\n"

            let vc = UIActivityViewController(activityItems: [shareText, imageView.asImage()], applicationActivities: [])
            present(vc, animated: true, completion: nil)


    }

    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            //showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            //showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
            let alertController = UIAlertController(title: "Saved Successfully", message: "Your image is saved successfully.", preferredStyle:UIAlertController.Style.alert)


            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            { action -> Void in
                alertController.dismiss(animated: true, completion: {

                })
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }



    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var image : UIImage!

        imageView.image = nil
        imageView.bounds = CGRect(x: 0, y: 0, width: self.imageContainerView.bounds.size.width, height:  self.imageContainerView.bounds.size.height )
        imageView.center = CGPoint(x: self.imageContainerView.bounds.size.width/2, y: self.imageContainerView.bounds.size.height/2)

        if let img = info[.editedImage] as? UIImage
        {
            image = img

        }
        else if let img = info[.originalImage] as? UIImage
        {
            image = img
        }
        let imageRatio = image.size.width / image.size.height
        let containerRatio = imageContainerView.frame.size.width / imageContainerView.frame.size.height
        if(imageRatio > containerRatio){
            imageView.frame = CGRect(x: 0, y: 0, width: self.imageContainerView.frame.size.width, height:  self.imageContainerView.frame.size.width / imageRatio)
            imageView.center = CGPoint(x: self.imageContainerView.frame.size.width/2, y: self.imageContainerView.frame.size.height/2)
        }else{
            imageView.frame = CGRect(x: 0, y: 0, width: self.imageContainerView.bounds.size.height * imageRatio, height:  self.imageContainerView.bounds.size.height )
            imageView.center = CGPoint(x: self.imageContainerView.bounds.size.width/2, y: self.imageContainerView.bounds.size.height/2)
        }

        print(imageRatio)
        print(containerRatio)
        print(imageContainerView.frame)
        print(imageView.frame)



        imageView.image = image
        self.imageView.layoutIfNeeded()
        imageView.mask = nil




        picker.dismiss(animated: true,completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func clipImage(maskImageName: String){
        let heartMaskView = UIImageView()
        heartMaskView.image = UIImage(named: maskImageName)
        heartMaskView.contentMode = .scaleAspectFit
        imageView.mask = heartMaskView
        heartMaskView.frame = imageView.bounds
    }

    func getStringFromDate(date: Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }




}



extension PictureModelClipsViewController :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapeCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "shapecell", for: indexPath) as! ShapeCollectionViewCell
        //cell.backgroundColor = .red
        cell.cellImageView.image = UIImage(named: shapeCollection[indexPath.row] as! String)

       // cell.layer.cornerRadius = 10
       // cell.layer.masksToBounds = true

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.imageView.image == nil){
            openPicker()
            return
        }
        clipImage(maskImageName: shapeCollection[indexPath.row] as! String)

    }
}


extension UIImageView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
