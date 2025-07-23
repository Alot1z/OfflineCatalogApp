import UIKit
import WebKit

class ViewController: UIViewController {
  let url = URL(string: "https://www.librarything.com/catalog/Itsmose/allcollections")!
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    fetchAndSave()
  }

  func fetchAndSave() {
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data else { return }
      let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let path = docs.appendingPathComponent("catalog.html")
      try? data.write(to: path)
      DispatchQueue.main.async {
        let web = WKWebView(frame: self.view.bounds)
        web.loadFileURL(path, allowingReadAccessTo: docs)
        self.view.addSubview(web)
      }
    }.resume()
  }
}
