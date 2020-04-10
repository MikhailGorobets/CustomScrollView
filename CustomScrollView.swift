import SwiftUI

fileprivate class TransparentScroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
        drawKnob()
    }
}

class TransparentScrollView: NSScrollView {
    override func tile() {
        super.tile()
        self.contentView.frame = self.bounds
    }
}

struct CustomScrollView<Content: View>: NSViewRepresentable  {
    private var content: Content
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func makeNSView(context: Context) -> NSScrollView {
            
        let scrollView = TransparentScrollView(frame: .zero)
        scrollView.verticalScroller   = TransparentScroller()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.contentHuggingPriority(for: .horizontal)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
      
        
        let document = NSHostingView(rootView:  AnyView(content))
        document.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.documentView = document
        
        
    
        
        NSLayoutConstraint.activate([
            document.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            document.widthAnchor.constraint(equalTo: scrollView.contentView.widthAnchor)
        
        ])
        return scrollView
    }
    
    public func updateNSView(_ view: NSScrollView, context: Context) {
        guard let document = view.documentView as? NSHostingView<AnyView> else {
            return
        }
        document.rootView = AnyView(content)
    }
    

}


struct CustomScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CustomScrollView() {
            ForEach(0 ..< 10) { _ in
                Text("Hi there, this is my first time posting here and I'm looking for some help around how to properly wrap an NSTextView(inside a ScrollView) for use in SwiftUI.").lineLimit(2).fixedSize(horizontal: false, vertical: true).padding(20)
            }
        }.background(Color.red)
    }
}
