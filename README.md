# Figma to Godot Experiment
An experimental Figma json importer that auto-builds nodes in Godot. 

<ins>**It is**</ins> a project to enable a jump-start on UI design and build within the Godot Engine.

<ins>**It is not**</ins> a program that will automatically build a functional app from Figma.

## Exporting from Figma
### Data Export
Exporting the necessary data from figma requires this plugin: https://github.com/yagudaev/figma-to-json

Follow the plugin instructions to export a json into your Godot project. 

### Image Export
To export images using the necessary hash names for the importer, use this plugin: https://www.figma.com/community/plugin/1070707193730369068/tojson

It will export a zip file of images and json, but the json data is not sufficient enough for my importer.

Place all of the exported images into single folder in your Godot project. Occasionally the images exported may be seen as corrupt by Godot. Simply open those files in an image editor and resave them.

## Using the Godot Importer
1. Create a User Interface Scene, or a 2D scene with a Control node.
2. Attach the converter script to the control node in which you want to place the imported content.
