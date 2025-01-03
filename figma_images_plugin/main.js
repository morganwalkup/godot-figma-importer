figma.showUI(__html__);

async function exportImages(type) {
  // Find all nodes that contain image fills
  const nodes = figma.currentPage.findAll(node => {
    if ('fills' in node) {
      return node.fills.some(fill => 
        fill.type === 'IMAGE' && 
        fill.visible !== false
      );
    }
    return false;
  });

  if (nodes.length === 0) {
    figma.notify('No image nodes found');
    return;
  }

  // Export all image nodes
  const exportRequests = [];
  for (const node of nodes) {
    if ('fills' in node) {
      const imageFills = node.fills.filter(fill => 
        fill.type === 'IMAGE' && 
        fill.visible !== false
      );

      for (const fill of imageFills) {
        const exports = await node.exportAsync({
          format: "PNG",
          constraint: { type: "SCALE", value: 1 }
        });

        const imageHash = fill.imageHash;
        exportRequests.push({
          data: exports,
          filename: `${imageHash}.png`
        });
      }
    }
  }

  // Send to UI for zipping and downloading
  figma.ui.postMessage({ 
    type: type, 
    files: exportRequests 
  });
}

figma.ui.onmessage = async (msg) => {
  if (msg.type === "export-separate") {
    await exportImages("export-separate-ready");
  }
  if (msg.type === "export-zip") {
    await exportImages("export-zip-ready");
  }
};