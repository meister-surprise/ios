import SwiftUI
import AppGPTLang

struct ProjectEditorView: View {
    @ObservedObject var viewModel = ProjectEditorViewModel()
    @State var code: String = """
        Text($x, 50, red)
        Text("Seokho", 30, label)
        Text("Hello, world!", 15, label)
        Spacer()
        Button({var(x="Hello");}, "Hi", red)
    """
    let name: String
    init(name: String) {
        self.name = name
    }
    var body: some View {
        VStack(spacing: 0) {
            ProjectEditorHeaderView(name: name)
            HStack(spacing: 26) {
                ProjectEditorTaskView(viewModel: viewModel)
                AppGPTView(code: $code)
                    .frame(width: 354)
                    .background(Color(uiColor: .systemGray4))
                    .cornerRadius(20)
            }
            .padding(40)
            .background(Color("BackGroundColor"))
            .animation(.easeIn)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ProjectEditorView(name: "asdf")
}

struct ProjectEditorHeaderView: View {
    
    @State private var position = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    let name: String
    
    init(name: String) {
        self.name = name
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 81)
            HStack(alignment: .center, spacing: 11) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 17, height: 24)
                        .foregroundColor(.white)
                }
                Text(name)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 40)
            ScrollView(.horizontal) {
                HStack(spacing: 13) {
                    ComponentCell(type: .button())
                        .draggable(ComponentType.button().toString())
                    ComponentCell(type: .text())
                        .draggable(ComponentType.text().toString())
                    ComponentCell(type: .image())
                        .draggable(ComponentType.image().toString())
                    ComponentCell(type: .spacer)
                        .draggable(ComponentType.spacer.toString())
                    Spacer()
                }
                .padding(.bottom, 13)
                .padding(.horizontal, 40)
            }
        }
        .background(Color(uiColor: .systemGray4))
    }
}


struct ProjectEditorTaskView: View {
    @ObservedObject var viewModel: ProjectEditorViewModel
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                VStack(spacing: 13) {
                    ForEach(0 ..< viewModel.dropView.count, id: \.self) { index in
                        let data: ComponentType = viewModel.dropView[index]
                        switch data {
                        case .button:
                            ComponentCell(type: .button(), isDrag: true) {
                                viewModel.removeBlock(index)
                            }
                        case .text:
                            ComponentCell(type: .text(), isDrag: true) {
                                viewModel.removeBlock(index)
                            }
                        case .image:
                            ComponentCell(type: .image(), isDrag: true)  {
                                viewModel.removeBlock(index)
                            }
                        case .spacer:
                            ComponentCell(type: .spacer, isDrag: true)  {
                                viewModel.removeBlock(index)
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(40)
        }
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(20)
        .dropDestination(for: String.self) { items ,_ in
            viewModel.addBlock(items.first ?? "button")
            return true
        }
    }
}