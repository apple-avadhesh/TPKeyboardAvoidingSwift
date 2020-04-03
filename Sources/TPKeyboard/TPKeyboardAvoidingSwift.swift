import UIKit

// MARK: - UITableView

public class TPKeyboardAvoidingTableView: UITableView, UITextFieldDelegate, UITextViewDelegate {
	override public var frame: CGRect {
		willSet {
			super.frame = frame
		}
		
		didSet {
			guard !hasAutomaticKeyboardAvoidingBehaviour else { return }
			TPKeyboardAvoiding_updateContentInset()
		}
	}
	
	override public var contentSize: CGSize {
		willSet(newValue) {
			guard !hasAutomaticKeyboardAvoidingBehaviour else {
				super.contentSize = newValue
				return
			}
			
			guard !newValue.equalTo(self.contentSize) else { return }
			
			super.contentSize = newValue
			self.TPKeyboardAvoiding_updateContentInset()
		}
	}
	
	var hasAutomaticKeyboardAvoidingBehaviour: Bool {
		if #available(iOS 8.3, *), self.delegate is UITableViewController {
			return true
		}
		return false
	}
	
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	override public func awakeFromNib() {
		setup()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func focusNextTextField() -> Bool {
		return self.TPKeyboardAvoiding_focusNextTextField()
	}
	
	@objc func scrollToActiveTextField() {
		return self.TPKeyboardAvoiding_scrollToActiveTextField()
	}
	
	override public func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		
		guard newSuperview != nil else { return }
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
	}
	
	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
		super.touchesEnded(touches, with: event)
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if !self.focusNextTextField() {
			textField.resignFirstResponder()
		}
		return true
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
		
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
	}
}

private extension TPKeyboardAvoidingTableView {
	func setup() {
		guard !hasAutomaticKeyboardAvoidingBehaviour else { return }
		
		NotificationCenter.default.addObserver(self, selector: #selector(TPKeyboardAvoiding_keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(TPKeyboardAvoiding_keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
	}
}

// MARK: - UICollectionView

public class TPKeyboardAvoidingCollectionView: UICollectionView, UITextViewDelegate {
	override public var contentSize: CGSize {
		willSet(newValue) {
			guard !newValue.equalTo(self.contentSize) else { return }
			
			super.contentSize = newValue
			self.TPKeyboardAvoiding_updateContentInset()
		}
	}
	
	override public var frame: CGRect {
		willSet {
			super.frame = frame
		}
		
		didSet {
			self.TPKeyboardAvoiding_updateContentInset()
		}
	}
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	override public func awakeFromNib() {
		setup()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func focusNextTextField() -> Bool {
		return self.TPKeyboardAvoiding_focusNextTextField()
	}
	
	@objc func scrollToActiveTextField() {
		return self.TPKeyboardAvoiding_scrollToActiveTextField()
	}
	
	override public func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		
		guard newSuperview != nil else { return }
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
	}
	
	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
		super.touchesEnded(touches, with: event)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if !self.focusNextTextField() {
			textField.resignFirstResponder()
		}
		return true
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
		
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
	}
}

private extension TPKeyboardAvoidingCollectionView {
	func setup() {
		NotificationCenter.default.addObserver(self, selector: #selector(TPKeyboardAvoiding_keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(TPKeyboardAvoiding_keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
	}
}

// MARK: - UIScrollView

public class TPKeyboardAvoidingScrollView: UIScrollView, UITextFieldDelegate, UITextViewDelegate {
	override public var contentSize: CGSize {
		didSet {
			self.TPKeyboardAvoiding_updateFromContentSizeChange()
		}
	}
	
	override public var frame: CGRect {
		didSet {
			self.TPKeyboardAvoiding_updateContentInset()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	override public func awakeFromNib() {
		setup()
	}
	
	func contentSizeToFit() {
		self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
	}
	
	func focusNextTextField() -> Bool {
		return self.TPKeyboardAvoiding_focusNextTextField()
	}
	
	@objc func scrollToActiveTextField() {
		return self.TPKeyboardAvoiding_scrollToActiveTextField()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override public func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		
		guard newSuperview != nil else { return }
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
	}
	
	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
		super.touchesEnded(touches, with: event)
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if !self.focusNextTextField() {
			textField.resignFirstResponder()
		}
		return true
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
		
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
	}
}

private extension TPKeyboardAvoidingScrollView {
	func setup() {
		NotificationCenter.default.addObserver(self, selector: #selector(TPKeyboardAvoiding_keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(TPKeyboardAvoiding_keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
	}
}

// MARK: - Process Event

let kCalculatedContentPadding: CGFloat = 10
let kMinimumScrollOffsetPadding: CGFloat = 20

extension UIScrollView {
	@objc func TPKeyboardAvoiding_keyboardWillShow(_ notification: Notification) {
		guard let userInfo = notification.userInfo else { return }
		guard let rectNotification = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		
		let keyboardRect = self.convert(rectNotification.cgRectValue, from: nil)
		guard !keyboardRect.isEmpty else { return }
		
		let state = self.keyboardAvoidingState()
		
		guard let firstResponder = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self) else { return }
		
		state.keyboardRect = keyboardRect
		if !state.keyboardVisible {
			state.priorInset = self.contentInset
			state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
			state.priorPagingEnabled = self.isPagingEnabled
		}
		
		state.keyboardVisible = true
		self.isPagingEnabled = false
		
		if self is TPKeyboardAvoidingScrollView {
			state.priorContentSize = self.contentSize
			if self.contentSize.equalTo(CGSize.zero) {
				self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
			}
		}
		
		let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
		let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
		let options = UIView.AnimationOptions(rawValue: UInt(curve))
		
		UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self] in
			guard let self = self else { return }
			
			self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
			let viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
			let point = CGPoint(x: self.contentOffset.x, y: self.TPKeyboardAvoiding_idealOffsetForView(firstResponder, viewAreaHeight: viewableHeight))
			self.setContentOffset(point, animated: false)
			
			self.scrollIndicatorInsets = self.contentInset
			self.layoutIfNeeded()
		})
	}
	
	@objc func TPKeyboardAvoiding_keyboardWillHide(_ notification: Notification) {
		guard let userInfo = notification.userInfo else { return }
		
		guard let rectNotification = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardRect = self.convert(rectNotification.cgRectValue, from: nil)
		guard !keyboardRect.isEmpty else { return }
		
		let state = self.keyboardAvoidingState()
		guard state.keyboardVisible else { return }
		state.keyboardRect = CGRect.zero
		state.keyboardVisible = false
		
		let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
		let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
		let options = UIView.AnimationOptions(rawValue: UInt(curve))
		
		UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self] in
			guard let self = self, self is TPKeyboardAvoidingScrollView else { return }
			
			self.contentSize = state.priorContentSize
			self.contentInset = state.priorInset
			self.scrollIndicatorInsets = state.priorScrollIndicatorInsets
			self.isPagingEnabled = state.priorPagingEnabled
			self.layoutIfNeeded()
		})
	}
	
	func TPKeyboardAvoiding_updateFromContentSizeChange() {
		let state = self.keyboardAvoidingState()
		if state.keyboardVisible {
			state.priorContentSize = self.contentSize
		}
	}
	
	func TPKeyboardAvoiding_focusNextTextField() -> Bool {
		guard let firstResponder = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self) else { return false }
		guard let view = self.TPKeyboardAvoiding_findNextInputViewAfterView(firstResponder, beneathView: self) else { return false }
		
		Timer.scheduledTimer(timeInterval: 0.1, target: view, selector: #selector(becomeFirstResponder), userInfo: nil, repeats: false)
		
		return true
	}
	
	func TPKeyboardAvoiding_scrollToActiveTextField() {
		let state = self.keyboardAvoidingState()
		guard state.keyboardVisible else { return }
		
		let visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
		let idealOffset = CGPoint(x: 0, y: self.TPKeyboardAvoiding_idealOffsetForView(self.TPKeyboardAvoiding_findFirstResponderBeneathView(self), viewAreaHeight: visibleSpace))
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { [weak self] in
			self?.setContentOffset(idealOffset, animated: true)
		}
	}
	
	// Helper
	func TPKeyboardAvoiding_findFirstResponderBeneathView(_ view: UIView) -> UIView? {
		for childView in view.subviews {
			if childView.responds(to: #selector(getter: isFirstResponder)) && childView.isFirstResponder {
				return childView
			}
			let result = TPKeyboardAvoiding_findFirstResponderBeneathView(childView)
			if result != nil {
				return result
			}
		}
		return nil
	}
	
	func TPKeyboardAvoiding_updateContentInset() {
		let state = self.keyboardAvoidingState()
		if state.keyboardVisible {
			self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
		}
	}
	
	func TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames() -> CGSize {
		let wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator
		let wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
		
		self.showsVerticalScrollIndicator = false
		self.showsHorizontalScrollIndicator = false
		
		var rect = CGRect.zero
		
		self.subviews.forEach {
			rect = rect.union($0.frame)
		}
		
		for view in self.subviews {
			rect = rect.union(view.frame)
		}
		
		rect.size.height += kCalculatedContentPadding
		self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator
		self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator
		
		return rect.size
	}
	
	func TPKeyboardAvoiding_idealOffsetForView(_ view: UIView?, viewAreaHeight: CGFloat) -> CGFloat {
		let contentSize = self.contentSize
		
		var offset: CGFloat = 0.0
		let subviewRect = view != nil ? view!.convert(view!.bounds, to: self) : CGRect.zero
		
		var padding = (viewAreaHeight - subviewRect.height) / 2
		if padding < kMinimumScrollOffsetPadding {
			padding = kMinimumScrollOffsetPadding
		}
		
		offset = subviewRect.origin.y - padding - self.contentInset.top
		
		if offset > (contentSize.height - viewAreaHeight) {
			offset = contentSize.height - viewAreaHeight
		}
		
		if offset < -self.contentInset.top {
			offset = -self.contentInset.top
		}
		
		return offset
	}
	
	func TPKeyboardAvoiding_contentInsetForKeyboard() -> UIEdgeInsets {
		let state = self.keyboardAvoidingState()
		var newInset = self.contentInset
		
		let keyboardRect = state.keyboardRect
		newInset.bottom = keyboardRect.size.height - max(keyboardRect.maxY - self.bounds.maxY, 0)
		
		return newInset
	}
	
	func TPKeyboardAvoiding_viewIsValidKeyViewCandidate(_ view: UIView) -> Bool {
		if view.isHidden || !view.isUserInteractionEnabled { return false}
		
		if let textField = view as? UITextField, textField.isEnabled {
			return true
		}
		
		if let textView = view as? UITextView, textView.isEditable {
			return true
		}
		
		return false
	}
	
	func TPKeyboardAvoiding_findNextInputViewAfterView(_ priorView: UIView, beneathView view: UIView, candidateView bestCandidate: inout UIView?) {
		let priorFrame = self.convert(priorView.frame, to: priorView.superview)
		let candidateFrame = bestCandidate == nil ? CGRect.zero : self.convert(bestCandidate!.frame, to: bestCandidate!.superview)
		
		var bestCandidateHeuristic = -sqrt(candidateFrame.origin.x * candidateFrame.origin.x + candidateFrame.origin.y * candidateFrame.origin.y) + ( Float(abs(candidateFrame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
		
		for childView in view.subviews {
			if TPKeyboardAvoiding_viewIsValidKeyViewCandidate(childView) {
				let frame = self.convert(childView.frame, to: view)
				let heuristic = -sqrt(frame.origin.x * frame.origin.x + frame.origin.y * frame.origin.y)
					+ (Float(abs(frame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
				
				if childView != priorView && (Float(abs(frame.minY - priorFrame.minY)) < Float.ulpOfOne
					&& frame.minX > priorFrame.minX
					|| frame.minY > priorFrame.minY)
					&& (bestCandidate == nil || heuristic > bestCandidateHeuristic) {
					bestCandidate = childView
					bestCandidateHeuristic = heuristic
				}
			} else {
				self.TPKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &bestCandidate)
			}
		}
	}
	
	func TPKeyboardAvoiding_findNextInputViewAfterView(_ priorView: UIView, beneathView view: UIView) -> UIView? {
		var candidate: UIView?
		self.TPKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &candidate)
		return candidate
	}
	
	@objc func TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_ obj: AnyObject) {
		func processWithView(_ view: UIView) {
			for childView in view.subviews {
				if childView is UITextField || childView is UITextView {
					self.TPKeyboardAvoiding_initializeView(childView)
				} else {
					self.TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(childView)
				}
			}
		}
		
		if let timer = obj as? Timer, let view = timer.userInfo as? UIView {
			processWithView(view)
		} else if let view = obj as? UIView {
			processWithView(view)
		}
	}
	
	func TPKeyboardAvoiding_initializeView(_ view: UIView) {
		if let textField = view as? UITextField,
			let delegate = self as? UITextFieldDelegate, textField.returnKeyType == UIReturnKeyType.default &&
			textField.delegate !== delegate {
			textField.delegate = delegate
			let otherView = self.TPKeyboardAvoiding_findNextInputViewAfterView(view, beneathView: self)
			textField.returnKeyType = otherView != nil ? .next : .done
		}
	}
	
	func keyboardAvoidingState() -> TPKeyboardAvoidingState {
		var state = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName) as? TPKeyboardAvoidingState
		if state == nil {
			state = TPKeyboardAvoidingState()
			self.state = state
		}
		
		return self.state!
	}
}

// MARK: - Internal object observer
internal class TPKeyboardAvoidingState: NSObject {
	var priorInset = UIEdgeInsets.zero
	var priorScrollIndicatorInsets = UIEdgeInsets.zero
	
	var keyboardVisible = false
	var keyboardRect = CGRect.zero
	var priorContentSize = CGSize.zero
	
	var priorPagingEnabled = false
}

internal extension UIScrollView {
	fileprivate struct AssociatedKeysKeyboard {
		static var DescriptiveName = "KeyBoard_DescriptiveName"
	}
	
	var state: TPKeyboardAvoidingState? {
		get {
			let optionalObject: AnyObject? = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName) as AnyObject?
			if let object: AnyObject = optionalObject {
				return object as? TPKeyboardAvoidingState
			} else {
				return nil
			}
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
