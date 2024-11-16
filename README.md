# Figma to Godot Experiment
An experimental Figma json importer that auto-builds nodes in Godot. 

![Video of the Figma Importer Inspector](/doc_images/example.gif)

This is a project to enable a jump-start on UI design and build within the Godot Engine and an attempt to mimic Figma or similar design programs' user experience in Godot.

### Support and Development
+ This is currently a for-fun personal project. I will be updating and working on making this a more flexible plugin in my free time. If you would like to contract me to update or customize this for your project or organization, contact Nate at mightymochigames@gmail.com.
+ For general info communication or to share what you did with your project, visit the Discord: https://discord.gg/4JsqksKMhg

### Compatibility Issues
+ The importer does not support vectors/polygons/stars/arrows, but it will add a frame in it's place. To use these types of images you will need to export them separately and place them manually within Godot. When an image is missing or unsupported you will see the image below:
  + ![Screenshot of the Figma Importer Inspector](/doc_images/errorTexture.png)

+ Figma image crop. Godot will place the image but you will need to re-crop within the frame.
+ Gradients. I am using Godot gradient textures and they do not support the squash and stretch of radial gradients.
+ Shadows. Figma shadows have more settings than Godot StyleBox shadows support.
+ Groups. Children of groups within Figma maintain an absolute position instead of a relative. I have not set up the code to handle this yet.
+ Figma's Flip Horizontal/Vertical. Figma flips by rotating and changing scale. If the frame is part of an autolayout, Godot will not "flip" the frame. If it is just an image, use the Flip_X or Flip_Y option in the Fill texture section.

### Disclamer
+ Game performance has not been tested. There may be, and probably is, more optimized ways of building UI elements depending on the game or application. Use the importer and related classes to jump start your development. 
+ I have not yet accounted for all error handling.
+ There are some code redundancies. I'm going to eliminate those as I move this concept to a plugin.

### Video Walkthrough Preview
[Youtube Walkthrough Preview](https://youtu.be/1WlDywF6gWI?si=KGAVI-KH-K4LlSEH)

## Exporting from Figma
### Data Export
Exporting the necessary data from figma requires this plugin: https://github.com/yagudaev/figma-to-json

Follow the plugin instructions to export a json into your Godot project. This plugin requires the desktop app. 

### Image Export
To export images using the necessary hash names for the importer, use this plugin: https://www.figma.com/community/plugin/1070707193730369068/tojson

It will export a zip file of images and json. Discard that json as the data is not sufficient enough for my importer.

Place all of the exported images into single folder in your Godot project. Occasionally the images exported may be seen as corrupt by Godot. Simply open those files in an image editor and resave them with the same file name. Currently the importer is only set up for PNG image files.

### Fonts
Either copy fonts from your system or download them for a web source. Add them to a single folder within your Godot project. The font files must be named to match the font name in the JSON export file. 

For example, to match the code below the font file name is "Inter_Bold.ttf" :
```
"fontName": {
  "family": "Inter",
  "style": "Bold"
}
```

## Using the Godot Importer
Download and copy the folder "FigmaImporter" to your Godot project.

### Importer
+ Create a User Interface Scene, a 2D scene with a Control node, or a scene with a FigmaImporter base node.

![Screenshot of the Figma Importer Inspector](/doc_images/figmaimporternode.PNG)

+ If you're not using a FigmaImporter node, attach the FigmaImporter.gd script to the control node in which you want to place the imported content.

![Screenshot of the Figma Importer Inspector](/doc_images/FigmaJsonImporterInspector.PNG)

+ <ins>**Document Json File:**</ins> Look at the Inspector under "Figma JSON Import." Select the json you exported from Figma.
+ <ins>**Process Json:**</ins> Click the Process Json "On" button to load the list of pages.
+ <ins>**Select Page:**</ins> Select the page from your Figma document you want to load.
+ <ins>**Select Frame:**</ins> Select the Frame from the selected page you want to import. Currently the importer will display a list of top level frames.
+ <ins>**Import Options: Fonts Folder:**</ins> Select the folder to where you copied your fonts. Leaving this empy will result in using Godot's default font.
+ <ins>**Import Options: Images Folder:**</ins> Select the folder to where you copied your images. Leaving this empty will result in images not being imported. Selecting a folder will automatically check the Auto Place Images option.
+ <ins>**Import Options: Auto Place Images:**</ins> Select or deselect if you want the importer to automatically import images. This option is unavailable if you have not selected an Images Folder.
+ <ins>**Import Options: Component Json Dictionary:**</ins> *Not required. This is an advanced Feature, more details below.* Select the json file with the details of which instantiated scene should be used with specific frame ids.
+ <ins>**Import Options: Comp Inst to Scenes:**</ins> Set to On to process Figma instances as instantiated Godot scenes using Component Json Dictionary as reference.
+ <ins>**Import Layouts: Import Frames:**</ins> Click On to run the importer.

When you're done importing, you can detach the Importer script as it is no longer required to work with the nodes.

### Frame Types Explained
I created "Frame" node classes to mimic the functionality of Figma layout controls. All of these types of controls exist within Godot, but they are not as straightforward as they are in Figma. These classes are not required to retain a functioning UI so you can detach the scripts as desired.

+ <ins>**Designer Frame**</ins>: Mimics the controls of the standard frame in Figma. It is an extension of Godot's ScrollContainer.
+ <ins>**Designer Image Panel**</ins>: Mimics Figma's image "rectangle." It has the same basic functions as the Designer Frame except it is not intending to contain children nodes. It is an extension of Godot's Panel node.

## Designer Frame Properties
This is a class extension of a ScrollContainer. In Figma, all frames have the potential to become scrollable. To account for this the easiest solution was to use ScrollContainer for any frame that could contain children. ScrollContainers require a single Control child to function properly, and that child houses all other children. Almost all of these custom settings, aside from fill texture and max size, are a repackaging of existing Godot node functions. I have simply consolidated them into one spot.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFrameInspector.PNG)

+ <ins>**Inner Container:**</ins> Select the node that will be the content container for the ScrollContainer. Start with a basic Control. This is important as the Auto Layout functions will change the node type depending on the settings.
+ <ins>**Horizontal and Vertical Anchor:**</ins> Set the anchor positions to determine how the frame will move or scale with the parent node. This differs from the default Godot anchors in that changing the anchors does not change the position or size of the frame/node. 

![Screenshot of the Designer Frame Inspector](/doc_images/designerFrameSizeInspector.PNG)

+ <ins>**Width and Height Size Mode:**</ins> Determines how the node will scale when in an auto layout.
+ <ins>**Min Size:**</ins> The node's smallest size.
+ <ins>**Max Size:**</ins> The node's largest size.
+ <ins>**Frame Rotation:**</ins> A duplication of node rotation for ease of access.
+ <ins>**Center Rotation:**</ins> Centers the rotation/transform pivot point. This will be maintain even when changing the node size.
+ <ins>**Clip Frame Contents:**</ins> Clips the contents of the frame. Note that in Godot clipping will not rotate with the frame/node.
+ <ins>**Scrolling Mode:**</ins> Change the frame scroll direction or whether it scrolls at all.

![Screenshot of the Designer Frame Inspector](/doc_images/stylepaddingFillColor.PNG)

+ <ins>**Break Style Links:**</ins> If you find changing one node is changing others, click this to break the style link. This will duplicate the Stylebox and shader to break it free of others.
+ <ins>**Fill Color:**</ins> Set the fill color.
+ <ins>**Use Solid Fill:**</ins> When placing an image with transparency, this option determines if the fill color appears behind it.
+ <ins>**Fill Gradient:**</ins> Add a gradient. Gradients always appear above the fill color.
+ <ins>**Gradient Behind Image:**</ins> If there is a fill image, you can set whether it appears in front of or behind that image.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFramefillimage.PNG)

+ <ins>**Fill Texture:**</ins> Add a background image to the frame.
+ <ins>**Edge Fill:**</ins> If there is an anti-aliased border, use this option to reduce an unexpected color bleeding.
+ <ins>**Texture Size Mode:**</ins> Godot will repeat the edge of pixels if there is not transparency and image does not fill the frame.
  + Fill: Fills the frame with the image.
  + Fit: Makes sure the image completely fits within the frame.
  + Stretch: Morphs the image to fill the frame edge to edge without cropping.
  + Keep Size: The image size will stay the same size even if you change the frame size.
+ <ins>**Flip X:**</ins> Flips the image horizontally.
+ <ins>**Flip Y:**</ins> Flips the image vertically.
+ <ins>**Zoom:**</ins> Zooms the image.
+ <ins>**Size Stretch:**</ins> Manual setting for stretch.
+ <ins>**Position Offset:**</ins> Manual setting for offest within the frame.
+ <ins>**Tint Color:**</ins> Tints the color of the image. Change the alpha will change the alpha of the image.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFrameborder.PNG)

+ <ins>**Border Line Weight All:**</ins> Changes all border weights.
+ <ins>**Border Weights:**</ins> An array of 4 border weights. Top, Right, Bottom, Left.
+ <ins>**Border Color:**</ins> Border color.
+ <ins>**Anti Alias Border:**</ins> Smooths the border line. This can create color artifacts if using fill textures. See Edge Fill.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFrameCornersPNG.PNG)

+ <ins>**Corner Radius All:**</ins> Changes all of the corner radius array.
+ <ins>**Corner Radius:**</ins> An array of 4 corner radius. Top, Right, Bottom, Left.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFramePadding.PNG)

+ <ins>**Padding All:**</ins> Changes all of the edge padding.
+ <ins>**Padding:**</ins> An array of 4 paddings. Top, Right, Bottom, Left.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFrameShadow.PNG)

+ <ins>**Shadow:**</ins> Self explanatory. There is no blur in Godot shadows.

![Screenshot of the Designer Frame Inspector](/doc_images/designerFrameAutoLayout.PNG)

+ <ins>**Layout Mode:**</ins> Creates or changes the direction and type of auto layout. This will swap the inner container node with the appropriate Godot control node.
  + None: Swaps in a Control.
  + Vertical: Swaps in a VBoxContainer.
  + Horizontal: Swaps in a HBoxContainer.
  + Grid: Swaps in a GridContainer.
+ <ins>**Layout Wrap:**</ins> This works in conjuction with the Layout Mode. This will not effect Grid.
  + NO_WRAP: Swaps VFlowContainer or HFlowContainer with VBoxContainer or HBoxContainer  respectively.
  + WRAP: Swaps VBoxContainer or HBoxContainer with VFlowContainer or HFlowContainer respectively.
+ <ins>**H and V Layout Align:**</ins> Changes the child node positioning. This is different from default Godot as I am changing each child's positioning when needed vs just modifying the parent container. This creates an effect closer to how Figma aligns content.
+ <ins>**Spacing:**</ins> Changing the space between children.
+ <ins>**Secondary Spacing:**</ins> In some containers you can change the horizontal and vertical spacing.
+ <ins>**Auto Space:**</ins> This option will expand the space of children to automatically fit the space. Only works in Vertical and Horizontal NO_WRAP.
+ <ins>**Grid Columns:**</ins> The the number of columns in Grid mode.

## Designer Image Panel Properties
These are the same as the designer frame minus the auto layout features.

## Figma Component Instances to Godot Instantiated Child Scenes
Rather than importing and rebuilding all of the Figma frames, you can save scenes and have the importer instantiate those scenes using the variables from the Figma component. 

For the importer to know what child scene to instantiate you must write a json dictionary matching the component IDs to the scene files. 

To get the component IDs:
1. Import the component Frame into Godot via the importer.
2. Look at the node names and you will see the ID in between xIDx____x.

![Screenshot of finding component IDS.](/doc_images/findingcomponentID.png)

### JSON
Copy that ID and write a json like the one below.
```
{
	"441_161": "res://components/my_instance_scene.tscn",
	"441_167": "res://components/my_instance_scene.tscn",
	"441_173": "res://components/my_instance_scene.tscn"
}
```
### Scenes

![Screenshot of child scene.](/doc_images/childscene.png)

Build the scenes as you see fit. If you want to use the custom Frame classes I built, extend the script and then you can add your own.

![Screenshot of child scene.](/doc_images/extend.PNG)

To retain functionality, format your script like the one below.

```
@tool extends DesignerFrame

func _ready() -> void:
	super._ready()
```

If you add variables that require the node to be ready, you'll need to set those variables again in the _ready func. A complete example below.

```
@tool extends DesignerFrame

@export var Title:String = "Title":
	set(value):
		Title = value
		get_node("InnerContainer/Text Area xIDx267_42x/InnerContainer/Title Label").text = Title
@export var Desc:String = "desc":
	set(value):
		Desc = value
		get_node("InnerContainer/Text Area xIDx267_42x/InnerContainer/Description Label").text = Desc
@export var thumb_image:Texture :
	set(value):
		thumb_image = value
		get_node("InnerContainer/Thumbnail xIDx267_47x").fill_texture = thumb_image
@export_enum("Red","Green","Blue") var Type:String = "Red":
	set(value):
		Type = value
		var label_settings = get_node("InnerContainer/Text Area xIDx267_42x/InnerContainer/Title Label").label_settings.duplicate()
		match Type:
			"Red":
				get_node("InnerContainer/Thumbnail xIDx267_47x").border_color = Color(0.724,0.17,0.0,1.0)
				label_settings.set_font_color(Color(0.724,0.17,0.0,1.0))
				get_node("InnerContainer/Text Area xIDx267_42x/InnerContainer/Title Label").label_settings = label_settings
			"Green":
				get_node("InnerContainer/Thumbnail xIDx267_47x").border_color = Color(0.039,0.812,0.514,1.0)
				label_settings.set_font_color(Color(0.039,0.812,0.514,1.0))
				get_node("InnerContainer/Text Area xIDx267_42x/InnerContainer/Title Label").label_settings = label_settings
			"Blue":
				get_node("InnerContainer/Thumbnail xIDx267_47x").border_color = Color(0.0,0.737,0.992,1.0)
				label_settings.set_font_color(Color(0.0,0.737,0.992,1.0))
				get_node("InnerContainer/Text Area xIDx267_42x/InnerContainer/Title Label").label_settings = label_settings

func _ready() -> void:
	super._ready()
	thumb_image = thumb_image
	Type = Type
```

Match the variable names to the Figma component properties, and the importer will automatically apply the values. Only properties that Figma supports are exported / imported.

![Screenshot of Figma Properties.](/doc_images/properties.PNG)

![Screenshot of Figma Properties.](/doc_images/godotvariables.PNG)



