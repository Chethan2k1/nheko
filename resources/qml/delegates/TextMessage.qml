import ".."

MatrixText {
	text: model.formattedBody.replace("<pre>", "<pre style='white-space: pre-wrap'>")
	width: parent ? parent.width : undefined
}