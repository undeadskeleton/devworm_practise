extends RichTextLabel


var defult_text = "HIGH SCORE:"


func _process(delta: float) -> void:
	var display_text = str(defult_text,str(Global.high_score))
	self.text = display_text
