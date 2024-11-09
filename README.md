# Figma to Godot Experiment v1
An experimental Figma json importer that auto-builds nodes in Godot. 

+ <ins>**It is**</ins> a project to enable a jump-start on UI design and build within the Godot Engine. This is an attempt to mimic Figma or similar design programs user experience in Godot.
+ <ins>**It is not**</ins> a program that will automatically build a functional app from Figma.

### Support and Development
+ This is currently a for-fun personal project. I will be updating and working on making this a more flexible plugin in my free time. If you would like to contract me to update or customize this for your project or organization, contact Nate at mightymochigames@gmail.com.
+ General info / communication Discord: https://discord.gg/4JsqksKMhg

### Compatibility
+ The importer does not support vectors/polygons/stars/arrows, but it will add a frame in it's place. To use these types of images you will need to export them separately and place them manually within Godot.
+ Figma image crop. Godot will place the image but you will need to re-crop within the frame.
+ Gradients. I am using Godot gradient textures and they do not support the squash and stretch of radial gradients.

### Disclamer
+ Game performance has not been tested. There may be, and probably is, more optimized ways of building UI elements depending on the game or application. Use the importer and related classes to jump start your development. 
+ I have not yet accounted for all error handling.

## Exporting from Figma
### Data Export
Exporting the necessary data from figma requires this plugin: https://github.com/yagudaev/figma-to-json

Follow the plugin instructions to export a json into your Godot project. 

### Image Export
To export images using the necessary hash names for the importer, use this plugin: https://www.figma.com/community/plugin/1070707193730369068/tojson

It will export a zip file of images and json. Discard that json as the json data is not sufficient enough for my importer.

Place all of the exported images into single folder in your Godot project. Occasionally the images exported may be seen as corrupt by Godot. Simply open those files in an image editor and resave them with the same file name. Currently the importer is only set up for PNG image files.

### Fonts
Either copy fonts from your system or download them for a web source. Add them to a single folder within your Godot project.

## Using the Godot Importer
### Importer
1. Create a User Interface Scene, or a 2D scene with a Control node.
2. Attach the FigmaImporter.gd script to the control node in which you want to place the imported content.
3. <ins>**Document Json File:**</ins> Look at the Inspector under "Figma JSON Import." Select the json you exported from Figma.
4. <ins>**Process Json:**</ins> Click the Process Json "On" button to load the list of pages.
5. <ins>**Select Page:**</ins> Select the page from your Figma document you want to load.
6. <ins>**Select Frame:**</ins> Select the Frame from the selected page you want to import. Currently the importer will display a list of top level frames.
7. <ins>**Import Options: Fonts Folder:**</ins> Select the folder to where you copied your fonts. Leaving this empy will result in using Godot's default font.
8. <ins>**Import Options: Images Folder:**</ins> Select the folder to where you copied your images. Leaving this empty will result in images not being imported. Selecting a folder will automatically check the Auto Place Images option.
9. <ins>**Import Options: Auto Place Images:**</ins> Select or deselect if you want the importer to automatically import images. This option is unavailable if you have not selected an Images Folder.
10. <ins>**Import Options: Component Json Dictionary:**</ins> *Not required. This is an advanced Feature, more details below.* Select the json file with the details of which instantiated scene should be used with specific frame ids.
11. <ins>**Import Options: Comp Inst to Scenes:**</ins> Set to On to process Figma instances as instantiated Godot scenes using Component Json Dictionary as reference.
12. <ins>**Import Layouts: Import Frames:**</ins> Click On to run the importer.

### Frame Types Explained
I created "Frame" node classes to mimic the functionality of Figma layout controls. All of these types of controls exist within Godot, but they are not as straightforward as they are in Figma. These classes are not required to retain a functioning UI so you can detach the scripts as desired.

+ <ins>**Designer Frame**</ins>: Mimics the controls of the standard frame in Figma. It is an extension of Godot's ScrollContainer.
+ <ins>**Designer Image Panel**</ins>: Mimics Figma's image "rectangle." It has the same basic functions as the Designer Frame except it is not intending to contain children nodes. It is an extension of Godot's Panel node.

## Designer Frame Properties
This is a class extension of a ScrollContainer. In Figma, all frames have the potential to become scrollable. To account for this the easiest solution was to use ScrollContainer for any frame that could contain children. ScrollContainers require a single Control child to function properly, and that child houses all other children.
1. <ins>**Inner Container:**</ins> Select the node that will be the content container for the ScrollContainer. Start with a basic Control. This is important as the Auto Layout functions will change the node type depending on the settings.
