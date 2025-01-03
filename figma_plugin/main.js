/**
 * Converts the entire Figma document to a JSON object
 * and sends it to the UI for downloading.
 * 
 * This file holds the main code for the plugin. Code in this file has access to
 * the *figma document* via the figma global object.
 * You can access browser APIs in the <script> tag inside "ui.html" which has a
 * full browser environment (See https://www.figma.com/plugin-docs/how-plugins-run).
 */

/**
 * Converts a Figma node to a JSON object.
 * @param {Object} node - The Figma node to convert.
 * @param {Boolean} withoutRelations - Whether to exclude parent, children, and masterComponent properties.
 * @returns {Object} The JSON object representation of the Figma node.
 */
const nodeToObject = (node, withoutRelations) => {
	const props = Object.entries(Object.getOwnPropertyDescriptors(node.__proto__))
	const blacklist = ['parent', 'children', 'removed', 'masterComponent']
	const obj = { id: node.id, type: node.type }
	for (const [name, prop] of props) {
		if (prop.get && !blacklist.includes(name)) {
			try {
				if (typeof obj[name] === 'symbol') {
					obj[name] = 'Mixed'
				} else {
					obj[name] = prop.get.call(node)
				}
			} catch (err) {
				obj[name] = undefined
			}
		}
	}
	if (node.parent && !withoutRelations) {
		obj.parent = { id: node.parent.id, type: node.parent.type }
	}
	if (node.children && !withoutRelations) {
		obj.children = node.children.map((child) => nodeToObject(child, withoutRelations))
	}
	if (node.masterComponent && !withoutRelations) {
		obj.masterComponent = nodeToObject(node.masterComponent, withoutRelations)
	}
	return obj
}

/** Show the `ui.html` page*/
figma.showUI(__html__);

/**
 * Calls to `parent.postMessage` inside `ui.html` will trigger this callback.
 * The callback will be passed the `pluginMessage` property of the posted message.
 * @param {Object} pluginMessage - The message from the HTML page, of the shape { type: string, filename?: string }
 */
figma.ui.onmessage = async (pluginMessage) => {
  // Handle the `request-json` message
  if (pluginMessage.type === "request-json") {
	await figma.loadAllPagesAsync();
	const json = nodeToObject(figma.root);
	const jsonString = JSON.stringify(json);
	figma.ui.postMessage({ type: "response-json", jsonString });
  }

  // Handle the `request-cancel` message
  if (pluginMessage.type === "request-cancel") {
    figma.closePlugin();
  }
};