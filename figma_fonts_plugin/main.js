figma.showUI(__html__);

const getAllFonts = async () => {
  const fonts = new Set();

  const traverse = (node) => {
    if (node.type === "TEXT") {
        // Get font names from text node
        node.getRangeAllFontNames(0, node.characters.length).forEach(font => {
        console.log("Font found:", font);
        fonts.add(font);
        });
    }

    // Traverse children if they exist
    if ("children" in node) {
      for (const child of node.children) {
        traverse(child);
      }
    }
  };

  await figma.loadAllPagesAsync();
  traverse(figma.root);
  return Array.from(fonts);
};

function getFontWeight(style) {
// Convert common font styles to weights
const weightMap = {
    'Thin': '100',
    'ExtraLight': '200',
    'Light': '300',
    'Regular': '400',
    'Medium': '500',
    'SemiBold': '600',
    'Bold': '700',
    'ExtraBold': '800',
    'Black': '900'
};

return weightMap[style] || '400'; // Default to 400 (Regular) if not found
}

function generateBatchScript(fonts) {
return `@echo off
setlocal EnableDelayedExpansion

:: Set colors and title
color 0A
title Font Downloader for Godot

echo ================================
echo    Font Downloader for Godot
echo ================================
echo.
echo This script will:
echo  1. Check your Windows Fonts directory for required fonts
echo  2. Copy found fonts to a local 'fonts' directory
echo  3. Attempt to download missing fonts from Google Fonts
echo.
echo Required fonts:
${fonts.map(font => `echo  - ${font.family} ${font.style}`).join('\n')}
echo.
echo Press any key to begin...
pause > nul

:: Create fonts directory if it doesn't exist
if not exist "fonts" mkdir "fonts"

echo Checking for required fonts...
echo.

${fonts.map(font => {
const fontFamily = font.family.replace(/\s+/g, '+');
const fontWeight = getFontWeight(font.style);
const fileName = `${font.family.replace(/\s+/g, '_')}-${font.style}.ttf`;

return `
echo Checking for ${font.family} ${font.style}...

:: Check Windows Fonts directory
if exist "%WINDIR%\\Fonts\\${fileName}" (
    echo Found in system fonts - copying...
    copy "%WINDIR%\\Fonts\\${fileName}" "fonts\\${fileName}" > nul
    echo Copied successfully.
) else (
    echo Not found in system fonts - attempting download from Google Fonts...
    powershell -Command "&{$webClient=New-Object System.Net.WebClient; $webClient.Headers.Add('User-Agent', 'Mozilla/5.0'); $cssUrl='https://fonts.googleapis.com/css2?family=${fontFamily}:wght@${fontWeight}'; $css=$webClient.DownloadString($cssUrl); if($css -match 'src: url\\((.*?)\\)'){$fontUrl=$matches[1]; $webClient.DownloadFile($fontUrl, 'fonts\\${fileName}')}}"
    if exist "fonts\\${fileName}" (
        echo Downloaded successfully.
    ) else (
        echo Failed to download. Please download manually from: https://fonts.google.com/specimen/${fontFamily}
    )
)
echo.`;
}).join('\n')}

echo.
echo All operations completed!
echo Font files have been saved to the 'fonts' directory.
echo.
pause
`;
}
  
figma.ui.onmessage = async (msg) => {
  if (msg.type === 'scan-fonts') {
    const fonts = await getAllFonts();
    const batchScript = generateBatchScript(fonts);
    
    figma.ui.postMessage({ 
    type: 'font-results', 
    fonts,
    script: batchScript
    });
  }
};