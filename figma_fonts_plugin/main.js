figma.showUI(__html__);

// const getAllFonts = async () => {
//   const fonts = new Set();
  
//   // Recursive function to traverse nodes
//   function traverse(node) {
//     if (node.type === "TEXT") {
//       // Get font names from text node
//       node.getRangeAllFontNames(0, node.characters.length).forEach(font => {
//         console.log("Font found:", font);
//         fonts.add(font);
//       });
//     }
    
//     // Traverse children if they exist
//     if ("children" in node) {
//       for (const child of node.children) {
//         traverse(child);
//       }
//     }
//   }
  
//   // Start traversing from the root
//   await figma.loadAllPagesAsync();
//   traverse(figma.root);
  
//   return Array.from(fonts);
// };

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

// async function downloadGoogleFont(fontFamily) {
//   try {
//     // Convert font family name to Google Fonts format
//     const formattedName = fontFamily.replace(/\s+/g, '+');
//     const apiUrl = `https://fonts.googleapis.com/css2?family=${formattedName}`;
    
//     const response = await fetch(apiUrl, {
//       headers: {
//         'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
//       }
//     });
    
//     if (!response.ok) {
//       throw new Error(`Font ${fontFamily} not found on Google Fonts`);
//     }
    
//     const cssText = await response.text();
//     return cssText;
//   } catch (error) {
//     console.error(`Error downloading font ${fontFamily}:`, error);
//     return null;
//   }
// }

figma.ui.onmessage = async (msg) => {
  if (msg.type === 'scan-fonts') {
    console.log("Main.js received scan-fonts message");
    const fonts = await getAllFonts();
    console.log("All fonts found:", fonts);
    // const results = [];
    
    // for (const font of fonts) {
    //   const cssData = await downloadGoogleFont(font);
    //   results.push({
    //     name: font,
    //     found: cssData !== null,
    //     cssData: cssData
    //   });
    // }
    
    // figma.ui.postMessage({ type: 'font-results', fonts });
  }
};