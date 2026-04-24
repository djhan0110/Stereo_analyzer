/* Colony Formation Assay Automated Analysis Pipeline (Standard UI Mode)
 * Logic: Persistent ROI from the first image applied to the entire batch.
 * Measurement: Re-activates ROI before analysis to exclude background area.*/

inputDir = getDirectory("Select Source Image Directory");
outputDir = getDirectory("Select Destination Directory");

list = getFileList(inputDir);

// Variables to store ROI coordinates
var roiX, roiY, roiW, roiH;

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".png") || endsWith(list[i], ".jpg") || endsWith(list[i], ".tif")) {
        
        open(inputDir + list[i]);
        currentID = getImageID(); 
        currentName = getTitle();
        
        // --- Image Preprocessing ---
        run("8-bit");
        run("Subtract Background...", "rolling=50 light");
        run("Enhance Contrast", "saturated=10");
        
        // --- ROI Management ---
        if (i == 0) {
            setBatchMode(false); 
            setTool("oval");
            // Default oval size (90% of image)
            makeOval(getWidth()*0.05, getHeight()*0.05, getWidth()*0.9, getHeight()*0.9);
            
            waitForUser("Initial ROI Setup", "Adjust the oval for the first image. \nThis exact position will be applied to ALL images.");
            
            // Capture the coordinates of the user-defined ROI
            getSelectionBounds(roiX, roiY, roiW, roiH);
            setBatchMode(true); 
        } else {
            // Apply the saved coordinates to subsequent images
            makeOval(roiX, roiY, roiW, roiH);
        }
        
        // Clear background outside the persistent ROI (White)
        setBackgroundColor(255, 255, 255);
        run("Clear Outside");
        run("Select None");
        
        // --- Advanced Segmentation ---
        setAutoThreshold("RenyiEntropy");
        setOption("BlackBackground", false);
        run("Convert to Mask");
        
        // Polarity Verification: Ensures colonies are White (255)
        getStatistics(area, mean);
        if (mean > 128) {
            run("Invert");
        }
        
        // --- CRITICAL: Measurement Restriction ---
        // Re-apply ROI to ensure Analyze Particles only calculates area inside the well.
        makeOval(roiX, roiY, roiW, roiH);
        
        // --- Quantification ---
        run("Set Measurements...", "area mean min max area_fraction display add redirect=None decimal=3");
        
        // Analyze only within the active ROI to exclude external black background.
        run("Analyze Particles...", "size=5-Infinity circularity=0.00-1.00 show=Masks display summarize");
        
        // --- Export Management ---
        maskWindow = "Mask of " + currentName;
        if (isOpen(maskWindow)) {
            selectWindow(maskWindow);
            saveAs("Png", outputDir + "Final_Mask_" + currentName);
            close(); 
        }
        
        if (isOpen(currentID)) {
            selectImage(currentID);
            close();
        }
    }
}

// Save Results
if (isOpen("Summary")) {
    selectWindow("Summary");
    saveAs("Results", outputDir + "Summary_Results.csv");
}

setBatchMode(false);
print("Batch processing complete. Area restricted to persistent ROI.");
