//
//  ContentView.swift
//  test_airdrop
//
//  Created by 米田 悠人  on 2022/10/21.
//
//

import SwiftUI
import LinkPresentation
import CoreData

final class AirDropOnlyActivityItemSource: NSObject {
  let item: Any

//static var readableContentTypes: [UTType] { [.myappdoc] }

  init(item: Any) {
    self.item = item
  }

  convenience init(backupFile: BackupFile) {
    // これで送ると、.txtになる
//    let dataStr = String(data: data, encoding: .utf8)!
//    self.init(item: dataStr)
    let data = try! JSONEncoder().encode(backupFile)
    self.init(item: data)
  }
}

extension AirDropOnlyActivityItemSource: UIActivityItemSource {
  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return NSURL(string: "")!
  }

  func activityViewController(
    _ activityViewController: UIActivityViewController,
    itemForActivityType activityType: UIActivity.ActivityType?
  ) -> Any? {
    item
  }

  func activityViewController(
    _ activityViewController: UIActivityViewController,
    dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?
  ) -> String {
    "dev.yoneyan.test-airdrop.backup"
  }

  func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
    let linkMetadata = LPLinkMetadata()
    linkMetadata.title = "Share backup file"

//    let fileUrl = AssetExtractor.createLocalUrl(forImageNamed: "pokemon_tcg")
//    linkMetadata.iconProvider = NSItemProvider(contentsOf: fileUrl)

    return linkMetadata
  }
}

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  @State private var showActivityView: Bool = false

  var body: some View {
    NavigationView {
      List {
        ForEach(items) { item in
          NavigationLink {
            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
          } label: {
            Text(item.timestamp!, formatter: itemFormatter)
          }
        }
          .onDelete(perform: deleteItems)
      }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
          }
          ToolbarItem {
//                    Button(action: {
//                        self.showActivityView = true
//                    }) {
//                        Image(systemName: "square.and.arrow.up")
//                    }
//                      .sheet(isPresented: self.$showActivityView) {
//                          AirDropView(
//                            activityItems: ["abc"],
//                            applicationActivities: nil
//                          )
//                      }
            Button(action: sendAirDrop) {
              Label("AirDrop", systemImage: "paperplane")
            }
          }
          ToolbarItem {
            Button(action: addItem) {
              Label("Add Item", systemImage: "plus")
            }
          }
        }
      Text("Select an item")
    }
  }

  private func sendAirDrop() {
    var backupFile: BackupFile
    backupFile = BackupFile(id: "1", date: Date(), name: "name", data: "data")

    let itemSource = AirDropOnlyActivityItemSource(backupFile: backupFile)

    let activityVC = UIActivityViewController(activityItems: [itemSource], applicationActivities: nil)
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let rootVC = windowScene?.windows.first?.rootViewController
    rootVC?.present(activityVC, animated: true)

//    guard let image = imageView.image else {
//      print("対象の画像が見つかりません")
//      return
//    }
//    let data = UIImagePNGRepresentation(image)
//
//    // ファイル一時保存してNSURLを取得
//    let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("tmp.png")
//    data?.writeToURL(url, atomically: true)
//
//    controller = UIDocumentInteractionController.init(URL: url)
//
//    if !(controller!.presentOpenInMenuFromRect(view.frame, inView: view, animated: true)) {
//      print("ファイルに対応するアプリがありません")
//    }
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()

      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map {
          items[$0]
        }
        .forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
