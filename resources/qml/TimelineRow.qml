import QtQuick 2.6
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2

import im.nheko 1.0

import "./delegates"
import "./emoji"

Item {
	anchors.left: parent.left
	anchors.right: parent.right
	height: row.height

	MouseArea {
		anchors.fill: parent
		propagateComposedEvents: true
		preventStealing: true
		hoverEnabled: true

		acceptedButtons: Qt.AllButtons
		onClicked: {
			if (mouse.button === Qt.RightButton)
			messageContextMenu.show(model.id, model.type, model.isEncrypted, row)
		}
		onPressAndHold: {
			messageContextMenu.show(model.id, model.type, model.isEncrypted, row, mapToItem(timelineRoot, mouse.x, mouse.y))
		}
	}
	Rectangle {
		color: (settings.messageHoverHighlight && parent.containsMouse) ? colors.base : "transparent"
		anchors.fill: row
	}
	RowLayout {
		id: row

		anchors.leftMargin: avatarSize + 16
		anchors.left: parent.left
		anchors.right: parent.right


		Column {
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop
			spacing: 4

			// fancy reply, if this is a reply
			Reply {
				visible: model.replyTo
				modelData: chat.model.getDump(model.replyTo, model.id)
				userColor: timelineManager.userColor(modelData.userId, colors.window)
			}

			// actual message content
			MessageDelegate {
				id: contentItem

				width: parent.width

				modelData: model
			}

			Reactions {
				id: reactionRow
				reactions: model.reactions
				roomId: model.roomId
				eventId: model.id
			}
		}

		StatusIndicator {
			state: model.state
			Layout.alignment: Qt.AlignRight | Qt.AlignTop
			Layout.preferredHeight: 16
			width: 16
		}

		EncryptionIndicator {
			visible: model.isRoomEncrypted
			encrypted: model.isEncrypted
			Layout.alignment: Qt.AlignRight | Qt.AlignTop
			Layout.preferredHeight: 16
			width: 16
		}
		EmojiButton {
			visible: settings.buttonsInTimeline
			Layout.alignment: Qt.AlignRight | Qt.AlignTop
			Layout.preferredHeight: 16
			width: 16
			id: reactButton
			hoverEnabled: true
			ToolTip.visible: hovered
			ToolTip.text: qsTr("React")
			emojiPicker: emojiPopup
			event_id: model.id
		}
		ImageButton {
			visible: settings.buttonsInTimeline
			Layout.alignment: Qt.AlignRight | Qt.AlignTop
			Layout.preferredHeight: 16
			width: 16
			id: replyButton
			hoverEnabled: true


			image: ":/icons/icons/ui/mail-reply.png"

			ToolTip.visible: hovered
			ToolTip.text: qsTr("Reply")

			onClicked: chat.model.replyAction(model.id)
		}
		ImageButton {
			visible: settings.buttonsInTimeline
			Layout.alignment: Qt.AlignRight | Qt.AlignTop
			Layout.preferredHeight: 16
			width: 16
			id: optionsButton
			hoverEnabled: true

			image: ":/icons/icons/ui/vertical-ellipsis.png"

			ToolTip.visible: hovered
			ToolTip.text: qsTr("Options")

			onClicked: messageContextMenu.show(model.id, model.type, model.isEncrypted, optionsButton)
		}

		Label {
			Layout.alignment: Qt.AlignRight | Qt.AlignTop
			text: model.timestamp.toLocaleTimeString("HH:mm")
			width: Math.max(implicitWidth, text.length*fontMetrics.maximumCharacterWidth)
			color: inactiveColors.text

			MouseArea{
				id: ma
				anchors.fill: parent
				hoverEnabled: true
				propagateComposedEvents: true
			}

			ToolTip.visible: ma.containsMouse
			ToolTip.text: Qt.formatDateTime(model.timestamp, Qt.DefaultLocaleLongDate)
		}
	}
}
