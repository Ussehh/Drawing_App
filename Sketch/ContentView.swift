import SwiftUI
import PencilKit

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color: Color = .black
    @State var toolType: PKInkingTool.InkType = .pencil

    var body: some View {
        NavigationView {
            DrawingView(canvas: $canvas, isDraw: $isDraw, toolType: $toolType, color: $color)
                .navigationTitle("Sketch")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(action: {
                       
                        SaveImage()
                        
                    }, label: {
                        IconView(systemName: "square.and.arrow.down.fill", color: getColor())
                            .font(.title2)
                    }),
                    trailing: HStack(spacing: 10) {
                        Button(action: {
                            isDraw = false
                        }) {
                            IconView(systemName: "eraser.fill", color: getColor())
                                .font(.title2)
                        }
                        
                        ColorPicker("", selection: $color, supportsOpacity: false)
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .clipShape(Circle())
                            .foregroundColor(getColor())

                        Menu {
                            Button(action: {
                                toolType = .pencil
                                isDraw = true
                            }) {
                                Label("Pencil", systemImage: "pencil")
                            }
                            Button(action: {
                                toolType = .pen
                                isDraw = true
                            }) {
                                Label("Pen", systemImage: "pencil.tip")
                            }
                            Button(action: {
                                toolType = .marker
                                isDraw = true
                            }) {
                                Label("Marker", systemImage: "highlighter")
                            }
                        } label: {
                            IconView(systemName: getToolIcon(), color: getColor())
                                .frame(width: 22, height: 22)
                        }
                    }
                )
        }
    }

    func getColor() -> Color {
        return colorScheme == .dark ? .white : .black
    }

    func getToolIcon() -> String {
        switch toolType {
        case .pencil:
            return "pencil"
        case .pen:
            return "pencil.tip"
        case .marker:
            return "highlighter"
        default:
            return "pencil.tip"
        }
    }
    
    func SaveImage() {
        
        
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var toolType: PKInkingTool.InkType
    @Binding var color: Color

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        updateTool()
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        updateTool()
    }
    
    func updateTool() {
        if isDraw {
            canvas.tool = PKInkingTool(toolType, color: UIColor(color))
        } else {
            canvas.tool = PKEraserTool(.bitmap)
        }
    }
}

struct IconView: View {
    var systemName: String
    var color: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.title2)
            .foregroundColor(color)
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                }
            }
    }
}
